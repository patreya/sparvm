pro sparvm_file_time, inputfile, timehr
;
;
; PURPOSE:
;     Get time from the metrec filenames. Used to identify double station meteors.      
;     
; CALLING SEQUENCE:
;     sparvm_file_time, inputfile, timehr 
;    
; INPUTS:
;     inputfile	: Array of Input file names 
;
; OUTPUTS:
;     timehr  	: Time extracted from filenames [Hr]
;
; PROCEDURE:
;     called by sparvm_double_station_main
;
; PROCEDURES USED:
;  none
;
; Note: This routine only works with example filename only. All the string values of filenames between slashes '/' are extracted (full_name). Then filename extention '.INF' is also removed (name). Change the string position in 'hr', 'min' and 'sec' according to your filename. For example for filename 'DDMMYYYY_HHMMSS.INP', hr=strmid(name,9,2),min=strmid(name,11,2),sec=strmid(name,13,2)    
;
; Last Updated
; 2012-09-10 
;
;********************************************************************************************
;********************************************************************************************
;
; Number of files
sz_file = (size(inputfile))[1]
timehr = dblarr(sz_file)
;
for i = 0, sz_file-1 do begin
  full_name = strsplit(inputfile[i], '/', /extract)
  name = ( strsplit( (full_name[(size(full_name))[1] - 1]), '.', /extract) ) [0] 
;
  hr = strmid (name, 0, 2)
  min = strmid (name, 2, 2)
  sec = strmid (name, 4, 2)
;
  timehr[i] = double(hr) + double(min/60.) + double(sec/3600.)
endfor
;
; NOTE: Modify this routine to suit the imperial file formats.  
;
end
