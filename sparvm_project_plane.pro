pro sparvm_project_plane,stxyz,eqconst1,eqconst2,unit_met,pxyz
;
; PURPOSE:
;     Projects meteor position onto a given plane
;
; CALLING SEQUENCE:
;     sparvm_project_plane,stxyz,eqconst1,eqconst2,unit_met,pxyz
;    
; INPUTS:
;     stxyz 	: XYZ Cartesian position of Station [km]
;     eqconst1	: Equation of station1 and meteor trajectory 
;     eqconst2 	: Equation of station4 and meteor trajectory 
;     unit_met	: Unit vector of meteor positions from station 1
;
; OUTPUTS:
;     pxyz	: XYZ cartesian position of meteor trajectory
;
; PROCEDURE:
;     called by sparvm_double_station_main
;
; PROCEDURES USED:
;  SVDC 
;
;*********************************************************************************************
;**********************************************************************************************
;
;
sz_xi=(size(unit_met))[2]
pxyz=dblarr(3,sz_xi)
;
an = eqconst1[2]*unit_met[1,*] - eqconst1[1]*unit_met[2,*] 
bn = eqconst1[0]*unit_met[2,*] - eqconst1[2]*unit_met[0,*] 
cn = eqconst1[1]*unit_met[0,*] - eqconst1[0]*unit_met[1,*] 
dn =-an*stxyz[0] -bn*stxyz[1] - cn*stxyz[2]
eqconstn=[an,bn,cn]
;
eqplane1=eqconst1[0:2] & d1=eqconst1[3]
eqplane2=eqconst2[0:2] & d2=eqconst2[3]
;
for i=0,sz_xi-1 do begin
	Aeq = 	[[ eqplane1 ], $  
   	 	 [ eqplane2 ], $ 
   	 	 [ eqconstn[*,i] ]]
 
	Beq=[d1,d2,dn[i]]

	SVDC, Aeq, W, U, V
		N = N_ELEMENTS(W)  
		WP = FLTARR(N, N)  
		FOR K = 0, N-1 DO $  
   		IF ABS(W(K)) GE 1.0e-5 THEN WP(K, K) = 1.0/W(K)
	pxyz[*,i] = -( V ## WP ## TRANSPOSE(U) ## Beq )  
endfor 
;
end
