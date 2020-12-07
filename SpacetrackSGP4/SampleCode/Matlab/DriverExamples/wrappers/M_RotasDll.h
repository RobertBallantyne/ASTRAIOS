// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// Initializes Rotas DLL for use in the program
// apPtr              The handle that was returned from DllMainInit() (in-Long)
// returns 0 if the Rotas dll is initialized successfully, non-0 if there is an error
int RotasInit(__int64 apPtr);


// Returns information about the current version of Rotas DLL. 
// infoStr            A string to hold the information about Rotas.dll (out-Character[128])
void RotasGetInfo(char* infoStr);


// Loads Rotas-related parameters from an input text file
// rotasInputFile     The name of the file containing Rotas-related parameters (in-Character[512])
// returns 0 if the input file is read successfully, non-0 if there is an error
int RotasLoadFile(char* rotasInputFile);


// Loads Rotas control parameters and all Rotas related data (environment, time, elsets, sensors, obs) from an input text file
// rotasInputFile     The name of the file containing Rotas control parameters and all Rotas related data (in-Character[512])
// returns 0 if the input file is read successfully, non-0 if there is an error
int RotasLoadFileAll(char* rotasInputFile);


// Loads a single Rotas-typed card
// card               Rotas-type input card (in-Character[512])
// returns 0 if the input card is read successfully, non-0 if there is an error
int RotasLoadCard(char* card);


// Saves current Rotas settings to a file
// rotasFile          The name of the file in which to save the settings (in-Character[512])
// saveMode           Specifies whether to create a new file or append to an existing one (0 = create, 1= append) (in-Integer)
// saveForm           Specifies the mode in which to save the file (0 = text format, 1 = not yet implemented, reserved for future) (in-Integer)
// returns 0 if the data is successfully saved to the file, non-0 if there is an error
int RotasSaveFile(char* rotasFile, int saveMode, int saveForm);


// Builds and returns the Rotas P-Card from the current Rotas settings
// rotasPCard         The resulting Rotas P-Card string (out-Character[512])
void RotasGetPCard(char* rotasPCard);


// Retrieves all Rotas control parameters with a single function call
// rotasMode          Rotas processing mode: TAG=verify ob tab (default), FTAG=force assoc vs all input elsets, ALLEL=find the best # assoc elsets (out-Character[5])
// grossBeta          gross beta threshold (deg) (default=2.0) (out-Double)
// betaLimit          ASTAT 0 beta limit (deg) (default=0.05) (out-Double)
// deltaTLimit        ASTAT 0 delta-t limit (min) (default=0.05) (out-Double)
// deltaHLimit        ASTAT 0 delta-height limit (km) (default=10) (out-Double)
// astat2Mult         ASTAT 2 multiplier (default=4) (out-Integer)
// prtFlag            Residual print flag: 1=print all, 2=print ASTAT 0/1, 3=print no residuals, 4=print ASTAT 0/1/2 (out-Integer)
// retagFlag          Retag flag: 0=don't retag (default), 1=retag ASTAT 0/1 to B3, 2=retag ASTAT 0/1 to TTY, 3=retag ASTAT 0/1/2 to B3 (out-Integer)
// ltcFlag            Type 5 observation light-time correct flag: 0=don't apply LTC, 1=apply LTC analytically, 2=apply LTC exactly (out-Integer)
// maxNumAssoc        Max number of associations per ob (ALLEL mode only) (out-Integer)
// debiasFlag         Debias observation flag: 0=don't apply debias, 1=debias ob by applying sensor's bias data (out-Integer)
// diagMode           Diagnostic print flag (out-Integer)
// covPrtFlag         Covariance flag: 1=Propagate covariance and compute covariance matrix (covariance matrix must be available) (out-Integer)
// isTrackMode        Track mode: 1=use track processing (each track is treated as a single entity) (out-Integer)
// remRetagObs        Retagged obs are removed from further association (out-Integer)
// extArr             For future use (out-Double[128])
void RotasGetPAll(char* rotasMode, double* grossBeta, double* betaLimit, double* deltaTLimit, double* deltaHLimit, int* astat2Mult, int* prtFlag, int* retagFlag, int* ltcFlag, int* maxNumAssoc, int* debiasFlag, int* diagMode, int* covPrtFlag, int* isTrackMode, int* remRetagObs, double* extArr);


// Sets all Rotas control parameters with a single function call
// rotasMode          Rotas processing mode: TAG=verify ob tab (default), FTAG=force assoc vs all input elsets, ALLEL=find the best # assoc (in-Character[5])
// grossBeta          gross beta threshold (deg) (default=2.0) (in-Double)
// betaLimit          ASTAT 0 beta limit (deg) (default=0.05) (in-Double)
// deltaTLimit        ASTAT 0 delta-t limit (min) (default=0.05) (in-Double)
// deltaHLimit        ASTAT 0 delta-height limit (km) (default=10) (in-Double)
// astat2Mult         ASTAT 2 multiplier (default=4) (in-Integer)
// prtFlag            Residual print flag: 1=print all, 2=print ASTAT 0/1, 3=print no residuals, 4=print ASTAT 0/1/2 (in-Integer)
// retagFlag          Retag flag: 0=don't retag (default), 1=retag ASTAT 0/1 to B3, 2=retag ASTAT 0/1 to TTY, 3=retag ASTAT 0/1/2 to B3 (in-Integer)
// ltcFlag            Type 5 observation light-time correct flag: 0=don't apply LTC, 1=apply LTC analytically, 2=apply LTC exactly (in-Integer)
// maxNumAssoc        Max number of associations per ob (ALLEL mode only) (in-Integer)
// debiasFlag         Debias observation flag: 0=don't apply debias, 1=debias ob by applying sensor's bias data (in-Integer)
// diagMode           Diagnostic print flag (in-Integer)
// covPrtFlag         Covariance flag: 1=Propagate covariance and compute covariance matrix (covariance matrix must be available) (in-Integer)
// isTrackMode        Track mode: 1=use track processing (each track is treated as a single entity) (in-Integer)
// remRetagObs        Retagged obs are removed from further association (in-Integer)
// extArr             For future use (in-Double[128])
void RotasSetPAll(char* rotasMode, double grossBeta, double betaLimit, double deltaTLimit, double deltaHLimit, int astat2Mult, int prtFlag, int retagFlag, int ltcFlag, int maxNumAssoc, int debiasFlag, int diagMode, int covPrtFlag, int isTrackMode, int remRetagObs, double* extArr);


// Retrieves the value of a specified Rotas control parameter (P-card field)
// xf_RP              Predefined number specifying which Rotas control parameter  to retrieve (in-Integer)
// retVal             A string to hold the value of the requested Rotas parameter (out-Character[512])
void RotasGetPField(int xf_RP, char* retVal);


//  Sets the value of a specified Rotas control parameter (P-card field)
// xf_RP              Predefined number specifying which Rotas control parameter to set (in-Integer)
// valueStr           The new value of the specified field, expressed as a string (in-Character[512])
void RotasSetPField(int xf_RP, char* valueStr);


// Gets ASTAT 1 association multipliers
// assocMultp         ASTAT 1 association multiplier array (out-Integer[12])
void RotasGetAssocMultipliers(int* assocMultp);


// Sets ASTAT 1 association multipliers
// assocMultp         ASTAT 1 association multiplier array (in-Integer[12])
void RotasSetAssocMultipliers(int* assocMultp);


// Resets all Rotas control parameters back to their default values
void RotasResetAll();


// Determines if the observation/satellite pair can possibly have an association
// obsKey             The obervation's unique key (in-Long)
// satKey             The satellite's unique key (in-Long)
// returns 0 if the observation/satellite pair doesn't have an association, 1 if the pair has an association
int RotasHasASTAT(__int64 obsKey, __int64 satKey);


// Computes residuals for one observation against one satellite
// obsKey             The observation's unique key (in-Long)
// satKey             The satellite's unique key (in-Long)
// xa_ObsRes          The resulting array of obs residuals, see XA_OBSRES_? for array arrangement (out-Double[100])
// satElts            satellite state in ECI/TEME of Date: position (1st-3rd), velocity (4th-6th); satellite LLH (7th-9th) (out-Double[9])
// obElts             observation state in ECI/TEME of Date: position (1st-3rd), velocity (4th-6th); observation LLH (7th-9th) (out-Double[9])
// returns 0 if successful, non-0 if there is an error
int RotasComputeObsResiduals(__int64 obsKey, __int64 satKey, double* xa_ObsRes, double* satElts, double* obElts);


// Computes residuals for a track of observations against one satellite. Each track is treated as a single entity
// obsKeys            The input array of obsKeys sorted in ascending order of sensor, satno, obstype, time, elev (in-Long[*])
// trackStartIdx      The start index of the first obs of the track (in-Integer)
// trackLength        The input track length (in-Integer)
// satKey             The satellite's unique key (in-Long)
// xa_ObsRes          The resulting array of obs residuals, see XA_OBSRES_? for array arrangement (out-Double[100])
// trackObsKeys       The 3 obsKeys of the 3 obs that were chosen to represent the track (out-Long[3])
// b3ObsCard          The resulting B3-card created by IOMOD to represent the whole track (out-Character[512])
// satElts            satellite state in ECI/TEME of Date: position (1st-3rd), velocity (4th-6th); satellite LLH (8th-9th) (out-Double[9])
// obElts             observation state in ECI/TEME of Date: position (1st-3rd), velocity (4th-6th); observation LLH (8th-9th) (out-Double[9])
// returns 0 if successful, non-0 if there is an error
int RotasComputeTrackResiduals(__int64* obsKeys, int trackStartIdx, int trackLength, __int64 satKey, double* xa_ObsRes, __int64* trackObsKeys, char* b3ObsCard, double* satElts, double* obElts);


// Computes residuals for one observation against one satellite directly (no need to load ob and propagate satellite)
// obDataArr          The array storing observation data: position (1st-3rd), velocity (4th-6th) (in-Double[16])
// satDataArr         The array storing satellite data: position (1st-3rd), velocity (4th-6th) (in-Double[16])
// xa_ObsRes          The resulting array of obs residuals, see XA_OBSRES_? for array arrangement (out-Double[100])
// returns 0 if successful, non-0 if there is an error
int RotasCompObResDirect(double* obDataArr, double* satDataArr, double* xa_ObsRes);


// Returns the name of the retag obs file
// retagObsFile       The resulting retag file name (out-Character[512])
void RotasGetRetagObsFile(char* retagObsFile);


// Sets the file name of the retag obs file
// retagObsFile       The retag file name (in-Character[512])
void RotasSetRetagObsFile(char* retagObsFile);

// Indexes of Rotas Control parameter fields (Rotas P-Card)
static const int  
   XF_RP_MODE       =  1,     // Rotas processing mode
   XF_RP_GROSSBETA  =  2,     // Gross Beta limit (deg)
   XF_RP_BETALIM    =  3,     // ASTAT 0 Beta limit (deg)
   XF_RP_DELTATLIM  =  4,     // ASTAT 0 delta-t limit (min)
   XF_RP_DELTAHLIM  =  5,     // ASTAT 0 delta-height limit (km)
   XF_RP_ASTAT2MULT =  6,     // ASTAT 2 multiplier
   XF_RP_PRTFLAG    =  7,     // Residual print flag
   XF_RP_RETAGFLAG  =  8,     // Retag ASTAT 1 ob flag
   XF_RP_LTC        =  9,     // Light-time correction flag
   XF_RP_NUMASSOC   = 10,     // Maximum number of ALLEL assoc's to compute
   XF_RP_DIAGNOSTIC = 11,     // Diagnostic print flag
   XF_RP_PRTCOV     = 12,     // Covariance print flag
   XF_RP_TRACKFLAG  = 13,     // Perform track processing
   XF_RP_REMRETAG   = 14,     // Retagged ob are removed from further association
   XF_RP_DEBIAS     = 15,     // Debias ob flag
   XF_RP_RESCOMPMETH= 16;     // Residual computation method: 1=DELTA/427M, 2=SPADOC-4(default)



// Residual computation methods
static const int  
   RESCOMPMETH_DELTA427M = 1,   // Delta/427M method
   RESCOMPMETH_SPADOC4   = 2;   // Spadoc 4 method

// PV Ob data
static const int  
   XA_OBPV_POSX     =  0,      // ob ECI position X (km) in TEME of Date
   XA_OBPV_POSY     =  1,      // ob ECI position Y (km) in TEME of Date
   XA_OBPV_POSZ     =  2,      // ob ECI position Z (km) in TEME of Date
   XA_OBPV_VELX     =  3,      // ob ECI velocity X (km/sec) in TEME of Date
   XA_OBPV_VELY     =  4,      // ob ECI velocity Y (km/sec) in TEME of Date
   XA_OBPV_VELZ     =  5,      // ob ECI velocity Z (km/sec) in TEME of Date
   XA_OBPV_TIME     =  6,      // ob time in days since 1950, UTC
   
   XA_OBPV_END      = 15,      // the last available index
   XA_OBPV_SIZE     = 16;

// Satellite state data
static const int  
   XA_SATPV_POSX    =  0,      // satellite ECI position X (km) in TEME of Date
   XA_SATPV_POSY    =  1,      // satellite ECI position Y (km) in TEME of Date
   XA_SATPV_POSZ    =  2,      // satellite ECI position Z (km) in TEME of Date
   XA_SATPV_VELX    =  3,      // satellite ECI velocity X (km/sec) in TEME of Date
   XA_SATPV_VELY    =  4,      // satellite ECI velocity Y (km/sec) in TEME of Date
   XA_SATPV_VELZ    =  5,      // satellite ECI velocity Z (km/sec) in TEME of Date
   
   XA_SATPV_END     = 15,      // the last available index
   XA_SATPV_SIZE    = 16;

   
// Obs residual data field indexes
static const int   
   XA_OBSRES_AZ     =  0,           // Azimuth residual (deg)
   XA_OBSRES_EL     =  1,           // Elevation residual (deg)
   XA_OBSRES_RANGE  =  2,           // Range residual (km)
   XA_OBSRES_HEIGHT =  3,           // Height residual (deg)
   XA_OBSRES_BETA   =  4,           // Beta residual (deg)
   XA_OBSRES_DELTAT =  5,           // Delta T residual (min)
   XA_OBSRES_VMAG   =  6,           // Vector magnitude (km)
   XA_OBSRES_AGE    =  7,           // Time since epoch (days)
   XA_OBSRES_SU     =  8,           // True argument of latitude (deg)
   XA_OBSRES_REVNUM =  9,           // Revolution number  
   XA_OBSRES_RNGRATE= 10,           // Range rate residual (km/sec)
   XA_OBSRES_ASTAT  = 11,           // observation ASTAT
   XA_OBSRES_OBSTYPE= 12,           // observation type
   XA_OBSRES_SATANOM= 13,           // satellite true anomaly (deg)
   XA_OBSRES_SATELEV= 14,           // satellite elevation (deg)
   XA_OBSRES_SATCAT = 15,           // satellite maintenance category
   XA_OBSRES_OBSTIME= 16,           // obs time in ds50UTC
   XA_OBSRES_OBSAZ  = 17,           // obs azimuth (deg)
   XA_OBSRES_OBSEL  = 18,           // obs elevation (deg)
   XA_OBSRES_VELANG = 19,           // Velocity angle residual (deg)
   XA_OBSRES_ANGMOM = 20,           // Angular momentum residual (deg)
   XA_OBSRES_RA     = 21,           // Right ascension residual (deg) (for ob types 5, 9, 19)
   XA_OBSRES_DEC    = 22,           // Declination residual (deg) (for ob types 5, 9, 19)
   XA_OBSRES_POSX   = 23,           // Delta X position (km)
   XA_OBSRES_POSY   = 24,           // Delta Y position (km)
   XA_OBSRES_POSZ   = 25,           // Delta Z position (km)
   XA_OBSRES_VELX   = 26,           // Delta X velocity (km/sec)
   XA_OBSRES_VELY   = 27,           // Delta Y velocity (km/sec)
   XA_OBSRES_VELZ   = 28,           // Delta Z velocity (km/sec)
   XA_OBSRES_OBSRNG = 29,           // Angle only obs computed range (km)

   XA_OBSRES_OBSRA  = 30,           // obs right ascension (deg)
   XA_OBSRES_OBSDEC = 31,           // obs declination (deg)
   XA_OBSRES_LON    = 32,           // Delta east longitude (deg) 
   
   
   XA_OBSRES_SIZE   =100;           

   
   




// ========================= End of auto generated code ==========================
