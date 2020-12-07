// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// Initializes the Sgp4 DLL for use in the program.
// apPtr              The handle that was returned from DllMainInit(). See the documentation for DllMain.dll for details. (in-Long)
// returns 0 if Sgp4Prop.dll is initialized successfully, non-0 if there is an error.
int Sgp4Init(__int64 apPtr);


// Returns information about the current version of Sgp4Prop.dll. The information is placed in the string parameter you pass in.
// infoStr            A string to hold the information about Sgp4Prop.dll. (out-Character[128])
void Sgp4GetInfo(char* infoStr);


// Initializes an SGP4 satellite from an SGP or SGP4 TLE.
// satKey             The satellite's unique key. This key will have been returned by one of the routines in Tle.dll. (in-Long)
// returns 0 if the satellite is successfully initialized and added to Sgp4Prop.dll's set of satellites, non-0 if there is an error.
int Sgp4InitSat(__int64 satKey);


// Removes a satellite, represented by the satKey, from the set of satellites.
// satKey             The satellite's unique key. (in-Long)
// returns 0 if the satellite is removed successfully, non-0 if there is an error.
int Sgp4RemoveSat(__int64 satKey);


// Removes all currently loaded satellites from memory.
// returns 0 if all satellites are removed successfully from memory, non-0 if there is an error.
int Sgp4RemoveAllSats();


// Propagates a satellite, represented by the satKey, to the time expressed in minutes since the satellite's epoch time. 
// The resulting data about the satellite is placed in the various reference parameters.
// satKey             The satellite's unique key. (in-Long)
// mse                The time to propagate to, specified in minutes since the satellite's epoch time. (in-Double)
// ds50UTC            Resulting time in days since 1950, UTC. (out-Double)
// pos                Resulting ECI position vector (km) in True Equator and Mean Equinox of Epoch. (out-Double[3])
// vel                Resulting ECI velocity vector (km/s) in True Equator and Mean Equinox of Epoch. (out-Double[3])
// llh                Resulting geodetic latitude (deg), longitude(deg), and height (km). (out-Double[3])
// returns 0 if the propagation is successful, non-0 if there is an error.
int Sgp4PropMse(__int64 satKey, double mse, double* ds50UTC, double* pos, double* vel, double* llh);


// Propagates a satellite, represented by the satKey, to the time expressed in days since 1950, UTC. 
// The resulting data about the satellite is placed in the various reference parameters.
// satKey             The unique key of the satellite to propagate. (in-Long)
// ds50UTC            The time to propagate to, expressed in days since 1950, UTC. (in-Double)
// mse                Resulting time in minutes since the satellite's epoch time. (out-Double)
// pos                Resulting ECI position vector (km) in True Equator and Mean Equinox of Epoch. (out-Double[3])
// vel                Resulting ECI velocity vector (km/s) in True Equator and Mean Equinox of Epoch. (out-Double[3])
// llh                Resulting geodetic latitude (deg), longitude(deg), and height (km). (out-Double[3])
// returns 0 if the propagation is successful, non-0 if there is an error.
int Sgp4PropDs50UTC(__int64 satKey, double ds50UTC, double* mse, double* pos, double* vel, double* llh);


// Propagates a satellite, represented by the satKey, to the time expressed in days since 1950, UTC. 
// Only the geodetic information is returned by this function.
// satKey             The unique key of the satellite to propagate. (in-Long)
// ds50UTC            The time to propagate to, expressed in days since 1950, UTC. (in-Double)
// llh                Resulting geodetic latitude (deg), longitude(deg), and height (km). (out-Double[3])
// returns 0 if the propagation is successful, non-0 if there is an error.
int Sgp4PropDs50UtcLLH(__int64 satKey, double ds50UTC, double* llh);


// Propagates a satellite, represented by the satKey, to the time expressed in days since 1950, UTC. 
// Only the ECI position vector is returned by this function.
// satKey             The unique key of the satellite to propagate. (in-Long)
// ds50UTC            The time to propagate to, expressed in days since 1950, UTC. (in-Double)
// pos                Resulting ECI position vector (km) in True Equator and Mean Equinox of Epoch. (out-Double[3])
// returns 0 if the propagation is successful, non-0 if there is an error.
int Sgp4PropDs50UtcPos(__int64 satKey, double ds50UTC, double* pos);


// Retrieves propagator's precomputed results. This function can be used to obtain results from 
// a propagation which are not made available through calls to the propagation functions themselves.
// satKey             The unique key of the satellite for which to retrieve results. (in-Long)
// xf_Sgp4Out         Specifies which propagator outputs to retrieve. (in-Integer)
// destArr            Array to receive the resulting propagator outputs. (out-Double[*])
// returns 0 if the requested information is retrieved successfully, non-0 if there is an error.
int Sgp4GetPropOut(__int64 satKey, int xf_Sgp4Out, double* destArr);


// Propagates a satellite, represented by the satKey, to the time expressed in either minutes since epoch or days since 1950, UTC. 
// All propagation data is returned by this function.
// satKey             The unique key of the satellite to propagate. (in-Long)
// timeType           The propagation time type: 0 = minutes since epoch, 1 = days since 1950, UTC (in-Integer)
// timeIn             The time to propagate to, expressed in either minutes since epoch or days since 1950, UTC. (in-Double)
// xa_Sgp4Out         The array that stores all Sgp4 propagation data, see XA_SGP4OUT_? for array arrangement (out-Double[64])
// returns 0 if the propagation is successful, non-0 if there is an error.
int Sgp4PropAll(__int64 satKey, int timeType, double timeIn, double* xa_Sgp4Out);


// Converts osculating position and velocity vectors to a set of mean Keplerian SGP4 elements.
// yr                 2 or 4 digit year of the epoch time. (in-Integer)
// day                Day of year of the epoch time. (in-Double)
// pos                Input osculating position vector (km). (in-Double[3])
// vel                Input osculating velocity vector (km/s). (in-Double[3])
// posNew             Resulting position vector (km) propagated from the sgp4MeanKep. (out-Double[3])
// velNew             Resulting velocity vector (km/s) propagated from the sgp4MeanKep. (out-Double[3])
// sgp4MeanKep        Resulting set of Sgp4 mean Keplerian elements. (out-Double[6])
// returns 0 if the conversion is successful, non-0 if there is an error.
int Sgp4PosVelToKep(int yr, double day, double* pos, double* vel, double* posNew, double* velNew, double* sgp4MeanKep);


// Converts osculating position and velocity vectors to TLE array - allows bstar/bterm, drag values to be used in the conversion if desired
// pos                Input osculating position vector (km). (in-Double[3])
// vel                Input osculating velocity vector (km/s). (in-Double[3])
// xa_tle             Input/Output array containing TLE's numerical fields, see XA_TLE_? for array arrangement; required data include epoch, drag, bstar/bterm (out-Double[64])
// returns 0 if the conversion is successful, non-0 if there is an error.
int Sgp4PosVelToTleArr(double* pos, double* vel, double* xa_tle);


// Reepochs a loaded TLE, represented by the satKey, to a new epoch.
// satKey             The unique key of the satellite to reepoch. (in-Long)
// reepochDs50UTC     The new epoch, express in days since 1950, UTC. (in-Double)
// line1Out           A string to hold the first line of the reepoched TLE. (out-Character[512])
// line2Out           A string to hold the second line of the reepoched TLE. (out-Character[512])
// returns 0 if the reepoch is successful, non-0 if there is an error.
int Sgp4ReepochTLE(__int64 satKey, double reepochDs50UTC, char* line1Out, char* line2Out);


// Sets path to the Sgp4 Open License file if the license file is not in the current working folder
// licFilePath        The file path to the Sgp4 Open License file (in-Character[512])
void Sgp4SetLicFilePath(char* licFilePath);


// Gets the current path to the Sgp4 Open License file
// licFilePath        The file path to the Sgp4 Open License file (out-Character[512])
void Sgp4GetLicFilePath(char* licFilePath);

// Different time types for passing to Sgp4PropAll
static const int  
   SGP4_TIMETYPE_MSE      = 0,   // propagation time is in minutes since epoch
   SGP4_TIMETYPE_DS50UTC  = 1;   // propagation time is in days since 1950, UTC
   
// Sgp4 propagated output fields
static const int  
   XF_SGP4OUT_REVNUM       = 1,    // Revolution number
   XF_SGP4OUT_NODAL_AP_PER = 2,    // Nodal period, apogee, perigee
   XF_SGP4OUT_MEAN_KEP     = 3,    // Mean Keplerian
   XF_SGP4OUT_OSC_KEP      = 4;    // Osculating Keplerian
   
// Sgp4 propagated data
static const int  
   XA_SGP4OUT_DS50UTC      =  0,   // Propagation time in days since 1950, UTC
   XA_SGP4OUT_MSE          =  1,   // Propagation time in minutes since the satellite's epoch time
   XA_SGP4OUT_POSX         =  2,   // ECI X position (km) in True Equator and Mean Equinox of Epoch
   XA_SGP4OUT_POSY         =  3,   // ECI Y position (km) in True Equator and Mean Equinox of Epoch
   XA_SGP4OUT_POSZ         =  4,   // ECI Z position (km) in True Equator and Mean Equinox of Epoch
   XA_SGP4OUT_VELX         =  5,   // ECI X velocity (km/s) in True Equator and Mean Equinox of Epoch
   XA_SGP4OUT_VELY         =  6,   // ECI Y velocity (km/s) in True Equator and Mean Equinox of Epoch
   XA_SGP4OUT_VELZ         =  7,   // ECI Z velocity (km/s) in True Equator and Mean Equinox of Epoch
   XA_SGP4OUT_LAT          =  8,   // Geodetic latitude (deg)
   XA_SGP4OUT_LON          =  9,   // Geodetic longitude (deg)
   XA_SGP4OUT_HEIGHT       = 10,   // Height above geoid (km)
   XA_SGP4OUT_REVNUM       = 11,   // Revolution number
   XA_SGP4OUT_NODALPER     = 12,   // Nodal period (min)
   XA_SGP4OUT_APOGEE       = 13,   // Apogee (km)
   XA_SGP4OUT_PERIGEE      = 14,   // Perigee (km)
   XA_SGP4OUT_MN_A         = 15,   // Mean semi-major axis (km)
   XA_SGP4OUT_MN_E         = 16,   // Mean eccentricity (unitless)
   XA_SGP4OUT_MN_INCLI     = 17,   // Mean inclination (deg)
   XA_SGP4OUT_MN_MA        = 18,   // Mean mean anomaly (deg)
   XA_SGP4OUT_MN_NODE      = 19,   // Mean right ascension of the asending node (deg)
   XA_SGP4OUT_MN_OMEGA     = 20,   // Mean argument of perigee (deg)
   XA_SGP4OUT_OSC_A        = 21,   // Osculating semi-major axis (km)  
   XA_SGP4OUT_OSC_E        = 22,   // Osculating eccentricity (unitless)
   XA_SGP4OUT_OSC_INCLI    = 23,   // Osculating inclination (deg)
   XA_SGP4OUT_OSC_MA       = 24,   // Osculating mean anomaly (deg)
   XA_SGP4OUT_OSC_NODE     = 25,   // Osculating right ascension of the asending node (deg)
   XA_SGP4OUT_OSC_OMEGA    = 26,   // Osculating argument of perigee (deg)

   XA_SGP4OUT_SIZE         = 64;




// ========================= End of auto generated code ==========================
