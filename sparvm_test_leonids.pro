pro sparvm_test_leonids
;
;
; PURPOSE:
;     Routine to test Leonids metrec data
;
; CALLING SEQUENCE:
;    sparvm_test_leonids
;
; INPUTS:
;    none	
;     
; OUTPUTS:
;    Basic Leonid Output In terminal
;
; PROCEDURES
;   
;
; PROCEDURE USED
;   none   
;
; Last Updated
; 2012-09-10
;
;********************************************************************************************
;********************************************************************************************
;
;
inputfolder1='/home/atreya/work/imperial/test/sparvm/test_data/ICC2/*.OUT'
inputfolder2='/home/atreya/work/imperial/test/sparvm/test_data/LCC3/*.OUT'
;
file1=file_search(inputfolder1, count=nf1 )
file2=file_search(inputfolder2, count=nf2 )
;
result=dblarr(8,nf1)
;
for i=0, nf1-1 do begin
;
sparvm_read_double_station_output,file1[i],st_info1,ra1,dec1,jd1,stxyz1,eqplane1,radiant1,qab1,$
  pxyz1,platlon1,Vavg1,Vinf1,std_vel1,orbital_ele1
;
sparvm_read_double_station_output,file2[i],st_info2,ra2,dec2,jd2,stxyz2,eqplane2,radiant2,qab2,$
  pxyz2,platlon2,Vavg2,Vinf2,std_vel2,orbital_ele2
;
result[*,i] = [radiant1, Vavg1, Vavg2, Vinf1, Vinf2, std_vel1, std_vel2] 
;
endfor 
;
;
leo_ra=152
leo_dec=21 
leo_diff=10
;
index_leo = where ( abs(result[0,*] - leo_ra) LT leo_diff AND abs(result[1,*] - leo_dec) LT leo_diff, num1 )
leo_result=result[*,index_leo]
;
ra = mean(leo_result[0,*]) & ra_std = stddev(leo_result[0,*])
dec = mean(leo_result[1,*]) & dec_std = stddev(leo_result[1,*])
;
v1 = mean(leo_result[4,*]) & v1_std = stddev(leo_result[4,*])
v2 = mean(leo_result[5,*]) & v2_std = stddev(leo_result[5,*])
;
;
print, 'Total number of leonid meteors',num1,format='(a,21X,I2)'
print, "Leonids radiant RA and std [deg]",ra,ra_std,format='(a,18X,F6.2,5X,F3.1)'
print, "Leonids radiant Dec and std [deg]", dec,dec_std,format='(a,18X,F5.2,5X,F3.1)'
;
print, "Velocity Infinity from station-1 and STD [km/s]", V1, v1_std, format='(a,4X,F5.2,4X,F4.1)'
print, "Velocity Infinity from station-2 and STD [km/s]", V2, v2_std, format='(a,4X,F5.2,4X,F4.1)'
;
end
