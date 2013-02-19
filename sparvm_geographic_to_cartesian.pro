pro sparvm_geographic_to_cartesian, st_info, jd, stxyz
;
;
; PURPOSE:
;     Converts geographic (lat,lon,alt) of stations to cartesian Coordinates (X,Y,Z)
;
; CALLING SEQUENCE:
;   sparvm_geographic_to_cartesian,st_info,jd,stxyz  
;
; INPUTS:
;     st_info 	: Latitude & Longitude [Degrees] & Altitude [km]
;     jd	: Julian date [days] 
;
; OUTPUTS:
;     stxyz   	: X, Y, Z cartesian coordinates with Earth centre as Origin [km]
;
;
; PROCEDURE:
;     called by sparvm_double_station_main
;
;
; PROCEDURES USED:
;   CT2LST,cirrange,LST2CT
;
; Last Updated
; 2012-09-10 
;
;********************************************************************************************
;********************************************************************************************
;
; mathematical conversion constants
d2r = !Dpi/180 	& r2d = 180/!Dpi
h2d = 15.0D 	& d2h = 1/15.0D
;
; Using WGS−84 Earth model 
fconst = 1d/298.257223563   
Req = 6378.137d  
Rpol = double(Req*(1-fconst))
;
;
; Using local sidereal time instead of longitude
CT2LST, lst1, st_info[1], dummy, jd[0]
lat=st_info[0]*d2r 	& lst=lst1*15*d2r & alt=st_info[2]
;
; Conversion from geodectic to geocentric latitude	
geo_lat = ATAN((TAN(lat))*(1-fconst)^2)
;
; Radius of the Earth at the station
Rs = sqrt((Req^2 - Rpol^2)/(((Req/Rpol)*TAN(geo_lat))^2 + 1) + Rpol^2 )
;
; Conversion from spherical to cartesian CS
Xst = (Rs+alt)*COS(geo_lat)*COS(lst)
Yst = (Rs+alt)*COS(geo_lat)*SIN(lst)
Zst = (Rs+alt)*SIN(geo_lat)
;
; 
stxyz = [Xst,Yst,Zst]
geo_lat=geo_lat*r2d


end
