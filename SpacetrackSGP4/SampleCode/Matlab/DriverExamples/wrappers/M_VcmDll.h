// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// Initializes Vcm DLL for use in the program
// apPtr              The handle that was returned from DllMainInit() (in-Long)
// returns 0 if Vcm.dll is initialized successfully, non-0 if there is an error
int VcmInit(__int64 apPtr);


// Returns information about the current version of Vcm DLL. The information is placed in the string parameter you pass in
// infoStr            A string to hold the information about Vcm.dll (out-Character[128])
void VcmGetInfo(char* infoStr);


// Loads a text file containing Vcm's
// vcmFile            The name of the file containing VCMs to be loaded (in-Character[512])
// returns 0 if the input file is read successfully, non-0 if there is an error
int VcmLoadFile(char* vcmFile);


// Saves the currently loaded VCM's to a file
// vcmFile            The name of the file in which to save the settings (in-Character[512])
// saveMode           Specifies whether to create a new file or append to an existing one (0 = create, 1= append) (in-Integer)
// saveForm           Specifies the mode in which to save the file (0 = text format, 1 = not yet implemented, reserved for future) (in-Integer)
// returns 0 if the data is successfully saved to the file, non-0 if there is an error
int VcmSaveFile(char* vcmFile, int saveMode, int saveForm);


// Removes a VCM represented by the satKey from memory
// satKey             The unique key of the satellite to be removed (in-Long)
// returns 0 if the VCM is removed successfully, non-0 if there is an error
int VcmRemoveSat(__int64 satKey);


// Removes all VCM's from memory
// returns 0 if all VCM's are removed successfully from memory, non-0 if there is an error
int VcmRemoveAllSats();


// Retrieves all of the currently loaded satKeys. These satKeys can be used to access the internal data for the VCM's
// returns The number of VCM's currently loaded
int VcmGetCount();


// Retrieves all of the currently loaded satKeys. These satKeys can be used to access the internal data for the VCM's
// order              Specifies the order in which the satKeys should be returned: 0=ascending, 1=descending, 2=order as loaded (in-Integer)
// satKeys            The array in which to store the satKeys (out-Long[*])
void VcmGetLoaded(int order, __int64* satKeys);


// Adds a VCM using its 1-line or concatenated string formats
// vcmString          1-line or concatenated string representation of the VCM (in-Character[4000])
// returns The satKey of the newly added VCM on success, a negative value on error
__int64 VcmAddSatFrLines(char* vcmString);


// Works like VcmAddSatFrLines but designed for Matlab
// vcmString          1-line or concatenated string representation of the VCM (in-Character[4000])
// satKey             The satKey of the newly added VCM on success, a negative value on error (out-Long)
void VcmAddSatFrLinesML(char* vcmString, __int64* satKey);


// Adds a VCM using its individually provided field values
// xs_vcm             The input string that contains all VCM's text fields (in-Character[512])
// xa_vcm             The input array that contains all VCM's numerical fields (in-Double[512])
// returns The satKey of the newly added VCM on success, a negative value on error
__int64 VcmAddSatFrFields(char* xs_vcm, double* xa_vcm);


// Works like VcmAddSatFrFields but designed for Matlab
// xs_vcm             The input string that contains all VCM's text fields (in-Character[512])
// xa_vcm             The input array that contains all VCM's numerical fields (in-Double[512])
// satKey             The satKey of the newly added VCM on success, a negative value on error (out-Long)
void VcmAddSatFrFieldsML(char* xs_vcm, double* xa_vcm, __int64* satKey);


// Retrieves VCM data associated with the input satKey
// satKey             The satKey of the loaded VCM (in-Long)
// xs_vcm             The output string that contains all VCM's text fields (out-Character[512])
// xa_vcm             The output array that contains all VCM's numerical fields (out-Double[512])
// returns 0 if the VCM data is successfully retrieved, non-0 if there is an error
int VcmRetrieveAllData(__int64 satKey, char* xs_vcm, double* xa_vcm);


// Updates a VCM using its individual field values. Note: satellite's number and epoch won't be updated
// satKey             The unique key of the satellite to update (in-Long)
// xs_vcm             The input string that contains all VCM's text fields (in-Character[512])
// xa_vcm             The input array that contains all VCM's numerical fields (in-Double[512])
// returns 0 if the Vcm data is successfully updated, non-0 if there is an error
int VcmUpdateSatFrFields(__int64 satKey, char* xs_vcm, double* xa_vcm);


// Retrieves the value of a specific field of a VCM
// satKey             The satellite's unique key (in-Long)
// xf_Vcm             Predefined number specifying which field to set (in-Integer)
// valueStr           A string to contain the value of the requested field (out-Character[512])
// returns 0 if the VCM is successfully retrieved, non-0 if there is an error
int VcmGetField(__int64 satKey, int xf_Vcm, char* valueStr);


// Updates the value of a specific field of a VCM
// satKey             The satellite's unique key (in-Long)
// xf_Vcm             Predefined number specifying which field to set (in-Integer)
// valueStr           The new value of the specified field, expressed as a string (in-Character[512])
// returns 0 if the VCM is successfully updated, non-0 if there is an error
int VcmSetField(__int64 satKey, int xf_Vcm, char* valueStr);


// Retrieves all of the data for a VCM in a single function call
// satKey             The satellite's unique key (in-Long)
// satNum             Satellite number (out-Integer)
// satName            Satellite name A8 (out-Character[8])
// epochDtg           Satellite epoch time A17 YYYYDDDHHMMSS.SSS (out-Character[17])
// revNum             Revolution number (out-Integer)
// posECI             ECI position (out-Double[3])
// velECI             ECI velocity (out-Double[3])
// geoName            Geopotential name A6 (WGS-72, WGS-84, EGM-96...) (out-Character[6])
// geoZonals          Geopotential zonals (out-Integer)
// geoTesserals       Geopotential tesserals (out-Integer)
// dragModel          Drag model A12 (NONE, JAC70/MSIS90...) (out-Character[12])
// lunarSolar         Lunar solar pertubations A3: ON, OFF (out-Character[3])
// radPress           Radiation pressure pertubations A3: ON, OFF (out-Character[3])
// earthTides         Earth + ocean tides pertubations A3: ON, OFF (out-Character[3])
// intrackThrust      Intrack thrust A3: ON, OFF (out-Character[3])
// bTerm              Ballistic coefficient (m2/kg) E13.10 (out-Double)
// agom               Solar radiation pressure coefficient (m2/kg) E13.10 (out-Double)
// ogParm             Outgassing parameter/Thrust acceleration (m/s2) E13.10 (out-Double)
// cmOffset           Center of mass offset (m) (out-Double)
// f10                Solar flux F10 I3 (out-Integer)
// f10Avg             Soluar flux F10 average I3 (out-Integer)
// apAvg              Ap average F5.1 (out-Double)
// tconRec            1: TaiMinusUTC, 2: UT1MinusUTC, 3: UT1Rate, 4: PolarX, 5: PolarY (out-Double[5])
// nTerms             Number of nutation terms I3 (out-Integer)
// leapYrDtg          Leap second time (out-Character[17])
// integMode          Integration mode A6: ASW, OSW, SPADOC (SPECTR=1 if ASW, OSW) (out-Character[6])
// partials           Type of partial derivatives A8 (ANALYTIC, FULL NUM, FAST NUM) (out-Character[8])
// stepMode           Integrator step mode A4: AUTO, TIME, S (out-Character[4])
// fixStep            Fixed step size indicator A3: ON, OFF (out-Character[3])
// stepSelection      Initial step size selection A6: AUTO, MANUAL (out-Character[6])
// initStepSize       Initial integration step size  F8.3 (out-Double)
// errCtrl            Integrator error control  E9.3 (out-Double)
// rms                Weighted RMS of last DC on the satellite E10.5 (out-Double)
// returns ! 0 if the VCM is successfully retrieved, non-0 if there is an error
int VcmGetAllFields(__int64 satKey, int* satNum, char* satName, char* epochDtg, int* revNum, double* posECI, double* velECI, char* geoName, int* geoZonals, int* geoTesserals, char* dragModel, char* lunarSolar, char* radPress, char* earthTides, char* intrackThrust, double* bTerm, double* agom, double* ogParm, double* cmOffset, int* f10, int* f10Avg, double* apAvg, double* tconRec, int* nTerms, char* leapYrDtg, char* integMode, char* partials, char* stepMode, char* fixStep, char* stepSelection, double* initStepSize, double* errCtrl, double* rms);


// Returns the concatenated string representation of a VCM by the satellite's satKey
// satKey             The satellite's unique key (in-Long)
// vcmLines           The resulting concatenated string representation of the VCM (out-Character[4000])
// returns 0 if successful, non-0 on error
int VcmGetLines(__int64 satKey, char* vcmLines);


// Converts VCM 1-line format to multi-line format (as a concatenated string)
// vcm1Line           The input VCM 1-line format (in-Character[1500])
// vcmLines           The resulting concatenated string (out-Character[4000])
// returns 0 if successful, non-0 on error
int Vcm1LineToMultiLine(char* vcm1Line, char* vcmLines);


// Converts VCM multi-line format (as a concatenated string) to 1-line format 
// vcmLines           The input concatenated string (in-Character[4000])
// vcm1Line           The resulting VCM 1-line format (out-Character[1500])
// returns 0 if successful, non-0 on error
int VcmMultiLineTo1Line(char* vcmLines, char* vcm1Line);


// Returns the first satKey from the currently loaded set of VCM's that contains the specified satellite number
// satNum             The input satellite number (in-Integer)
// returns The satellite's unique key
__int64 VcmGetSatKey(int satNum);


// Works like VcmGetSatKey but designed for Matlab
// satNum             The input satellite number (in-Integer)
// satKey             The satellite's unique key (out-Long)
void VcmGetSatKeyML(int satNum, __int64* satKey);


// Computes a satKey from the input data
// satNum             The input satellite number (in-Integer)
// epochDtg           [yy]yydddhhmmss.sss or [yy]yyddd.ddddddd or DTG15, DTG17, DTG20 (in-Character[20])
// returns The satellite's unique key
__int64 VcmFieldsToSatKey(int satNum, char* epochDtg);


// Works like VcmFieldsToSatKey but designed for Matlab
// satNum             The input satellite number (in-Integer)
// epochDtg           [yy]yydddhhmmss.sss or [yy]yyddd.ddddddd or DTG15, DTG17, DTG20 (in-Character[20])
// satKey             The satellite's unique key (out-Long)
void VcmFieldsToSatKeyML(int satNum, char* epochDtg, __int64* satKey);


// Constructs a multi-line VCM (as a concatenated string) from the VCM data stored in the input arrays.
// xa_vcm             Array containing VCM's numerical fields, see XA_VCM_? for array arrangement (in-Double[512])
// xs_vcm             Input string that contains all VCM's text fields, see XS_VCM_? for column arrangement (in-Character[512])
// vcmLines           The resulting concatenated string representation of a VCM (out-Character[4000])
void VcmArrayToVcmLines(double* xa_vcm, char* xs_vcm, char* vcmLines);


// Constructs a 1-line VCM from the VCM data stored in the input arrays.
// xa_vcm             Array containing VCM's numerical fields, see XA_VCM_? for array arrangement (in-Double[512])
// xs_vcm             Input string that contains all VCM's text fields, see XS_VCM_? for column arrangement (in-Character[512])
// vcm1Line           The resulting 1-line VCM (out-Character[1500])
void VcmArrayToVcm1Line(double* xa_vcm, char* xs_vcm, char* vcm1Line);


// Parses data either in 1-line or multi-line (as a concatenated string) VCM and stores that data into the output arrays
// vcmString          An input 1-line or concatenated string representation of the VCM (in-Character[4000])
// xa_vcm             Array containing VCM's numerical fields, see XA_VCM_? for array arrangement (out-Double[512])
// xs_vcm             Output string that contains all VCM's text fields, see XS_VCM_? for column arrangement (out-Character[512])
// returns 0 if the VCM is parsed successfully, non-0 if there is an error.
int VcmStringToArray(char* vcmString, double* xa_vcm, char* xs_vcm);
  
// Starting location of the VCM's text data fields
static const int  
   XS_VCM_SATNAME       =   0,     // satellite name A8
   XS_VCM_COMMNAME      =   8,     // common satellite name A25
   XS_VCM_GEONAME       =  33,     // geopotential name A6 (WGS-72, WGS-84, EGM-96, ...)
   XS_VCM_DRAGMOD       =  39,     // drag model A12
   XS_VCM_LUNAR         =  51,     // lunar solar pertubations A3 (ON, OFF)
   XS_VCM_RADPRESS      =  54,     // radiation pressure pertubations A3 (ON, OFF)
   XS_VCM_EARTHTIDES    =  57,     // Earth + ocean tides pertubation A3 (ON, OFF)
   XS_VCM_INTRACK       =  60,     // intrack thrust A3 (ON, OFF)
   XS_VCM_INTEGMODE     =  63,     // integration mode A6 (ASW, OSW, SPADOC, ...)
   XS_VCM_COORDSYS      =  69,     // coordinate system A5
   XS_VCM_PARTIALS      =  74,     // type of partial derivatives A8
   XS_VCM_STEPMODE      =  82,     // step mode A4 (AUTO, TIME, S)
   XS_VCM_FIXEDSTEP     =  86,     // fixed step size indicator A3 (ON, OFF)
   XS_VCM_STEPSEL       =  89,     // initial step size selection A6 (AUTO, MANUAL)
   
   XS_VCM_SIZE          = 512;

// Indexes to access data from an array containing VCM numerical data fields
static const int     
   XA_VCM_SATNUM        =   0,     // satellite number
   XA_VCM_EPOCHDS50UTC  =   1,     // satellite's epoch time
   XA_VCM_REVNUM        =   2,     // epoch revolution number
   XA_VCM_J2KPOSX       =   3,     // J2K position X (km)
   XA_VCM_J2KPOSY       =   4,     // J2K position Y (km)
   XA_VCM_J2KPOSZ       =   5,     // J2K position Z (km)
   XA_VCM_J2KVELX       =   6,     // J2K velocity X (km/s)
   XA_VCM_J2KVELY       =   7,     // J2K velocity Y (km/s)
   XA_VCM_J2KVELZ       =   8,     // J2K velocity Z (km/s)
   XA_VCM_ECIPOSX       =   9,     // ECI position X (km)
   XA_VCM_ECIPOSY       =  10,     // ECI position Y (km)
   XA_VCM_ECIPOSZ       =  11,     // ECI position Z (km)
   XA_VCM_ECIVELX       =  12,     // ECI velocity X (km/s)
   XA_VCM_ECIVELY       =  13,     // ECI velocity Y (km/s)
   XA_VCM_ECIVELZ       =  14,     // ECI velocity Z (km/s)
   XA_VCM_EFGPOSX       =  15,     // EFG position X (km)
   XA_VCM_EFGPOSY       =  16,     // EFG position Y (km)
   XA_VCM_EFGPOSZ       =  17,     // EFG position Z (km)
   XA_VCM_EFGVELX       =  18,     // EFG velocity X (km/s)
   XA_VCM_EFGVELY       =  19,     // EFG velocity Y (km/s)
   XA_VCM_EFGVELZ       =  20,     // EFG velocity Z (km/s)
   XA_VCM_GEOZON        =  21,     // geopotential zonals
   XA_VCM_GEOTES        =  22,     // geopotential tesserals
   XA_VCM_BTERM         =  23,     // ballistic coefficient (m^2/kg)
   XA_VCM_BDOT          =  24,     // BDOT (m^2/kg-s)
   XA_VCM_AGOM          =  25,     // solar radiation pressure coefficient (m^2/kg)
   XA_VCM_EDR           =  26,     // energy dissipation rate (w/kg)
   XA_VCM_OGPARM        =  27,     // outgassing parameter/thrust acceleration (m/s^2)
   XA_VCM_CMOFFSET      =  28,     // center of mass offset (m)
   XA_VCM_F10           =  29,     // solar flux F10
   XA_VCM_F10AVG        =  30,     // average F10
   XA_VCM_APAVG         =  31,     // average Ap
   XA_VCM_TAIMUTC       =  32,     // TAI - UTC (s)
   XA_VCM_UT1MUTC       =  33,     // UT1 - UTC (s)
   XA_VCM_UT1RATE       =  34,     // UT1 rate (ms/day)
   XA_VCM_POLMOTX       =  35,     // polar motion X (arcsec)
   XA_VCM_POLMOTY       =  36,     // polar motion Y (arcsec)
   XA_VCM_NUTTERMS      =  37,     // nutation terms
   XA_VCM_LEAPDS50UTC   =  38,     // leap second time in days since 1950 UTC
   XA_VCM_INITSTEP      =  39,     // initial step size
   XA_VCM_ERRCTRL       =  40,     // integrator control error 
   XA_VCM_POSUSIG       =  41,     // position u sigma (km)   
   XA_VCM_POSVSIG       =  42,     // position v sigma (km)
   XA_VCM_POSWSIG       =  43,     // position w sigma (km)
   XA_VCM_VELUSIG       =  44,     // velocity u sigma (km/s)
   XA_VCM_VELVSIG       =  45,     // velocity v sigma (km/s)
   XA_VCM_VELWSIG       =  46,     // velocity w sigma (km/s)
   XA_VCM_COVMTXSIZE    =  47,     // covariance matrix size
   XA_VCM_RMS           =  48,     // weighted RM of last DC on the satellite
   XA_VCM_COVELEMS      = 100,     // the lower triangle portion of the full cov matrix (100-120: 6x6 covmtx, ..., 100-144: 9x9 covmtx)
   
   XA_VCM_SIZE          = 512;

// Indexes of VCM data fields
static const int  
   XF_VCM_SATNUM    =  1,      // Satellite number I5
   XF_VCM_SATNAME   =  2,      // Satellite international designator A8
   XF_VCM_EPOCH     =  3,      // Epoch YYYYDDDHHMMSS.SSS A17
   XF_VCM_REVNUM    =  4,      // Revolution number I5
   XF_VCM_POSX      =  5,      // position X (km) F16.8 
   XF_VCM_POSY      =  6,      // position Y (km) F16.8 
   XF_VCM_POSZ      =  7,      // position Z (km) F16.8   
   XF_VCM_VELX      =  8,      // velocity X (km/s) F16.12
   XF_VCM_VELY      =  9,      // velocity Y (km/s) F16.12
   XF_VCM_VELZ      = 10,      // velocity Z (km/s) F16.12
   XF_VCM_GEONAME   = 11,      // Geo Name A6
   XF_VCM_GEOZONALS = 12,      // Geo zonals I2
   XF_VCM_GEOTESSER = 13,      // Geo tesserals I2
   XF_VCM_DRAGMODE  = 14,      // Drag modelel A12 (NONE, JAC70/MSIS90) 
   XF_VCM_LUNSOL    = 15,      // Lunar solar A3 (ON/OFF)
   XF_VCM_RADPRESS  = 16,      // Radiation pressure pertubations A3 (ON/OFF)
   XF_VCM_ERTHTIDES = 17,      // Earth + ocean tides pertubations A3 (ON/OFF)
   XF_VCM_INTRACK   = 18,      // Intrack thrust A3 (ON/OFF)
   XF_VCM_BTERM     = 19,      // Ballistic coefficient (m^2/kg)
   XF_VCM_AGOM      = 20,      // Radiation pressure coefficient  (m^2/kg)
   XF_VCM_OGPARM    = 21,      // Outgassing parameter (m/s^2)
   XF_VCM_CMOFFSET  = 22,      // Center of mass offset (m)
   XF_VCM_F10       = 23,      // Solar flux F10 I3
   XF_VCM_F10AVG    = 24,      // Solar flux F10 average I3
   XF_VCM_APAVG     = 25,      // Ap average F5.1
   XF_VCM_TAIMUTC   = 26,      // TAI minus UTC (s)I2
   XF_VCM_UT1MUTC   = 27,      // UT1 minus UTC (s) F7.5
   XF_VCM_UT1RATE   = 28,      // UT1 rate (ms/day)  F5.3
   XF_VCM_POLARX    = 29,      // Polar motion X (arcsec) F6.4
   XF_VCM_POLARY    = 30,      // Polar motion Y (arcsec) F6.4
   XF_VCM_NTERMS    = 31,      // Nutation terms I3
   XF_VCM_LEAPYR    = 32,      // Leap second time YYYYDDDHHMMSS.SSS A17
   XF_VCM_INTEGMODE = 33,      // Integration mode A6 (ASW, OSW, SPADOC)
   XF_VCM_PARTIALS  = 34,      // Type of partial derivatives A8 (ANALYTIC, FULL NUM, FAST NUM)
   XF_VCM_STEPMODE  = 35,      // Integration step mode A4 (AUTO/TIME, S)
   XF_VCM_FIXEDSTEP = 36,      // Fixed step size indicator A3 (ON/OFF)
   XF_VCM_STEPSLCTN = 37,      // Initial step size selection A6 (AUTO/MANUAL)
   XF_VCM_STEPSIZE  = 38,      // Initial integration step size F8.3
   XF_VCM_ERRCTRL   = 39,      // Integrator error control E9.3
   XF_VCM_RMS       = 40,      // Weighted RMS of last DC E10.5
   XF_VCM_BDOT      = 41,      // BDOT (M2/KG-S)
   XF_VCM_EDR       = 42;      // EDR (W/KG)
   
   



// ========================= End of auto generated code ==========================
