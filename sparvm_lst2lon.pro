PRO sparvm_LST2LON, lst, jd, lon 
; 
;
; PURPOSE:
;     Convert from Local Sidereal Time to Longitude     
;     
; CALLING SEQUENCE:
;     sparvm_LST2LON, lst, jd, lon
;    
; INPUTS:
;     lst	: Local Sidereal Time [hr]
;     jd	: Julian date [days]
;
; OUTPUTS:
;     lon	: Longitude of the station [deg]
;
; PROCEDURE:
;     called by sparvm_cartesian_to_geographic. 
;
; PROCEDURES USED:
;  none
;
; Note: This routine was modified from CT2LST.pro from Astrolib
;
; Last Updated
; 2012-09-10 
;
;********************************************************************************************
;********************************************************************************************
;
On_error,2
;
jd = double(jd)
;
;Useful constants, see Meeus, p.84
c = [280.46061837d0, 360.98564736629d0, 0.000387933d0, 38710000.0 ]
jd2000 = 2451545.0D0
t0 = jd - jd2000
t = t0/36525
;
; Compute GST in seconds.
 theta = c[0] + (c[1] * t0) + t^2*(c[2] - t/ c[3] )
;
; Compute LST in hours.
;
lon = lst*15.0D - theta
neg = where(lst lt 0.0D0, n)
if n gt 0 then lon[neg] = 360.0 + lon[neg]
lon = lon mod 360.0D
;  
;
END
