// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// Initializes Saas dll for use in the program
// apPtr              The handle that was returned from DllMainInit() (in-Long)
// returns 0 if Saas.dll is initialized successfully, non-0 if there is an error
int SaasInit(__int64 apPtr);


// Returns information about the current version of Saas.dll. The information is placed in the
// string parameter passed-in
// infoStr            A string to hold information about the Saas.dll (out-Character[128])
void SaasGetInfo(char* infoStr);


//   SaasGetResults executes SAAS (Satellite Attack Assessment Software) also known as DA ASAT
//   (Direct Ascent Anti-Satellite). 
// satKey             The satellite's unique key (in-Long)
// xa_saasrun         run parameters (in-Double[8])
// xa_msl             missile profile data (in-Double[32])
// xa_ls              launch site data (in-Double[8])
// xa_satPen          array that stores data of satellite penetrations (out-Double[*, 16])
// xa_saasRet         array that stores other SAAS output (out-Double[16])
// returns 0 if successfully, non-0 if there is an error
int SaasGetResults(__int64 satKey, double* xa_saasrun, double* xa_msl, double* xa_ls, double* xa_satPen, double* xa_saasRet);


// Computes auto cone size based on satellite height and missile profile      
// satHeight          satelite height (km) (in-Double)
// xa_msl             missile profile data (in-Double[32])
// returns computed auto cone size (deg)
double SaasAutoConeSize(double satHeight, double* xa_msl);


// Computes missile time of flight based on satellite height and missile profile  
// satHeight          satellite height (km) (in-Double)
// xa_msl             missile profile data (in-Double[32])
// returns computed missile flight time (sec)
double SaasMissileFlightTime(double satHeight, double* xa_msl);


// Computes launch orbital plane (inclination and node) based on the launch data
// xa_lnch            The input launch data (see XA_LNCH_ for array arrangement) (in-Double[8])
// incli              The output planer's inclination (deg) (out-Double)
// node               The output planer's node (deg) (out-Double)
void ComputeLnchOrbPlane(double* xa_lnch, double* incli, double* node);


// Compares a satellite elset against a new launch to find planer intersection time and associated data
// satKey             The satellite's unique key (in-Long)
// xa_plnr            The input new launch and time of flight data (in-Double[16])
// xa_intxn           The output planer intersection data (out-Double[16])
// returns 0 if successfully, non-0 if there is an error
int FindPlanerIntersection(__int64 satKey, double* xa_plnr, double* xa_intxn);

//*******************************************************************************

// Missile Profile
static const int     
   XA_MSL_MINHGT  =  0,     // missile profile's minimum height limit (km)
   XA_MSL_MAXHGT  =  1,     // missile profile's maximum height limit (km)
   XA_MSL_MAXSA   =  2,     // maximum allowed solar aspect angle (deg)
   XA_MSL_ANGMAX  =  3,     // maximum allowed missile attack angle (deg)
   XA_MSL_REJFLG  =  4,     // rejection flag (-1: reject negative, 0: reject neg and pos, 1: reject pos) 
   XA_MSL_TIMCOE1 =  5,     // missile trajectory time coefficient for the *X**2 term [sec]
   XA_MSL_TIMCOE2 =  6,     // missile trajectory time coefficient for the *X term [sec]
   XA_MSL_TIMCOE3 =  7,     // missile trajectory time constant for the C term [sec] 
   XA_MSL_RNGCOE1 =  8,     // missile trajectory range coefficient *X**2 term [km]
   XA_MSL_RNGCOE2 =  9,     // missile trajectory range coefficient *X term [km]
   XA_MSL_RNGCOE3 = 10,     // missile trajectory range constant for the C term [km]
 
   XA_MSL_SIZE    = 32;

//*******************************************************************************
   
// Launch site location
static const int     
   XA_LS_LAT     = 0,     // launch site's latitude (deg)  (+N) (-S)
   XA_LS_LON     = 1,     // launch site's longitude (deg) (+E) (-W)
   XA_LS_HEIGHT  = 2,     // launch site's height(m)
   
   XA_LS_SIZE    = 8;
   
//*******************************************************************************   
   
// Saas run parameters
static const int     
   XA_SAASRUN_MAXPENS  = 0,     // Maximum number of penetration points that are allowed
   XA_SAASRUN_START    = 1,     // SAAS start time in days since 1950, UTC
   XA_SAASRUN_STOP     = 2,     // SAAS stop time in days since 1950, UTC
   XA_SAASRUN_HALFCONE = 3,     // Half angle of attack cone (0=auto)
   
   XA_SAASRUN_SIZE     = 8;      
   
//*******************************************************************************      

// Satellite penetration data
static const int     
   XA_SATPEN_IMPTIME  =  0,     // impact time in days since 1950, UTC
   XA_SATPEN_LAUTIME  =  1,     // msl launch time in days since 1950, UTC
   XA_SATPEN_AZ       =  2,     // azimuth (deg)
   XA_SATPEN_EL       =  3,     // elevation (deg)
   XA_SATPEN_RANGE    =  4,     // range (km)
   XA_SATPEN_RNGRATE  =  5,     // range rate (km/s)
   XA_SATPEN_SOLANG   =  6,     // solar aspect angle (deg)
   XA_SATPEN_ATTCKANG =  7,     // attack angle (deg)
   XA_SATPEN_SATHGHT  =  8,     // satellite's height (km)
   XA_SATPEN_EN0EX1   =  9,     // ring penetration entry or exit time (0=entry, 1=exit)
   
   XA_SATPEN_SIZE     = 16;      
   
//*******************************************************************************      

// SAAS ouput data
static const int     
   XA_SAASRET_NUMOFPENS =  0,     // number of actual satellite penetrations
   XA_SAASRET_SATAHT    =  1,     // satellite apogee height (km)
   XA_SAASRET_SATPHT    =  2,     // satellite perigee height (km)
   XA_SAASRET_MINCONE   =  3,     // autocone minimum cone half angle (deg)
   XA_SAASRET_MAXCONE   =  4,     // autocone maximum cone half angle (deg)
   
   

   
   XA_SAASRET_SIZE     = 16;      
   
//*******************************************************************************      

// predefined values for different orbit types used in planer program
static const int  
   ORBTYPE_LEO = 1,  
   ORBTYPE_MEO = 2,   
   ORBTYPE_GEO = 3; 

//*******************************************************************************      

// indexes of fields specifying parameters for planer intersection program
static const int  
  XA_LNCH_LAT     = 0,       // launch site latitude (deg)
  XA_LNCH_LON     = 1,       // launch site longitude (deg)
  XA_LNCH_INJAZ   = 2,       // injection azimuth (deg)
  XA_LNCH_DS50UTC = 3,       // launch time in days since 1950 UTC
  
  XA_LNCH_SIZE    = 8;
  
//*******************************************************************************   
  
// indexes of fields specifying parameters for planer intersection program
static const int  
  XA_PLNR_ORBTYPE  = 0,       // orbital type (LEO = 1, MEO = 2, GEO = 3)
  XA_PLNR_LSLAT    = 1,       // launch site latitude (deg)
  XA_PLNR_LSLON    = 2,       // launch site longitude (deg)
  XA_PLNR_DS50UTC  = 4,       // launch time in days since 1950 UTC
  XA_PLNR_TOFFR    = 5,       // time of flight start (min)
  XA_PLNR_TOFTO    = 6,       // time of flight end (min) 
  XA_PLNR_INCLI    = 7,       // planer's inclination (deg)
  XA_PLNR_NODE     = 8,       // planer's node (deg)
  
  XA_PLNR_SIZE     = 16;
  
//*******************************************************************************        
   
// indexes of output data returned by planer intersection program
static const int  
   XA_INTXN_DS50UTC = 0,      // time of intersection in days since 1950 UTC
   XA_INTXN_INCLI   = 1,      // satellite inclination (deg)
   XA_INTXN_LAT     = 2,      // satellite latitude (deg) at the time of the intersection 
   XA_INTXN_LON     = 3,      // satellite longitude (deg) at the time of the intersection                            
   XA_INTXN_HEIGHT  = 4,      // satellite height (km) at the time of the intersection                               
   XA_INTXN_TOF     = 5,      // time of flight (min) since launch time                          
   
   XA_INTXN_SIZE    = 16;                               
   
//*******************************************************************************         
   



// ========================= End of auto generated code ==========================
