// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// Initializes AstroFunc DLL for use in the program.
// apPtr              The handle that was returned from DllMainInit(). See the documentation for DllMain.dll for details. (in-Long)
// returns 0 if AstroFunc.dll is initialized successfully, non-0 if there is an error.
int AstroFuncInit(__int64 apPtr);


// Retrieves information about the current version of AstroFunc.dll. The information is placed in the string parameter you pass in.
// infoStr            A string to hold the information about AstroFunc.dll. (out-Character[128])
void AstroFuncGetInfo(char* infoStr);


// Converts a set of Keplerian elements to a set of equinoctial elements. 
// metricKep          The set of Keplerian elements to be converted. (in-Double[6])
// metricEqnx         The resulting set of equinoctial elements. (out-Double[6])
void KepToEqnx(double* metricKep, double* metricEqnx);


// Converts a set of osculating Keplerian elements to osculating position and velocity vectors.
// metricKep          The set of Keplerian elements to be converted. (in-Double[6])
// pos                The resulting position vector. (out-Double[3])
// vel                The resulting velocity vector. (out-Double[3])
void KepToPosVel(double* metricKep, double* pos, double* vel);


// Converts a set of Keplerian elements to Ubar, Vbar, and Wbar vectors.
// metricKep          The set of Keplerian elements to be converted. (in-Double[6])
// uBar               The resulting ubar vector. (out-Double[3])
// vBar               The resulting vbar vector. (out-Double[3])
// wBar               The resulting wbar vector. (out-Double[3])
void KepToUVW(double* metricKep, double* uBar, double* vBar, double* wBar);


// Converts a set of classical elements to a set of equinoctial elements. 
// metricClass        The set of classical elements to be converted. (in-Double[6])
// metricEqnx         The resulting set of equinoctial elements. (out-Double[6])
void ClassToEqnx(double* metricClass, double* metricEqnx);


// Converts a set of equinoctial elements to a set of classical elements.
// metricEqnx         The set of equinoctial elements to be converted. (in-Double[6])
// metricClass        The resulting set of classical elements. (out-Double[6])
void EqnxToClass(double* metricEqnx, double* metricClass);


// Converts a set of equinoctial elements to a set of Keplerian elements. 
// metricEqnx         The set of equinoctial elements to be converted. (in-Double[6])
// metricKep          The resulting set of Keplerian elements. (out-Double[6])
void EqnxToKep(double* metricEqnx, double* metricKep);


// Converts a set of equinoctial elements to position and velocity vectors.
// metricEqnx         The set of equinoctial elements to be converted. (in-Double[6])
// pos                The resulting position vector. (out-Double[3])
// vel                The resulting velocity vector. (out-Double[3])
void EqnxToPosVel(double* metricEqnx, double* pos, double* vel);


// Converts position and velocity vectors to a set of equinoctial elements.
// pos                The position vector to be converted. (in-Double[3])
// vel                The velocity vector to be converted. (in-Double[3])
// metricEqnx         The resulting set of equinoctial elements. (out-Double[6])
void PosVelToEqnx(double* pos, double* vel, double* metricEqnx);


// Converts position and velocity vectors to a set of equinoctial elements with the given mu value. 
// pos                The position vector to be converted. (in-Double[3])
// vel                The velocity vector to be converted. (in-Double[3])
// mu                 The value of mu. (in-Double)
// metricEqnx         The resulting set of equinoctial elements. (out-Double[6])
void PosVelMuToEqnx(double* pos, double* vel, double mu, double* metricEqnx);


// Converts osculating position and velocity vectors to a set of osculating Keplerian elements.
// pos                The position vector to be converted. (in-Double[3])
// vel                The velocity vector to be converted. (in-Double[3])
// metricKep          The resulting set of Keplerian elements. (out-Double[6])
void PosVelToKep(double* pos, double* vel, double* metricKep);


// Converts osculating position and velocity vectors to a set of osculating Keplerian elements with the given value of mu.
// pos                The position vector to be converted. (in-Double[3])
// vel                The velocity vector to be converted. (in-Double[3])
// mu                 The value of mu. (in-Double)
// metricKep          The resulting set of Keplerian elements. (out-Double[6])
void PosVelMuToKep(double* pos, double* vel, double mu, double* metricKep);


// Converts position and velocity vectors to U, V, W vectors. See the remarks section for details.
// pos                The position vector to be converted. (in-Double[3])
// vel                The velocity vector to be converted. (in-Double[3])
// uVec               The resulting U vector. (out-Double[3])
// vVec               The resulting V vector. (out-Double[3])
// wVec               The resulting W vector. (out-Double[3])
void PosVelToUUVW(double* pos, double* vel, double* uVec, double* vVec, double* wVec);


// Converts position and velocity vectors to U, V, W vectors. See the remarks section for details.
// pos                The position vector. (in-Double[3])
// vel                The velocity vector. (in-Double[3])
// uVec               The resulting U vector. (out-Double[3])
// vVec               The resulting V vector. (out-Double[3])
// wVec               The resulting W vector. (out-Double[3])
void PosVelToPTW(double* pos, double* vel, double* uVec, double* vVec, double* wVec);


// Solves Kepler's equation (M = E - e sin(E)) for the eccentric anomaly, E, by iteration.
// metricKep          The set of Keplerian elements for which to solve the equation. (in-Double[6])
// returns The eccentric anomaly.
double SolveKepEqtn(double* metricKep);


// Computes true anomaly from a set of Keplerian elements.
// metricKep          The set of Keplerian elements for which to compute true anomaly. (in-Double[6])
// returns The true anomaly in degrees.
double CompTrueAnomaly(double* metricKep);


// Converts mean motion N to semi-major axis A.
// n                  Mean motion N (revs/day). (in-Double)
// returns The semi-major axis A (km).
double NToA(double n);


// Converts semi-major axis A to mean motion N.
// a                  Semi-major axis A (km). (in-Double)
// returns The mean motion N (revs/day).
double AToN(double a);


// Converts Kozai mean motion to Brouwer mean motion.
// eccen              eccentricity (in-Double)
// incli              inclination (degrees) (in-Double)
// nKozai             Kozai mean motion (revs/day). (in-Double)
// returns Brouwer mean motion (revs/day).
double KozaiToBrouwer(double eccen, double incli, double nKozai);


// Converts Brouwer mean motion to Kozai mean motion.
// eccen              eccentricity (in-Double)
// incli              inclination (degrees) (in-Double)
// nBrouwer           Brouwer mean motion (revs/day). (in-Double)
// returns Kozai mean motion (revs/day).
double BrouwerToKozai(double eccen, double incli, double nBrouwer);


// Converts a set of osculating Keplerian elements to a set of mean Keplerian elements using method 9 algorithm.
// metricOscKep       The set of osculating Keplerian elements to be converted. (in-Double[6])
// metricMeanKep      The resulting set of mean Keplerian elements. (out-Double[6])
void KepOscToMean(double* metricOscKep, double* metricMeanKep);


// Converts an ECI position vector XYZ to geodetic latitude, longitude, and height.
// thetaG             ThetaG - Greenwich mean sidereal time (rad). (in-Double)
// metricPos          The ECI (TEME of Date) position vector (km) to be converted. (in-Double[3])
// metricLLH          The resulting geodetic north latitude (degree), east longitude(degree), and height (km). (out-Double[3])
void XYZToLLH(double thetaG, double* metricPos, double* metricLLH);


// Converts geodetic latitude, longitude, and height to an ECI position vector XYZ.
// thetaG             Theta - Greenwich mean sidereal time (rad). (in-Double)
// metricLLH          An array containing geodetic north latitude (degree), east longitude (degree), and height (km) to be converted. (in-Double[3])
// metricXYZ          The resulting ECI (TEME of Date) position vector (km). (out-Double[3])
void LLHToXYZ(double thetaG, double* metricLLH, double* metricXYZ);


// Converts EFG position and velocity vectors to ECI position and velocity vectors.
// thetaG             Theta - Greenwich mean sidereal time (rad). (in-Double)
// posEFG             The EFG position vector (km) to be converted. (in-Double[3])
// velEFG             The EFG velocity vector (km/s) to be converted. (in-Double[3])
// posECI             The resulting ECI (TEME of Date) position vector (km). (out-Double[3])
// velECI             The resulting ECI (TEME of Date) velocity vector (km/s). (out-Double[3])
void EFGToECI(double thetaG, double* posEFG, double* velEFG, double* posECI, double* velECI);


// Converts ECI position and velocity vectors to EFG position and velocity vectors.
// thetaG             Theta - Greenwich mean sidereal time (rad). (in-Double)
// posECI             The ECI (TEME of Date) position vector (km) to be converted. (in-Double[3])
// velECI             The ECI (TEME of Date) velocity vector (km/s) to be converted. (in-Double[3])
// posEFG             The resulting EFG position vector (km). (out-Double[3])
// velEFG             The resulting EFG velocity vector (km/s). (out-Double[3])
void ECIToEFG(double thetaG, double* posECI, double* velECI, double* posEFG, double* velEFG);


// Converts ECR position and velocity vectors to EFG position and velocity vectors.
// polarX             Polar motion X (arc-sec). (in-Double)
// polarY             Polar motion Y (arc-sec). (in-Double)
// posECR             The ECR position vector (km) to be converted. (in-Double[3])
// velECR             The ECR velocity vector (km/s) to be converted. (in-Double[3])
// posEFG             The resulting EFG position vector (km). (out-Double[3])
// velEFG             The resulting EFG velocity vector (km/s). (out-Double[3])
void ECRToEFG(double polarX, double polarY, double* posECR, double* velECR, double* posEFG, double* velEFG);


// Converts EFG position and velocity vectors to ECR position and velocity vectors.
// polarX             Polar motion X (arc-sec). (in-Double)
// polarY             Polar motion Y (arc-sec). (in-Double)
// posEFG             The EFG position vector (km) to be converted. (in-Double[3])
// velEFG             The EFG velocity vector (km/s) to be converted. (in-Double[3])
// posECR             The resulting ECR position vector (km). (out-Double[3])
// velECR             The resulting ECR velocity vector (km/s). (out-Double[3])
void EFGToECR(double polarX, double polarY, double* posEFG, double* velEFG, double* posECR, double* velECR);


// Converts an EFG position vector to geodetic latitude, longitude, and height.
// posEFG             The EFG position vector (km) to be converted. (in-Double[3])
// metricLLH          The resulting geodetic north latitude (degree), east longitude (degree), and height (km). (out-Double[3])
void EFGPosToLLH(double* posEFG, double* metricLLH);


// Converts geodetic latitude, longitude, and height to an EFG position vector.
// metricLLH          An Array containing the geodetic north latitude (degree), east longitude (degree), and height (km) to be converted. (in-Double[3])
// posEFG             The resulting EFG position vector (km). (out-Double[3])
void LLHToEFGPos(double* metricLLH, double* posEFG);


// Rotates position and velocity vectors from J2000 to coordinates of the specified date, expressed in ds50TAI.
// spectr             Specifies whether to run in SPECTR compatibility mode. A value of 1 means Yes. (in-Integer)
// nutationTerms      Nutation terms (4-106, 4:least accurate, 106:most acurate). (in-Integer)
// ds50TAI            The date to rotate to coordinates of, expressed in days since 1950, TAI. (in-Double)
// posJ2K             The position vector from J2000. (in-Double[3])
// velJ2K             The velocity vector from J2000. (in-Double[3])
// posDate            The resulting position vector in coordinates of date, ds50TAI. (out-Double[3])
// velDate            The resulting velocity vector in coordinates of date, ds50TAI. (out-Double[3])
void RotJ2KToDate(int spectr, int nutationTerms, double ds50TAI, double* posJ2K, double* velJ2K, double* posDate, double* velDate);


// Rotates position and velocity vectors from coordinates of date to J2000.
// spectr             Specifies whether to run in SPECTR compatibility mode. A value of 1 means Yes. (in-Integer)
// nutationTerms      Nutation terms (4-106, 4:least accurate, 106:most acurate). (in-Integer)
// ds50TAI            Time in days since 1950, TAI for which the coordinates of position and velocity vectors are currently expressed. (in-Double)
// posDate            The position vector from coordinates of Date. (in-Double[3])
// velDate            The velocity vector from coordinates of Date. (in-Double[3])
// posJ2K             The resulting position vector in coordinates of J2000. (out-Double[3])
// velJ2K             The resulting velocity vector in coordinates of J2000. (out-Double[3])
void RotDateToJ2K(int spectr, int nutationTerms, double ds50TAI, double* posDate, double* velDate, double* posJ2K, double* velJ2K);


// Computes the Sun and Moon position at the specified time.
// ds50ET             The number of days since 1950, ET for which to compute the sun and moon position. (in-Double)
// uvecSun            The resulting sun position unit vector. (out-Double[3])
// sunVecMag          The resulting magnitude of the sun position vector (km). (out-Double)
// uvecMoon           The resulting moon position unit vector. (out-Double[3])
// moonVecMag         The resulting magnitude of the moon position vector (km). (out-Double)
void CompSunMoonPos(double ds50ET, double* uvecSun, double* sunVecMag, double* uvecMoon, double* moonVecMag);


// Computes the Sun position at the specified time.
// ds50ET             The number of days since 1950, ET for which to compute the sun position. (in-Double)
// uvecSun            The resulting sun position unit vector. (out-Double[3])
// sunVecMag          The resulting magnitude of the sun position vector (km). (out-Double)
void CompSunPos(double ds50ET, double* uvecSun, double* sunVecMag);


// Computes the Moon position at the specified time.
// ds50ET             The number of days since 1950, ET for which to compute the moon position. (in-Double)
// uvecMoon           The resulting moon position unit vector. (out-Double[3])
// moonVecMag         The resulting magnitude of the moon position vector (km). (out-Double)
void CompMoonPos(double ds50ET, double* uvecMoon, double* moonVecMag);


// This function is intended for future use.  No information is currently available.
// xf_Conv            Index of the conversion function (in-Integer)
// frArr              The input array (in-Double[128])
// toArr              The resulting array (out-Double[128])
void AstroConvFrTo(int xf_Conv, double* frArr, double* toArr);


// Converts right ascension and declination to vector triad LAD in topocentric equatorial coordinate system.
// RA                 Right ascension (deg). (in-Double)
// dec                Declination (deg). (in-Double)
// L                  The resulting unit vector from the station to the satellite (referred to the equatorial coordinate system axis). (out-Double[3])
// A_Tilde            The resulting unit vector perpendicular to the hour circle passing through the satellite, in the direction of increasing RA. (out-Double[3])
// D_Tilde            The resulting unit vector perpendicular to L and is directed toward the north, in the plane of the hour circle. (out-Double[3])
void RADecToLAD(double RA, double dec, double* L, double* A_Tilde, double* D_Tilde);


// Converts azimuth and elevation to vector triad LAD in topocentric horizontal coordinate system.
// az                 Input azimuth (deg). (in-Double)
// el                 Input elevation angle (deg). (in-Double)
// Lh                 The resulting unit vector from the station to the satellite (referred to the horizon coordinate system axis). (out-Double[3])
// Ah                 The resulting unit vector perpendicular to the hour circle passing through the satellite, in the direction of increasing Az. (out-Double[3])
// Dh                 The resulting unit vector perpendicular to L and is directed toward the zenith, in the plane of the hour circle. (out-Double[3])
void AzElToLAD(double az, double el, double* Lh, double* Ah, double* Dh);


// Converts satellite ECI position/velocity vectors and sensor location to topocentric components.
// theta              Theta - local sidereal time(rad). (in-Double)
// lat                Station's astronomical latitude (deg). (+N) (-S) (in-Double)
// senPos             Sensor position in ECI (km). (in-Double[3])
// satPos             Satellite position in ECI (km). (in-Double[3])
// satVel             Satellite velocity in ECI (km/s). (in-Double[3])
// xa_topo            An array that stores the resulting topocentric components. (out-Double[10])
void ECIToTopoComps(double theta, double lat, double* senPos, double* satPos, double* satVel, double* xa_topo);


// Converts right ascension and declination in the topocentric reference frame to Azimuth/Elevation in the local horizon reference frame.
// thetaG             Theta - Greenwich mean sidereal time (rad). (in-Double)
// lat                Station's astronomical latitude (deg). (+N) (-S) (in-Double)
// lon                Station's astronomical longitude (deg). (+E) (-W) (in-Double)
// RA                 Right ascension (deg) (in-Double)
// dec                Declination (deg) (in-Double)
// az                 Azimuth (deg) (out-Double)
// el                 Elevation (deg) (out-Double)
void RaDecToAzEl(double thetaG, double lat, double lon, double RA, double dec, double* az, double* el);


// Converts Azimuth/Elevation in the local horizon reference frame to Right ascension/Declination in the topocentric reference frame
// thetaG             Theta - Greenwich mean sidereal time (rad). (in-Double)
// lat                Station's astronomical latitude (deg). (+N) (-S) (in-Double)
// lon                Station's astronomical longitude (deg). (+E) (-W) (in-Double)
// az                 Azimuth (deg) (in-Double)
// el                 Elevation (deg) (in-Double)
// RA                 Right ascension (deg) (out-Double)
// dec                Declination (deg) (out-Double)
void AzElToRaDec(double thetaG, double lat, double lon, double az, double el, double* RA, double* dec);


// Converts full state RAE (range, az, el, and their rates) to full state ECI (position and velocity)
// theta              Theta - local sidereal time(rad). (in-Double)
// astroLat           Astronomical latitude (ded). (in-Double)
// xa_rae             An array contains input data. (in-Double[6])
// senPos             Sensor position in ECI (km). (in-Double[3])
// satPos             Satellite position in ECI (km). (out-Double[3])
// satVel             Satellite velocity in ECI (km/s). (out-Double[3])
void RAEToECI(double theta, double astroLat, double* xa_rae, double* senPos, double* satPos, double* satVel);


// Computes initial values for the SGP drag term NDOT and the SGP4 drag term BSTAR based upon eccentricity and semi-major axis.
// semiMajorAxis      Semi-major axis (km). (in-Double)
// eccen              Eccentricity (unitless). (in-Double)
// ndot               Ndot (revs/day^2). (out-Double)
// bstar              Bstar (1/earth radii). (out-Double)
void GetInitialDrag(double semiMajorAxis, double eccen, double* ndot, double* bstar);


// Converts covariance matrix PTW to UVW.
// pos                The input position vector (km). (in-Double[3])
// vel                The input velocity vector (km/s). (in-Double[3])
// ptwCovMtx          The PTW covariance matrix to be converted. (in-Double[6, 6])
// uvwCovMtx          The resulting UVW covariance matrix. (out-Double[6, 6])
void CovMtxPTWToUVW(double* pos, double* vel, double* ptwCovMtx, double* uvwCovMtx);


// Converts covariance matrix UVW to PTW.
// pos                The input position vector (km). (in-Double[3])
// vel                The input velocity vector (km/s). (in-Double[3])
// uvwCovMtx          The UVW covariance matrix to be converted. (in-Double[6, 6])
// ptwCovMtx          The resulting PTW covariance matrix. (out-Double[6, 6])
void CovMtxUVWToPTW(double* pos, double* vel, double* uvwCovMtx, double* ptwCovMtx);


// Computes Earth/Sensor/Earth Limb and Earth/Sensor/Satellite angles.
// earthLimb          Earth limb distance (km). (in-Double)
// satECI             Satellite position in ECI (km). (in-Double[3])
// senECI             Sensor position in ECI (km). (in-Double[3])
// earthSenLimb       The resulting earth/sensor/limb angle (deg). (out-Double)
// earthSenSat        The resulting earth/sensor/sat angle (deg). (out-Double)
// satEarthSen        The resulting sat/earth/sensor angle (deg). (out-Double)
void EarthObstructionAngles(double earthLimb, double* satECI, double* senECI, double* earthSenLimb, double* earthSenSat, double* satEarthSen);


// Determines if a point in space is sunlit at the input time ds50ET
// ds50ET             The number of days since 1950, ET for which to determine if the point is sunlit. (in-Double)
// ptEci              a position in ECI (km). (in-Double[3])
// returns 0=no, the specified point isn't sunlit, 1=yes, the specified point is sunlit
int IsPointSunlit(double ds50ET, double* ptEci);


// Rotates Right Ascension and Declination to specified epoch
// nutationTerms      Nutation terms (4-106, 4:least accurate, 106:most acurate). (in-Integer)
// dir                1: TEME of Date To MEME year of equinox, 2: MEME year of equinox to TEME of Date (in-Integer)
// ds50UTCIn          Origin time in days since 1950 UTC (in-Double)
// RAIn               Input right ascension (deg) (in-Double)
// declIn             Input declination (deg) (in-Double)
// ds50UTCOut         Destination time in days since 1950 UTC (in-Double)
// RAOut              Output right ascension (deg) (out-Double)
// declOut            Output declination (deg) (out-Double)
void RotRADecl(int nutationTerms, int dir, double ds50UTCIn, double RAIn, double declIn, double ds50UTCOut, double* RAOut, double* declOut);


// Rotates Right Ascension and Declination from TEME of Date to MEME of the specified year of equinox
// nutationTerms      Nutation terms (4-106, 4:least accurate, 106:most acurate). (in-Integer)
// yrOfEqnx           Year of equinox (=1: 0 Jan of input year, =2: J2000, =3: B1950) (in-Integer)
// ds50UTCIn          Input time in days since 1950 UTC (in-Double)
// RAIn               Input right ascension (deg) (in-Double)
// declIn             Input declination (deg) (in-Double)
// RAOut              Output right ascension (deg) (out-Double)
// declOut            Output declination (deg) (out-Double)
// returns 0 if the rotation was successful, non-0 if there is an error
int RotRADec_DateToEqnx(int nutationTerms, int yrOfEqnx, double ds50UTCIn, double RAIn, double declIn, double* RAOut, double* declOut);


// Rotates Right Ascension and Declination from MEME of the specified year of equinox to TEME of Date
// nutationTerms      Nutation terms (4-106, 4:least accurate, 106:most acurate). (in-Integer)
// yrOfEqnx           Year of equinox (=1: 0 Jan of input year, =2: J2000, =3: B1950) (in-Integer)
// ds50UTCIn          Input time in days since 1950 UTC (in-Double)
// RAIn               Input right ascension (deg) (in-Double)
// declIn             Input declination (deg) (in-Double)
// RAOut              Output right ascension (deg) (out-Double)
// declOut            Output declination (deg) (out-Double)
// returns 0 if the rotation was successful, non-0 if there is an error
int RotRADec_EqnxToDate(int nutationTerms, int yrOfEqnx, double ds50UTCIn, double RAIn, double declIn, double* RAOut, double* declOut);

// Index of Keplerian elements
static const int  
   XA_KEP_A     =   0,       // semi-major axis (km)
   XA_KEP_E     =   1,       // eccentricity (unitless)
   XA_KEP_INCLI =   2,       // inclination (deg)
   XA_KEP_MA    =   3,       // mean anomaly (deg)
   XA_KEP_NODE  =   4,       // right ascension of the asending node (deg)
   XA_KEP_OMEGA =   5,       // argument of perigee (deg)
   XA_KEP_SIZE  =  6;   
   
// Index of classical elements
static const int  
   XA_CLS_N     =   0,       // N mean motion (revs/day)
   XA_CLS_E     =   1,       // eccentricity (unitless)
   XA_CLS_INCLI =   2,       // inclination (deg)
   XA_CLS_MA    =   3,       // mean anomaly (deg)
   XA_CLS_NODE  =   4,       // right ascension of the asending node (deg)
   XA_CLS_OMEGA =   5,       // argument of perigee (deg)
   XA_CLS_SIZE  =   6;

// Index of equinoctial elements
static const int  
   XA_EQNX_AF   =   0,       // Af (unitless) 
   XA_EQNX_AG   =   1,       // Ag (unitless)
   XA_EQNX_CHI  =   2,       // Chi (unitless)
   XA_EQNX_PSI  =   3,       // Psi (unitless)
   XA_EQNX_L    =   4,       // L mean longitude (deg)
   XA_EQNX_N    =   5,       // N mean motion (revs/day)
   XA_EQNX_SIZE =   6;
   
// Indexes of AstroConvFrTo
static const int  
   XF_CONV_SGP42SGP = 101;        // SGP4 (A, E, Incli, BStar) to SGP (Ndot, N2Dot)


// Indexes for topocentric components
static const int  
   XA_TOPO_RA    = 0,         // Right ascension (deg)
   XA_TOPO_DEC   = 1,         // Declination (deg)
   XA_TOPO_AZ    = 2,         // Azimuth (deg)
   XA_TOPO_EL    = 3,         // Elevation (deg)
   XA_TOPO_RANGE = 4,         // Range (km)
   XA_TOPO_RADOT = 5,         // Right ascension dot (deg/s)
   XA_TOPO_DECDOT= 6,         // Declincation dot (deg/s)
   XA_TOPO_AZDOT = 7,         // Azimuth dot (deg/s)
   XA_TOPO_ELDOT = 8,         // Elevation dot (deg/s)
   XA_TOPO_RANGEDOT = 9,      // Range dot (km/s)   
   XA_TOPO_SIZE  = 10;   
   
   
// Indexes for RAE components
static const int  
   XA_RAE_RANGE   = 0,        // Range (km)
   XA_RAE_AZ      = 1,        // Azimuth (deg)
   XA_RAE_EL      = 2,        // Elevation (deg)
   XA_RAE_RANGEDOT= 3,        // Range dot (km/s)   
   XA_RAE_AZDOT   = 4,        // Azimuth dot (deg/s)
   XA_RAE_ELDOT   = 5,        // Elevation dot (deg/s)
   XA_RAE_SIZE    = 6;
   
   
// Year of Equinox indicator
static const int  
   YROFEQNX_OBTIME = 0,       // Date of observation
   YROFEQNX_CURR   = 1,       // 0 Jan of Date
   YROFEQNX_2000   = 2,       // J2000
   YROFEQNX_1950   = 3;       // B1950
   



// ========================= End of auto generated code ==========================
