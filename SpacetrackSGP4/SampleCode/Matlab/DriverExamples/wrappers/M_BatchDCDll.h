// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// Initializes BatchDC DLL for use in the program
// apPtr              The handle that was returned from DllMainInit() (in-Long)
// returns 0 if BatchDC.dll is initialized successfully, non-0 if there is an error
int BatchDCInit(__int64 apPtr);


// Returns information about the current version of BatchDC DLL. 
// infoStr            A string to hold the information about BatchDC.dll (out-Character[128])
void BatchDCGetInfo(char* infoStr);


// Read/Load BatchDC input data from an input file
// batchDCInputFile   The name of the file containing BatchDC-related parameters (in-Character[512])
// returns 0 if the input file is read successfully, non-0 if there is an error
int BatchDCLoadFile(char* batchDCInputFile);


// Loads BatchDC control parameters and all BatchDC related data (environment, time, elsets, sensors) from an input text file
// batchDCInputFile   The name of the file containing BatchDC and BatchDC-related parameters (in-Character[512])
// returns 0 if the input file is read successfully, non-0 if there is an error
int BatchDCLoadFileAll(char* batchDCInputFile);


// Read/Load BatchDC-typed input data from an input card
// card               BatchDC-type input card (in-Character[512])
// returns 0 if the input card is read successfully, non-0 if there is an error
int BatchDCLoadCard(char* card);


// Builds and returns the DC parameter card (1P-Card) from the current DC settings
// dcPCard            the resulting DC 1P-Card (out-Character[512])
void BatchDCGetPCard(char* dcPCard);


// Saves any currently loaded BatchDC-related settings to a file
// batchDCFile        The name of the file in which to save the settings (in-Character[512])
// saveMode           Specifies whether to create a new file or append to an existing one (0 = create, 1= append) (in-Integer)
// saveForm           Specifies the mode in which to save the file (0 = text format, 1 = not yet implemented, reserved for future) (in-Integer)
// returns 0 if the data is successfully saved to the file, non-0 if there is an error
int BatchDCSaveFile(char* batchDCFile, int saveMode, int saveForm);


// Gets BatchDC parameter data (P Card) - all fields
// xai_ctrl           Array contains integer BatchDC parameters (out-Integer[256])
// xar_ctrl           Array contains double BatchDC parameters (out-Double[256])
// xas_ctrl           BatchDC parameters in character string format - not yet used (out-Character[512])
void BatchDCGetParams(int* xai_ctrl, double* xar_ctrl, char* xas_ctrl);


// Sets BatchDC parameter data (P Card) - all fields
// xai_ctrl           Array contains integer BatchDC parameters (in-Integer[256])
// xar_ctrl           Array contains double BatchDC parameters (in-Double[256])
// xas_ctrl           BatchDC parameters in character string format - not yet used (in-Character[512])
void BatchDCSetParams(int* xai_ctrl, double* xar_ctrl, char* xas_ctrl);


// Initializes DC parameters for the satellite
// satKey             The satellite's unique key (in-Long)
// numObs             Actual number of obs being selected to be used in the DC (out-Integer)
// obsKeys            The array in which to store the obsKeys (out-Long[*])
// xai_dcElts         Array of integers containing resulting BatchDC data (out-Integer[256])
// xar_dcElts         Array of doubles containing resulting BatchDC data (out-Double[256])
// xas_dcElts         String containing resulting BatchDC data - not yet used (out-Character[512])
// returns 0 if successful, non-0 if there is an error
int BatchDCInitSat(__int64 satKey, int* numObs, __int64* obsKeys, int* xai_dcElts, double* xar_dcElts, char* xas_dcElts);


// Performs batch-least-square differential corrections to the specified satellite and
// return the corrected elements and related data - using all loaded obs
// satKey             The satellite's unique key (in-Long)
// xai_dcElts         Array of integers containing resulting BatchDC data (out-Integer[256])
// xar_dcElts         Array of doubles containing resulting BatchDC data (out-Double[256])
// xas_dcElts         String containing resulting BatchDC data  - not yet used (out-Character[512])
// returns 0 if successful, 1: dc fails, best elset returned, 2: dc fails, no eleset returned
int BatchDCSolve(__int64 satKey, int* xai_dcElts, double* xar_dcElts, char* xas_dcElts);


// Performs batch-least-square differential corrections to the specified satellite and
// return the corrected elements and related data - using only the provided obsKeys (not all loaded obs)
// satKey             The satellite's unique key (in-Long)
// obsKeys            The array of obs keys that wil be used in the DC (in-Long[*])
// numObs             The size of the obsKeys array (in-Integer)
// xai_dcElts         Array of integers containing resulting BatchDC data (out-Integer[256])
// xar_dcElts         Array of doubles containing resulting BatchDC data (out-Double[256])
// xas_dcElts         String containing resulting BatchDC data  - not yet used (out-Character[512])
// returns 0 if successful, 1: dc fails, best elset returned, 2: dc fails, no eleset returned
int BatchDCSolveSelObs(__int64 satKey, __int64* obsKeys, int numObs, int* xai_dcElts, double* xar_dcElts, char* xas_dcElts);


// Removes a satellite, represented by the satKey, from BatchDC's memory
// satKey             The unique key of the satellite to be removed (in-Long)
// returns 0 if the satellite is removed successfully, non-0 if there is an error
int BatchDCRemoveSat(__int64 satKey);


// Iterates DC for the satellite
// satKey             The satellite's unique key (in-Long)
// obsResArr          Obs residual array (out-Double[*, 100])
// obsRejFlags        Obs rejection flag array (out-Integer[*, 32])
// xai_dcElts         Array of integers containing resulting BatchDC data (out-Integer[256])
// xar_dcElts         Array of doubles containing resulting BatchDC data (out-Double[256])
// xas_dcElts         String containing resulting BatchDC data  - not yet used (out-Character[512])
// returns iterating code: 0=successful, 1=has error, 2=iterating, 3=diverged\try to recover
int BatchDCIterate(__int64 satKey, double* obsResArr, int* obsRejFlags, int* xai_dcElts, double* xar_dcElts, char* xas_dcElts);


// Returns a concatenated string representation of a VCM generated by a successful DC
// satKey             The satellite's unique key (in-Long)
// vcmLines           The resulting concatenated string representation of the VCM, (out-Character[4000])
// returns 0 if successful, non-0 on error
int BatchDCGetVcm(__int64 satKey, char* vcmLines);


// Returns the full file name of the output SP Vector file that was specified using "SPVOUT = " 
// in the main input file or using the BatchDCSetSpVOutFileName() function call
// spVOutFile         The output file that stores SP output message (out-Character[512])
void BatchDCGetSpVOut(char* spVOutFile);


// Sets the full file name of the SP Vector output file which will be used to store the generated SP vector data
// spVOutFile         The output file that stores SP vector output (VCM message) (in-Character[512])
void BatchDCSetSpVOut(char* spVOutFile);


// Resets all BatchDC control parameters back to their default values and empties the DC binary tree (objects created by BatchDCInitSat)
void BatchDCResetAll();


// Returns DC acceptance criteria data for the specified satellite
// satKey             The satellite's unique key (in-Long)
// xa_ac              acceptance criteria values in an array, see xa_ac for array arrangement (out-Double[64])
// returns 0 if the acceptance criteria is successfully returned, non-0 if there is an error
int BatchDCGetAccptCrit(__int64 satKey, double* xa_ac);


// Performs batch-least-square differential corrections to the specified satellite (VCM/SPVEC) and
// returns the corrected SGP4/SGP4-XP elements and related data
// satKey             The satellite's unique key (in-Long)
// xa_egpCtrl         Array containing settings for SpToEGP conversion, see XA_EGPCTRL_? for array arrangement (in-Double[64])
// xai_dcElts         Array of integers containing resulting BatchDC data (out-Integer[256])
// xar_dcElts         Array of doubles containing resulting BatchDC data (out-Double[256])
// xas_dcElts         String containing resulting BatchDC data - not yet used (out-Character[512])
// returns 0 if successful, 1: dc fails, best elset returned, 2: dc fails, no eleset returned
int SpToEGP(__int64 satKey, double* xa_egpCtrl, int* xai_dcElts, double* xar_dcElts, char* xas_dcElts);


// Performs batch-least-square differential corrections to the specified satellite (VCM/SPVEC) and
// returns the corrected elements SGP4/SGP4-XP in form of a TLE
// satKey             The satellite's unique key (in-Long)
// xa_egpCtrl         Array containing settings for SpToEGP conversion, see XA_EGPCTRL_? for array arrangement (in-Double[64])
// line1              Returned first line of a TLE. (out-Character[512])
// line2              Returned second line of a TLE (out-Character[512])
// returns 0 if successful, 1: dc fails, best elset returned, 2: dc fails, no eleset returned
int SpToTle(__int64 satKey, double* xa_egpCtrl, char* line1, char* line2);

// DC setting parameters

#define MAX_PARAMS   256 


// DC print options
static const int  
   DC_PRINT_FIRSTBEST   =  0,   // print first and last iteration
   DC_PRINT_ALLPASS     =  1,   // print every pass and summary
   DC_PRINT_SUMONLY     =  2,   // print summary only
   DC_PRINT_ELTONLY     =  3,   // print output elemenets only 
   DC_PRINT_NONE        =  4;   // do not print anything 
   
// Iteration summary options
static const int     
   ITER_SUM_KEP         =  1,   // print summary every iteration in Keplerian elts
   ITER_SUM_EQNX        =  2;   // print summary every iteration in Equinoctial elts

// indexes for integer data fields
static const int  
   XAI_CTRL_PRINTOPTION  =  0,    // DC print option
   XAI_CTRL_DEBIASOBS    =  1,    // Apply biases from sensor file
   XAI_CTRL_WEIGHTEDDC   =  2,    // Weighed DC flag
   XAI_CTRL_EPOCHOPTION  =  3,    // Epoch placement control
   XAI_CTRL_CORRECT_AG   =  4,    // Element correction flag - Ag
   XAI_CTRL_CORRECT_AF   =  5,    // Element correction flag - Af
   XAI_CTRL_CORRECT_PSI  =  6,    // Element correction flag - Psi
   XAI_CTRL_CORRECT_CHI  =  7,    // Element correction flag - Chi
   XAI_CTRL_CORRECT_L    =  8,    // Element correction flag - L
   XAI_CTRL_CORRECT_N    =  9,    // Element correction flag - N
   XAI_CTRL_CORRECT_B    = 10,    // Element correction flag - B* (SGP4) B (SP)
   XAI_CTRL_CORRECT_AGOM = 11,    // Element correction flag - Agom (SP)
   XAI_CTRL_CORRECTORDER = 12,    // Correction order
   XAI_CTRL_FOR1ITERONLY = 13,    // Correct by the specified correction order for 1 iteration only
   XAI_CTRL_RESIDSELECT  = 14,    // Flag specifies which residuals are used for RMS calculation and convergence
   XAI_CTRL_SENPERFORM   = 15,    // Flag; if set, produce sensor performance analysis summary
   XAI_CTRL_DWOBSPERTRCK = 16,    // Flag; if set, deweight according to # of obs per track 
   XAI_CTRL_ITERSUMOPT   = 17,    // Iteration summary control
   XAI_CTRL_PARTIALMETH  = 18,    // Partials method 
   XAI_CTRL_LTC          = 19,    // Light time correction control
   XAI_CTRL_BRUCE        = 20,    // Number of iteration to allow no auto rejection of residuals
   XAI_CTRL_PROPMETHOD   = 21,    // Propagation method - GP=0, XP=4, SP=99
   XAI_CTRL_CORRECTBVSX  = 22,    // Flag; if set, correct B* vs X
   XAI_CTRL_MAXOFITERS   = 23,    // Max # of iterations before declaring divergence
   XAI_CTRL_USEPREDRMS   = 24,    // Use predicted RMS versus previous RMS for convergence testing
   XAI_CTRL_RESCOMPMETH  = 25,    // Residual computation method (GP only): DELTA/427M=1, SPADOC4=2
   XAI_CTRL_USEANGRATES  = 26,    // Flag; if set, use angle rates (obstypes = 4, 11)
   
   XAI_CTRL_SIZE         = 256;  
   


// indexes for real data fields
static const int  
   XAR_CTRL_RMSMULT        =   0,    // RMS multiplier
   XAR_CTRL_USEREPOCH      =   1,    // Time of specified epoch
   XAR_CTRL_CNVCRITONT     =   2,    // Convergence criteria on time correction (%)
   XAR_CTRL_1STPASDELTAT   =   3,    // First pass delta-t rejection criteria
   XAR_CTRL_CNVCRITON7ELT  =   4,    // Convergence criteria on 7-elt correction (%)
   XAR_CTRL_BRESET         =   5,    // reset value for B term in subset correction
   XAR_CTRL_SIZE           = 256;


// indexes for accessing DC's integer data
static const int  
   XAI_DCELTS_SATNUM       =   0,    // satellite number
   XAI_DCELTS_ELSETNUM     =   1,    // elset number
   XAI_DCELTS_ORBTYPE      =   2,    // elset's orbital/element type - see ELTTYPE_ constants for a list of possible values
   XAI_DCELTS_PROPTYPE     =   3,    // propagation method - see PROPTYPE_ constants for a list of possible values (GP=1, SP=2, External Ephemeris=3)
   XAI_DCELTS_SPECTR       =   4,    // spectr mode
   XAI_DCELTS_REVNUM       =   5,    // epoch revolution number
   XAI_DCELTS_CORRTYPE     =   6,    // correction type: 0=TIME, 1=PLANE", 2=7-ELT, 3=IN-TRK, 4=8-ELT, 5=SUBELT
   
   XAI_DCELTS_ITERCOUNT    =  10,    // total iteration count
   XAI_DCELTS_SUBITER      =  11,    // sub iteration count
   XAI_DCELTS_RESACC       =  12,    // # residual accepted
   XAI_DCELTS_RESREJ       =  13,    // # residual rejected
   
   XAI_DCELTS_CORRFLGS     =  20,    // 20-28 correction element flags  
   
   XAI_DCELTS_SIZE         = 256;

// indexes for accessing DC's real data   
static const int  
   XAR_DCELTS_EPOCHDS50UTC =   0,    // elset's epoch time in days since 1950 UTC
   XAR_DCELTS_NDOT         =   1,    // n-dot/2  (for SGP, eph-type = 0)
   XAR_DCELTS_N2DOT        =   2,    // n-double-dot/6  (for SGP, eph-type = 0)
   XAR_DCELTS_BFIELD       =   3,    // either SGP4 bStar (1/er) or SGP4-XP/SP bTerm (m2/kg)
   XAR_DCELTS_AGOM         =   4,    // SGP4-XP/SP agom (m**2/kg)
   XAR_DCELTS_OGPARM       =   5,    // SP outgassing parameter (km/s**2)
   XAR_DCELTS_KEP_A        =   6,    // semi major axis (km)
   XAR_DCELTS_KEP_E        =   7,    // eccentricity 
   XAR_DCELTS_KEP_INCLI    =   8,    // inclination (deg)
   XAR_DCELTS_KEP_MA       =   9,    // mean anamoly (deg)
   XAR_DCELTS_KEP_NODE     =  10,    // right ascension of the ascending node (deg)
   XAR_DCELTS_KEP_OMEGA    =  11,    // argument of perigee (deg)
   XAR_DCELTS_EQNX_AF      =  12,    // AF
   XAR_DCELTS_EQNX_AG      =  13,    // AG
   XAR_DCELTS_EQNX_CHI     =  14,    // CHI
   XAR_DCELTS_EQNX_PSI     =  15,    // PSI
   XAR_DCELTS_EQNX_L       =  16,    // mean longitude (deg)
   XAR_DCELTS_EQNX_N       =  17,    // mean motion (revs/day)
   XAR_DCELTS_POSX         =  18,    // ECI posX (km)
   XAR_DCELTS_POSY         =  19,    // ECI posY (km)
   XAR_DCELTS_POSZ         =  20,    // ECI posZ (km)
   XAR_DCELTS_VELX         =  21,    // ECI velX (km/s)
   XAR_DCELTS_VELY         =  22,    // ECI velY (km/s)
   XAR_DCELTS_VELZ         =  23,    // ECI velZ (km/s)
   
   XAR_DCELTS_RMS          =  40,    // RMS (km)
   XAR_DCELTS_RMSUNWTD     =  41,    // unweighted RMS (km)
   XAR_DCELTS_DELTATRMS    =  42,    // delta T RMS (min)
   XAR_DCELTS_BETARMS      =  43,    // beta RMS (deg)
   XAR_DCELTS_DELTAHTRMS   =  44,    // delta height RMS (km)
   XAR_DCELTS_CONVQLTY     =  45,    // convergence value (km)
   XAR_DCELTS_RMSPD        =  46,    // predicted RMS (km)
   
   XAR_DCELTS_COVL         =  60,    // covariance diagonal L
   XAR_DCELTS_COVN         =  61,    // covariance diagonal N   
   XAR_DCELTS_COVCHI       =  62,    // covariance diagonal CHI
   XAR_DCELTS_COVPSI       =  63,    // covariance diagonal PSI
   XAR_DCELTS_COVAF        =  64,    // covariance diagonal AF
   XAR_DCELTS_COVAG        =  65,    // covariance diagonal AG
   XAR_DCELTS_COVBTERM     =  66,    // covariance diagonal BTERM
   XAR_DCELTS_COVNA        =  67,    // covariance not used
   XAR_DCELTS_COVAGOM      =  68,    // covariance diagonal AGOM
   
   XAR_DCELTS_XMAX         =  70,    // max partial residual (km) 
   XAR_DCELTS_XMAX2        =  71,    // max velocity resid (km/sec)
   XAR_DCELTS_XMAX3        =  72,    // max beta residual (deg)
   XAR_DCELTS_XMAX4        =  73,    // max delta-t residual (min)
   XAR_DCELTS_PATCL        =  74,    // low argument of latitude coverage (deg)
   XAR_DCELTS_PATCH        =  75,    // high argument of latitude coverage (deg)
   
   XAR_DCELTS_EQNXCOVMTX   = 200,    // equinoctial covariance matrix - the lower triangular half 200-244
   
   XAR_DCELTS_SIZE         = 256;
   
// indexes for accessing obs rejection flags
static const int  
   XA_REJFLG_DECAYED      =   0,    // satellite has decayed at the time of obs
   XA_REJFLG_ERROR        =   1,    // obs residual computation error code
   XA_REJFLG_RA           =   2,    // right ascension residual rejected
   XA_REJFLG_BETA         =   3,    // beta residual rejected
   XA_REJFLG_DEC          =   4,    // declination residual rejected
   XA_REJFLG_HEIGHT       =   5,    // delta h residual rejected
   XA_REJFLG_RANGE        =   6,    // range residual rejected
   XA_REJFLG_RR           =   7,    // range rate residual rejected
   XA_REJFLG_TIME         =   8,    // delta t residual rejected
   
   XA_REJFLG_SIZE         =  32;
   
// indexes for accessing DC's acceptance criteria data   
static const int  
   XA_AC_STD_EPOCH    =   0,    // standard - days from epoch
   XA_AC_STD_NORES    =   1,    // standard - number of residuals
   XA_AC_STD_PRCNTRES =   2,    // standard - percent residual
   XA_AC_STD_RMS      =   3,    // standard - RMS (km)
   XA_AC_STD_OBSSPAN  =   4,    // standard - obs span (days)
   XA_AC_STD_DELTAW   =   5,    // standard - change in plan (deg)
   XA_AC_STD_DELTAABAR=   6,    // standard - change in abar 
   XA_AC_STD_DELTAN   =   7,    // standard - change in N (rev/day)
   XA_AC_STD_DELTAB   =   8,    // standard - change in B term

   XA_AC_ACT_EPOCH    =  20,    // actual - days from epoch
   XA_AC_ACT_NORES    =  21,    // actual - number of residuals
   XA_AC_ACT_PRCNTRES =  22,    // actual - percent residual
   XA_AC_ACT_RMS      =  23,    // actual - RMS (km)
   XA_AC_ACT_OBSSPAN  =  24,    // actual - obs span (days)
   XA_AC_ACT_DELTAW   =  25,    // actual - change in plan (deg)
   XA_AC_ACT_DELTAABAR=  26,    // actual - change in abar 
   XA_AC_ACT_DELTAN   =  27,    // actual - change in N (rev/day)
   XA_AC_ACT_DELTAB   =  28,    // actual - change in B term
   
   XA_AC_SIZE         =  64; 
   
// Different DC propagation method
static const int  
  DCPROPTYPE_GP =  0,      // DC propagator method is GP
  DCPROPTYPE_XP =  4,      // DC propagator method is SGP4-XP
  DCPROPTYPE_SP = 99;      // DC propagator method is SP 

// DC iterating returned code   
static const int  
   ITERCODE_DONE      = 0,     // DC was successful
   ITERCODE_ERROR     = 1,     // DC has error
   ITERCODE_ITERATING = 2,     // DC is still iterating
   ITERCODE_DIVERGED  = 3;     // DC diverged but trying to recover
  
  
// indexes for ob rejection error code
static const int  
   OBREJ_NONE       = 0,      // ob residual computation ok
   OBREJ_NOSENDATA  = 1,      // sensor data retrieval error
   OBREJ_NOSENLOC   = 2,      // no sensor location
   OBREJ_RESCOMPERR = 3;      // residual computation error
   
// indexes represent epoch placement options
static const int     
   EPFLG_NODALXINGLATESTOB = 0,     // Nodal crossing nearest latest obs
   EPFLG_LATESTOB          = 1,     // Exact time of latest obs
   EPFLG_NODALXINGATTIME   = 2,     // Nodal crossing closest to specified time
   EPFLG_ATEPOCH           = 3,     // Do not change epoch 
   EPFLG_ATSPECIFIEDTIME   = 4,     // Exact at specified time
   EPFLG_MIDDLEOBSSPAN     = 5,     // Middle of obs span
   EPFLG_EARLIESTOB        = 6;     // Exact time of earliest obs 
   
// indexes for EGP control parameters   
static const int  
   XA_EGPCTRL_OPTION     =  0,      // Not being used yet
   XA_EGPCTRL_DCELTTYPE  =  1,      // DC element type: 0=SPG4, 4=SGP4-XP
   XA_EGPCTRL_STARTMSE   =  2,      // Fit span start time (minutes since VCM's epoch/specified new epoch) (set start/stop = 0 to auto select)
   XA_EGPCTRL_STOPMSE    =  3,      // Fit span stop time (minutes since VCM's epoch/specified new epoch) (set start/stop = 0 to auto select)
   XA_EGPCTRL_STEPMIN    =  4,      // Step size in minutes (how often obs are generated) (set to zero to auto select)
   XA_EGPCTRL_DRAGCOR    =  5,      // Drag correction: 0=no correction, 1=correct BStar(SGP4)/BTerm(SGP4-XP), 2=correct X(SGP4 only)
   XA_EGPCTRL_AGOMCOR    =  6,      // Agom correction: 0=no correction, 1=correct agom (only when DC element = SGP4-XP)
   XA_EGPCTRL_EPFLG      =  7,      // Epoch placement flag - se EPFLG_xxx for description
   XA_EGPCTRL_NEWEPOCH   =  8,      // Time of specified Epoch in Ds50UTC (only for XA_EGPCTRL_EPFLG = 2 or 4)                 * 
   XA_EGPCTRL_SIZE       = 64;
  



// ========================= End of auto generated code ==========================
