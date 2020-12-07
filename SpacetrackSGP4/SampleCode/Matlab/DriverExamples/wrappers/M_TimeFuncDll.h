// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// apPtr              The pointer that was returned from DllMain.DllMainInit (in-Long)
// returns Returns zero indicating the TimeFunc DLL has been initialized successfully. Other values indicate an error.
int TimeFuncInit(__int64 apPtr);


// Returns the information about the TimeFunc DLL.  The information is placed in the string parameter you pass in.
// infoStr            A string to hold the information about TimeFunc.dll. (out-Character[128])
void TimeFuncGetInfo(char* infoStr);


// Loads timing constants data from an input file.
// tconFile           The name of the file from which to read timing constants data. (in-Character[512])
// returns 0 if the input file has been loaded successfully, non-0 if error.
int TConLoadFile(char* tconFile);


// Loads timing constants data and prediction control (6P-card) from an input file.
// tconFile           The name of the file from which to read timing constants data and/or prediction control data. (in-Character[512])
// returns 0 if the input file is loaded successfully, non-0 if there is an error.
int TimeFuncLoadFile(char* tconFile);


// Checks to see if timing constants have been loaded into memory.
// returns 1 if timing constants data have been loaded, some other value if not.
int IsTConFileLoaded();


// Saves currently loaded timing constants data to a file.
// tconFile           The name of the file in which to save the timing constants data. (in-Character[512])
// saveMode           Specifies whether to create a new file or append to an existing one. (0 = Create new file, 1= Append to existing file) (in-Integer)
// saveForm           Specifies the format in which to save the file. (0 = SPECTER Print Record format, 1 = XML format (future implementation)) (in-Integer)
// returns 0 if the data is successfully saved to the file, non-0 if there is an error.
int TConSaveFile(char* tconFile, int saveMode, int saveForm);


// Adds a timing constant record to memory. Note that this function is solely for backward compatible with legacy software.
// The users should use TConLoadFile or TimeFuncLoadFile to load timing constants file instead.
// refDs50UTC         Reference time (days since 1950, UTC) (in-Double)
// leapDs50UTC        Leap Second time (days since 1950, UTC) (in-Double)
// taiMinusUTC        TAI minus UTC offset at the reference time (seconds) (in-Double)
// ut1MinusUTC        UT1 minus UTC offset at the reference time (seconds) (in-Double)
// ut1Rate            UT1 rate of change versus UTC at the reference time (msec/day) (in-Double)
// polarX             Polar wander (X direction) at the reference time (arc-seconds) (in-Double)
// polarY             Polar wander (Y direction) at the reference time (arc-seconds) (in-Double)
// returns 0 if the timing constants record is successfully added to memory, non-0 if there is an error.
int TConAddARec(double refDs50UTC, double leapDs50UTC, double taiMinusUTC, double ut1MinusUTC, double ut1Rate, double polarX, double polarY);


// Adds one timing constant record to memory. This API can be used to avoid TConLoadFile's file I/O
// refDs50UTC         Reference time (days since 1950, UTC) (in-Double)
// taiMinusUTC        TAI minus UTC offset at the reference time (seconds) (in-Double)
// ut1MinusUTC        UT1 minus UTC offset at the reference time (seconds) (in-Double)
// ut1Rate            UT1 rate of change versus UTC at the reference time (msec/day) (in-Double)
// polarX             Polar wander (X direction) at the reference time (arc-seconds) (in-Double)
// polarY             Polar wander (Y direction) at the reference time (arc-seconds) (in-Double)
// returns 0 if the timing constants record is successfully added to memory, non-0 if there is an error.
int TConAddOne(double refDs50UTC, double taiMinusUTC, double ut1MinusUTC, double ut1Rate, double polarX, double polarY);


// Retrieves the timing constants record, if exists, at the requested input time in ds50UTC.
// ds50UTC            Input days since 1950, UTC (in-Double)
// taiMinusUTC        Returned TAI minus UTC offset at requested time (seconds) (out-Double)
// ut1MinusUTC        Returned UT1 minus UTC offset at requested time (seconds) (out-Double)
// ut1Rate            Returned UT1 rate of change versus UTC at Reference time (msec/day) (out-Double)
// polarX             Returned interpolated polar wander (X direction) at requested time (arc-seconds) (out-Double)
// polarY             Returned interpolated polar wander (Y direction) at requested time (arc-seconds) (out-Double)
void UTCToTConRec(double ds50UTC, double* taiMinusUTC, double* ut1MinusUTC, double* ut1Rate, double* polarX, double* polarY);


// Removes all the timing constants records in memory.
// returns 0 if all timing constants records are successfully removed from memory, non-0 if there is an error.
int TConRemoveAll();


// Converts an internal time in ds50UTC to a string in DTG20 format. The resulting string takes the form "YYYY/DDD HHMM SS.SSS".
// ds50UTC            Days since 1950, UTC to be converted. (in-Double)
// dtg20              A string to hold the result of the conversion. (out-Character[20])
void UTCToDTG20(double ds50UTC, char* dtg20);


// Converts a time in ds50UTC to a time in DTG19 format. The resulting string takes the form "YYYYMonDDHHMMSS.SSS".
// ds50UTC            Days since 1950, UTC to be converted. (in-Double)
// dtg19              A string to hold the result of the conversion. (out-Character[19])
void UTCToDTG19(double ds50UTC, char* dtg19);


// Converts a time in ds50UTC to a time in DTG17 format. The resulting string takes the form "YYYY/DDD.DDDDDDDD" format.
// ds50UTC            Days since 1950, UTC to be converted. (in-Double)
// dtg17              A string to hold the result of the conversion. (out-Character[17])
void UTCToDTG17(double ds50UTC, char* dtg17);


// Converts a time in ds50UTC to a time in DTG15 format. The resulting string takes the form "YYDDDHHMMSS.SSS".
// ds50UTC            Days since 1950, UTC to be converted. (in-Double)
// dtg15              A string to hold the result of the conversion. (out-Character[15])
void UTCToDTG15(double ds50UTC, char* dtg15);


// Converts a time in one of the DTG formats to a time in ds50UTC. DTG15, DTG17, DTG19, and DTG20 formats are accepted.
// dtg                The string to convert. Can be any of the DTG formats previously documented. (in-Character[20])
// returns The number of days since 1950, UTC. Partial days may be returned.
double DTGToUTC(char* dtg);


// Converts a time in ds50UTC to a time in ds50TAI using timing constants records in memory. 
// If no timing constants records were loaded, ds50UTC and ds50TAI are the same.
// ds50UTC            Days since 1950, UTC to be converted. (in-Double)
// returns The number of days since 1950, TAI. Partial days may be returned.
double UTCToTAI(double ds50UTC);


// Converts a time in ds50UTC to a time in ds50UT1 using timing constants records in memory. 
// If no timing constants records were loaded, ds50UTC and ds50UT1 are the same. 
// ds50UTC            Days since 1950, UTC to be converted. (in-Double)
// returns The number of days since 1950, UT1. Partial days may be returned.
double UTCToUT1(double ds50UTC);


// Converts a time in ds50UTC to a time in ds50ET using timing constants records in memory. 
// If no timing constants records were loaded, ds50UTC and ds50UT1 are the same. 
// ds50UTC            Days since 1950, UTC to be converted. (in-Double)
// returns The number of days since 1950, ET. Partial days may be returned.
double UTCToET(double ds50UTC);


// Converts a time in ds50TAI to a time in ds50UTC using timing constants records in memory. 
// If no timing constants records were loaded, ds50TAI and ds50UTC are the same. 
// ds50TAI            Days since 1950, TAI to be converted. (in-Double)
// returns The number of Days since 1950, UTC. Partial days may be returned.
double TAIToUTC(double ds50TAI);


// Converts a time in ds50TAI to a time in ds50UT1 using timing constants records in memory. 
// If no timing constants records were loaded, ds50TAI and ds50UT1 are the same. 
// ds50TAI            Days since 1950, TAI to be converted. (in-Double)
// returns The number of days since 1950, UT1. Partial days may be returned.
double TAIToUT1(double ds50TAI);


// Converts a year and a number of days to a time in ds50UTC. 
// year               Two or four digit years are accepted. (in-Integer)
// dayOfYear          The day of year. Partial days can be specified. (in-Double)
// returns The number of days since 1950, UTC. Partial days may be returned.
double YrDaysToUTC(int year, double dayOfYear);


// Converts a time in ds50UTC to a year and day of year.
// ds50UTC            Days since 1950, UTC to be converted. (in-Double)
// year               A reference to a variable in which to place the 4-digit year. (out-Integer)
// dayOfYear          A reference to a variable in which to place the day of year. Partial days may be expressed in this variable. (out-Double)
void UTCToYrDays(double ds50UTC, int* year, double* dayOfYear);


// Converts a set of time components (year, day of year, hour, minute, second) to a time in ds50UTC. 
// year               Two or four digit years are accepted. (in-Integer)
// dayOfYear          The day of year, expressed as a whole number. (in-Integer)
// hh                 The hour. (in-Integer)
// mm                 The minute. (in-Integer)
// sss                The second, including partial seconds if desired. (in-Double)
// returns The number of Days since 1950, UTC. Partial days may be returned.
double TimeComps1ToUTC(int year, int dayOfYear, int hh, int mm, double sss);


// Converts a time in ds50UTC to its individual components (year, day of year, hour, minute, second).
// ds50UTC            Days since 1950, UTC to be converted. (in-Double)
// year               A reference to a variable in which to store the 4-digit year. (out-Integer)
// dayOfYear          A reference to a variable in which to store the day of year. (out-Integer)
// hh                 A reference to a variable in which to store the hour. (out-Integer)
// mm                 A reference to a variable in which to store the minute. (out-Integer)
// sss                A reference to a variable in which to store the second. Partial seconds may be expressed if necessary. (out-Double)
void UTCToTimeComps1(double ds50UTC, int* year, int* dayOfYear, int* hh, int* mm, double* sss);


// Converts a set of time components (year, month, day of month, hour, minute, second) to a time in ds50UTC. 
// year               Two or four digit years are accepted. (in-Integer)
// mon                The month. (in-Integer)
// dayOfMonth         The day of the month. (in-Integer)
// hh                 The hour. (in-Integer)
// mm                 The minute. (in-Integer)
// sss                The second. (in-Double)
// returns The number of Days since 1950, UTC. Partial days may be returned.
double TimeComps2ToUTC(int year, int mon, int dayOfMonth, int hh, int mm, double sss);


// Converts a time in ds50UTC to its individual components (year, month, day of month, hour, minute, second).
// ds50UTC            Days since 1950, UTC to be converted. (in-Double)
// year               A reference to a variable in which to store the 4-digit year. (out-Integer)
// month              A reference to a variable in which to store the month. (out-Integer)
// dayOfMonth         A reference to a variable in which to store the day of the month. (out-Integer)
// hh                 A reference to a variable in which to store the hour. (out-Integer)
// mm                 A reference to a variable in which to store the minute. (out-Integer)
// sss                A reference to a variable in which to store the second. Partial seconds may be expressed if necessary. (out-Double)
void UTCToTimeComps2(double ds50UTC, int* year, int* month, int* dayOfMonth, int* hh, int* mm, double* sss);


// Computes right ascension of Greenwich at the specified time in ds50UT1. 
// The Fk constants as you currently have them set up in EnvConst.dll are used.
// ds50UT1            Input days since 1950, UT1. (in-Double)
// envFk              A handle to the FK data. Use the value returned from EnvGetFkPtr(), located in EnvConst.dll. (in-Long)
// returns Right ascension of Greenwich in radians at the specified time.
double ThetaGrnwch(double ds50UT1, __int64 envFk);


// Computes right ascension of Greenwich at the specified time in ds50UT1 using the Fourth Fundamental Catalogue (FK4).
// ds50UT1            Days since 1950, UT1. (in-Double)
// returns Right ascension of Greenwich in radians at the specified time using FK4.
double ThetaGrnwchFK4(double ds50UT1);


// Computes right ascension of Greenwich at the specified time in ds50UT1 using the Fifth Fundamental Catalogue (FK5).
// ds50UT1            Input days since 1950, UT1. (in-Double)
// returns Right ascension of Greenwich in radians at the specified time using FK5.
double ThetaGrnwchFK5(double ds50UT1);


// This function is intended for future use.  No information is currently available.
// funcIdx            Input function index (in-Integer)
// frArr              Input (in-Double[*])
// toArr              Output (out-Double[*])
void TimeConvFrTo(int funcIdx, double* frArr, double* toArr);


// Returns prediction control parameters. The parameters are placed in the reference variables passed to this function.
// startFrEpoch       Indicates whether startTime is expressed in minutes since epoch. (startFrEpoch = 1: startTime is in minutes since epoch, startFrEpoch = 0: startTime is in days since 1950, UTC) (out-Integer)
// stopFrEpoch        Indicates whether stopTime is expressed in minutes since epoch. (stopFrEpoch = 1: stopTime is in minutes since epoch, stopFrEpoch = 0: stopTime is in days since 1950, UTC) (out-Integer)
// startTime          The start time. Depending on the value of startFrEpoch, start time can be expressed in minutes since epoch or days since 1950, UTC. (out-Double)
// stopTime           The stop time. Depending on the value of stopFrEpoch, stop time can be expressed in minutes since epoch or days since 1950, UTC. (out-Double)
// interval           The Step size (min). (out-Double)
void Get6P(int* startFrEpoch, int* stopFrEpoch, double* startTime, double* stopTime, double* interval);


// Sets prediction control parameters.
// startFrEpoch       Indicates whether startTime is expressed in minutes since epoch. (startFrEpoch = 1: Value of startTime is in minutes since epoch, startFrEpoch = 0: Value of startTime is in days since 1950, UTC) (in-Integer)
// stopFrEpoch        Indicates whether stopTime is expressed in minutes since epoch. (stopFrEpoch = 1: Value of stopTime is in minutes since epoch, stopFrEpoch = 0: Value of stopTime is in days since 1950, UTC) (in-Integer)
// startTime          Start time. (in-Double)
// stopTime           Stop time. (in-Double)
// interval           Step size (min). (in-Double)
void Set6P(int startFrEpoch, int stopFrEpoch, double startTime, double stopTime, double interval);


// Returns current prediction control parameters in form of a 6P-Card string.
// card6PLine         The resulting 6P-Card string. (out-Character[512])
void Get6PCardLine(char* card6PLine);
  



// ========================= End of auto generated code ==========================
