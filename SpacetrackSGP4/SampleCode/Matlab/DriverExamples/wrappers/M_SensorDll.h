// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// Initializes Sensor DLL for use in the program
// apPtr              The handle that was returned from DllMainInit() (in-Long)
// returns 0 if Sensor.dll is initialized successfully, non-0 if there is an error
int SensorInit(__int64 apPtr);


// Returns information about the current version of Sensor DLL. 
// infoStr            A string to hold the information about Sensor.dll (out-Character[128])
void SensorGetInfo(char* infoStr);


// Loads sensor data, contained in a text file, into the set of loaded sensors
// senFile            The name of the file containing sensor data (in-Character[512])
// returns 0 if the input file is read successfully, non-0 if there is an error
int SensorLoadFile(char* senFile);


// Loads a single sensor-typed card
// card               Any single sensor-typed card (in-Character[512])
// returns 0 if the input card is read successfully, non-0 if there is an error
int SensorLoadCard(char* card);


// Saves the currently loaded sensor data to a file
// sensorFile         The name of the file in which to save the settings (in-Character[512])
// saveMode           Specifies whether to create a new file or append to an existing one (0 = create, 1= append) (in-Integer)
// saveForm           Specifies the mode in which to save the file (0 = text format, 1 = not yet implemented, reserved for future) (in-Integer)
// returns 0 if the data is successfully saved to the file, non-0 if there is an error
int SensorSaveFile(char* sensorFile, int saveMode, int saveForm);


// Removes a sensor, represented by the senKey, from the set of currently loaded sensors
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// returns 0 if the sensor is successfully removed, non-0 if there is an error
int SensorRemove(int senKey);


// Removes all currently loaded sensors from memory
// returns 0 if all the loaded sensors are removed successfully, non-0 if there is an error
int SensorRemoveAll();


// Returns the number of sensors currently loaded
// returns the number of sensors currently loaded
int SensorGetCount();


// Retrieves all of the currently loaded senKeys. 
// order              Specifies the order in which the senKeys should be returned:0=Sort in ascending order, 1=Sort in descending order, 2=Sort in the order in which the senKeys were loaded in memory (in-Integer)
// senKeys            The array in which to store the senKeys (out-Integer[*])
void SensorGetLoaded(int order, int* senKeys);


// Retrieves sensor location data for a sensor
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// astroLat           Astronomical Latitude (deg): astroLat[-90, 90], (+ = North; - = South) (out-Double)
// astroLon           Astronomical Longitude (deg): astroLon[-360, 360], (+ = West; - = East) (out-Double)
// senPos             Sensor XYZ geocentric position (meters) (out-Double[3])
// senDesc            Sensor location description (out-Character[24])
// orbSatNum          For orbiting sensors, this is the associated satellite number. For ground sensors, orbSatNum = 0 (out-Integer)
// secClass           Sensor classification: U = Unclassified, C = Confidential, S = Secret (out-Character)
// returns 0 if all sensor location data fields are retrieved successfully, non-0 if there is an error
int SensorGetLocAll(int senKey, double* astroLat, double* astroLon, double* senPos, char* senDesc, int* orbSatNum, char* secClass);


// Adds/updates sensor location data for a sensor using individually provided field values
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// astroLat           Astronomical Latitude (deg): astroLat[-90, 90], (+ = North; - = South) (in-Double)
// astroLon           Astronomical Longitude (deg): astroLon[-360, 360], (+ = West; - = East) (in-Double)
// senPos             Sensor XYZ geocentric position (meters) (in-Double[3])
// senDesc            Sensor location description (in-Character[24])
// orbSatNum          For orbiting sensors, this is the associated satellite number. For ground sensors, orbSatNum = 0 (in-Integer)
// secClass           Sensor classification: U = Unclassified, C = Confidential, S = Secret (in-Character)
// returns 0 if the sensor location data is added/updated successfully, non-0 if there is an error
int SensorSetLocAll(int senKey, double astroLat, double astroLon, double* senPos, char* senDesc, int orbSatNum, char secClass);


// Retrieves the value of an individual field of sensor location data
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// xf_SenLoc          Predefined number specifying which field to retrieve (in-Integer)
// strValue           A string to contain the value of the requested field (out-Character[512])
// returns 0 if the sensor location data is successfully retrieved, non-0 if there is an error
int SensorGetLocField(int senKey, int xf_SenLoc, char* strValue);


// Updates the value of an individual field of sensor location data
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// xf_SenLoc          Predefined number specifying which field to retrieve (in-Integer)
// strValue           The new value of the specified field, expressed as a string (in-Character[512])
// returns 0 if the sensor location data is successfully updated, non-0 if there is an error
int SensorSetLocField(int senKey, int xf_SenLoc, char* strValue);


// Retrieves sensor limits data
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// viewType           Sensor viewing type (out-Character)
// obsType            Sensor observation type (out-Character)
// rngUnits           Units of range and range rate: 0=km, km/sec, 1=nm, nm/sec (out-Integer)
// maxRngLim          Maximum observable range limit (km) (out-Double)
// boresight1         Orbiting sensor boresight1 vector (out-Character)
// elLim1             Elevation limit #1 (low, deg) OR orbiting sensor off-boresight angle (out-Double)
// elLim2             Elevation limit #2 (high, deg) OR orbiting sensor off-boresight angle (out-Double)
// azLim1             Azimuth limit #1 (left, deg) OR orbiting sensor clock angle (out-Double)
// azLim2             Azimuth limit #2 (right, deg) OR orbiting sensor clock angle (out-Double)
// interval           ouput interval (min) (out-Double)
// visFlg             Visual pass control flag (out-Integer)
// rngLimFlg          Range limits control flag (out-Integer)
// maxPPP             Max number of points per pass (0=unlimited) (out-Integer)
// minRngLim          Minimum observable range limit (km) (out-Double)
// plntryRes          Orbiting sensor planetary restrictions (out-Integer)
// rrLim              Range rate/relative velocity limit (km/sec) (out-Double)
// returns 0 if all sensor limits data fields are retrieved successfully, non-0 if there is an error
int SensorGet1L(int senKey, char* viewType, char* obsType, int* rngUnits, double* maxRngLim, char* boresight1, double* elLim1, double* elLim2, double* azLim1, double* azLim2, double* interval, int* visFlg, int* rngLimFlg, int* maxPPP, double* minRngLim, int* plntryRes, double* rrLim);


// Adds/updates sensor limits data via individually provided field values
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// viewType           Sensor viewing type (in-Character)
// obsType            Sensor observation type (in-Character)
// rngUnits           Units of range and range rate: 0=km, km/sec, 1=nm, nm/sec (in-Integer)
// maxRngLim          Maximum observable range limit (km) (in-Double)
// boresight1         Orbiting sensor boresight1 vector (in-Character)
// elLim1             Elevation limit #1 (low, deg) OR orbiting sensor off-boresight angle (in-Double)
// elLim2             Elevation limit #2 (high, deg) OR orbiting sensor off-boresight angle (in-Double)
// azLim1             Azimuth limit #1 (left, deg) OR orbiting sensor clock angle (in-Double)
// azLim2             Azimuth limit #2 (right, deg) OR orbiting sensor clock angle (in-Double)
// interval           ouput interval (min) (in-Double)
// visFlg             Visual pass control flag (in-Integer)
// rngLimFlg          Range limits control flag (in-Integer)
// maxPPP             Max number of points per pass (0=unlimited) (in-Integer)
// minRngLim          Minimum observable range limit (km) (in-Double)
// plntryRes          Orbiting sensor planetary restrictions (in-Integer)
// rrLim              Range rate/relative velocity limit (km/sec) (in-Double)
// returns 0 if the sensor limits data is added/updated successfully, non-0 if there is an error
int SensorSet1L(int senKey, char viewType, char obsType, int rngUnits, double maxRngLim, char boresight1, double elLim1, double elLim2, double azLim1, double azLim2, double interval, int visFlg, int rngLimFlg, int maxPPP, double minRngLim, int plntryRes, double rrLim);


// Retrieves additional sensor limits data
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// boresight2         Orbiting sensor boresight2 vector (out-Character)
// elLim3             Elevation limit #3 (low, deg) OR orbiting sensor off-boresight angle (out-Double)
// elLim4             Elevation limit #4 (high, deg) OR orbiting sensor off-boresight angle (out-Double)
// azLim3             Azimuth limit #3 (left, deg) OR orbiting sensor clock angle (out-Double)
// azLim4             Azimuth limit #4 (right, deg) OR orbiting sensor clock angle (out-Double)
// earthBckgrnd       Flag; if set, allow orb sensor to view satellite against earth background (out-Integer)
// earthLimb          Orbiting sensor earth limb exclusion distance (km) (out-Double)
// solarXAngle        Orbiting sensor solar exclusion angle (deg) (out-Double)
// lunarXAngle        Orbiting sensor lunar exclusion angle (deg) (out-Double)
// minIllum           Orbiting sensor minimum illumination angle (deg) (out-Double)
// twilit             Ground site twilight offset angle (deg) (out-Double)
// returns 0 if all optional/additional sensor limits data fields are retrieved successfully, non-0 if there is an error
int SensorGet2L(int senKey, char* boresight2, double* elLim3, double* elLim4, double* azLim3, double* azLim4, int* earthBckgrnd, double* earthLimb, double* solarXAngle, double* lunarXAngle, double* minIllum, double* twilit);


// Adds/updates additional sensor limits data
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// boresight2         Orbiting sensor boresight2 vector (in-Character)
// elLim3             Elevation limit #3 (low, deg) OR orbiting sensor off-boresight angle (in-Double)
// elLim4             Elevation limit #4 (high, deg) OR orbiting sensor off-boresight angle (in-Double)
// azLim3             Azimuth limit #3 (left, deg) OR orbiting sensor clock angle (in-Double)
// azLim4             Azimuth limit #4 (right, deg) OR orbiting sensor clock angle (in-Double)
// earthBckgrnd       Flag; if set, allow orb sensor to view satellite against earth background (in-Integer)
// earthLimb          Orbiting sensor earth limb exclusion distance (km) (in-Double)
// solarXAngle        Orbiting sensor solar exclusion angle (deg) (in-Double)
// lunarXAngle        Orbiting sensor lunar exclusion angle (deg) (in-Double)
// minIllum           Orbiting sensor minimum illumination angle (deg) (in-Double)
// twilit             Ground site twilight offset angle (deg) (in-Double)
// returns 0 if the optional/additional sensor limits data is added/updated successfully, non-0 if there is an error
int SensorSet2L(int senKey, char boresight2, double elLim3, double elLim4, double azLim3, double azLim4, int earthBckgrnd, double earthLimb, double solarXAngle, double lunarXAngle, double minIllum, double twilit);


// Retrieves an individual field of sensor limits data
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// xf_SenLim          Predefined number specifying which field to retrieve (in-Integer)
// strValue           A string to contain the value of the requested field (out-Character[512])
// returns 0 if the sensor limits data is retrieved successfully, non-0 if there is an error
int SensorGetLimField(int senKey, int xf_SenLim, char* strValue);


// Updates an individual field of sensor limits data
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// xf_SenLim          Predefined number specifying which field to retrieve (in-Integer)
// strValue           The new value of the specified field, expressed as a string (in-Character[512])
// returns Returns zero indicating the sensor limits data has been successfully updated. Other values indicate an error
int SensorSetLimField(int senKey, int xf_SenLim, char* strValue);


// Retrieves sensor sigma/bias data
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// biasSigmaArr       bias/sigma array 0=azSigma, 1=elSigma, 2=rgSigma, 3=rrSigma, 8=azBias, 9=elBias, 10=rgBias, 11=rrBias, 15=timeBias (out-Double[16])
// returns 0 if all sensor sigma/bias data fields are retrieved successfully, non-0 if there is an error
int SensorGetBS(int senKey, double* biasSigmaArr);


// Adds/updates sensor sigma/bias data 
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// biasSigmaArr       bias/sigma array 0=azSigma, 1=elSigma, 2=rgSigma, 3=rrSigma, 8=azBias, 9=elBias, 10=rgBias, 11=rrBias, 15=timeBias (in-Double[16])
// returns 0 if the sensor sigma/bias data is added/updated successfully, non-0 if there is an error
int SensorSetBS(int senKey, double* biasSigmaArr);


// Retrieves an individual field of sensor sigma/bias data
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// xaf_SenBS          Predefined number specifying which field to retrieve: 0=azSigma, 1=elSigma, 2=rgSigma, 3=rrSigma, 8=azBias, 9=elBias, 10=rgBias, 11=rrBias, 15=timeBias (in-Integer)
// strValue           A string to contain the value of the requested field (out-Character[512])
// returns 0 if the sensor sigma/bias data is retrieved successfully, non-0 if there is an error
int SensorGetBSField(int senKey, int xaf_SenBS, char* strValue);


// Updates an individual field of sensor sigma/bias data
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// xaf_SenBS          Predefined number specifying which field to retrieve: 0=azSigma, 1=elSigma, 2=rgSigma, 3=rrSigma, 8=azBias, 9=elBias, 10=rgBias, 11=rrBias, 15=timeBias (in-Integer)
// strValue           The new value of the specified field, expressed as a string (in-Character[512])
// returns Returns zero indicating the sensor sigma/bias data has been successfully updated. Other values indicate an error
int SensorSetBSField(int senKey, int xaf_SenBS, char* strValue);


// Retrieves the sensor data in form of S-Card, L1-Card, and L2-Card of the sensor
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// sCard              S-Card string of the sensor (out-Character[512])
// l1Card             L1-Card string of the sensor (out-Character[512])
// l2Card             L2-Card string of the sensor (out-Character[512])
// returns 0 on success, non-0 if there is an error
int SensorGetLines(int senKey, char* sCard, char* l1Card, char* l2Card);


// Gets sensor's orbiting satellite's satKey
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// orbSatKey          The orbiting satellite's unique key (out-Long)
// returns 0 on success, non-0 if there is an error
int SensorGetOrbSatKey(int senKey, __int64* orbSatKey);


// Sets sensor's orbiting satellite's satKey
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// orbSatKey          The orbiting satellite's unique key (in-Long)
// returns 0 on success, non-0 if there is an error
int SensorSetOrbSatKey(int senKey, __int64 orbSatKey);


// Loads Space Fence's detailed azimuth-elevation definition table
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// azElTableFile      The name of the file containing Space Fence's az/el definition table (in-Character[512])
// returns 0 if the input file is read successfully, non-0 if there is an error
int SensorLoadAzElTable(int senKey, char* azElTableFile);


// Adds a new sensor segment whose limits defined by the input parameters - a cone or a dome portion 
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// segType            Input segment type (bounded-cone = 1, dome = 2) (in-Integer)
// xa_seg             sensor segment data (in-Double[16])
// returns 0 if the new sensor segment is added successfully, non-0 if there is an error
int SensorAddSegment(int senKey, int segType, double* xa_seg);


// Retrieves sensor segment data of the specified segment (segNum)
// senKey             The sensor's unique key (same as the sensor number) (in-Integer)
// segNum             The segment number of the sensor segment whose data is returned (in-Integer)
// segType            The output segment type (bounded-cone = 1, dome = 2) (out-Integer)
// xa_seg             The resulting sensor segment data (out-Double[16])
// returns 0 if the sensor segment data is returned successfully, non-0 if there is an error
int SensorGetSegment(int senKey, int segNum, int* segType, double* xa_seg);

// Indexes of Sensor data fields
static const int  
   XF_SENLOC_NUM  = 1,             // Sensor number
   XF_SENLOC_LAT  = 2,             // Sensor astronomical latitude (deg)
   XF_SENLOC_LON  = 3,             // Sensor astronomical longitude (deg)
   XF_SENLOC_POSX = 4,             // Sensor position X (km)
   XF_SENLOC_POSY = 5,             // Sensor position Y (km)
   XF_SENLOC_POSZ = 6,             // Sensor position Z (km)
   XF_SENLOC_DESC = 7,             // Sensor description
   XF_SENLOC_ORBSATNUM = 8,        // Orbiting sensor's number (satnum)   
   XF_SENLOC_SECCLASS  = 9,        // Sensor classification   
   
   XF_SENLIM_VIEWTYPE  = 11,       // Sensor view type
   XF_SENLIM_OBSTYPE   = 12,       // Sensor observation type
   XF_SENLIM_UNIT      = 13,       // Unit on range/range rate
   XF_SENLIM_MAXRNG    = 14,       // Max observable range (km)
   XF_SENLIM_MINRNG    = 15,       // Min observable range (km)
   XF_SENLIM_INTERVAL  = 16,       // Output interval (min)
   XF_SENLIM_OPTVISFLG = 17,       // Visual pass control flag
   XF_SENLIM_RNGLIMFLG = 18,       // Range limit control flag 
   XF_SENLIM_PTSPERPAS = 19,       // Max number of points per pass
   XF_SENLIM_RRLIM     = 20,       // Range rate/relative velocity limit (km/sec)
   
   XF_SENLIM_ELLIM1    = 31,       // Elevation limits #1 (low, deg) or orbiting sensor off-boresight angle (low, deg) or conical sensor boresight elvation (deg)
   XF_SENLIM_ELLIM2    = 32,       // Elevation limits #2 (high, deg) or orbiting sensor off-boresight angle (high, deg) or conical sensor boresight minimum angle (deg)
   XF_SENLIM_ELLIM3    = 33,       // Elevation limits #3 (low, deg) or orbiting sensor off-boresight angle (low, deg) or 
   XF_SENLIM_ELLIM4    = 34,       // Elevation limits #4 (high, deg) or orbiting sensor off-boresight angle (high, deg)
   XF_SENLIM_AZLIM1    = 35,       // Azimuth limits #1 (low, deg) or orbiting sensor clock angle (from, deg) or conical sensor boresight azimuth (deg)
   XF_SENLIM_AZLIM2    = 36,       // Azimuth limits #2 (high, deg) or orbiting sensor clock angle (to, deg) or conical sensor off-boresight azimuth angle (deg)
   XF_SENLIM_AZLIM3    = 37,       // Azimuth limits #3 (low, deg) or orbiting sensor clock angle (from, deg)
   XF_SENLIM_AZLIM4    = 38,       // Azimuth limits #4 (high, deg) or orbiting sensor clock angle (to, deg)
   
   
   XF_SENLIM_PLNTRYRES = 52,       // Orbiting sensor planetary restriction
   XF_SENLIM_BOREVEC1  = 53,       // Orbiting sensor boresight vector 1
   XF_SENLIM_BOREVEC2  = 54,       // Orbiting sensor boresight vector 2
   XF_SENLIM_KEARTH    = 55,       // Allow orbiting sensor to view sat against earth background
   XF_SENLIM_ELIMB     = 56,       // Orbiting sensor earth limb exclusion distance (km)
   XF_SENLIM_SOLEXCANG = 57,       // Orbiting sensor solar exclusion angle (deg)   
   XF_SENLIM_LUNEXCANG = 58,       // Orbiting sensor lunar exclusion angle (deg)
   
   
   XF_SENLIM_MINIL     = 59,       // Orbiting sensor min illumination angle (deg)
   XF_SENLIM_TWILIT    = 60,       // Ground site twilight offset angle (deg) 
   XF_SENLIM_SMSEN     = 61,       // Is special mobil sensor flag / column 9 in 1L card
   XF_SENLIM_NUMSEGS   = 62,       // Number of additional segments added to sensor limits
   XF_SENLIM_FILE      = 63,       // Space fence FOR's Az/El table file name
   XF_SENLIM_AZELROWS  = 64;       // Number of rows in space fence FOR's Az/El table 

//*******************************************************************************
   
// Indexes of Sensor's sigma   biases data fields
static const int  
   XAF_SENBS_AZSIGMA =  0,    // azimuth sigma (deg)
   XAF_SENBS_ELSIGMA =  1,    // elevation sigma (deg)
   XAF_SENBS_RGSIGMA =  2,    // range sigma (km)
   XAF_SENBS_RRSIGMA =  3,    // range-rate sigma (km/sec) 
   XAF_SENBS_ARSIGMA =  4,    // az rate sigma (deg/sec)
   XAF_SENBS_ERSIGMA =  5,    // el rate sigma (deg/sec)

   XAF_SENBS_AZBIAS  =  8,    // azimuth bias (deg)
   XAF_SENBS_ELBIAS  =  9,    // elevation bias (deg)
   XAF_SENBS_RGBIAS  = 10,    // range bias (km)
   XAF_SENBS_RRBIAS  = 11,    // range-rate bias (km/sec)
   XAF_SENBS_TIMEBIAS= 15;    // time bias (sec)
   
   
   
// Sensor segment types
static const int  
   SEG_BCONE = 1,      // bounded-cone-typed limit: Boresight Az/El, Min/Max halfcone angle/Range, minimum cut-off elevation
   SEG_DOME  = 2;      // dome-typed limit: Min/Max Az/El/Range
   


// Indexes of dome segment parameters
static const int  
   XA_SEG_DOME_AZFR   =  0,   // start azimuth (deg)          
   XA_SEG_DOME_AZTO   =  1,   // end azimuth (deg)            
   XA_SEG_DOME_ELFR   =  2,   // lower-bound elevation (deg)  
   XA_SEG_DOME_ELTO   =  3,   // higher-bound elevation (deg) 
   XA_SEG_DOME_MINRNG =  4,   // minimum range (km)           
   XA_SEG_DOME_MAXRNG =  5,   // maximum range (km)           
   
   XA_SEG_DOME_SIZE   = 16;
   

// Indexes of bounded-cone segment parameters
static const int  
   XA_SEG_BCONE_BSAZ   =  0,   // boresight azimuth (deg)
   XA_SEG_BCONE_BSEL   =  1,   // boresight elevation (deg)          
   XA_SEG_BCONE_ANGFR  =  2,   // offboresight lower angle (deg)
   XA_SEG_BCONE_ANGTO  =  3,   // offboresight higher angle (deg)
   XA_SEG_BCONE_MINRNG =  4,   // minimum range (km)
   XA_SEG_BCONE_MAXRNG =  5,   // maximum range (km)
   XA_SEG_BCONE_MINEL  =  6,   // minimum cut-off elevation (deg)
   
   XA_SEG_BCONE_SIZE   = 16;
   
   



// ========================= End of auto generated code ==========================
