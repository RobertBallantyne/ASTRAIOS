// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// Initializes Lamod dll for use in the program
// apPtr              The handle that was returned from DllMainInit() (in-Long)
// returns 0 if Lamod.dll is initialized successfully, non-0 if there is an error
int LamodInit(__int64 apPtr);


// Returns information about the current version of Lamod.dll. The information is placed in the string parameter you pass in
// infoStr            A string to hold the information about Lamod.dll. (out-Character[128])
void LamodGetInfo(char* infoStr);


// Loads Lamod-related parameters (1P/2P/3P cards, and Lamod parameter free format) from an input text file
// lamodInputFile     The name of the file containing Lamod-related parameters (in-Character[512])
// returns 0 if the input file is read successfully, non-0 if there is an error
int LamodLoadFile(char* lamodInputFile);


// Loads Lamod control parameters and all Lamod related data (environment, time, elsets, sensors) from an input text file
// lamodInputFile     The name of the file containing Lamod control parameters and all Lamod related data (in-Character[512])
// returns 0 if the input file is read successfully, non-0 if there is an error
int LamodLoadFileAll(char* lamodInputFile);


// Loads a single Lamod-typed card
// card               Lamod-type input card (in-Character[512])
// returns 0 if the input card is read successfully, non-0 if there is an error
int LamodLoadCard(char* card);


// Saves any currently loaded Lamod-related settings to a file
// lamodFile          The name of the file in which to save the settings (in-Character[512])
// saveMode           Specifies whether to create a new file or append to an existing one (0 = create, 1= append) (in-Integer)
// saveForm           Specifies the mode in which to save the file (0 = text format, 1 = not yet implemented, reserved for future) (in-Integer)
// returns 0 if the data is successfully saved to the file, non-0 if there is an error
int LamodSaveFile(char* lamodFile, int saveMode, int saveForm);


// Returns number of sensors/satellites entered via 1P/2P cards
// numSens            The number of sensors that were entered via 1P/2P cards (out-Integer)
// numSats            number of satellites that were entered via 1P/2P cards (out-Integer)
void LamodGetNumOfSensSats(int* numSens, int* numSats);


// Retrieves all of the input sensor numbers that were entered via 1P-card  (column 38-44), 2P-card, or Lamod parameter free format (SENNO=)
// senNums            The array in which to store the list of input sensors that were entered via 1P/2P cards or Lamod parameter free format (out-Integer[*])
void LamodGetSenNums(int* senNums);


// Retrieves all of the input satellite numbers that were entered via 1P-card (column 40-62), 2P-card, or Lamod parameter free format (SATNO=)
// satNums            The array in which to store the list of input satellites that were entered via 1P/2P cards or Lamod parameter free format (out-Integer[*])
void LamodGetSatNums(int* satNums);


// Builds and returns the Lamod parameter card (1P-Card) from the current Lamod settings
// lamod1PCard        the resulting Lamod 1P card (out-Character[512])
void LamodGet1pCard(char* lamod1PCard);


// Retrieves all Lamod control parameters with a single function call
// timeFlg            Time format:0 = minutes since epoch (MSE), 1 = days since 1950, UTC (out-Integer)
// startTime          Begin time in ds50UTC or MSE depending on timeFlg (out-Double)
// stopTime           End time  in ds50UTC or MSE depending on timeFlg (out-Double)
// interval           Output interval (min) (out-Double)
// prtOpt             Print options (out-Integer)
// punchObs           Flag to generate obs from look angles: 0=Do not form obs, 1=Form B3 obs from look angles, 2=Form TTY obs from look angles (out-Integer)
// visFlg             Optical visibility flag:	0=Accept all passes, 1=Accept optically visual pass only, 2=Same as 1 w/ SAA restrictions, 3=For IR sensors, 9=Use limits record (out-Integer)
// stepMode           Step mode: 0=Use culmination mode, 1=Use step mode (out-Integer)
// schedMode          Processing mode:'O' = OBSCHED mode (all sensors vs all sats), 'P' = PASCHED mode (all satellites vs all sensors) (out-Character)
// diagMode           Pass by pass diagnostic flag: 0=None, 1=Print sensor/sat position at each look, 2=Print pass-by-pass diagnostics, 3=1+2 combined (out-Integer)
// solAspAngle        Max solar aspect angle (deg) for optical sites (out-Double)
void LamodGet1pAll(int* timeFlg, double* startTime, double* stopTime, double* interval, int* prtOpt, int* punchObs, int* visFlg, int* stepMode, char* schedMode, int* diagMode, double* solAspAngle);


// Sets all Lamod control parameters with a single function call
// timeFlg            Time format:0 = minutes since epoch (MSE), 1 = days since 1950, UTC (in-Integer)
// startTime          Begin time in ds50UTC or MSE depending on timeFlg (in-Double)
// stopTime           End time  in ds50UTC or MSE depending on timeFlg (in-Double)
// interval           Output interval (min) (in-Double)
// prtOpt             Print options (in-Integer)
// punchObs           Flag to generate obs from look angles: 0=Do not form obs, 1=Form B3 obs from look angles, 2=Form TTY obs from look angles (in-Integer)
// visFlg             Optical visibility flag:	0=Accept all passes, 1=Accept optically visual pass only, 2=Same as 1 w/ SAA restrictions, 3=For IR sensors, 9=Use limits record (in-Integer)
// stepMode           Step mode: 0=Use culmination mode, 1=Use step mode (in-Integer)
// schedMode          Processing mode:'O' = OBSCHED mode (all sensors vs all sats), 'P' = PASCHED mode (all satellites vs all sensors) (in-Character)
// diagMode           Pass by pass diagnostic flag: 0=None, 1=Print sensor/sat position at each look, 2=Print pass-by-pass diagnostics, 3=1+2 combined (in-Integer)
// solAspAngle        Max solar aspect angle (deg) for optical sites (in-Double)
void LamodSet1pAll(int timeFlg, double startTime, double stopTime, double interval, int prtOpt, int punchObs, int visFlg, int stepMode, char schedMode, int diagMode, double solAspAngle);


// Retrieves the value of a specified Lamod control parameter (1P-card field)
// xf_1P              Predefined number specifying which Lamod control parameter  to retrieve (in-Integer)
// retVal             A string to hold the value of the requested Lamod parameter (out-Character[512])
void LamodGet1pField(int xf_1P, char* retVal);


// Sets the value of a specified Lamod control parameter (1P-card field)
// xf_1P              Predefined number specifying which Lamod control parameter to set (in-Integer)
// valueStr           The new value of the specified field, expressed as a string (in-Character[512])
void LamodSet1pField(int xf_1P, char* valueStr);


// Retrieves the concurrent viewing options read from the input 3P Parameter card
// concurrFlg         Concurrent view option: 0=Normal looks (1 sen + 1 sat), 1/4=2 or 3 sens viewing the same target sat, 2/3=1 orbiting sen viewing the target sat as 2nd/3rd site(s) viewing the orbiting sen (out-Integer)
// concurrSens        Concurrent sensor numbers (maximum 3 sensors) (out-Integer[3])
void LamodGet3pAll(int* concurrFlg, int* concurrSens);


// Sets concurrent viewing options similar to what is entered in the input 3P Parameter card
// concurrFlg         Concurrent view option: 0=Normal looks (1 sen + 1 sat), 1/4=2 or 3 sens viewing the same target sat, 2/3=1 orbiting sen viewing the target sat as 2nd/3rd site(s) viewing the orbiting sen (in-Integer)
// concurrSens        Concurrent sensor numbers (maximum 3 sensors) (in-Integer[3])
void LamodSet3pAll(int concurrFlg, int* concurrSens);


// Returns the full file name of the output obs file that was specified using "OBSOUT = " in the main input file or using the LamodSetObsFileName() function call
// obsFile            The output obs file name (out-Character[512])
void LamodGetObsFileName(char* obsFile);


// Sets the full file name of the output obs file which will be used to store the generated obs data
// obsFile            The new output obs file name (in-Character[512])
void LamodSetObsFileName(char* obsFile);


// Checks to see whether the input satellite will ever be viewable to the input sensor
// senKey             The sensor's unique key (sensor number) (in-Integer)
// satKey             The satellite's unique key (in-Long)
// returns 1 if the input satellite is viewable to the input sensor, 0 if not
int LamodSenSatVisible(int senKey, __int64 satKey);


// Initializes a sensor/satellite pair in preparation for computing look angles
// senKey             The sensor's unique key (sensor number) (in-Integer)
// satKey             The satellite's unique key (in-Long)
// returns Returns a senSatKey: gt 0: Success, = 0: Warning, lt 0: Error
__int64 LamodInitSenSat(int senKey, __int64 satKey);


// Retrieves all of the data for an initialized sensor/satellite pair with a single function call
// senSatKey          The sensor/satellite pair's unique key (in-Long)
// stepMode           0: culmination, 1: step mode (out-Integer)
// visPassOnly        Visual pass only (out-Integer)
// startDs50TAI       Start time in ds50TAI (out-Double)
// stopDs50TAI        Stop time in ds50TAI (out-Double)
// interval           Output interval (min) (out-Double)
// period             Satellite's period (min) (out-Double)
// returns 0 if the computation data is retrieved successfully, non-0 if there is an error
int LamodGetSenSatDataAll(__int64 senSatKey, int* stepMode, int* visPassOnly, double* startDs50TAI, double* stopDs50TAI, double* interval, double* period);


// Retrieves an individual field of data for an initialized sensor/satellite pair
// senSatKey          The sensor/satellite pair's unique key (in-Long)
// xf_SenSat          Predefined number specifying which data field to retrieve (in-Integer)
// retVal             A string to contain the value of the requested field (out-Character[512])
// returns 0 if the data is successfully retrieved, non-0 if there is an error
int LamodGetSenSatDataField(__int64 senSatKey, int xf_SenSat, char* retVal);


// Returns the number of possible passes of the sensor/satellite pair in the requested time span which pass 
// the horizontal limit test. This function only applies when the culmination mode was selected
// senSatKey          The sensor/satellite pair's unique key (in-Long)
// returns The number of possible passes. Special values: -1: The senSatKey is invalid, 0: culmination mode wasn't selected
int LamodGetNumPasses(__int64 senSatKey);


// Returns an array of rise, culmination, and set times of all possible passes of a sensor/satellite pair during the requested time span
// senSatKey          sensor/satellite pair's unique key (in-Long)
// rcsTimeArr         array of rise/culmination/set times in days since 1950 TAI of the possible passes (out-Double[*, 3])
// returns 0 if the computation is successful, non-0 if there is an error
int LamodGetRiseCulmSetTimes(__int64 senSatKey, double* rcsTimeArr);


// Computes a single look angle of the sensor/satellite pair at the specified time
// senSatKey          The sensor/satellite pair's unique key (in-Long)
// currDs50TAI        Time, in ds50TAI, for which to compute the look angle (in-Double)
// lookCode           lookCode: 0=valid look; 1=Fail horizon break test; 2=Fail sensor's limit tests (out-Integer)
// lookArr            look output data: ds50UTC, mse, el (deg), az (deg), range (km), rangeRate (km/s) (out-Double[6])
// senElts            sensor's state (ECI TEME of Date): position (1st-3rd), velocity (4th-6th), llh (7th-9th) (out-Double[9])
// satElts            satellite's state (ECI TEME of Date): position (1st-3rd), velocity (4th-6th), llh (7th-9th) (out-Double[9])
// returns 0 if the look angle is computed successfully, non-0 if there is an error
int LamodComputeLookAngle(__int64 senSatKey, double currDs50TAI, int* lookCode, double* lookArr, double* senElts, double* satElts);


// Computes at once look and view data of the sensor/satellite pair at the specified time
// senSatKey          The sensor/satellite pair's unique key (in-Long)
// currDs50TAI        Time, in ds50TAI, for which to compute the look angle (in-Double)
// xa_lv              The array that stores resulting look and view data, see XA_LV_??? for array arrangement (out-Double[128])
// returns 0 if the look angle is computed successfully, non-0 if there is an error
int LamodComputeLookView(__int64 senSatKey, double currDs50TAI, double* xa_lv);


// Finds exact time when satellite is IN or OUT of sensor's coverage
// senSatKey          The sensor/satellite pair's unique key (in-Long)
// t1Ds50TAI          The bracket start time when satellite changes its coverage status, in ds50TAI (in-Double)
// t2Ds50TAI          The bracket end time when satellite changes its coverage status, in ds50TAI (in-Double)
// returns The exact time when satellite is IN or OUT of sensor's coverage (= 0 if none exists)
double LamodFindExactIOTime(__int64 senSatKey, double t1Ds50TAI, double t2Ds50TAI);


// Returns viewing and geometric data for orbiting sensors
// senSatKey          The sensor/satellite pair's unique key (in-Long)
// uvSun              unit vector to the sun (out-Double[3])
// uvMoon             unit vector to the moon (out-Double[3])
// angArr             array of angles (deg): moon/sen/sat, sun/earth/sat, sun/earth/sen, sun/sen/sat, solar aspect angle (out-Double[5])
// nBore1             Orbiting sensor boresight vector (U, V, W) for limits interval #1 (out-Integer)
// nBore2             Orbiting sensor boresight vector (U, V, W) for limits interval #2 (out-Integer)
// offBoreAzEl        array of angles (deg): Off-boresight az #1, Off-boresight az #2, Off-boresight el #1, Off-boresight el #2 (out-Double[4])
// returns 0 if the viewing data is retrieved successfully, non-0 if there is an error
int LamodGetOrbSenViewdata(__int64 senSatKey, double* uvSun, double* uvMoon, double* angArr, int* nBore1, int* nBore2, double* offBoreAzEl);


// Retrieves a single field of look angle viewing data
// senSatKey          The sensor/satellite pair's unique key (in-Long)
// xf_View            Predefined value specifying which field to retrieve (in-Integer)
// retVal             An array to store the retrieved result (out-Double[*])
// returns 0 if the viewing data is retrieved successfully, non-0 if there is an error
int LamodGetViewDataField(__int64 senSatKey, int xf_View, double* retVal);


// Computes right-ascension and declination from the input sensor's range unit vector (also called local horizon vector)
// xlPos              sensor local horizon vector (range unit vector) (in-Double[3])
// rasc               computed right ascension (deg) (out-Double)
// decl               computed declination (deg) (out-Double)
// raHr               Right-ascension hour (out-Integer)
// raMin              Right-ascension minute (out-Integer)
// raSec              Right-ascension second (out-Double)
// decDeg             Declination hour (out-Integer)
// decMin             Declination minute (out-Integer)
// decSec             Declination second (out-Double)
void LamodCompRaDec(double* xlPos, double* rasc, double* decl, int* raHr, int* raMin, double* raSec, int* decDeg, int* decMin, double* decSec);


// Retrieves the formatted observation strings, either in B3 or transmission format, generated from the most recent look angle data
// senSatKey          The sensor/satellite pair's unique key (in-Long)
// punchObs           Generate obs from look angles flag: 1/11=Form B3 obs, 2/12=Form transmission, 3/13=SP Tasker (11/12/13 is for LTC) (in-Integer)
// obsClass           Input character specifying the classification of the generated obs (in-Character)
// obsLine1           First line of the formatted obs strings (out-Character[512])
// obsLine2           Second line, if available, of the formatted obs strings (out-Character[512])
// numLines           Number of lines of the output strings (out-Integer)
// returns 0 if the generated obs strings are retrieved successfully, non-0 if there is an error
int LamodGenObs(__int64 senSatKey, int punchObs, char obsClass, char* obsLine1, char* obsLine2, int* numLines);


// Generates formatted observation strings, either in B3 or transmission format, from a VALID look angle obtained at the requested time 
// senSatKey          The sensor/satellite pair's unique key (in-Long)
// currDs50TAI        Time, in ds50TAI, for which to compute the look angle (in-Double)
// punchObs           Generate obs from look angles flag: 1=Form B3 obs, 2=Form transmission, 3=SP Tasker (in-Integer)
// obsClass           Input character specifying the classification of the generated obs (in-Character)
// obsLine1           First line of the formatted obs strings (out-Character[512])
// obsLine2           Second line, if available, of the formatted obs strings (out-Character[512])
// numLines           Number of lines of the output strings (out-Integer)
// returns 0 if the generated obs strings are retrieved successfully, non-0 if there is an error
int LamodGenObsAtTime(__int64 senSatKey, double currDs50TAI, int punchObs, char obsClass, char* obsLine1, char* obsLine2, int* numLines);


// Removes a sensor/satellite pair from Lamod.dll's set of loaded sensor/satellite pairs
// senSatKey          The sensor/satellite pair's unique key (in-Long)
// returns 0 if the sensor/satellite pair is removed successfully, non-0 if there is an error
int LamodRemoveSenSat(__int64 senSatKey);


// Removes all sensor/satellite pairs from Lamod.dll's set of sensor/satellite pairs
// returns 0 if all sensor/satellite pairs are removed successfully, non-0 if there is an error
int LamodRemoveAllSenSats();


// Resets all Lamod-related parameters back to their default values
void LamodReset();

// Indexes of SenSatData fields
static const int  
   XF_SENSAT_STEPMODE     = 1,      // Step mode
   XF_SENSAT_VISPASSONLY  = 2,      // Visual pass only
   XF_SENSAT_BEGDS50TAI   = 3,      // Begin time in ds50TAI
   XF_SENSAT_ENDDS50TAI   = 4,      // End time in ds50TAI
   XF_SENSAT_INTERVAL     = 5,      // Print interval 
   XF_SENSAT_PERIOD       = 6;      // Satellite's period 


//*******************************************************************************
// Indexes of lookCode
static const int  
   LOOK_VALID   = 0,             // Valid look 
   LOOK_HTEST   = 1,             // Failed horizon break test
   LOOK_SENLIMS = 2;             // Failed limit tests

//*******************************************************************************

// Indexes of look angle data output
static const int  
   XA_LOOK_DS50UTC= 0,          // Look time in ds50UTC
   XA_LOOK_MSE    = 1,          // Look time in minutes since epoch
   XA_LOOK_ELEV   = 2,          // Elevation (deg)
   XA_LOOK_AZIM   = 3,          // Azimuth (deg)
   XA_LOOK_RNG    = 4,          // Range (km) or ? for optical sensor
   XA_LOOK_RNGRT  = 5,          // Range rate (km/sec) or ? for optical sensor
   XA_LOOK_SIZE   = 6;
   
//*******************************************************************************   

// Indexes of viewing data output
static const int  
   XF_VIEW_UVEC      =  1,         // computed U-vector to object
   XF_VIEW_RUVEC     =  2,         // range unit vector
   XF_VIEW_LVEC      =  3,         // topocentric L unit vector
   XF_VIEW_ZVEC      =  4,         // station zenith vector
   XF_VIEW_RNGVEC    =  5,         // computed range vector (km)
   XF_VIEW_RRTVEC    =  6,         // computed range-rate vector/relative velocity vector (er/kem)
   XF_VIEW_SUNVEC    =  7,         // unit vector of sun 
   XF_VIEW_MOONVEC   =  8,         // unit vector of moon
   XF_VIEW_ANGARR    =  9,         // angle array (1:moon/sen/sat, 2:sun/earth/sat, 3:sun/earth/sen, 4:sun/sen/sat, 5:solar aspect angle)
   XF_VIEW_CVIS      = 10,         // illumination result
   XF_VIEW_RELVEL    = 11,         // Relative velocity (km/sec)
   XF_VIEW_SENEFG    = 12,         // sensor position EFG
   XF_VIEW_LIMFLGS   = 13,         // limit check flags
   XF_VIEW_AZELRATES = 14,         // azimuth and elevation rates (deg/sec)
   XF_VIEW_MOONANGLES= 15;         // moon angles (1:moon/earth/sat in deg, 2:moon/earth/sen in deg)
   
   
//*******************************************************************************   

// Indexes of angle array
static const int  
   XA_ANGLE_MOONSENSAT  = 0,        //  moon/sen/sat angle (deg)
   XA_ANGLE_SUNEARTHSAT = 1,        //  sun/earth/sat angle (deg)
   XA_ANGLE_SUNEARTHSEN = 2,        //  sun/earth/sen angle (deg)
   XA_ANGLE_SUNSENSAT   = 3,        //  sun/sen/sat angle (deg) - solar exclusion angle
   XA_ANGLE_SOLARASPECT = 4,        //  earth/sat/sun angle (deg) - solar aspect angle/solar phase angle
   XA_ANGLE_SIZE        = 5;

// Indexes of moon angle array
static const int  
   // DHN 18Jan13 - Add moon/earth/sat, moon/earth/sen  angles
   XA_ANGLE_MOONEARTHSAT = 0,       //  moon/earth/sat angle (deg)
   XA_ANGLE_MOONEARTHSEN = 1;       //  moon/earth/sen angle (deg)

   
//*******************************************************************************   

// Indexes of orbiting sensor's off-boresight/clock  array
static const int  
   XA_OFFBORE_EL1 = 0,              //  off-boresight angle 1 
   XA_OFFBORE_AZ1 = 1,              //  off-boresight clock 1
   XA_OFFBORE_EL2 = 2,              //  off-boresight angle 2 
   XA_OFFBORE_AZ2 = 3,              //  off-boresight clock 2
   XA_OFFBORE_SIZE= 4;
   
//*******************************************************************************   

// Indexes of LAMOD 1P-card data
static const int  
   XF_1P_TIMEFRM = 1,        // Input time format: 0=Minutes since epoch, 1=UTC
   XF_1P_BEGTIME = 2,        // Begin time
   XF_1P_ENDTIME = 3,        // End time
   XF_1P_INTERVAL= 4,        // Ouput interval
   XF_1P_PRTOPT  = 5,        // Print options: 0: print look angles, 1: print look angle and initial conditions
   XF_1P_GENOBS  = 6,        // Generate obs from look angles flag
   XF_1P_VISFLG  = 7,        // Compute optical visibility flag: 0: use sen limits,  1: optically visible passes only, 2: output pass only if SAA less than max SAA
   XF_1P_STEPMODE = 8,       // Step mode flag: 0: use culmination mode; 1: use step mode
   XF_1P_PROCMODE = 9,       // Processing mode: 'O': obsched mode; 'P': P ASCHED mode
   XF_1P_DIAGNOST = 10,      // Diagnostic mode: 0: none, 1: print sen/sat pos at each look, 2: print pass by pass diagnostics, 3: both 1 and 2
   XF_1P_MAXSAA   = 11;      // Max solar aspect for optical sites
   
//*******************************************************************************  
   
// Indexes of limit test flags in the returned array 
static const int  
   XA_LIMFLG_AZLIM    =  0,      //  az limits test flag
   XA_LIMFLG_ELLIM    =  1,      //  el limits test flag
   XA_LIMFLG_EARTHBK  =  2,      //  earth in background flag
   XA_LIMFLG_EARTHOB  =  3,      //  earth obstructed flag
   XA_LIMFLG_LUNEXCL  =  4,      //  lunar exclusion angle fl
   XA_LIMFLG_MAXRANGE =  5,      //  max range test flag
   XA_LIMFLG_MINRANGE =  6,      //  min range test flag
   XA_LIMFLG_PENECLIP =  7,      //  penumb eclipse test flag
   XA_LIMFLG_RVELLIM  =  8,      //  relative velocity test fl
   XA_LIMFLG_SAALIM   =  9,      //  solar aspect angle test
   XA_LIMFLG_SOLEXCL  = 10,      //  solar exclusion angle fl
   XA_LIMFLG_UMBECLIP = 11,      //  umbral eclipse test flag
   XA_LIMFLG_SIZE     = 12;
   

// Generate obs options
static const int  
   GENOBS_NONE      =  0,     // Don't generate obs
   GENOBS_B3        =  1,     // Generate B3 obs
   GENOBS_TTY       =  2,     // Generate TYY obs
   GENOBS_SPTASKER  =  3;     // Generate SP TASKER V obstype
   

// indexes of look and view data in an array
static const int  
   XA_LV_LOOKCODE =   0,    // look code: 0=valid look; 1=Fail horizon break test; 2=Fail sensor's limit tests
   XA_LV_DS50UTC  =   1,    // time in ds50UTC when the look angle is computed    
   XA_LV_MSE      =   2,    // time mse when the look angle is computed
   XA_LV_ELEV     =   3,    // elevation (deg)
   XA_LV_AZIM     =   4,    // azimuth (deg)
   XA_LV_RNG      =   5,    // range (km) 
   XA_LV_RNGRT    =   6,    // range rate (km/s) 
   XA_LV_RA       =   7,    // right ascension (deg)
   XA_LV_DEC      =   8,    // declination (deg)
   XA_LV_AZRATE   =   9,    // azimuth rate (deg/s)
   XA_LV_ELRATE   =  10,    // elevation rate (deg/s)

   XA_LV_SENPOSX  =  11,    // sensor ECI position (X) (km) 
   XA_LV_SENPOSY  =  12,    // sensor ECI position (Y) (km) 
   XA_LV_SENPOSZ  =  13,    // sensor ECI position (Z) (km) 
   XA_LV_SENVELX  =  14,    // sensor ECI velocity (X) (km/s)
   XA_LV_SENVELY  =  15,    // sensor ECI velocity (Y) (km/s)
   XA_LV_SENVELZ  =  16,    // sensor ECI velocity (Z) (km/s)
   XA_LV_SENLAT   =  17,    // sensor latitude (deg)
   XA_LV_SENLON   =  18,    // sensor longitude (deg) 
   XA_LV_SENHEIGHT=  19,    // sensor height (km)

   XA_LV_SATPOSX  =  20,    // satellite ECI position (X) (km) 
   XA_LV_SATPOSY  =  21,    // satellite ECI position (Y) (km) 
   XA_LV_SATPOSZ  =  22,    // satellite ECI position (Z) (km) 
   XA_LV_SATVELX  =  23,    // satellite ECI velocity (X) (km/s) 
   XA_LV_SATVELY  =  24,    // satellite ECI velocity (Y) (km/s) 
   XA_LV_SATVELZ  =  25,    // satellite ECI velocity (Z) (km/s) 
   XA_LV_SATLAT   =  26,    // satellite latitude (deg)
   XA_LV_SATLON   =  27,    // satellite longitude (deg)
   XA_LV_SATHEIGHT=  28,    // satellite height (km)

   XA_LV_UVECX    =  31,    // computed U-vector to object (X)
   XA_LV_UVECY    =  32,    // computed U-vector to object (Y)
   XA_LV_UVECZ    =  33,    // computed U-vector to object (Z)
   XA_LV_RUVECX   =  34,    // slant range unit vector (X)- vector from the sensor to the satellite 
   XA_LV_RUVECY   =  35,    // slant range unit vector (Y)- vector from the sensor to the satellite  
   XA_LV_RUVECZ   =  36,    // slant range unit vector (Z)- vector from the sensor to the satellite  
   XA_LV_LVECX    =  37,    // station unit vector (X) - vector directed from the center of the earth to the sensor
   XA_LV_LVECY    =  38,    // station unit vector (Y) - vector directed from the center of the earth to the sensor
   XA_LV_LVECZ    =  39,    // station unit vector (Z) - vector directed from the center of the earth to the sensor
   XA_LV_ZVECX    =  40,    // station zenith vector (X)  
   XA_LV_ZVECY    =  41,    // station zenith vector (Y)
   XA_LV_ZVECZ    =  42,    // station zenith vector (Z) 
   XA_LV_RNGVECX  =  43,    // slant range vector (X) (km) - vector from the sensor to the satellite 
   XA_LV_RNGVECY  =  44,    // slant range vector (Y) (km) - vector from the sensor to the satellite 
   XA_LV_RNGVECZ  =  45,    // slant range vector (Z) (km) - vector from the sensor to the satellite 
   XA_LV_RRTVECX  =  46,    // range-rate vector - relative velocity vector (X) (km/s)
   XA_LV_RRTVECY  =  47,    // range-rate vector - relative velocity vector (Y) (km/s)
   XA_LV_RRTVECZ  =  48,    // range-rate vector - relative velocity vector (Z) (km/s)
   XA_LV_USUNX    =  49,    // unit vector to sun (X)
   XA_LV_USUNY    =  50,    // unit vector to sun (Y) 
   XA_LV_USUNZ    =  51,    // unit vector to sun (Z) 
   XA_LV_UMOONX   =  52,    // unit vector to moon (X) 
   XA_LV_UMOONY   =  53,    // unit vector to moon (Y) 
   XA_LV_UMOONZ   =  54,    // unit vector to moon (Z) 
   XA_LV_MOSESA   =  55,    // moon/sensor/satellite angle (deg)    
   XA_LV_MOEASA   =  56,    // moon/earth/satellite angle (deg)     
   XA_LV_MOEASE   =  57,    // moon/earth/sensor angle (deg)     
   XA_LV_SUSESA   =  58,    // sun/sensor/satellite angle (deg)   
   XA_LV_SUEASA   =  59,    // sun/earth/satellite angle (deg) 
   XA_LV_SUEASE   =  60,    // sun/earth/sensor angle (deg)  
   XA_LV_SOLAA    =  61,    // solar aspect angle (deg)
   XA_LV_VIS      =  62,    // illumination result
   XA_LV_RELVEL   =  63,    // relative velocity (km/s)

   XA_LV_AZLIM    =  70,    // pass azimuth check (0=failed, 1=passed)
   XA_LV_ELLIM    =  71,    // pass elevation check (0=failed, 1=passed) 
   XA_LV_EARTHBK  =  72,    // pass earth in background check (0=failed, 1=passed) 
   XA_LV_EARTHOB  =  73,    // pass earth obstruction check (0=failed, 1=passed) 
   XA_LV_LUNEXCL  =  74,    // pass lunar exclusion check (0=failed, 1=passed)
   XA_LV_MAXRANGE =  75,    // pass maximum range check (0=failed, 1=passed)
   XA_LV_MINRANGE =  76,    // pass minimum range check (0=failed, 1=passed)
   XA_LV_PENECLIP =  77,    // pass penum eclipse check (0=failed, 1=passed)
   XA_LV_RVELLIM  =  78,    // pass relative velocity check (0=failed, 1=passed)
   XA_LV_SAALIM   =  79,    // pass solar aspect angle check (0=failed, 1=passed)
   XA_LV_SOLEXCL  =  80,    // pass solar exclusion angle check (0=failed, 1=passed)
   XA_LV_UMBECLIP =  81,    // pass umbral eclipse check (0=failed, 1=passed)
   XA_LV_OPTVIS   =  82,    // pass visibility check for optical sensor (0=failed, 1=passed)

   XA_LV_SENPOSE  =  90,    // orbiting sensor EFG position (E) (km)
   XA_LV_SENPOSF  =  91,    // orbiting sensor EFG position (F) (km)
   XA_LV_SENPOSG  =  92,    // orbiting sensor EFG position (G) (km)
   XA_LV_NBORE1   =  93,    // orbiting sensor boresight vector #1 (1='D', 2='U', 3='B', 4='A', 5='R', 6='L', 7=no limits)
   XA_LV_NBORE2   =  94,    // orbiting sensor boresight vector #2 (1='D', 2='U', 3='B', 4='A', 5='R', 6='L', 7=no limits)
   XA_LV_OBEL1    =  95,    // orbiting sensor off boresight elevation #1 (deg)
   XA_LV_OBAZ1    =  96,    // orbiting sensor off boresight azimuth #1 (deg)
   XA_LV_OBAZ2    =  97,    // orbiting sensor off boresight elevation #2 (deg)
   XA_LV_OBEL2    =  98,    // orbiting sensor off boresight azimuth #2 (deg)

   XA_LV_SIZE     = 128;

   



// ========================= End of auto generated code ==========================
