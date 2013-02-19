pro sparvm_eqn_plane, ra, dec, stxyz, unit_met, eqplane
;
;
; PURPOSE:
;     Computes equation of a plane for a given meteor and station
;
; CALLING SEQUENCE:
;     sparvm_eqn_plane,ra,dec,stxyz,unit_met,eqplane
;    
; INPUTS:
;     ra	: RA of meteor points [degree]
;     dec      	: Dec of meteor points [degree]
;     stxyz   	: XYZ Cartesian coordinates of station [km]
;
; OUTPUTS:
;     unit_met  : Unit vector of the meteor points 
;     eqplane	: Equation of a plane defining meteor trajectory and station
;
; PROCEDURE:
;     called by sparvm_double_station_main
;
; PROCEDURES USED:
;  none
;
; Last Updated
; 2012-09-10 
;
;********************************************************************************************
;********************************************************************************************
;
; Constants
d2r  =!Dpi/180 			
r2d = 180/!Dpi
;
rat=ra*d2r 			
dect=dec*d2r
;
xi = COS(dect)*COS(rat) 	
eta = COS(dect)*SIN(rat) 	
zeta = SIN(dect)
unit_met=[xi,eta,zeta]
;
apr = [(total(xi*eta))*(total(eta*zeta))] - [(total(eta^2))*(total(xi*zeta))]
bpr = [(total(xi*eta))*(total(xi*zeta))]  - [(total(xi^2))*(total(eta*zeta))]
cpr = [(total(xi^2))*(total(eta^2))]      - [(total(xi*eta))^2]
dpr = sqrt(apr^2 + bpr^2 + cpr^2)
;
a   =  (apr/dpr) 		& b  =  (bpr/dpr) 	& c  =  (cpr/dpr)
d = -total([a,b,c]*stxyz)
eqplane=[a,b,c,d]
;
delta = a[0]*xi + b[0]*eta + c[0]*zeta
;
;
end
