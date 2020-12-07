// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// Initializes SatState DLL for use in the program
// apPtr              The handle that was returned from DllMainInit() (in-Long)
// returns 0 if SatState.dll is initialized successfully, non-0 if there is an error
int SatStateInit(__int64 apPtr);


// Returns information about the current version of SatState DLL. 
// infoStr            A string to hold the information about SatState.dll (out-Character[128])
void SatStateGetInfo(char* infoStr);


// Loads any orbital element types (TLE's/SPVEC's/VCM's), EXTEPHEM's, and/or propagator controls from an input text file
// inputFile          The name of the input file to load (in-Character[512])
// xf_Task            Specified task mode: 1=load SP control parameters, 2=load elsets only, 3=both 1 + 2 (in-Integer)
// returns 0 if the input file is read successfully, non-0 if there is an error
int SatStateLoadFile(char* inputFile, int xf_Task);


// Saves currently loaded orbital element types (TLE's/SPVEC's/VCM's), EXTEPHEM's, and/or propagator controls to a file
// outFile            The name of the file in which to save the settings (in-Character[512])
// saveMode           Specifies whether to create a new file or append to an existing one (0 = create, 1= append) (in-Integer)
// saveForm           Specifies the mode in which to save the file (0 = text format, 1 = not yet implemented, reserved for future) (in-Integer)
// xf_Task            Specified task mode: 1=Only save propagator control parameters, 2=Only save orbital elements/external ephemeris data,	3=Save both 1 + 2 (in-Integer)
// returns 0 if the data is successfully saved to the file, non-0 if there is an error
int SatStateSaveFile(char* outFile, int saveMode, int saveForm, int xf_Task);


// Removes a satellite from the appropriate elset DLL's set of loaded satellites. 
// satKey             The unique key of the satellite to be removed (in-Long)
// returns 0 if the satellite is successfully removed from memory, non-0 if there is an error
int SatStateRemoveSat(__int64 satKey);


// Removes a satellite from the appropriate sets of loaded satellites. 
// satKey             The unique key of the satellite to be removed (in-Long)
// returns 0 if the satellite is successfully removed from memory, non-0 if there is an error
int SatStateRemoveSatAll(__int64 satKey);


// Removes all satellites from all of the loaded data sets. 
// returns 0 if all of the data sets are cleared successfully, non-0 if there is an error
int SatStateRemoveAllSats();


// Resets propagator settings back to their default values
void SatStateReset();


// Returns the total number of satellites (TLE's, SPVEC's, VCM's, and EXTEPHEM's) currently loaded in memory
// returns The total number of currently loaded satellites
int SatStateGetCount();


// Retrieves all of the currently loaded satKeys. 
// order              Specifies the order in which the satKeys should be returned:	0=ascending order, 1=descending order, 2=order in which the satKeys were loaded in memory (in-Integer)
// satKeys            The array in which to store the satKeys (out-Long[*])
void SatStateGetLoaded(int order, __int64* satKeys);


// Returns the first satKey that contains the specified satellite number in all sets of loaded satellites. 
// satNum             The satellite number to search for (in-Integer)
// returns The satKey of the matching satellite if one is found, a negative value indicating an error if not
__int64 SatStateNumToKey(int satNum);


// Retrieves the data which is common to all satellite types. 
// satKey             The satellite's unique key (in-Long)
// satNum             Satellite number (out-Integer)
// satName            Satellite international designator (out-Character[8])
// eltType            Element type (see ELTTYPE_? which is listed in DllMain for list of possible element types) (out-Integer)
// revNum             Revolution number at epoch (out-Integer)
// epochDs50UTC       Epoch time time in days since 1950 UTC (out-Double)
// bField             Ballistic coefficient (m^2/kg) (out-Double)
// elsetNum           Element set number (out-Integer)
// incli              Inclination (deg) (out-Double)
// node               Right ascension of ascending node (deg) (out-Double)
// eccen              Eccentricity (out-Double)
// omega              Argument of perigee (deg) (out-Double)
// mnAnomaly          Mean anomaly (deg) (out-Double)
// mnMotion           Mean motion (rev/day) (out-Double)
// period             Satellite period (min) (out-Double)
// perigeeHt          Satellite perigee height (km) above the ellipsoid (out-Double)
// apogeeHt           Satellite apogee height (km) above the ellipsoid (out-Double)
// perigee            Satellite perigee height (km) above the ellipsoid (out-Double)
// apogee             Satellite apogee height (km) above the ellipsoid (out-Double)
// A                  Satellite apogee height (km) above the ellipsoid (out-Double)
// returns 0 if all satellite data fields are retrieved successfully, non-0 if there is an error
int SatStateGetSatDataAll(__int64 satKey, int* satNum, char* satName, int* eltType, int* revNum, double* epochDs50UTC, double* bField, int* elsetNum, double* incli, double* node, double* eccen, double* omega, double* mnAnomaly, double* mnMotion, double* period, double* perigeeHt, double* apogeeHt, double* perigee, double* apogee, double* A);


// Retrieves an individual field of a satellite. 
// satKey             The satellite's unique key (in-Long)
// xf_Sat             Predefined number specifying which field to retrieve, see XF_SAT_? for field specification (in-Integer)
// retVal             A string to contain the value of the requested field (out-Character[512])
// returns 0 if the satellite data is successfully retrieved, non-0 if there is an error
int SatStateGetSatDataField(__int64 satKey, int xf_Sat, char* retVal);


// Initializes a TLE, SPVEC, or VCM in preparation for propagation, or an EXTEPHEM in preparation for interpolation
// satKey             The satellite's unique key (in-Long)
// returns 0 if the satellite is successfully initialized, non-0 if there is an error
int SatStateInitSat(__int64 satKey);


// Propagates a TLE/SPVEC/VCM, or interpolates an EXTEPHEM. 
// satKey             The satellite's unique key (in-Long)
// mse                The time to propagate to, specified in minutes since the satellite's epoch time (in-Double)
// ds50UTC            Resulting time in days since 1950, UTC (out-Double)
// revNum             Revolution number (out-Integer)
// pos                Resulting ECI position vector (km) in True Equator and Mean Equinox of Epoch (out-Double[3])
// vel                Resulting ECI velocity vector (km/s) in True Equator and Mean Equinox of Epoch (out-Double[3])
// llh                Resulting geodetic latitude (deg), longitude(deg), and height (km) (out-Double[3])
// returns 0 if the satellite is propagated/interpolated successfully, non-0 if there is an error
int SatStateMse(__int64 satKey, double mse, double* ds50UTC, int* revNum, double* pos, double* vel, double* llh);


// Propagates a TLE/SPVEC/VCM, or interpolates an EXTEPHEM. 
// satKey             The satellite's unique key (in-Long)
// ds50UTC            The time to propagate to, specified in days since 1950, UTC (in-Double)
// mse                Resulting time in minutes since the satellite's epoch time (out-Double)
// revNum             Revolution number (out-Integer)
// pos                Resulting ECI position vector (km) in True Equator and Mean Equinox of Epoch (out-Double[3])
// vel                Resulting ECI velocity vector (km/s) in True Equator and Mean Equinox of Epoch (out-Double[3])
// llh                Resulting geodetic latitude (deg), longitude(deg), and height (km) (out-Double[3])
// returns 0 if the satellite is propagated/interpolated successfully, non-0 if there is an error
int SatStateDs50UTC(__int64 satKey, double ds50UTC, double* mse, int* revNum, double* pos, double* vel, double* llh);


// Returns additional propagated/interpolated results (reserved for future implementation)
// satKey             the satellite's unique key (in-Long)
// index              type of returned data (in-Integer)
// destArr            the resulting array (out-Double[128])
// returns 0 if successful, non-0 if there is an error
int SatStateGetPropOut(__int64 satKey, int index, double* destArr);


// Returns various ephemeris comparison results between two satellite states.
// primSatKey         The primary satellite's unique key (in-Long)
// secSatKey          The secondary satellite's unique key (in-Long)
// ds50UTC            Requested time in days since 1950 UTC (in-Double)
// uvwFlag            UVW coordinate system flag: 0=use rotating UVW, 1=use inertial UVW (in-Integer)
// xa_Delta           The resulting ephemeris comparison deltas, see XA_DELTA_? for array arrangement (out-Double[100])
// returns 0 if the comparison results are computed successfully, non-0 if there is an error
int SatStateEphCom(__int64 primSatKey, __int64 secSatKey, double ds50UTC, int uvwFlag, double* xa_Delta);


// Determines if a satellite contains covariance matrix. 
// satKey             the satellite's unique key (in-Long)
// returns 0=sat doesn't have cov mtx, 1=sat has cov mtx
int SatStateHasCovMtx(__int64 satKey);


// Propagates/Interpolates UVW covariance matrix from VCM/External ephemeris to the time in days since 1950
// satKey             The satellite's unique key (in-Long)
// ds50UTC            The input time in days since 1950 UTC (in-Double)
// covUVW             6x6 UVW covariance matrix (out-Double[6, 6])
// returns 0 if the UVW covariance matrix is propagated/interpolated successfully, non-0 if there is an error
int SatStateGetCovUVW(__int64 satKey, double ds50UTC, double* covUVW);


// Generate external ephemeris file for the specified satellite (via its unique satKey) 
// satKey             The satellite's unique key (in-Long)
// startDs50UTC       Start time in days since 1950 UTC (in-Double)
// stopDs50UTC        Stop time in days since 1950 UTC (in-Double)
// stepSizeSecs       Step size in seconds. Set to zero if natural integration step size (auto adjust) is desired for SP propagator (in-Double)
// ephFileName        The generated external ephemeris file name (in-Character[512])
// ephFileType        External ephemeris file type: 1=ITC (in-Integer)
// returns 0 if the external ephemeris file was generated successfully, non-0 if there is an error
int SatStateGenEphFile(__int64 satKey, double startDs50UTC, double stopDs50UTC, double stepSizeSecs, char* ephFileName, int ephFileType);

// Indexes of Satellite data fields
static const int  
   XF_SAT_NUM      =  1,      // Satellite number I5
   XF_SAT_NAME     =  2,      // Satellite international designator A8
   XF_SAT_EPHTYPE  =  3,      // Element type I1 
   XF_SAT_REVNUM   =  4,      // Epoch revolution number I6
   XF_SAT_EPOCH    =  5,      // Epoch time in days since 1950
   XF_SAT_BFIELD   =  6,      // BStar drag component (GP) or Ballistic coefficient-BTerm (SP) (m^2/kg)
   XF_SAT_ELSETNUM =  7,      // Element set number
   XF_SAT_INCLI    =  8,      // Inclination (deg)
   XF_SAT_NODE     =  9,      // Right ascension of ascending node (deg)
   XF_SAT_ECCEN    = 10,      // Eccentricity
   XF_SAT_OMEGA    = 11,      // Argument of perigee (deg)
   XF_SAT_MNANOM   = 12,      // Mean anomaly (deg)
   XF_SAT_MNMOTN   = 13,      // Mean motion (revs/day)
   XF_SAT_PERIOD   = 14,      // Satellite period (min)
   XF_SAT_PERIGEEHT= 15,      // Perigee Height(km)
   XF_SAT_APOGEEHT = 16,      // Apogee Height (km)
   XF_SAT_PERIGEE  = 17,      // Perigee(km)
   XF_SAT_APOGEE   = 18,      // Apogee (km)
   XF_SAT_A        = 19;      // Semi-major axis (km)


// Indexes of SatState's load/save file task mode
static const int  
   XF_TASK_CTRLONLY = 1,     // Only load/save propagator control parameters
   XF_TASK_SATONLY  = 2,     // Only load/save orbital elements/external ephemeris data
   XF_TASK_BOTH     = 3;     // Load/Save both 1 and 2


// Indexes of available satellite data fields
static const int  
   XF_SATFIELD_EPOCHUTC =  1,    // Satellite number
   XF_SATFIELD_MNANOM   =  2,    // Mean anomaly (deg)
   XF_SATFIELD_NODE     =  3,    // Right ascension of asending node (deg) 
   XF_SATFIELD_OMEGA    =  4,    // Argument of perigee (deg)
   XF_SATFIELD_PERIOD   =  5,    // Satellite's period (min)
   XF_SATFIELD_ECCEN    =  6,    // Eccentricity
   XF_SATFIELD_INCLI    =  7,    // Orbit inclination (deg)
   XF_SATFIELD_MNMOTION =  8,    // Mean motion (rev/day)
   XF_SATFIELD_BFIELD   =  9,    // GP B* drag term (1/er)  or SP Radiation Pressure Coefficient
   XF_SATFIELD_PERIGEEHT= 10,    // Perigee height above the geoid (km)
   XF_SATFIELD_APOGEEHT = 11,    // Apogee height above the geoid (km)
   XF_SATFIELD_PERIGEE  = 12,    // Perigee height above the center of the earth (km)
   XF_SATFIELD_APOGEE   = 13,    // Apogee height above the center of the earth (km)
   XF_SATFIELD_A        = 14,    // Semimajor axis (km)
   XF_SATFIELD_NDOT     = 15,    // Mean motion derivative (rev/day /2)
   XF_SATFIELD_SATCAT   = 16,    // Satellite category (Synchronous, Deep space, Decaying, Routine)
   XF_SATFIELD_HTM3     = 17,    // Astat 3 Height multiplier
   XF_SATFIELD_CMOFFSET = 18,    // Center of mass offset (m)
   XF_SATFIELD_N2DOT    = 19,    // Unused
   XF_SATFIELD_NODEDOT  = 20,    // GP node dot (deg/s)
   XF_SATFIELD_ERRORTIME= 21,    // GP only - the last time when propagation has error
   XF_SATFIELD_MU       = 22;    // value of mu

  
//*******************************************************************************

// Indexes of available deltas
static const int  
   XA_DELTA_POS         =  0,     // delta position (km)
   XA_DELTA_TIME        =  1,     // delta time (sec)
   XA_DELTA_PRADIAL     =  2,     // delta position in radial direction (km)
   XA_DELTA_PINTRCK     =  3,     // delta position in in-track direction (km)
   XA_DELTA_PCRSSTRCK   =  4,     // delta position in cross-track direction (km)
   XA_DELTA_VEL         =  5,     // delta velocity (km/sec)
   XA_DELTA_VRADIAL     =  6,     // delta velocity in radial direction (km/sec)
   XA_DELTA_VINTRCK     =  7,     // delta velocity in in-track direction (km/sec)
   XA_DELTA_VCRSSTRCK   =  8,     // delta velocity in cross-track direction (km/sec)
   XA_DELTA_BETA        =  9,     // delta Beta (deg)
   XA_DELTA_HEIGHT      = 10,     // delta height (km)
   XA_DELTA_ANGMOM      = 11,     // delta angular momentum (deg)
   
   XA_DELTA_SIZE        =100; 
   
   

//*******************************************************************************

static const int  
   TIME_IS_MSE = 1,     // Input time is in minutes since epoch 
   TIME_IS_TAI = 2,     // Input time is in days since 1950 TAI
   TIME_IS_UTC = 3;     // Input time is in days since 1950 UTC
   
//*******************************************************************************





// ========================= End of auto generated code ==========================
