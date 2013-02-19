pro sparvm_compute_orbit,orbit_code,geo_xyz,jd,Vavg,orbital_ele,comment
;
;
; PURPOSE:
;     Computes helio centric orbital elements from geocentric (Position, Velocity) state vector 
;
; CALLING SEQUENCE:
;    sparvm_compute_orbit,orbit_code,geo_xyz,jd,Vavg,orbital_ele
;
; INPUTS:
;     geo_xyz  : Position [X,Y,Z] and Velcoity [Vx,Vy,Vz] of a meteor at jd [km & km/s]
;     jd       : Julian date [days]
;
; OUTPUTS:
;     Orbital_ele  : Perifocal distance [AU]
;                  : Semi major axis [AU]
;                  : Eccentricity 
;                  : Inclination  [deg]
;                  : Longitude of the ascending node [deg]
;                  : Argument of periapsis [deg]
;                  : Mean anomaly at epoch [deg]
;                  : Epoch [seconds past J2000]
;                  : Gravitational parameter [km^3/sec^2]
;
; PROCEDURE:
;     called by double_station_main
;
; PROCEDURES USED:
;   cspice_bodvrd, cspice_spkezr,cspice_oscelt,cspice_conics, cspice_sxform 
;
; Last Updated
; 2012-09-10
;
;********************************************************************************************
;********************************************************************************************
;
; Checking if velocity is within range to compute orbits
; Maximum velocity of 100 km/s is used instead of theoritical value of 72, to include hyperbolic meteors. 
IF Vavg LT 12.0 THEN comment = 'Velocity is Less than 12.0 km/s. Not possible to compute Orbit' ELSE $      
IF Vavg GT 100.0 THEN comment = 'Velocity is more than 100.0 km/s. Orbits not computed' ELSE comment = ' '
;
IF strlen(comment) LT 50 AND orbit_code EQ 'yes' THEN BEGIN

; Position of Earth at given jd
  et_atm = ( jd-cspice_j2000() ) *cspice_spd()
  cspice_bodvrd, 'EARTH', "GM", 5, GMe
  cspice_spkezr, 'EARTH', et_atm[0], 'J2000', 'LT', 'SUN', Estate, ltime 

; Sphere of Influence of Earth
  Rear=sqrt( total(Estate[0:2]^2) )
  cspice_bodvrd, 'SUN', "GM", 5, GMs
  Rsoi=Rear*(GMe/(GMs))^(2./5)

; Convert state-velocity vector to geocentric orbital elements
  cspice_oscelt, geo_xyz, et_atm[0], GMe[0], elt_atm
  et_rsoi_tmp = elt_atm[6] - (Rsoi/sqrt(total(geo_xyz[3:5]^2)) )

; Integration to Sphere of Influence. Assumption meteor path is a parabolla, as influence due to Earth's gravity
  nstep=0
  REPEAT BEGIN
	   et_rsoi=et_rsoi_tmp
     cspice_conics, elt_atm, et_rsoi[0], rsoi_xyz
     Xear = sqrt (total (rsoi_xyz[0:2]^2) )
     V1   = sqrt (total (rsoi_xyz[3:5]^2) )
     XRdif=abs(Rsoi-Xear)
     IF Xear LT Rsoi THEN et_rsoi_tmp = et_rsoi + XRdif/V1 ELSE $
     IF Xear GE Rsoi THEN et_rsoi_tmp = et_rsoi - Xrdif/V1 ELSE print, 'error'
     nstep=nstep+1
  ENDREP UNTIL XRdif LT 1
;
; Convert geocentric coordinates at sphere of Influence into Heliocentric
  cspice_sxform, 'J2000', 'ECLIPJ2000', et_rsoi[0], xform
  geostate_xyz = transpose(xform) # rsoi_xyz
  cspice_spkezr, 'EARTH', et_rsoi[0], 'ECLIPJ2000', 'LT+S', 'SUN', Earth_hel_xyz, ltime
  helstate_xyz = Earth_hel_xyz - geostate_xyz
  cspice_oscelt, helstate_xyz, et_rsoi[0], GMs[0], elt_rsoi
;
; Compute Semi major axis
  r2d=180./!dpi
  semi_major_axis = elt_rsoi[0]/(1-elt_rsoi[1])
  orbital_ele=[elt_rsoi[0]/Rear,semi_major_axis/Rear,elt_rsoi[1],elt_rsoi[2:6]*r2d]

ENDIF ELSE BEGIN
  orbital_ele = fltarr(8)
ENDELSE

;
end
