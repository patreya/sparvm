pro sparvm_configuration,path_to_spice_kernel, inputfolder1, inputfolder2, inputfile_extension, station1_code, station2_code, $
            orbit_code, log_code, logfile_path, meteor_diff 
;
;
; PURPOSE:
;     Configuration file for running sparvm double station. Values, paths and filenames are set here. 
;
; CALLING SEQUENCE:
;    sparvm_configuration,path_to_spice_kernel, inputfolder1, inputfolder2, inputfile_extension, station1_code, station2_code, $
;            orbit_code, log_code, logfile_path, meteor_diff 
;
; INPUTS:
;    none	
;     
; OUTPUTS:
;    path_to_spice_kernel	: Path to the SPICE kernels to load routines for orbit computation 
;    inputfolder1		: Input folder of station-1.
;    inputfolder2		: Input folder of station-2.
;    inputfile_extension	: Type of Input file extenion such as TXT or INF
;    station1_code 		: Station-1 code. Station-1 information is loaded using this code from sparvm_getinfo_station
;    station2_code		: Station-2 code. Station-1 information is loaded using this code from sparvm_getinfo_station
;    orbit_code 		: Orbit code. "yes" denotes to compute orbit
;    log_code 			: Log file code. "yes" denotes to create log file
;    logfile_path 		: Log file path. Path where Log files are saved
;    meteor_diff 		: difference between two meteor file times to design them as double station [sec].
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
; Path to the SPICE standard kernel file
path_to_spice_kernel = '/home/atreya/work/imperial/test/sparvm/spice/kernels/standard.ker'
;
; Path to the main folder of Station Event data
; For more than one file end the folder name with '/*'. 
; For only one file, end the file with filename excluding the dot(.) extension 
inputfolder1 = '/home/atreya/work/imperial/test/sparvm/test_data/ICC2/*'
inputfolder2 = '/home/atreya/work/imperial/test/sparvm/test_data/LCC3/*'
;
; Input file extension. Differentiate it from others FITS, LOG, PS, PDF or TXT file
; Include dot before the given extention
inputfile_extension = '.INF'
;
;Station Code. Use this code to get station geographic information
station1_code = 'ICC2'
station2_code = 'LCC3'
;
; Compute orbit ("yes"). Any other value is 'no' 
orbit_code = 'yes'
;
; Create log file ("yes"). Any other value is 'no'. 
; Log file is created for every run and is named according to the date and time of the run. It contains output concering the progress of the software.   
log_code = 'yes'
logfile_path='/home/atreya/work/imperial/test/sparvm/test_data'
;
;
; Time difference in seconds between two meteors to classify them as double station meteors 
meteor_diff = 5.0
;
; NOTE: Use this file to add more configuration parameters when needed
; 
end


