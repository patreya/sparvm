pro sparvm_check_inputs, ra, dec, jd
;
;
; PURPOSE:
;     Check input [ra, dec, jd] formats and basic input error checking.
;
; CALLING SEQUENCE:
;     sparvm_check_inputs, ra, dec, jd
;
; INPUTS:
;     ra   	: RA array of meteor [deg]
;     dec   	: Dec array of meteor [deg]
;     jd        : Julian date [days]
;     
; OUTPUTS:
;     ra, dec, jd
;
; PROCEDURE
;     called by sparvm_double_station_main
;
; PROCEDURES USED
;     none
;
; Last Update
; 2012-09-10
;;********************************************************************************************
;********************************************************************************************
;
; Change the dimension of the array to 1xN from N
IF (size(ra))[0] EQ 1 THEN ra=transpose(ra)
IF (size(dec))[0] EQ 1 THEN dec=transpose(dec)
IF (size(jd))[0] EQ 1 THEN jd=transpose(jd)
;
; Check if all parameters are of same length
IF (size(ra))[2] NE (size(dec))[2] OR (size(ra))[2] NE (size(jd))[2] THEN BEGIN
  print, "The inputs RA, Dec and JD are not of same dimension. Abort"
  stop
ENDIF
;
; Check the minimum length
IF (size(ra))[2] LT 3 THEN BEGIN
  print, "Double station requires at least 3 position in RA, Dec and JD. Abort"
  stop
ENDIF
;
; Check if RA is in range
IF min(ra) LT 0 OR max(ra) GT 360 THEN BEGIN
  print, "RA is outside 0 - 360 degree range. Abort"
  stop
ENDIF
;
; Check if Dec is in range
IF min(dec) LT -90 OR max(dec) GT +90 THEN BEGIN
  print, "Dec is outside -90 - +90 degree range. Abort"
  stop
ENDIF
;
; Check the duration of meteor
IF abs ( max(jd) - min(jd) )*24*60 GT 5 THEN BEGIN
  print, "The duration of meteor is more than 5 minutes. Abort"
  stop
ENDIF
;
; Set jd range for 01-Jan 2000 - 2020 year 
IF jd[0] LT 2451545 OR jd[0] GT 2458850 THEN BEGIN
  print, "The julian date is outside range year 1-Jan 2000 - 2020. Abort"
  stop
ENDIF
;
; Note: More error traps can be added according to the requirement of the stations
;

end
