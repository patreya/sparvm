pro sparvm_meteor_vel,p,jd,Vxyz,Vabs,Vavg,std_vel
;
;
; PURPOSE:
;     Compute different form of meteor velocity 
;
; CALLING SEQUENCE:
;    podet_met_vel,p,jd,Vxyz,speed,Vavg,std_vel 
;
; INPUTS:
;     p 	: XYZ Cartesian Coordinates of meteor trajectory [km] 
;     jd	: Julian day [days] of meteor position
;
; OUTPUTS:
;     Vxyz 	: Meteor velcoity in XYZ direction [km/s]
;     Vabs	: velcoity at each point [km/s]
;     Vavg	: Average velocity computed using all permutations of points [km/s]
;  std_vel 	: Standard deviation for Vavg [km/s]
;
;
; PROCEDURE:
;     called by sparvm_cartesian_to_geographic. 
;
; PROCEDURES USED:
;   moment
;
; Note: Other methods might exists to compute velocity depending on the quality of the meteor data.   
;
; Last Updated
; 2012-09-10 
;
;***********************************************************************************************************************************************
;************************************************************************************************************************************************
;
; Defining varaibles
szp=(size(p))[2]
spall=dblarr(szp,szp)	
timetot=dblarr(szp)
;
;Creation of time for metrec. Change this for other data.
FOR k=0,szp-1 DO timetot[k]=(jd[k]-jd[0])*24.*3600
;
;Calculation of speed for all permutations
for i=0,szp-1 do begin
	for j=0,szp-1 do begin
		len1   = sqrt( total((p[*,j]-p[*,i])^2 ) )
		tme1   = (timetot[j]-timetot[i] )
		spall[i,j]= len1/tme1
	endfor
endfor
;
;
;Mean and standard deviation
Vavg=(moment(abs(spall), /NAN))[0]
std_vel=sqrt((moment(abs(spall), /NAN))[1])
;
;Calculating speed using two adjacent points
tme=dblarr(3,szp-1)   
len=dblarr(3,szp-1)
;
for i=0,szp-2 do begin
  len[*,i]=p[*,i+1]-p[*,i]
	tme[*,i] = [(timetot[i+1]-timetot[i]), (timetot[i+1]-timetot[i]), (timetot[i+1]-timetot[i]) ]
endfor
;
; Velocity at each XYZ direction 
Vxyz = len/tme
;
; Absolute Velocity at each point
Vabs=sqrt ( (Vxyz[0,*])^2 + (Vxyz[1,*])^2 + (Vxyz[2,*])^2 )
;
;
end
