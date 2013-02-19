pro sparvm_double_station_main
;
;
; PURPOSE:
;     Computes double station trajectory
;
; CALLING SEQUENCE:
;     sparvm_double_station_main
;     
; 
; PROCEDURE:
;     (Ceplecha, 1987, Geometric, dynamic, orbital and photometric data on meteoroids from photographic fireball networks, Bulletin of the Astronomical Institutes of Czechoslovakia,38, 222-234)
;
;
; PROCEDURES USED:
;   sparvm_configuration, sparvm_getinfo_station, sparvm_read_metrec, sparvm_check_inputs, sparvm_geographic_to_cartesian, sparvm_eqn_plane, 
;   sparvm_intersect_plane, sparvm_check_radiant, sparvm_project_plane, sparvm_cartesian_to_geographic, sparvm_meteor_vel, sparvm_vel_corr, sparvm_compute_orbit
;
;********************************************************************************************
;********************************************************************************************
;
print, "Starting sparvm_double_station_main.pro ..............."
;
; Reading the configuration file
sparvm_configuration,path_to_spice_kernel, inputfolder1, inputfolder2, inputfile_extension, station1_code, station2_code, $
            orbit_code, log_code, logfile_path, meteor_diff 
;
;Creating Log file
sparvm_create_logfile,logfile_path,logfile
openw,log_lun,logfile, /get_lun
;
printf,log_lun, systime()
printf,log_lun, "Starting sparvm_double_station_main.pro ..............."
printf,log_lun, "Write Log File --> ", log_code
printf,log_lun, "Compute Orbit --> ", orbit_code
;
; Check if ORBIT needs to be computed. Load SPICE kernels if necessary
IF orbit_code EQ 'yes' THEN BEGIN
  cspice_furnsh,path_to_spice_kernel
  printf,log_lun, "SPICE kernels loaded from  "  
  printf,log_lun,path_to_spice_kernel
ENDIF ELSE BEGIN
  printf,log_lun, "SPICE kernels not loaded"
ENDELSE
;
; Getting the station geographic information (lat, lon, alt)
sparvm_getinfo_station,station1_code,st_info1
sparvm_getinfo_station,station2_code,st_info2
;
; Searching file in the input folder
inputfile1=file_search( strjoin([inputfolder1,inputfile_extension]), count=nf1 )
inputfile2=file_search( strjoin([inputfolder2,inputfile_extension]), count=nf2 )
;
printf,log_lun, "Station-1 input folder "
printf,log_lun, inputfolder1
printf,log_lun, "Station-2 input folder " 
printf,log_lun, inputfolder2
printf,log_lun, "# files Station-1 ", nf1
printf,log_lun, "# files Station-2 ", nf2
;
sparvm_file_time, inputfile1, timehr1
sparvm_file_time, inputfile2, timehr2

FOR i=0, nf1-1 DO BEGIN
;  
  time_diff = (abs(timehr1[i] - timehr2))*3600.  
  j = fix((where(time_diff LE meteor_diff , count))[0])
  IF count GE 1.0 THEN BEGIN
;  
; Reading the metrec input file
; !!!! Use different routine to read input file
  sparvm_read_metrec,inputfile1[i],ra1,dec1,mag1,tsec1,jd1
  sparvm_read_metrec,inputfile2[j],ra2,dec2,mag2,tsec2,jd2
;
  printf,log_lun, "*****************************************************************"
  printf,log_lun, inputfile1[i]
  printf,log_lun, inputfile2[j]
;
; Check the formats of ra, dec, jd
  sparvm_check_inputs, ra1, dec1, jd1
  sparvm_check_inputs, ra2, dec2, jd2
;
; Converting Station geographic coordinates to cartesian 
  sparvm_geographic_to_cartesian,st_info1,jd1,stxyz1
  sparvm_geographic_to_cartesian,st_info2,jd2,stxyz2
;
; Equation of Plane of meteor and Station
  sparvm_eqn_plane,ra1,dec1,stxyz1,unit_met1,eqplane1
  sparvm_eqn_plane,ra2,dec2,stxyz2,unit_met2,eqplane2
;
; Intersection of two planes	
  sparvm_intersect_plane,eqplane1,eqplane2,intervec,radiant,qab
;
; Check if it is the correct radiant
  sparvm_check_radiant,radiant,jd1, st_info1
;
; Projecting the meteor into the plane
  sparvm_project_plane,stxyz1,eqplane1,eqplane2,unit_met1,pxyz1
  sparvm_project_plane,stxyz2,eqplane2,eqplane1,unit_met2,pxyz2
;
; Converting meteor postion to latitude, longitude, height
  sparvm_cartesian_to_geographic,pxyz1,jd1,platlon1, rsm1, geo_latm1, lstm1
  sparvm_cartesian_to_geographic,pxyz2,jd2,platlon2, rsm2, geo_latm2, lstm2
;
; Computing meteor velocity
; NOTE: This assumes high quality of data and focuses on point to point velocity rather than average.
;      There exists better method to compute average meteor velocity   
  sparvm_meteor_vel,pxyz1,jd1,Vxyz1,Vabs1,Vavg1,std_vel1
  sparvm_meteor_vel,pxyz2,jd2,Vxyz2,Vabs2,Vavg2,std_vel2
;
; Meteor height
  meteor_hgt1 = rsm1 + platlon1[2,*]
  meteor_hgt2 = rsm2 + platlon2[2,*]
;
; Compute Velcoity Infinity
  sparvm_vel_corr,Vavg1,meteor_hgt1[0],radiant,geo_latm1[0],lstm1[0],Vec1,Vinf1
  sparvm_vel_corr,Vavg2,meteor_hgt2[0],radiant,geo_latm2[0],lstm2[0],Vec2,Vinf2
;
; Arrange 6 vector position/velocity for orbital computation
  geo_xyz1 = [ pxyz1[*,0],Vec1 ]
  geo_xyz2 = [ pxyz2[*,0],Vec2 ]

; Compute orbital elements
 sparvm_compute_orbit,orbit_code,geo_xyz1,jd1[0],Vavg1,orbital_ele1, comment1
 sparvm_compute_orbit,orbit_code,geo_xyz2,jd2[0],Vavg2,orbital_ele2, comment2
 IF strlen(comment1) GT 50 THEN printf,log_lun, comment1, Vavg1
 IF strlen(comment2) GT 50 THEN printf,log_lun, comment2, Vavg2      
;
; Creating Output file names
  output_file1=strjoin( [(strsplit(inputfile1[i],'.', /extract))[0],'_sparvm', '.OUT' ] )
  output_file2=strjoin( [(strsplit(inputfile2[i],'.', /extract))[0],'_sparvm', '.OUT' ] )
;
; Writing Output files
  sparvm_write_double_station,output_file1,st_info1,ra1,dec1,jd1,stxyz1,eqplane1,radiant,qab,$
          pxyz1,platlon1,Vavg1,Vinf1,std_vel1,orbital_ele1
  sparvm_write_double_station,output_file2,st_info2,ra2,dec2,jd2,stxyz2,eqplane2,radiant,qab,$
          pxyz2,platlon2,Vavg2,Vinf2,std_vel2,orbital_ele2         
;
  printf, log_lun, "Station-1 Results :", output_file1
  printf, log_lun, "Station-2 Results :", output_file2
;  print, "Station-1 Results --> ", output_file1
;  print, "Station-2 Results --> ", output_file2

  ENDIF ELSE BEGIN
  printf, log_lun, 'Double station not found for :', inputfile1[i]
  print, 'Double station not found for :', inputfile1[i]
  ENDELSE
 
ENDFOR
;
; Unloading SPICE kernels 
IF orbit_code EQ 'yes' THEN BEGIN
  cspice_unload, path_to_spice_kernel
  printf,log_lun, "SPICE Kernels unload"
ENDIF
;
; Deleteting log file if not required
printf,log_lun, systime()
free_lun, log_lun
IF log_code NE 'yes' THEN BEGIN
  file_delete, logfile
  print, "Log-File has been deleted --> ", logfile
ENDIF ELSE BEGIN
  print, "Log-file path --> ", logfile
ENDELSE
;
;print, "End of sparvm_double_station_main "
;print, systime()
;
end
