pro sparvm_intersect_plane,eqconst1,eqconst2,intervec,radiant,qab
;
;
; PURPOSE:
;     Intersect two given planes to get meteor radiant
;
; CALLING SEQUENCE:
;     podet_intersect_plane,eqconst1,eqconst4,intervec,rad_radec,qab
;    
; INPUTS:
;     eqconst1 	: equation of plane 1
;     eqconst2	: equation of plane 2
;    
; OUTPUTS:
;     intervec 	: Intersection vector of two planes 
;     radiant	: Radiant (RA, Dec) [degree]
;     qab	: Angle between the two planes [degree]
;
; PROCEDURE:
;     called by sparvm_double_station_main
;
; PROCEDURES USED:
;   none
;
; Last Updated
; 2012-09-10
;  
;**************************************************************************************
;**************************************************************************************
;
;
r2d=180/!Dpi
a1 = eqconst1[0] 	& b1 = eqconst1[1] 	& c1=eqconst1[2]
a2 = eqconst2[0] 	& b2 = eqconst2[1] 	& c2=eqconst2[2]
;
drr   = sqrt((b1*c2 - b2*c1)^2 + (a2*c1- a1*c2)^2 + (a1*b2 - a2*b1)^2)
Rxi   = (b1*c2 - b2*c1)/drr
Reta  = (a2*c1- a1*c2)/drr
Rzeta = (a1*b2 - a2*b1)/drr
;
rad_dec=r2d*(ASIN(Rzeta))
rad_ra=r2d*(ATAN(Reta,Rxi))
;
;
Qab = ACOS(abs(a1*a2 + b1*b2 + c1*c2)*((a1^2 + b1^2 + c1^2)*(a2^2 + b2^2 + c2^2)))
Qab=Qab*r2d
;
intervec=[Rxi,Reta,Rzeta]
radiant=[rad_ra,rad_dec]

end
