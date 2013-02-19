pro sparvm_cartesian_to_geographic, pxyz, jd, platlon, Rs, geo_lat, lst_deg
;
;
; PURPOSE:
;     Converts Cartesian Coordinates (X,Y,Z) of meteors to Geographic (lat,lon,alt)
;
; CALLING SEQUENCE:
;     sparvm_cartesian_to_geographic,pxyz,jd, platlon, Rs, geo_lat, lst_deg
;
; INPUTS:
;     pxyz    	: cartesian [X,Y,Z] coordinates of meteor [km]
;     jd	: Julian date [days]
;
; OUTPUTS:
;     platlon 	: [latitude, longitude, altitude] of meteor in deg and km
;     Rs      	: Distance of the point from centre of the Earth [km]
;     geo_lat 	: Geocentric Latitude of the point [deg] 
;     lst_deg	: Local sidereal time [deg]
;
; PROCEDURE:
;     called by sparvm_double_station_main
;
; PROCEDURES USED:
;   cirrange, sparvm_LST2LON
;
; Last Updated
; 2012-09-10
;
;********************************************************************************************
;********************************************************************************************
;
; Constants
d2r=!Dpi/180 	& r2d=180/!Dpi
h2d=15.0D 	& d2h=1/15.0D
;
; Using WGS−84 Earth model 
fconst=1d/298.257223563   
Req=6378.137d  
Rpol=double(Req*(1-fconst))
;
Xst=pxyz[0,*] & Yst=pxyz[1,*] & Zst=pxyz[2,*]
;
Rt=sqrt(Xst^2 + Yst^2 + Zst^2)
lst = ATAN(Yst,Xst)
cirrange,lst,RADIANS=1
geo_lat=ASIN(Zst/rt)
;
; Radius of the Earth
Rs = sqrt( (Req^2 - Rpol^2) / ( ( (Req/Rpol)*TAN(geo_lat) )^2 + 1) + Rpol^2 )
alt=Rt-Rs 
;
; Conversion from geocentric to geodetic latitude 	
lat1=ATAN((TAN(geo_lat)),(1-fconst)^2)
geodic_lat= lat1 + alt*(geo_lat-lat1)/(Rs+alt)
;
; Conversion from local sidereal time to longitude
sparvm_LST2LON, lst*r2d/15., jd[0], lon
;
; Output to degree
platlon=[geodic_lat*r2d, lon, alt]
geo_lat=geo_lat*r2d
lst_deg=lst*r2d	
;
;
end
