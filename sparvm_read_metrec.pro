pro sparvm_read_metrec,file,ra,dec,mag,tsec,jd
;
;
; PURPOSE:
;     Reads metrec output file
;
; CALLING SEQUENCE:
;     sparvm_read_metrec,file,ra,dec,mag,tsec,jd
;
; INPUTS:
;     file    : metrec file
;
; Outputs
;     ra      : RA of meteor
;     dec     : Declination of meteor
;     mag     : Magnitude of meteor
;     tsec    : Meteor seconds
;     jd      : Julian date [days]
;
; PROCEDURE:
;     called by sparvm_double_station_main
;
; Note: This file is used only to read metrec output file
;
;
; PROCEDURES USED:
;   JDCNV,cirrange
;
;********************************************************************************************
;********************************************************************************************

;
;

;
nline=FILE_LINES(file) & data1=strarr(nline)
openr,lun,file, /get_lun & readf,lun ,data1 & free_lun,lun
;
date=STRSPLIT( STRMID(data1[0], 14, 13), " ." ,/EXTRACT )
time1=STRSPLIT( STRMID(data1[1], 14, 13), " :" ,/EXTRACT )
;
pp=nline-5
ra=dblarr(pp) 		& dec=dblarr(pp) 
time=dblarr(3,pp) 	& yesno=strarr(pp)
mag=strarr(pp)		& tsec=dblarr(pp)
;
;
for jj=0,pp-1 do begin
	temp1=STRSPLIT(data1[5+jj], " ," ,/EXTRACT )
	time[*,jj]=[time1[0],time1[1],temp1[1]]
	tsec[jj]=temp1[1]
	ra[jj]=15.0*float(temp1[5])
	dec[jj]=float(temp1[6])
	yesno[jj]=temp1[11]
	mag[jj] =temp1[2]
endfor
;
JDCNV,date[2],date[1],date[0],tenv(time[0,*],time[1,*],time[2,*]),jd
;
;
ind_yesno=where(mag NE '----',imag)
ra=ra[ind_yesno] 
dec=dec[ind_yesno]
jd=jd[ind_yesno]
mag=mag[ind_yesno]
tsec=tsec[ind_yesno]
cirrange, ra

end
