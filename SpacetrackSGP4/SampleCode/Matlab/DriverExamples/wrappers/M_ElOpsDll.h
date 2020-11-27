// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// Initializes ElOps dll for use in the program
// apPtr              The handle that was returned from DllMainInit() (in-Long)
// returns 0 if the ElOps dll is initialized successfully, non-0 if there is an error
int ElOpsInit(__int64 apPtr);


// Returns information about the current version of ElOps.dll. The information is placed in the string parameter you pass in
// infoStr            A string to hold the information about ElOps.dll (out-Character[128])
void ElOpsGetInfo(char* infoStr);


// Checks to see if satellite has geo orbit
// incli              satellite's inclination (deg) (in-Double)
// period             satellite's period (min) (in-Double)
// returns Return 1 if satellite has geo orbit, 0 if it doesn't
int IsGeoOrbit(double incli, double period);


// Estimates the approx long east subpt
// ds50UTC            time in days since 1950, UTC (in-Double)
// node               right ascension of the ascending node (deg) (in-Double)
// omega              argument of perigee (deg) (in-Double)
// mnAnomaly          mean anomaly (deg) (in-Double)
// returns estimated long east sub point (deg)
double CompLonEastSubPt(double ds50UTC, double node, double omega, double mnAnomaly);


// Computes the decay time of the input satellite
// satKey             The input satkey of the satellite needs to compute decay time (in-Long)
// f10Avg             Input F10 average value (in-Double)
// decayDs50UTC       The output decay time in days since 1950 UTC (out-Double)
// returns Returns 0 if success, 1 if ndot/2 lt 0, 2 if mean motion lt 1.5, and 3 if f2log lt 0
int FindSatDecayTime(__int64 satKey, double f10Avg, double* decayDs50UTC);


// Returs parameters of a satellite via its satKey
// satKey             The input satkey of the satellite needs to compute gobs parameters (in-Long)
// xa_satparm         Output satellite's parameters (out-Double[32])
// returns 0 if the satellite parameters are successfully retrieved, non-0 if there is an error
int GetSatParameters(__int64 satKey, double* xa_satparm);

// Satellite maintenance category
static const int  
   SATCAT_SYNCHRONOUS = 1,       // Synchronous
   SATCAT_DEEPSPACE   = 2,       // Deep space (not synchronous)
   SATCAT_DECAYING    = 3,       // Decaying (perigee height below 575 km)
   SATCAT_ROUTINE     = 4;       // Routine (everything else)   
   
// Indexes of available satellite data fields
static const int  
   XF_ELFIELD_EPOCHUTC =  1,     // epoch in days since 1950, UTC
   XF_ELFIELD_MNANOM   =  2,     // mean anomaly (deg)
   XF_ELFIELD_NODE     =  3,     // right ascension of the asending node (deg) 
   XF_ELFIELD_OMEGA    =  4,     // argument of perigee (deg) 
   XF_ELFIELD_PERIOD   =  5,     // period (min)
   XF_ELFIELD_ECCEN    =  6,     // eccentricity (unitless)    
   XF_ELFIELD_INCLI    =  7,     // inclination (deg)
   XF_ELFIELD_MNMOTION =  8,     // mean motion (revs/day)
   XF_ELFIELD_BFIELD   =  9,     // either SGP4 bStar (1/er) or SP bTerm (m2/kg)
   XF_ELFIELD_PERIGEEHT= 10,     // perigee height (km) 
   XF_ELFIELD_APOGEEHT = 11,     // apogee height (km) 
   XF_ELFIELD_PERIGEE  = 12,     // perigee (km)
   XF_ELFIELD_APOGEE   = 13,     // apogee (km)
   XF_ELFIELD_A        = 14,     // semi major axis (km)
   XF_ELFIELD_SATCAT   = 15,     // Satellite category (Synchronous, Deep space, Decaying, Routine)
   XF_ELFIELD_HTM3     = 16,     // Astat 3 Height multiplier
   XF_ELFIELD_CMOFFSET = 17,     // Center of mass offset (m)
   XF_ELFIELD_N2DOT    = 18;     // n-double-dot/6  (for SGP, eph-type = 0)  

   
// Indexes of available satellite parameters
static const int  
   XA_SATPARM_EPOCHUTC =  0,     // satellite's epoch in days since 1950, UTC
   XA_SATPARM_MNANOM   =  1,     // satellite's mean anomaly (deg)
   XA_SATPARM_NODE     =  2,     // satellite's right ascension of the asending node (deg) 
   XA_SATPARM_OMEGA    =  3,     // satellite's argument of perigee (deg) 
   XA_SATPARM_PERIOD   =  4,     // satellite's period (min)
   XA_SATPARM_ECCEN    =  5,     // satellite's eccentricity (unitless)    
   XA_SATPARM_INCLI    =  6,     // satellite's inclination (deg)
   XA_SATPARM_MNMOTION =  7,     // satellite's mean motion (revs/day)
   XA_SATPARM_BFIELD   =  8,     // satellite's either SGP4 bStar (1/er) or SP bTerm (m2/kg)
   XA_SATPARM_PERIGEEHT=  9,     // satellite's perigee height (km) 
   XA_SATPARM_APOGEEHT = 10,     // satellite's apogee height (km) 
   XA_SATPARM_PERIGEE  = 11,     // satellite's perigee (km)
   XA_SATPARM_APOGEE   = 12,     // satellite's apogee (km)
   XA_SATPARM_A        = 13,     // satellite's semi major axis (km)
   XA_SATPARM_SATCAT   = 14,     // satellite's category (1=Synchronous, 2=Deep space, 3=Decaying, 4=Routine)
   XA_SATPARM_CMOFFSET = 15,     // satellite's center of mass offset (m)
   XA_SATPARM_LONE     = 16,     // satellite's east longitude east subpoint (deg) - only for synchronous orbits
   XA_SATPARM_DRIFT    = 17,     // satellite's longitude drift rate (deg East/day) - only for synchronous orbits
   XA_SATPARM_OMEGADOT = 18,     // satellite's omega rate of change (deg/day)
   XA_SATPARM_RADOT    = 19,     // satellite's nodal precession rate (deg/day)
   XA_SATPARM_NODALPRD = 20,     // satellite's nodal period (min)
   XA_SATPARM_NODALX   = 21,     // satellite's nodal crossing time prior to its epoch (ds50UTC)
   XA_SATPARM_ISGEO    = 22,     // satellite is GEO: 0=no, 1=yes
   XA_SATPARM_RELENERGY= 23,     // satellite's relative energy - only for GOBS
   
   XA_SATPARM_SIZE     = 32;




// ========================= End of auto generated code ==========================
