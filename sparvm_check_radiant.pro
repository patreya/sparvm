pro sparvm_check_radiant, radiant, jd, st_info
;
;
; PURPOSE:
;     Check if the given radiant is visible from the station and correct if it is anti-radiant.
;
; CALLING SEQUENCE:
;     sparvm_check_radiant,radiant,jd,st_info
;
; INPUTS:
;     radiant   : radiant [RA, Dec] of a meteor
;     jd        : Julian date [days]
;     st_info   : Latitude, Longitude & Altitude of the station
;     
; OUTPUTS:
;     radiant   : radiant [RA, Dec]. Only changed if the given radiant was anti-radiant 
;
; PROCEDURES USED:
; eq2hor, cirrange
;
; Last Updated
; 2012-09-10
;
;********************************************************************************************
;********************************************************************************************
;
;
ra_tmp=radiant[0]   & dec_tmp=radiant[1]  
cirrange, ra_tmp
;
eq2hor, ra_tmp, dec_tmp, jd[0], alt, az, lat=st_info[0], lon=st_info[1], alt=st_info[2]
;
; If the altitude of the meteor raidant from the station is negative, then it is anti-radiant.
IF alt LT 0.0 THEN BEGIN
  dec_tmp = -dec_tmp
  ra_tmp = ra_tmp-180
ENDIF
;
;
cirrange, ra_tmp    
radiant = [ra_tmp,dec_tmp]
;
end
