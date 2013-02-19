pro sparvm_write_double_station,output_file,st_info,ra,dec,jd,stxyz,eqplane,radiant,qab,pxyz,platlon,Vavg,Vinf,std_vel,orbital_ele
;
;
; PURPOSE:
;     Write output files of sparvm software 
;
; CALLING SEQUENCE:
;    sparvm_write_double_station,output_file,st_info,ra,dec,jd,stxyz,eqplane,radiant,qab,pxyz,platlon,Vavg,Vinf,std_vel,orbital_ele
;
; INPUTS:
;     	output_file	: Full path to the Output file to write
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
;     called by sparvm_douoble_station_main
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
openw,lun,output_file,/get_lun
;
printf,lun,'Station Latitude [deg] :',st_info[0], format='(a,5X,F11.7)'
printf,lun,'Station Longitude[deg] :',st_info[1], format='(a,5X,F11.7)'
printf,lun,'Station Altitude [m] :',st_info[2],  format='(a,5X,F8.2)'
printf,lun,'Number of meteor points :', (size(ra))[2], format='(a,4X,I2)'
printf,lun,'RA[deg]           Dec[deg]        JD[days]'
printf,lun,[ra,dec,jd], format='(F8.4, 8X, F8.4, 8X, F16.7)'
;
printf,lun,'Equation of station-meteor plane:'
printf,lun, eqplane, format='(3(F12.7, X), F12.5)'
printf,lun,'Station X[km]           Y[km]           Z[km]'
printf,lun,stxyz
printf,lun,'Meteor X[km]            Y[km]           Z[km]'
printf,lun, pxyz
printf,lun,'Meteor Lat[deg]         Lon[deg]        Height[km]'
printf,lun, platlon
printf,lun,'Meteor Radiant RA Dec [deg]:',radiant, format='(a,11X,F6.2,3X,F6.2)'
printf,lun,'Angle between the plane Qab [deg]:',qab, format='(a,5X,F4.1)'
printf,lun,'Velocity Observed [km/s]:',Vavg, format='(a,14X,F5.1)'
printf,lun,'Velocity Infinity [km/s]:',Vinf, format='(a,14X,F5.1)'
printf,lun,'Deviation of Velcoity [km/s]:',std_vel, format='(a,9X,F5.1)'
printf,lun,'Perifocal distance [AU]:',orbital_ele[0], format='(a,14X,F12.7)'
printf,lun,'Semi major axis [AU]:',orbital_ele[1], format='(a,18X,F12.7)'
printf,lun,'Eccentricity:',orbital_ele[2], format='(a,25X,F12.7)'
printf,lun,'Inclination  [deg]:',orbital_ele[3], format='(a,21X,F12.7)'
printf,lun,'Longitude of the ascending node [deg]:',orbital_ele[4], format='(a,X,F12.7)'
printf,lun,'Argument of periapsis [deg]:',orbital_ele[5], format='(a,11X,F12.7)'
printf,lun,'Mean anomaly at epoch [deg]:',orbital_ele[6], format='(a,11X,F12.7)'
printf,lun,'END OF FILE   ',systime()
;
free_lun,lun
;
end
