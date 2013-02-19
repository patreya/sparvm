pro sparvm_read_double_station_output,output_file,st_info,ra,dec,jd,stxyz,eqplane,radiant,qab,pxyz,platlon,Vavg,Vinf,std_vel,orbital_ele
;
; PURPOSE:
;     Read output files of sparvm software 
;
; CALLING SEQUENCE:
;     sparvm_read_double_station_output,output_file,st_info,ra,dec,jd,stxyz,eqplane,radiant,qab,pxyz,platlon,Vavg,Vinf,std_vel,orbital_ele
;    
; INPUTS:
;     none
;
; OUTPUTS:
;     	output_file	: Full path to the Output file to be read
;	st_info		: [lat, lon, alt] of the station
;	ra		: RA of meteors [deg]
;	dec		: Dec of meteors [deg]
;	jd		: Julian date [days]
;	stxyz		: Station cartesian coordinates in XYZ [km]
;	eqplane		: Equation of station-meteor plane
;	radiant		: radiant of meteor [deg]
;	qab		: angle between two planes [deg]
;	pxyz		: XYZ position of meteor [km]
;	platlon		: [lat, lon, alt] of meteor
;	Vavg		: Average Velocity of meteor [km/s] 
;	Vinf		: Velocity at Infinity [km/s]
;	std_vel		: Standard Deviation of Vavg [km/s]
;	orbital_ele	: Orbital elements
;    
; PROCEDURE:
;     utility file
;
; PROCEDURES USED:
;  none
;
; Last Update
; 2012-09-10
;
;*********************************************************************************************
;**********************************************************************************************
;
;
nline=FILE_LINES(output_file)  
tmparr=strarr(nline)
;
openr,lun,output_file, /get_lun
readf,lun, tmparr
free_lun, lun
;
j=0
lat=(strsplit(tmparr[j+0], ':',/extract))[1]
lon=(strsplit(tmparr[j+1], ':',/extract))[1]
alt=(strsplit(tmparr[j+2], ':',/extract))[1]
st_info=[lat,lon,alt]
;
meteor_points=double( (strsplit(tmparr[j+3], ':',/extract))[1])
ra=dblarr(1,meteor_points)
dec=dblarr(1,meteor_points)
jd=strarr(1,meteor_points)
;
j=j+5
for i = 0, meteor_points - 1 do begin
  ra[0,i]  = double( (strsplit(tmparr[i+j], ' ',/extract))[0])
  dec[0,i] = double( (strsplit(tmparr[i+j], ' ',/extract))[1])
  jd[0,i]  = (strsplit(tmparr[i+j], ' ',/extract))[2]
endfor
;
j = j + meteor_points
eqplane = double( (strsplit(tmparr[j+1], ' ',/extract)) ) 
stxyz= double( (strsplit(tmparr[j+3], ' ',/extract)) ) 
;
j = j + 5 
pxyz=dblarr(3,meteor_points)
for i = 0, meteor_points - 1 do begin
  pxyz[0,i]  = double( (strsplit(tmparr[i+j], ' ',/extract))[0])
  pxyz[1,i] =  double( (strsplit(tmparr[i+j], ' ',/extract))[1])
  pxyz[2,i]  = double( (strsplit(tmparr[i+j], ' ',/extract))[2])
endfor
;
j = j + meteor_points + 1
platlon=dblarr(3,meteor_points) 
for i = 0, meteor_points - 1 do begin
  platlon[0,i] = double( (strsplit(tmparr[i+j], ' ',/extract))[0])
  platlon[1,i] = double( (strsplit(tmparr[i+j], ' ',/extract))[1])
  platlon[2,i] = double( (strsplit(tmparr[i+j], ' ',/extract))[2])
endfor
;
j = j + meteor_points
radiant=  double( strsplit( ((strsplit(tmparr[j+0], ':',/extract))[1]),' ',/extract) )
qab = double( (strsplit(tmparr[j+1], ':',/extract))[1])
;
Vavg = double( (strsplit(tmparr[j+2], ':',/extract))[1])
Vinf = double( (strsplit(tmparr[j+3], ':',/extract))[1])
std_vel = double( (strsplit(tmparr[j+4], ':',/extract))[1])
;
orbital_ele=dblarr(7)
orbital_ele[0]= double( (strsplit(tmparr[j+5], ':',/extract))[1])
orbital_ele[1]= double( (strsplit(tmparr[j+6], ':',/extract))[1])
orbital_ele[2]= double( (strsplit(tmparr[j+7], ':',/extract))[1])
orbital_ele[3]= double( (strsplit(tmparr[j+8], ':',/extract))[1])
orbital_ele[4]= double( (strsplit(tmparr[j+9], ':',/extract))[1])
orbital_ele[5]= double( (strsplit(tmparr[j+10], ':',/extract))[1])
orbital_ele[6]= double( (strsplit(tmparr[j+11], ':',/extract))[1])
;
end
