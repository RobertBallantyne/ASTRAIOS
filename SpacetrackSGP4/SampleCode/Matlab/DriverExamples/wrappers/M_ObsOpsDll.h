// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// Initializes ObsOps DLL for use in the program
// apPtr              The handle that was returned from DllMainInit() (in-Long)
// returns 0 if ObsOps.dll is initialized successfully, non-0 if there is an error
int ObsOpsInit(__int64 apPtr);


// Returns information about the current version of ObsOps DLL. 
// infoStr            A string to hold the information about ObsOps.dll (out-Character[128])
void ObsOpsGetInfo(char* infoStr);


// Loads Iomod parameters from an input text file
// iomodInputFile     The name of the file containing IOMOD-related parameters (in-Character[512])
// returns 0 if the input file is read successfully, non-0 if there is an error
int IomodLoadFile(char* iomodInputFile);


// Loads Iomod control parameters and all Iomod related data (environment, time, sensors, obs) from an input text file
// iomodInputFile     The name of the file containing Iomod control parameters and all Iomod related data (in-Character[512])
// returns 0 if the input file is read successfully, non-0 if there is an error
int IomodLoadFileAll(char* iomodInputFile);


// Saves any currently loaded IOMOD-related settings to a file
// iomodFile          The name of the file in which to save the settings (in-Character[512])
// saveMode           Specifies whether to create a new file or append to an existing one (0 = create, 1= append) (in-Integer)
// saveForm           Specifies the mode in which to save the file (0 = text format, 1 = not yet implemented, reserved for future) (in-Integer)
// returns 0 if the data is successfully saved to the file, non-0 if there is an error
int IomodSaveFile(char* iomodFile, int saveMode, int saveForm);


// Builds and returns the IOMOD-parameter card (IP-Card) from the current IOMOD settings
// iomodIPCard        the resulting IOMOD IP card (out-Character[512])
void IomodGetIpCard(char* iomodIPCard);


// Retrieves all IOMOD parameters with a single function call
// printIOHG          control flag for IOHG advisory prints: 0=do not print IOHG information, 1=print IOHG (out-Integer)
// useFirst3Obs       use first 3 obs flag (out-Integer)
// satNum             satelite number (out-Integer)
// sortOrder          obs sorting order (out-Integer)
// satName            international designator (out-Character[8])
// runDC              run DC flag: 1=yes, 0=no (out-Integer)
// runRotas           run ROTAS flag: 1=yes, 0=no (out-Integer)
// extArr             the extra array (future use) (out-Double[128])
void IomodGetIpAll(int* printIOHG, int* useFirst3Obs, int* satNum, int* sortOrder, char* satName, int* runDC, int* runRotas, double* extArr);


// Sets all IOMOD parameters with a single function call
// printIOHG          control flag for IOHG advisory prints: 0=do not print IOHG information, 1=print IOHG (in-Integer)
// useFirst3Obs       use first 3 obs flag (in-Integer)
// satNum             satelite number (in-Integer)
// sortOrder          obs sorting order (in-Integer)
// satName            international designator (in-Character[8])
// runDC              run DC flag: 1=yes, 0=no (in-Integer)
// runRotas           run ROTAS flag: 1=yes, 0=no (in-Integer)
// extArr             the extra array (future use) (in-Double[128])
void IomodSetIpAll(int printIOHG, int useFirst3Obs, int satNum, int sortOrder, char* satName, int runDC, int runRotas, double* extArr);


// Retrieves the value of a specified IOMOD parameter
// xf_IP              Predefined number specifying which IOMOD parameter to retrieve (in-Integer)
// retVal             A string to hold the value of the requested IOMOD parameter (out-Character[512])
void IomodGetIpField(int xf_IP, char* retVal);


// Sets the value of a specified IOMOD parameter
// xf_IP              Predefined number specifying which IOMOD parameter to set, see XF_IP_? for field specification (in-Integer)
// valueStr           The new value of the specified field, expressed as a string (in-Character[512])
void IomodSetIpField(int xf_IP, char* valueStr);


// Computes initial orbit vector from many observations using Herrick-Gibbs method
// obsKeyArr          the obsKey array contains obsKeys that are available for IOMOD (in-Long[*])
// arrSize            the size of the obsKeyArr (in-Integer)
// timeDs50UTC        the resulting time of the new vector in ds50UTC (out-Double)
// pos                the resulting position vector (km) (out-Double[3])
// vel                the resulting velocity vector (km/s) (out-Double[3])
// arr3ObsKeys        the resulting 3 obsKeys that were used by IOMOD (out-Long[3])
// returns 0 if the computation is successful, non-0 if there is an error
int ManyObsToPosVel(__int64* obsKeyArr, int arrSize, double* timeDs50UTC, double* pos, double* vel, __int64* arr3ObsKeys);


// Computes initial orbit vector from three selected observations using Herrick-Gibbs method
// arr3ObsKeys        the three input obsKeys (in-Long[3])
// timeDs50UTC        the resulting time of the new vector in ds50UTC (out-Double)
// pos                the resulting position vector (km) (out-Double[3])
// vel                the resulting velocity vector (km/s) (out-Double[3])
// returns 0 if the computation is successful, non-0 if there is an error
int ThreeObsToPosVel(__int64* arr3ObsKeys, double* timeDs50UTC, double* pos, double* vel);


// Computes initial orbit vector from two selected observations using Two-Ob method
// arr2ObsKeys        the two input obsKeys (in-Long[2])
// timeDs50UTC        the resulting time of the new vector in ds50UTC (out-Double)
// pos                the resulting position vector (km) (out-Double[3])
// vel                the resulting velocity vector (km/s) (out-Double[3])
// returns 0 if the computation is successful, non-0 if there is an error
int TwoObsToPosVel(__int64* arr2ObsKeys, double* timeDs50UTC, double* pos, double* vel);


// Computes the initial orbit vector from three selected angle-only observations using the Gooding Algorithm.
// arr3ObsKeys        the three input obsKeys (in-Long[3])
// range1             the range guess to first observation (km) (in-Double)
// range3             the range guess to third observation (km) (in-Double)
// NHREV              number of half revolutions (in-Integer)
// IND                solution number (in-Integer)
// MAXIT              maximum number of iterations (in-Integer)
// PDINC              partial derivative increment (in-Double)
// CRIVAL             convergence criterion (in-Double)
// timeDs50UTC        the resulting time of the new vector in ds50UTC (out-Double)
// pos                the resulting position vector (km) (out-Double[3])
// vel                the resulting velocity vector (km/s) (out-Double[3])
// returns 0 if the computation is successful, non-0 if there is an error
int AnglesOnlyToPosVel(__int64* arr3ObsKeys, double range1, double range3, int NHREV, int IND, int MAXIT, double PDINC, double CRIVAL, double* timeDs50UTC, double* pos, double* vel);


// Computes the track length of a track whose first observation started at the input startIdx.
// obsKeyArr          the input obsKeyArr (in-Long[*])
// arrSize            the size of the obsKeyArr (number of obs) (in-Integer)
// startIdx           the index of the first observation to start computing the track length (in-Integer)
// trackLength        the track length (trackLength = 1 for single obs) (out-Integer)
// returns 0 if the computation is successful, non-0 if there is an error
int FindTrack(__int64* obsKeyArr, int arrSize, int startIdx, int* trackLength);


// Computes initial orbit vector from a track of obs. Also returns the three obs in the track that are used by IOMOD
// obsKeys            the input obsKeyArr (in-Long[*])
// trackStartIdx      the index of the first observation that starts the track (in-Integer)
// trackLength        the track length (in-Integer)
// timeDs50UTC        the resulting time of the new vector in ds50UTC (out-Double)
// pos                the resulting position vector (km) (out-Double[3])
// vel                the resulting velocity vector (km/s) (out-Double[3])
// trackObsKeys       obsKeys of the tree obs that are used by IOMOD (out-Long[3])
// returns 0 if the computation is successful, non-0 if there is an error
int ATrackToPosVel(__int64* obsKeys, int trackStartIdx, int trackLength, double* timeDs50UTC, double* pos, double* vel, __int64* trackObsKeys);


// Returns the default values of the triangulation settings
// xa_tri             triangulation parameters (out-Double[32])
void TriGetDefParams(double* xa_tri);


// Triangulates the input obs and write generated obs with range data to the specified output file
// obsKeyArr          the input obsKeyArr contains obsKeys that are available for triangulation (in-Long[*])
// arrSize            the size of the obsKeyArr (number of obs) (in-Integer)
// xa_tri             triangulation parameters (in-Double[32])
// toFile             output file that stores the generated obs with the computed range data (in-Character[512])
// returns 0 if successful, non-0 if there is an error
int TriComputeToFile(__int64* obsKeyArr, int arrSize, double* xa_tri, char* toFile);


// Triangulates the input obs and returns the overlap and polyfit information; creates and loads obs with range data into memory and returns their associated obsKeys
// obsKeyArr          the input obsKeyArr contains obsKeys that are available for triangulation (in-Long[*])
// arrSize            the size of the obsKeyArr (number of obs) (in-Integer)
// xa_tri             triangulation parameters (in-Double[32])
// numOvlps           number of overlap tracks (out-Integer)
// xa_ovlp            overlap data (out-Double[*, 8])
// numFits            number of qualified tracks for fitting (out-Integer)
// xa_fit             polyfit data (out-Double[*, 32])
// maxGenObs          maximum number of generated obs (in-Integer)
// nGenObs            number of actual obs generated by triangulation process (nGenObs always lt or eq maxGenObs) (out-Integer)
// genObsKeys         generate obs with range, then load them into memory, and return the obsKeys of all generated obs (out-Long[*])
// returns 0 if successful, non-0 if there is an error
int TriCompute1(__int64* obsKeyArr, int arrSize, double* xa_tri, int* numOvlps, double* xa_ovlp, int* numFits, double* xa_fit, int maxGenObs, int* nGenObs, __int64* genObsKeys);


// Triangulates the input obs and returns the overlap and polyfit information 
// obsKeyArr          the input obsKeyArr contains obsKeys that are available for triangulation (in-Long[*])
// arrSize            the size of the obsKeyArr (number of obs) (in-Integer)
// xa_tri             triangulation parameters (in-Double[32])
// numOvlps           number of overlap tracks (out-Integer)
// xa_ovlp            overlap data (out-Double[*, 8])
// numFits            number of qualified tracks for fitting (out-Integer)
// xa_fit             polyfit data (out-Double[*, 32])
// returns 0 if successful, non-0 if there is an error
int TriCompute2(__int64* obsKeyArr, int arrSize, double* xa_tri, int* numOvlps, double* xa_ovlp, int* numFits, double* xa_fit);


// Triangulates the input obs; creates and loads obs with range data (by triangulation) into memory and returns their associated obsKeys
// obsKeyArr          the input obsKeyArr contains obsKeys that are available for triangulation (in-Long[*])
// arrSize            the size of the obsKeyArr (number of obs) (in-Integer)
// xa_tri             triangulation parameters (in-Double[32])
// maxGenObs          maximum number of generated obs (in-Integer)
// nGenObs            number of actual obs generated by triangulation process (nGenObs always lt or eq maxGenObs) (out-Integer)
// genObsKeys         generate obs with range, then load them into memory, and return the obsKeys of all generated obs (out-Long[*])
// returns 0 if successful, non-0 if there is an error
int TriCompute3(__int64* obsKeyArr, int arrSize, double* xa_tri, int maxGenObs, int* nGenObs, __int64* genObsKeys);


// Returns the default values of the waterfall altitude (km)
// returns The default altitude (km) being used in the Waterfall algorithm
double GetWaterfallAlt();


// Converts angle-only observation to lat/lon/height positions
// obsKey             The unique key of the angle-only observation that needs to be converted by the waterfall calculation (in-Long)
// assumedAltitude    The input assumed altitude (km) to calculate LLH (set to 0 to indicate default altitude should be used) (in-Double)
// rho                The ouput calculated range to sphere of assumed altitude (out-Double[2])
// llhs               The calculated LLH at sphere of assumed altitude (out-Double[2, 3])
// numSols            Number of Waterfall Solutions (out-Integer)
// returns Returns 0 if the conversion is successful, non-0 if there is an error
int AnglesOnlyToLLH(__int64 obsKey, double assumedAltitude, double* rho, double* llhs, int* numSols);

// Indexes for accessing Iomod control parameters
static const int  
   XF_IP_PRINTIOHG  = 1,     // control flag for IOHG advisory prints: 0=do not print IOHG information, 1=print IOHG
   XF_IP_USE1ST3OBS = 2,     // use first 3 obs flag
   XF_IP_SATNUM     = 3,     // satelite number
   XF_IP_SORTORDER  = 4,     // obs sorting order
   XF_IP_SATNAME    = 5,     // international designator 
   XF_IP_RUNDC      = 6,     // run DC flag: 1=yes, 0=no
   XF_IP_RUNROTAS   = 7;     // run ROTAS flag: 1=yes, 0=no
   
// Indexes of TRI configuration parameters
static const int  
   XA_TRI_USEDEFAULT       =  0,    // I - Flag to specify whether or not to use triangulation's default parameters: =[1]: use them and ignore the rest; =0: not to use them
   XA_TRI_OBSTYPEOUT       =  1,    // I - Output obs type (valid values are 0, 2, 3, 4, 6, 8 and 9)
   XA_TRI_APPLYBIAS        =  2,    // I - Flag to specify whether or not to apply sensor bias: =[1]: apply bias, =0: not apply bias
   XA_TRI_LTC              =  3,    // I - apply applyLTC time correction (applyLTC) flag: 0=do no apply, [1]= aplly applyLTC 
   XA_TRI_CREATEOBSSIZE    =  4,    // I - number of obs created for each overlap track
   XA_TRI_DEFANGLEORDER    =  5,    // I - default order of the Polyfit for angle RA/DEC
   XA_TRI_DEFRANGEORDER    =  6,    // I - default order of the Polyfit for range
   XA_TRI_DEFEFGORDER      =  7,    // I - default order of the Polyfit for EFG components
   XA_TRI_AUTOFITANGLE     =  8,    // I - whether or not to use auto mode for angle (increase order if needed when doing Polyfit)
   XA_TRI_AUTOFITRANGE     =  9,    // I - whether or not to use auto for range (increase order if needed when doing Polyfit)
   XA_TRI_ANCHORRADEC      = 10,    // I - anchor order of RA/DEC  
   XA_TRI_SEPSATNO         = 11,    // I - check to see satellite number is different
   XA_TRI_RARMSLIM         = 12,    // D - limit RMS for RA (arcsec)
   XA_TRI_DECRMSLIM        = 13,    // D - limit RMS for Dec (arcsec)
   XA_TRI_RANGERMSLIM      = 14,    // D- limit RMS for Range (km)
   XA_TRI_TRKSEPARATION    = 15,    // D - track separation criteria (minutes)
   XA_TRI_MINSTEREOANGLE   = 16,    // D - minimum stereoscopic angle (deg)
                                    
   XA_TRI_SIZE             = 32;   

// Indexes of overlap track data 
static const int  
   XA_OVLP_SATNUM       =  0,       // I - Satellite number
   XA_OVLP_SENNUM1      =  1,       // I - Sensor number of track 1
   XA_OVLP_SENNUM2      =  2,       // I - Sensor number of track 2
   XA_OVLP_STARTTIME    =  3,       // D - Overlap track's start time (in DS50UTC)
   XA_OVLP_ENDTIME      =  4,       // D - Overlap track's end time (in DS50UTC)
   
   XA_OVLP_SIZE         =  8;       //
   
// Indexes of polyfitting track data
static const int  
   XA_FIT_SATNUM        =  0,       // I - Satellite number
   XA_FIT_SENNUM1       =  1,       // I - Sensor number of track 1
   XA_FIT_SENNUM2       =  2,       // I - Sensor number of track 2
   
   XA_FIT_RAORDER1      =  3,       // I - Right ascension polyfit order of track 1
   XA_FIT_RAORDER2      =  4,       // I - Right ascension polyfit order of track 2
   XA_FIT_RARMS1        =  5,       // D - Right ascension RMS of track 1
   XA_FIT_RARMS2        =  6,       // D - Right ascension RMS of track 2
   
   XA_FIT_DECORDER1     =  7,       // I - Declination polyfit order of track 1
   XA_FIT_DECORDER2     =  8,       // I - Declination polyfit order of track 2
   XA_FIT_DECMS1        =  9,       // D - Declination RMS of track 1
   XA_FIT_DECRMS2       = 10,       // D - Declination RMS of track 2
   
   XA_FIT_RANGEORDER1   = 11,       // I - Declination polyfit order of track 1
   XA_FIT_RANGEORDER2   = 12,       // I - Declination polyfit order of track 2
   XA_FIT_RANGERMS1     = 13,       // D - Declination RMS of track 1
   XA_FIT_RANGERMS2     = 14,       // D - Declination RMS of track 2
   
   XA_FIT_THETA1        = 15,       // D - First stereoscopic angle (deg)
   XA_FIT_THETA2        = 16,       // D - Second stereoscopic angle (deg)
   XA_FIT_THETA3        = 17,       // D - Third stereoscopic angle (deg)
   
   XA_FIT_SIZE          =  32;       //

   



// ========================= End of auto generated code ==========================
