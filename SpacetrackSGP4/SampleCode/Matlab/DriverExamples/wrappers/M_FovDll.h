// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// Initializes Fov dll for use in the program
// apPtr              The handle that was returned from DllMainInit() (in-Long)
// returns 0 if Fov.dll is initialized successfully, non-0 if there is an error
int FovInit(__int64 apPtr);


// Returns information about the current version of Fov.dll. The information is placed in the string parameter you pass in
// infoStr            A string to hold the information about Fov.dll. (out-Character[128])
void FovGetInfo(char* infoStr);


// Loads Fov-related parameters (1P/2P/3P cards, and Fov parameter free format) from an input text file
// fovInputFile       The name of the file containing Fov-related parameters (in-Character[512])
// returns 0 if the input file is read successfully, non-0 if there is an error
int FovLoadFile(char* fovInputFile);


// Loads Fov-related parameters (1P/2P/3P cards, and Fov parameter free format) from an input text file
// fovInputFile       The name of the file containing Fov-related parameters (in-Character[512])
// returns 0 if the input file is read successfully, non-0 if there is an error
int FovLoadFileAll(char* fovInputFile);


// Loads a single Fov-typed card
// card               Fov-type input card (in-Character[512])
// returns 0 if the input card is read successfully, non-0 if there is an error
int FovLoadCard(char* card);


// Saves any currently loaded Fov-related settings to a file
// fovFile            The name of the file in which to save the settings (in-Character[512])
// saveMode           Specifies whether to create a new file or append to an existing one (0 = create, 1= append) (in-Integer)
// saveForm           Specifies the mode in which to save the file (0 = text format, 1 = not yet implemented, reserved for future) (in-Integer)
// returns 0 if the data is successfully saved to the file, non-0 if there is an error
int FovSaveFile(char* fovFile, int saveMode, int saveForm);


// This function retrieves various FOV input data being entered from input flat files (various FOV cards)
// xa_fovCtrl         FOV control parameters, see XA_FOVCTRL_? for array arrangement (out-Double[8])
// numOfWindows       Number of specified start/stop windows (out-Integer)
// startStopTimes     Array of start/stop times in days since 1950 UTC (even idxs=start times, odd idxs=stop times) (out-Double[256])
// numOfSources       Number of sources (out-Integer)
// xa_fovSrc_Arr      Array of source records, see XA_FOVSRC for array arrangement (out-Double[128, 8])
// numOfTargets       Number of targets (out-Integer)
// xa_fovTgt_Arr      Array of target records, see XA_FOVTGT_? for array arrangement (out-Double[128, 8])
// numVicSats         Number of specified potential victims (out-Integer)
// vicSatNums         Array of satellite numbers of the specified potential victims (out-Integer[128])
void FovGetDataFrInputFiles(double* xa_fovCtrl, int* numOfWindows, double* startStopTimes, int* numOfSources, double* xa_fovSrc_Arr, int* numOfTargets, double* xa_fovTgt_Arr, int* numVicSats, int* vicSatNums);


// This function screens the specified start/end time window and returns passes when the target satellite can be seen (passed all limit checks) by the source 
// startTimeDs50UTC   window start time in days since 1950 UTC (in-Double)
// stopTimeDs50UTC    window stop time in days since 1950 UTC (in-Double)
// srcSenKey          the source sensor key (in-Integer)
// tgtSatKey          the targeted satellite's unique key (in-Long)
// tgtPassesArr       array of entry/exit times of each pass; the size of the array should match the specified value in XA_FOVRUN_MAXPASSES (out-Double[*, 2])
// numOfPasses        number of passes that target satellite can be seen (passed all limit checks) by the source sensor (out-Integer)
// returns 0 if successfully, non-0 if there is an error
int FovFindTargetPasses(double startTimeDs50UTC, double stopTimeDs50UTC, int srcSenKey, __int64 tgtSatKey, double* tgtPassesArr, int* numOfPasses);


// This function screens a potential victim satellite for penetrating the illumination cone between a source and a target (target is an elset).
// xa_fovRun          fov run parameters, see XA_FOVRUN_? for array arrangement (in-Double[8])
// xa_fovSrc          source data, see XA_FOVSRC_? for array arrangement (in-Double[8])
// tgtSatKey          the targeted satellite's unique key (in-Long)
// vicSatKey          the victim satellite's unique key (in-Long)
// xa_emeDat          array of entry/minimum/exit times of each pass (out-Double[*, 3])
// numOfPasses        number of passes found (out-Integer)
// returns 0 if successfully, non-0 if there is an error
int FovTargetElset(double* xa_fovRun, double* xa_fovSrc, __int64 tgtSatKey, __int64 vicSatKey, double* xa_emeDat, int* numOfPasses);


// This function returns a look angle from the source to the potential victim satellite at the specified time (target is an elset)
// currDs50TAI        Time, in ds50TAI, for which to compute the look angle (in-Double)
// xa_fovSrc          source data, see XA_FOVSRC_? for array arrangement (in-Double[8])
// vicSatKey          the victim satellite's unique key (in-Long)
// xa_look            look angle data, see XA_LOOK_? for array arrangement (out-Double[8])
// returns 0 if successfully, non-0 if there is an error
int FovTargetElsetLook(double currDs50TAI, double* xa_fovSrc, __int64 vicSatKey, double* xa_look);


// This function screens a potential victim satellite for penetrating the illumination cone between a source and a target (target is a vector: AZ/EL or RA/DEC).
// xa_fovRun          fov run parameters, see XA_FOVRUN_? for array arrangement (in-Double[8])
// xa_fovSrc          source data, see XA_FOVSRC_? for array arrangement (in-Double[8])
// xa_fovTgt          target data, see XA_FOVTGT_? for array arrangement (in-Double[8])
// vicSatKey          the victim satellite's unique key (in-Long)
// xa_emeDat          array of entry/minimum/exit times of each pass (out-Double[*, 3])
// numOfPasses        number of passes found (out-Integer)
// returns 0 if successfully, non-0 if there is an error
int FovTargetVec(double* xa_fovRun, double* xa_fovSrc, double* xa_fovTgt, __int64 vicSatKey, double* xa_emeDat, int* numOfPasses);


// This function returns a look angle from the source to the potential victim satellite at the specified time (target is a vector: AZ/EL or RA/DEC).
// currDs50TAI        Time, in ds50TAI, for which to compute the look angle (in-Double)
// xa_fovSrc          source data, see XA_FOVSRC_? for array arrangement (in-Double[8])
// xa_fovTgt          target data, see XA_FOVTGT_? for array arrangement (in-Double[8])
// vicSatKey          the victim satellite's unique key (in-Long)
// xa_look            look angle data, see XA_LOOK_? for array arrangement (out-Double[8])
// returns 0 if successfully, non-0 if there is an error
int FovTargetVecLook(double currDs50TAI, double* xa_fovSrc, double* xa_fovTgt, __int64 vicSatKey, double* xa_look);


// Resets all FOV control parameters back to their default values
void FovReset();
   
// Fov run parameters
static const int     
   XA_FOVRUN_MAXPASSES= 0,     // Maximum number of passes (entry/minimum/exit times) that FOV returns in one start/stop time
   XA_FOVRUN_START    = 1,     // FOV start time in days since 1950, UTC
   XA_FOVRUN_STOP     = 2,     // FOV stop time in days since 1950, UTC
   XA_FOVRUN_HALFCONE = 3,     // Cone half angle (deg) (0=auto) (0-45)
   XA_FOVRUN_INTERVAL = 4,     // Search interval (min) 
   
   XA_FOVRUN_SIZE     = 8;      

// FOV source types   
static const int  
   FOV_SRCTYPE_SEN = 1,    // Source is sensor
   FOV_SRCTYPE_LLH = 2,    // Source is lat lon height
   FOV_SRCTYPE_EFG = 3,    // Source is EFG 
   FOV_SRCTYPE_XYZ = 4;    // Source is XYZ
   
// FOV source types   
static const int  
   FOV_TGTTYPE_ELSET = 1,    // Target is elset
   FOV_TGTTYPE_AZEL  = 2,    // Target is constant Az/El
   FOV_TGTTYPE_RADEC = 3;    // Target is RA/Dec (STAR)
   
// FOV source specification
static const int  
   XA_FOVSRC_TYPE  = 0,   // 1=SEN   | 2=LLH       | 3=EFG      | 4=XYZ
   XA_FOVSRC_ID    = 1,   // Sensor# | Source ID   | Source ID  | Source ID                            
   XA_FOVSRC_ELEM1 = 2,   //         | N lat (deg) | EFG: E (m) | X (m)
   XA_FOVSRC_ELEM2 = 3,   //         | E lon (deg) | EFG: F (m) | Y (m)
   XA_FOVSRC_ELEM3 = 4,   //         | height (m)  | EFG: G (m) | Z (m)
   XA_FOVSRC_ELEM4 = 5,   //         |             |            | time of position in Ds50UTC
   
   XA_FOVSRC_SIZE  = 8;
   

// FOV target specification
static const int  
   XA_FOVTGT_TYPE  = 0,   // 1=ELSET | 2=AZEL    | 3=RADEC
   XA_FOVTGT_ID    = 1,   // Elset#  | Target ID | Target ID
   XA_FOVTGT_ELEM1 = 2,   //         | az (deg)  | RA (deg)
   XA_FOVTGT_ELEM2 = 3,   //         | el (deg)  | Dec (deg)
   XA_FOVTGT_ELEM3 = 4,   //         |           | equinox indicator 
   
   XA_FOVTGT_SIZE  = 8;
   
// entry/minimum/exit time data   
static const int  
   XA_EMEDAT_ENTRY = 0,   // entry time (ds50UTC)
   XA_EMEDAT_MIN   = 1,   // minimum time (ds50UTC)
   XA_EMEDAT_EXIT  = 2,   // exit time (ds50UTC)
   
   XA_EMEDAT_SIZE  = 3;

// FOV parameters   
static const int  
   XA_FOVCTRL_HALFCONE = 0,     // Cone half angle (deg) (0=auto) (0-45)
   XA_FOVCTRL_INTERVAL = 1,     // Search interval (min) 
   XA_FOVCTRL_PRTOPT   = 2,     // Print option
   
   XA_FOVCTRL_SIZE     = 8;     
   
   
static const int FOVMAXNUM = 128;  // maximum number of windows/potential, victims/sources/targets allowed to be entered via an input file
   



// ========================= End of auto generated code ==========================
