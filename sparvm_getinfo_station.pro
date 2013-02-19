pro sparvm_getinfo_station,st_code,st_info
;
;
; PURPOSE:
;     Get station geographic (lat, lon,alt) information
;
; CALLING SEQUENCE:
;    sparvm_getinfo_station,st_code,st_info  
;
; INPUTS:
;     st_code        : Code for the Station
;
; OUTPUTS:
;     st_info[0]     : Latitude of Station [deg]
;     st_info[1]     : Longitude of Station [deg] 
;     st_info[2]     : Elevation of Station [m]
;
; PROCEDURE:
;     called by sparvm_double_station_main
;
; PROCEDURES USED:
; ten  
;
; Example
;  IDL>sparvm_getinfo_station,'ICC2',st_info
;  IDL>print,st_info
;  IDL>42.936389      0.14250000       2900.0000
;  
; Notes:
;  Add your location information in the following format below during initial configuration
; 
; Last Updated
; 2012-09-10 
; 
;********************************************************************************************
;********************************************************************************************

ON_ERROR, 2

IF st_code EQ 'ICC2' THEN BEGIN
    latitude_st    = ten(-17,49,24) 	 
    longitude_st   = ten(122,37,25)		 
    elevation_st   = 50		 ; estimated
ENDIF ELSE IF st_code EQ 'LCC3' THEN BEGIN
    latitude_st    = ten(-18,21,29)    
    longitude_st   = ten(123,07,05)    
    elevation_st   = 50 	 ; estimated
ENDIF ELSE IF st_code EQ 'dfn_st1' THEN BEGIN
    latitude_st    = 0    
    longitude_st   = 0  
    elevation_st   = 0 
ENDIF ELSE IF st_code EQ 'dfn_st2' THEN BEGIN
    latitude_st    = 0   
    longitude_st   = 0   
    elevation_st   = 0 
ENDIF ELSE BEGIN
  print, "getinfo_station : Can not determine location station_code : ",st_code
  STOP
ENDELSE

st_info=[latitude_st,longitude_st,elevation_st]

end
