// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// Initializes ElComp dll for use in the program 
// apPtr              The handle that was returned from DllMainInit() (in-Long)
// returns 0 if the ElComp dll is initialized successfully, non-0 if error
int ElCompInit(__int64 apPtr);


// Returns information about the current version of ElComp.dll. The information is placed in the
// string parameter passed-in
// infoStr            A string to hold the information about ElComp.dll (out-Character[128])
void ElCompGetInfo(char* infoStr);


// ElCompSetCriteria for ElComp 'Manual' mode which replaces default association status criteria
// for "FULL", including primary vs. secondary element comparison difference thresholds in 
// inclination, coplanar angle (determined as the dot product of the primary and secondary 
// angular momentum vectors), perigee height, eccentricity, orbital period, and argument of perigee
// xa_ecdiff          Array to store manual setting criteria for "FULL" (MAX1 parameters only) (in-Double[32])
void ElCompSetCriteria(double* xa_ecdiff);


// Retrieves criteria settings for ElComp    
// xa_ecdiff          Array to receive the ElComp criteria (out-Double[32])
void ElCompGetCriteria(double* xa_ecdiff);


//   ElCompGetResults executes ELCOMP, Element Comparison, to evaluate two element sets loaded
//   via their satKeys 
// priSatKey          The primary satellite's unique key (in-Long)
// secSatKey          The secondary satellite's unique key (in-Long)
// checkDeltaTime     Suppress=0/Allow=1: check on nodal time and sync long (in-Integer)
// xa_elcom_pri       primary satellite data (out-Double[16])
// xa_elcom_sec       secondary satellite data (out-Double[16])
// xa_elcom_deltas    delta quantities between primary and secondary satellites (out-Double[16])
// elcom_astat        =1:FULL, =2:CLOSE, =3:MAYBE, =4:NONE (out-Integer)
// returns 0 if ElComp is successful, non-0 if there is an error
int ElCompGetResults(__int64 priSatKey, __int64 secSatKey, int checkDeltaTime, double* xa_elcom_pri, double* xa_elcom_sec, double* xa_elcom_deltas, int* elcom_astat);


// Returns comparison results between two elsets without loading the elsets into memory
// checkDeltaTime     Supress=0/Allow=1: check on nodal time and sync long (in-Integer)
// xa_elcom_pri       primary satellite data   : 0:incli, 1:node, 2:E, 3:omega, 4: mean anomaly, 5:mean motion, 6:epoch (in-Double[16])
// xa_elcom_sec       secondary satellite data : 0:incli, 1:node, 2:E, 3:omega, 4: mean anomaly, 5:mean motion, 6:epoch (in-Double[16])
// xa_elcom_deltas    delta quantities between primary and secondary satellites (out-Double[16])
// elcom_astat        =1:FULL, =2:CLOSE, =3:MAYBE, =4:not assoc (out-Integer)
void ElCompFrElData(int checkDeltaTime, double* xa_elcom_pri, double* xa_elcom_sec, double* xa_elcom_deltas, int* elcom_astat);


// Resets criteria to default values for ElComp 
void ElCompResetCriteria();


// Sets up criteria for Coco 
// xa_ecdiff          Array to set the Coco criteria (in-Double[32])
void CocoSetCriteria(double* xa_ecdiff);


// Retrieves criteria settings for Coco
// xa_ecdiff          Array to receive the Coco criteria (out-Double[32])
void CocoGetCriteria(double* xa_ecdiff);


//   CocoGetResults executes COCO, Computation of coplanar Orbits, to evaluate two element sets
//   loaded via their satKeys.   
// priSatKey          The primary satellite's unique key (in-Long)
// secSatKey          The secondary satellite's unique key (in-Long)
// xa_satData_pri     primary satellite data (see order below) (out-Double[16])
// xa_satData_sec     secondary satellite data (see order below) (out-Double[16])
// xa_coco            primary v.secondary delta quantities (see below) (out-Double[16])
// coco_astat         =1:SAME, =2:CLOSE, =5:not assoc (out-Integer)
// returns 0 if Coco is successful, non-0 if there is an error
int CocoGetResults(__int64 priSatKey, __int64 secSatKey, double* xa_satData_pri, double* xa_satData_sec, double* xa_coco, int* coco_astat);


//   CocoGetResultsWOA executes COCO, Computation of coplanar Orbits, to evaluate two element sets
//   loaded via their satKeys. It's similar to CocoGetResults but without returning the ASTAT value
// priSatKey          The primary satellite's unique key (in-Long)
// secSatKey          The secondary satellite's unique key (in-Long)
// xa_satData_pri     primary satellite data (see order below) (out-Double[16])
// xa_satData_sec     secondary satellite data (see order below) (out-Double[16])
// xa_coco            primary v.secondary delta quantities (see below) (out-Double[16])
// returns 0 if Coco is successful, non-0 if there is an error
int CocoGetResultsWOA(__int64 priSatKey, __int64 secSatKey, double* xa_satData_pri, double* xa_satData_sec, double* xa_coco);


// Returns comparison results between two elsets without loading the elsets into TLE dll
// xa_satData_pri     primary sat data, see XA_SATDAT_? for array arrangement (in-Double[16])
// xa_satData_sec     secondary sat data, see XA_SATDAT_? for array arrangement (in-Double[16])
// xa_coco            delta quantities between pri/sec satellites, see XA_COCO_? for array arrangement (out-Double[16])
// coco_astat         resulting astat value; 1=SAME, 2=CLOSE, 3=NEARBY, 5=NONE (out-Integer)
void CocoFrElData(double* xa_satData_pri, double* xa_satData_sec, double* xa_coco, int* coco_astat);


// Returns comparison results between two elsets without loading the elsets into TLE dll. It's similar to CocoFrElData but without returning the ASTAT value
// xa_satData_pri     primary sat data, see XA_SATDAT_? for array arrangement (in-Double[16])
// xa_satData_sec     secondary sat data, see XA_SATDAT_? for array arrangement (in-Double[16])
// xa_coco            delta quantities between pri/sec satellites, see XA_COCO_? for array arrangement (out-Double[16])
void CocoFrElDataWOA(double* xa_satData_pri, double* xa_satData_sec, double* xa_coco);


// Resets criteria to default values for Coco 
void CocoResetCriteria();
   
// indexes for ElComp reference sat data and deltas   
static const int     
   XA_ELCOM_INCLI    =  0,     // inclination (deg)
   XA_ELCOM_NODE     =  1,     // right ascension of the asending node (deg) 
   XA_ELCOM_E        =  2,     // eccentricity (unitless)    
   XA_ELCOM_OMEGA    =  3,     // argument of perigee (deg) 
   XA_ELCOM_MNANOM   =  4,     // mean anomaly (deg)
   XA_ELCOM_MNMOTION =  5,     // mean motion (revs/day)
   XA_ELCOM_EPOCH    =  6,     // epoch in days since 1950, UTC
   
   XA_ELCOM_PHT      =  7,     // perigee height (km) 
   XA_ELCOM_PERIOD   =  8,     // period (min)
   XA_ELCOM_TNODE    =  9,     // delta t between nodal crossing times (min)
   XA_ELCOM_LONGE    = 10,     // delta east longitude for geo satellites (deg)
   
   XA_ELCOM_SIZE     = 16;
   
// indexes for setting criteria for full, close, maybe
static const int     
   XA_ECDIFF_INCMAX1  =  0,    // incli diff in deg - full
   XA_ECDIFF_INCMAX2  =  1,    // incli diff in deg - close
   XA_ECDIFF_INCMAX3  =  2,    // incli diff in deg - maybe
   
   XA_ECDIFF_RAMAX1   =  3,    // W vector dot product in deg - full
   XA_ECDIFF_RAMAX2   =  4,    // W vector dot product in deg - close
   XA_ECDIFF_RAMAX3   =  5,    // W vector dot product in deg - maybe
   
   XA_ECDIFF_PHTMAX1  =  6,    // perigee height diff in km - full
   XA_ECDIFF_PHTMAX2  =  7,    // perigee height diff in km - close
   XA_ECDIFF_PHTMAX3  =  8,    // perigee height diff in km - maybe
   
   XA_ECDIFF_ECCMAX1  =  9,    // eccentricity diff - full
   XA_ECDIFF_ECCMAX2  = 10,    // eccentricity diff - close
   XA_ECDIFF_ECCMAX3  = 11,    // eccentricity diff - maybe
   
   XA_ECDIFF_PERMAX1  = 12,    // period diff in min - full
   XA_ECDIFF_PERMAX2  = 13,    // period diff in min - close
   XA_ECDIFF_PERMAX3  = 14,    // period diff in min - maybe
   
   XA_ECDIFF_APMAX1   = 15,    // argument of perigee diff in deg - full
   XA_ECDIFF_APMAX2   = 16,    // argument of perigee diff in deg - close
   XA_ECDIFF_APMAX3   = 17,    // argument of perigee diff in deg - maybe
   
   XA_ECDIFF_SIZE     = 32;   
   
// indexes for association status from ElComp   
static const int  
   ELCOM_ASTAT_FULL  = 1,     // "FULL" association
   ELCOM_ASTAT_CLOSE = 2,     // "CLOSE" association
   ELCOM_ASTAT_MAYBE = 3,     // "MAYBE" association
   ELCOM_ASTAT_NONE  = 4;     // "NONE" association
   
// indexes for setting criteria for full, close, maybe
static const int     
   XA_COCODIFF_INCMAX1  =  0,    // incli diff in deg - same
   XA_COCODIFF_INCMAX2  =  1,    // incli diff in deg - close
   XA_COCODIFF_INCMAX3  =  2,    // incli diff in deg - near-by
   
   XA_COCODIFF_RAMAX1   =  3,    // W vector dot product in deg - same
   XA_COCODIFF_RAMAX2   =  4,    // W vector dot product in deg - close
   XA_COCODIFF_RAMAX3   =  5,    // W vector dot product in deg - near-by
   
   XA_COCODIFF_PHTMAX1  =  6,    // perigee height diff in km - same
   XA_COCODIFF_PHTMAX2  =  7,    // perigee height diff in km - close
   XA_COCODIFF_PHTMAX3  =  8,    // perigee height diff in km - near-by
   
   XA_COCODIFF_PERMAX1  =  9,    // period diff in min - same
   XA_COCODIFF_PERMAX2  = 10,    // period diff in min - close
   XA_COCODIFF_PERMAX3  = 11,    // period diff in min - near-by
   
   XA_COCODIFF_SIZE     = 32;   

   
// indexes for Coco sat data and coplanar deltas fields
static const int     
   XA_SATDATA_INCLI    =  0,     // inclination (deg)
   XA_SATDATA_NODE     =  1,     // right ascension of the asending node (deg) 
   XA_SATDATA_E        =  2,     // eccentricity (unitless)    
   XA_SATDATA_OMEGA    =  3,     // argument of perigee (deg) 
   XA_SATDATA_MNANOM   =  4,     // mean anomaly (deg)
   XA_SATDATA_MNMOTION =  5,     // mean motion (revs/day)
   XA_SATDATA_EPOCH    =  6,     // epoch in days since 1950, UTC
   
   XA_SATDATA_PHT      =  7,     // perigee height (km) 
   XA_SATDATA_PERIOD   =  8,     // period (min)
   
   XA_SATDATA_SIZE     = 16;
   
   
// indexes for Coco sat data and coplanar deltas fields
static const int     
   XA_COCO_INCLI    =  0,     // inclination (deg)
   XA_COCO_NODE     =  1,     // right ascension of the asending node (deg) 
   XA_COCO_PHT      =  2,     // perigee height (km) 
   XA_COCO_PERIOD   =  3,     // period (min)
   XA_COCO_WDOT     =  4,     // coplanar angle (dot the w vectors) (deg) 
   XA_COCO_RADOT    =  5,     // right ascension dot (deg/day)
   XA_COCO_TNODE    =  6,     // nodal crossing (min)   
   XA_COCO_TZERO    =  7,     // time in days to approach 0.0 RA delta
   XA_COCO_SCAP     =  8,     // sustained close approach possible
   XA_COCO_PCM      =  9,     // potential constellation member
   
   XA_COCO_SIZE     = 16;   
   
   
// indexes for association status from COCO  
static const int  
   COCO_ASTAT_SAME   = 1,     // "SAME" association
   COCO_ASTAT_CLOSE  = 2,     // "CLOSE" association
   COCO_ASTAT_NEARBY = 3,     // "NEARBY" association
   COCO_ASTAT_NONE   = 5;     // "NONE" association




// ========================= End of auto generated code ==========================
