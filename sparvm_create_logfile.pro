pro sparvm_create_logfile,logfile_path,logfile
;
;
; PURPOSE:
;    Create log file name.
;
; CALLING SEQUENCE:
;    sparvm_create_logfile,logfile_path,logfile
;
; INPUTS:
;    logfile_path	: Path where Log file is to be saved
;     
; OUTPUTS:
;    logfile		: Full log file name with format as log_file_path/sparvm_DDMMYYYY_HH_MM_SS.LOG
;
; PROCEDURES
;   called my sparvm_double_station_main
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
; Current Julian date and time
current_jd = systime(/JUL)
;
; convert Julian day to gregorian
CALDAT,current_jd, month, day, year, hour, min, sec
;
date_string =  string(day,f='(I2.2)') + string(month,f='(i2.2)') + string(year,f='(I4.4)') + '_' + $
               string(hour,f='(i2.2)') + string(min,f='(i2.2)') + string(min,f='(i2.2)' )
;
;Full name of LOG file with format as log_file_path/sparvm_DDMMYYYY_HH_MM_SS.LOG
logfile=strjoin([logfile_path,'/','sparvm_',date_string,'.LOG'])
;
;
end
