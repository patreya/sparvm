pro sparvm_vel_corr,Vavg,hh0,rad,latavg,lstm,Vcc,Vinf
;
;
; PURPOSE:
;     Corection to meteor velcoity (Earth's rotation and Gravitation) to compute velocity at infinity
;
; CALLING SEQUENCE:
;     sparvm_vel_corr,Vavg,hh0,rad,latavg,ra,Vcc,Vinf
;
; INPUTS:
;     Vavg 	: Average Velocity of meteor [km/s] 
;     hh0	: Height of the meteor from centro of the Earth [km]
;     rad	: RA & Dec of the radiant [Degree]
;  latavg	: latitude of the meteor tarjectory at hh0 [deg] 
;      ra	: RA [dec] of meteor trajectory at at hh0 [deg]
;
; OUTPUTS:
;     Vcc 	: Meteor velcoity in XYZ direction [km/s]
;    Vinf	: velcoity at each point [km/s]
;
;
; PROCEDURES USED:
;   
;***********************************************************************************************************************************************
;************************************************************************************************************************************************
;

; Constants
d2r=!dpi/180.		 & r2d=180./!dpi
GMe=double(398600.44)
rta=(lstm+90)*d2r
;
rad1=rad*d2r    
;
; Vector from radiant
Vx=Vavg*COS(rad1[1])*COS(rad1[0])
Vy=Vavg*COS(rad1[1])*SIN(rad1[0])
Vz=Vavg*SIN(rad1[1])
;
; Earth rotation
Vear = 2*!pi*hh0*COS(latavg)/86164.09
Vxc = Vx - Vear*COS(rta)
Vyc = Vy - Vear*SIN(rta)
Vzc = Vz
Vc =sqrt(Vxc^2 + Vyc^2 + Vzc^2)
Vcc=[Vxc,Vyc,Vzc]
;
; Velocity corrected after earth gravitation 
Vinf = sqrt(Vc^2 - double(2*GMe/hh0) )
IF Vavg LT 11.2 THEN Vinf=0

 
;
end
