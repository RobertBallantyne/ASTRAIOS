// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// Initializes Bam dll for use in the program
// apPtr              The handle that was returned from DllMainInit() (in-Long)
// returns 0 if the Bam dll is initialized successfully, non-0 if there is an error
int BamInit(__int64 apPtr);


// Returns information about the current version of Bam.dll. The information is placed in the string parameter you pass in
// infoStr            A string to hold the information about Bam.dll (out-Character[128])
void BamGetInfo(char* infoStr);


// Computes the number of time steps using the input start/end times and the step size
// startDs50UTC       start time in days since 1950, UTC (in-Double)
// stopDs50UTC        stop time in days since 1950, UTC (in-Double)
// stepSizeMin        step size in minutes (in-Double)
// returns number of time steps computed from the input time span and step size
int BamCompNumTSs(double startDs50UTC, double stopDs50UTC, double stepSizeMin);


// Computes and returns separate/missed distance data
// satKeys            array of satellite keys that wil be used in BAM (in-Long[*])
// numSats            the size of the satKeys array (in-Integer)
// startDs50UTC       start time in days since 1950, UTC (in-Double)
// stopDs50UTC        stop time in days since 1950, UTC (in-Double)
// stepSizeMin        step size in minutes (in-Double)
// avgSDs             average separate distances of all time steps (out-Double[*])
// avgMDs             average missed distances of all time steps (out-Double[*])
// extBamArr          other BAM resulting data (out-Double[*])
// errCode            0 if Bam is successful, non-0 if there is an error (out-Integer)
void BamCompute(__int64* satKeys, int numSats, double startDs50UTC, double stopDs50UTC, double stepSizeMin, double* avgSDs, double* avgMDs, double* extBamArr, int* errCode);


// Retrieves other BAM data
// xf_bam             Predefined number specifying which BAM array to retrieve (in-Integer)
// bamArr             An array to store the retrieved result (out-Double[*])
void BamGetResults(int xf_bam, double* bamArr);

static const int  
   BAM_SD_TIME    =  0,    // time at mininum average separate distances (ds50UTC)
   BAM_SD_DIST    =  1,    // minimum average separate distance (km)
   BAM_SD_POSX    =  2,    // average position X at minimum average separate distance (km) 
   BAM_SD_POSY    =  3,    // average position Y at minimum average separate distance (km) 
   BAM_SD_POSZ    =  4,    // average position Z at minimum average separate distance (km) 
   BAM_SD_VELX    =  5,    // average velocity X at minimum average separate distance (km/s)
   BAM_SD_VELY    =  6,    // average velocity Y at minimum average separate distance (km/s)
   BAM_SD_VELZ    =  7,    // average velocity Z at minimum average separate distance (km/s)
   BAM_SD_LAT     =  8,    // average latitude at minimum average separate distance (deg) 
   BAM_SD_LON     =  9,    // average longitude at minimum average separate distance (deg)  
   BAM_SD_HEIGHT  = 10,    // average height at minimum average separate distance (km) 

   BAM_MD_TIME    = 20,    // time at mininum average missed distances (ds50UTC)
   BAM_MD_DIST    = 11,    // minimum average missed distance (km)
   BAM_MD_POSX    = 22,    // average position X of satellites when they cross the pinch point plan (km) 
   BAM_MD_POSY    = 23,    // average position Y of satellites when they cross the pinch point plan (km) 
   BAM_MD_POSZ    = 24,    // average position Z of satellites when they cross the pinch point plan (km) 
   BAM_MD_VELX    = 25,    // average velocity X of satellites when they cross the pinch point plan (km/s)
   BAM_MD_VELY    = 26,    // average velocity Y of satellites when they cross the pinch point plan (km/s)
   BAM_MD_VELZ    = 27,    // average velocity Z of satellites when they cross the pinch point plan (km/s)
   BAM_MD_LAT     = 28,    // average latitude of satellites when they cross the pinch point plan (deg) 
   BAM_MD_LON     = 29,    // average longitude of satellites when they cross the pinch point plan (deg)  
   BAM_MD_HEIGHT  = 30,    // average height of satellites when they cross the pinch point plan (km) 

   BAM_MD_END     = 63; 
   
static const int  
   XF_BAM_MDTIME  =  0,    // times when satellites cross the pinch point plan (ds50UTC) 
   XF_BAM_RANGE   =  1,    // missed distances from satellites to the pinch point (km)
   XF_BAM_NADIR   =  2,    // nadir angles of satellites when they cross the pinch point plan
   XF_BAM_POSX    =  3,    // position Xs of satellites when they cross the pinch point plan (km)   
   XF_BAM_POSY    =  4,    // position Ys of satellites when they cross the pinch point plan (km) 
   XF_BAM_POSZ    =  5,    // position Zs of satellites when they cross the pinch point plan (km) 
   XF_BAM_VELX    =  6,    // velocity Xs of satellites when they cross the pinch point plan (km/s)
   XF_BAM_VELY    =  7,    // velocity Ys of satellites when they cross the pinch point plan (km/s)
   XF_BAM_VELZ    =  8,    // velocity Zs of satellites when they cross the pinch point plan (km/s)
   XF_BAM_LAT     =  9,    // latitude of satellites when they cross the pinch point plan (deg) 
   XF_BAM_LON     = 10,    // longitude of satellites when they cross the pinch point plan (deg)  
   XF_BAM_HEIGHT  = 11;    // height of satellites when they cross the pinch point plan (km) 
   

   



// ========================= End of auto generated code ==========================
