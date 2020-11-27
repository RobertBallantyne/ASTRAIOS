// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// Initializes SpVec DLL for use in the program
// apPtr              The handle that was returned from DllMainInit() (in-Long)
// returns 0 if SpVec.dll is initialized successfully, non-0 if there is an error
int SpVecInit(__int64 apPtr);


// Returns information about the current version of SpVec DLL. The information is placed in the string parameter you pass in
// infoStr            A string to hold the information about SpVec.dll (out-Character[128])
void SpVecGetInfo(char* infoStr);


// Loads a text file containing SpVec's
// spVecFile          The name of the file containing osculating vectors (SpVecs) to be loaded (in-Character[512])
// returns 0 if the input file is read successfully, non-0 if there is an error
int SpVecLoadFile(char* spVecFile);


// Saves the currently loaded SpVecs's to a file
// spVecFile          The name of the file in which to save the settings (in-Character[512])
// saveMode           Specifies whether to create a new file or append to an existing one (0 = create, 1= append) (in-Integer)
// saveForm           Specifies the mode in which to save the file (0 = text format, 1 = not yet implemented, reserved for future) (in-Integer)
// returns 0 if the data is successfully saved to the file, non-0 if there is an error
int SpVecSaveFile(char* spVecFile, int saveMode, int saveForm);


// Removes an SpVec represented by the satKey from memory
// satKey             The unique key of the satellite to be removed (in-Long)
// returns 0 if the SpVec is removed successfully, non-0 if there is an error
int SpVecRemoveSat(__int64 satKey);


// Removes all SpVec's from memory
// returns 0 if all SpVec's are removed successfully from memory, non-0 if there is an error
int SpVecRemoveAllSats();


// Retrieves all of the currently loaded satKeys. These satKeys can be used to access the internal data for the SpVec's
// returns The number of SpVec's currently loaded
int SpVecGetCount();


// Retrieves all of the currently loaded satKeys. These satKeys can be used to access the internal data for the SpVec's
// order              Specifies the order in which the satKeys should be returned: 0=ascending, 1=descending, 2=order as loaded (in-Integer)
// satKeys            The array in which to store the satKeys (out-Long[*])
void SpVecGetLoaded(int order, __int64* satKeys);


// Adds an SpVec using its directly specified first and second lines
// line1              The first input line of the two line element set (in-Character[512])
// line2              The second input line of the two line element set (in-Character[512])
// returns The satKey of the newly added SpVec on success, a negative value on error
__int64 SpVecAddSatFrLines(char* line1, char* line2);


// Works like SpVecAddSatFrLines but designed for Matlab
// line1              The first input line of the two line element set (in-Character[512])
// line2              The second input line of the two line element set (in-Character[512])
// satKey             The satKey of the newly added SpVec on success, a negative value on error (out-Long)
void SpVecAddSatFrLinesML(char* line1, char* line2, __int64* satKey);


// Adds an SpVec using its individually provided field values
// pos                position vector (km) (in-Double[3])
// vel                velocity vector (m/s) (in-Double[3])
// secClass           Security classification: U=Unclass, C=Confidential, S=Secret (in-Character)
// satNum             Satellite number (in-Integer)
// satName            Satellite name A8 (in-Character[8])
// epochDtg           Satellite's epoch A17 (YYYYDDDHHMMSS.SSS) (in-Character[17])
// revNum             Revolution number (in-Integer)
// elsetNum           Element set number (in-Integer)
// bterm              Bterm m^2/kg (in-Double)
// agom               Agom  m^2/kg (in-Double)
// ogParm             Outgassing parameter (km/s^2) (in-Double)
// coordSys           Input coordinate system A5 - TMDAT/TMEPO: Epoch, MMB50/MMJ2K: J2000 (in-Character[5])
// returns The satKey of the newly added SpVec on success, a negative value on error
__int64 SpVecAddSatFrFields(double* pos, double* vel, char secClass, int satNum, char* satName, char* epochDtg, int revNum, int elsetNum, double bterm, double agom, double ogParm, char* coordSys);


// Works like SpVecAddSatFrFields but designed for Matlab 
// pos                position vector (km) (in-Double[3])
// vel                velocity vector (m/s) (in-Double[3])
// secClass           Security classification: U=Unclass, C=Confidential, S=Secret (in-Character)
// satNum             Satellite number (in-Integer)
// satName            Satellite name A8 (in-Character[8])
// epochDtg           Satellite's epoch A17 (YYYYDDDHHMMSS.SSS) (in-Character[17])
// revNum             Revolution number (in-Integer)
// elsetNum           Element set number (in-Integer)
// bterm              Bterm m^2/kg (in-Double)
// agom               Agom  m^2/kg (in-Double)
// ogParm             Outgassing parameter (km/s^2) (in-Double)
// coordSys           Input coordinate system A5 - TMDAT/TMEPO: Epoch, MMB50/MMJ2K: J2000 (in-Character[5])
// satKey             The satKey of the newly added SpVec on success, a negative value on error (out-Long)
void SpVecAddSatFrFieldsML(double* pos, double* vel, char secClass, int satNum, char* satName, char* epochDtg, int revNum, int elsetNum, double bterm, double agom, double ogParm, char* coordSys, __int64* satKey);


// Updates an SpVec satellite's data in memory using individually provided field values. Note: satnum, epoch string can't be updated.
// satKey             The sattelite's unique key (in-Long)
// pos                position vector (km) (in-Double[3])
// vel                velocity vector (m/s) (in-Double[3])
// secClass           Security classification: U=Unclass, C=Confidential, S=Secret (in-Character)
// satName            Satellite name A8 (in-Character[8])
// revNum             Revolution number (in-Integer)
// elsetNum           Element set number (in-Integer)
// bterm              Bterm m^2/kg (in-Double)
// agom               Agom  m^2/kg (in-Double)
// ogParm             Outgassing parameter (km/s^2) (in-Double)
// coordSys           Input coordinate system A5 - TMDAT/TMEPO: Epoch, MMB50/MMJ2K: J2000 (in-Character[5])
// returns 0 if the SpVec is successfully updated, non-0 if there is an error
int SpVecUpdateSatFrFields(__int64 satKey, double* pos, double* vel, char secClass, char* satName, int revNum, int elsetNum, double bterm, double agom, double ogParm, char* coordSys);


// Retrieves the value of a specific field of an SpVec
// satKey             The satellite's unique key (in-Long)
// xf_SpVec           Predefined number specifying which field to set (in-Integer)
// valueStr           A string to contain the value of the requested field (out-Character[512])
// returns 0 if the SpVec is successfully retrieved, non-0 if there is an error
int SpVecGetField(__int64 satKey, int xf_SpVec, char* valueStr);


// Updates the value of a field of an SpVec
// satKey             The satellite's unique key (in-Long)
// xf_SpVec           Predefined number specifying which field to set (in-Integer)
// valueStr           The new value of the specified field, expressed as a string (in-Character[512])
// returns 0 if the SpVec is successfully updated, non-0 if there is an error
int SpVecSetField(__int64 satKey, int xf_SpVec, char* valueStr);


// Retrieves all of the data for an SpVec satellite in a single function call
// satKey             The satellite's unique key (in-Long)
// pos                position vector (km) (out-Double[3])
// vel                velocity vector (m/s) (out-Double[3])
// secClass           Security classification U: unclass, C: confidential, S: Secret (out-Character)
// satNum             Satellite number (out-Integer)
// satName            Satellite name A8 (out-Character[8])
// epochDtg           Satellite's epoch A17 (YYYYDDDHHMMSS.SSS) (out-Character[17])
// revNum             Revolution number (out-Integer)
// elsetNum           Element set number (out-Integer)
// bterm              Bterm m^2/kg (out-Double)
// agom               Agom  m^2/kg (out-Double)
// ogParm             Outgassing parameter (km/s^2) (out-Double)
// coordSys           Input coordinate system A5 - TMDAT/TMEPO: Epoch, MMB50/MMJ2K: J2000 (out-Character[5])
// returns 0 if the SpVec is successfully retrieved, non-0 if there is an error
int SpVecGetAllFields(__int64 satKey, double* pos, double* vel, char* secClass, int* satNum, char* satName, char* epochDtg, int* revNum, int* elsetNum, double* bterm, double* agom, double* ogParm, char* coordSys);


// Retrieves all of the data for an SpVec satellite in a single function call
// line1              the first input line of a 1P/2P card (in-Character[512])
// line2              the second input line of a 1P/2P card (in-Character[512])
// pos                position vector (km) (out-Double[3])
// vel                velocity vector (m/s) (out-Double[3])
// secClass           Security classification U: unclass, C: confidential, S: Secret (out-Character)
// satNum             Satellite number (out-Integer)
// satName            Satellite name A8 (out-Character[8])
// epochDtg           Satellite's epoch A17 (YYYYDDDHHMMSS.SSS) (out-Character[17])
// revNum             Revolution number (out-Integer)
// elsetNum           Element set number (out-Integer)
// bterm              Bterm m^2/kg (out-Double)
// agom               Agom  m^2/kg (out-Double)
// ogParm             Outgassing parameter (km/s^2) (out-Double)
// coordSys           Input coordinate system A5 - TMDAT/TMEPO: Epoch, MMB50/MMJ2K: J2000 (out-Character[5])
// returns 0 if the SpVec data is successfully parsed, non-0 if there is an error
int SpVecParse(char* line1, char* line2, double* pos, double* vel, char* secClass, int* satNum, char* satName, char* epochDtg, int* revNum, int* elsetNum, double* bterm, double* agom, double* ogParm, char* coordSys);


// Parses SPVEC data from the input first and second lines of an 1P/2P state vector and store that data back into the output parameters.
// line1              The first line of the two line element set. (in-Character[512])
// line2              The second line of the two line element set (in-Character[512])
// xa_spVec           Array containing SPVEC's numerical fields, see XA_SPVEC_? for array arrangement (out-Double[512])
// xs_spVec           Output string that contains all SPVEC's text fields, see XS_SPVEC_? for column arrangement (out-Character[512])
// returns 0 if the SPVEC is parsed successfully, non-0 if there is an error.
int SpVecLinesToArray(char* line1, char* line2, double* xa_spVec, char* xs_spVec);


// Returns the first and second lines of the 1P/2P representation of an SpVec
// satKey             The satellite's unique key (in-Long)
// line1              The resulting first line of a 1P/2P card (out-Character[512])
// line2              The resulting second line of a 1P/2P card (out-Character[512])
// returns 0 if successful, non-0 on error
int SpVecGetLines(__int64 satKey, char* line1, char* line2);


// Constructs 1P/2P cards from individually provided SpVec data fields
// pos                position vector (km) (in-Double[3])
// vel                velocity vector (m/s) (in-Double[3])
// secClass           Security classification U: unclass, C: confidential, S: Secret (in-Character)
// satNum             Satellite number (in-Integer)
// satName            Satellite name A8 (in-Character[8])
// epochDtg           Satellite's epoch A17 (YYYYDDDHHMMSS.SSS) (in-Character[17])
// revNum             Revolution number (in-Integer)
// elsetNum           Element set number (in-Integer)
// bterm              Bterm m^2/kg (in-Double)
// agom               Agom  m^2/kg (in-Double)
// ogParm             Outgassing parameter (km/s^2) (in-Double)
// coordSys           Input coordinate system A5 - TMDAT/TMEPO: Epoch, MMB50/MMJ2K: J2000 (in-Character[5])
// line1              The resulting first line of a 1P/2P card (out-Character[512])
// line2              The resulting second line of a 1P/2P card (out-Character[512])
void SpVecFieldsToLines(double* pos, double* vel, char secClass, int satNum, char* satName, char* epochDtg, int revNum, int elsetNum, double bterm, double agom, double ogParm, char* coordSys, char* line1, char* line2);


// Constructs 1P/2P cards from SPVEC data stored in the input arrays.
// xa_spVec           Array containing SPVEC's numerical fields, see XA_SPVEC_? for array arrangement (in-Double[512])
// xs_spVec           Input string that contains all SPVEC's text fields, see XS_SPVEC_? for column arrangement (in-Character[512])
// line1              Returned first line of an SPVEC. (out-Character[512])
// line2              Returned second line of an SPVEC (out-Character[512])
void SpVecArrayToLines(double* xa_spVec, char* xs_spVec, char* line1, char* line2);


// Returns the first satKey from the currently loaded set of SpVec's that contains the specified satellite number
// satNum             The input satellite number (in-Integer)
// returns The satellite's unique key
__int64 SpVecGetSatKey(int satNum);


// This function is similar to SpVecGetSatKey but designed to be used in Matlab. 
// satNum             The input satellite number (in-Integer)
// satKey             The satellite's unique key (out-Long)
void SpVecGetSatKeyML(int satNum, __int64* satKey);


// Computes a satKey from the input data
// satNum             The input satellite number (in-Integer)
// epochDtg           [yy]yydddhhmmss.sss or [yy]yyddd.ddddddd or DTG15, DTG17, DTG20 (in-Character[20])
// returns The resulting satellite key
__int64 SpVecFieldsToSatKey(int satNum, char* epochDtg);


// This function is similar to SpVecFieldsToSatKey but designed to be used in Matlab. 
// satNum             The input satellite number (in-Integer)
// epochDtg           [yy]yydddhhmmss.sss or [yy]yyddd.ddddddd or DTG15, DTG17, DTG20 (in-Character[20])
// satKey             The resulting satellite key (out-Long)
void SpVecFieldsToSatKeyML(int satNum, char* epochDtg, __int64* satKey);


// Adds an SpVec using its individually provided field values
// xa_spVec           Array containing SPVEC's numerical fields, see XA_SPVEC_? for array arrangement (in-Double[512])
// xs_spVec           Input string that contains all SPVEC's text fields, see XS_SPVEC_? for column arrangement (in-Character[512])
// returns The satKey of the newly added SPVEC on success, a negative value on error.
__int64 SpVecAddSatFrArray(double* xa_spVec, char* xs_spVec);


// Adds an SpVec using its individually provided field values
// xa_spVec           Array containing SPVEC's numerical fields, see XA_SPVEC_? for array arrangement (in-Double[512])
// xs_spVec           Input string that contains all SPVEC's text fields, see XS_SPVEC_? for column arrangement (in-Character[512])
// satKey             The satKey of the newly added SPVEC on success, a negative value on error. (out-Long)
void SpVecAddSatFrArrayML(double* xa_spVec, char* xs_spVec, __int64* satKey);


// Updates existing SPVEC data with the provided new data stored in the input parameters. Note: satnum, epoch string can't be updated.
// satKey             The satellite's unique key (in-Long)
// xa_spVec           Array containing SPVEC's numerical fields, see XA_SPVEC_? for array arrangement (in-Double[512])
// xs_spVec           Input string that contains all SPVEC's text fields, see XS_SPVEC_? for column arrangement (in-Character[512])
// returns 0 if the SPVEC is successfully updated, non-0 if there is an error.
int SpVecUpdateSatFrArray(__int64 satKey, double* xa_spVec, char* xs_spVec);


// Retrieves SPVEC data and stored it in the passing parameters
// satKey             The satellite's unique key (in-Long)
// xa_spVec           Array containing SPVEC's numerical fields, see XA_SPVEC_? for array arrangement (out-Double[512])
// xs_spVec           Output string that contains all SPVEC's text fields, see XS_SPVEC_? for column arrangement (out-Character[512])
// returns 0 if all values are retrieved successfully, non-0 if there is an error
int SpVecDataToArray(__int64 satKey, double* xa_spVec, char* xs_spVec);
  
// Indexes of SPVEC data fields
static const int  
   XF_SPVEC_POS1     =  1,      // X component of satellite's position (km)
   XF_SPVEC_POS2     =  2,      // Y component of satellite's position (km)
   XF_SPVEC_POS3     =  3,      // Z component of satellite's position (km)
   XF_SPVEC_VEL1     =  4,      // X component of satellite's velocity (m/s)
   XF_SPVEC_VEL2     =  5,      // Y component of satellite's velocity (m/s)
   XF_SPVEC_VEL3     =  6,      // Z component of satellite's velocity (m/s)
   XF_SPVEC_SECCLASS =  7,      // Security classification
   XF_SPVEC_SATNUM   =  9,      // Satellite number
   XF_SPVEC_SATNAME  = 10,      // Satellite common name
   XF_SPVEC_EPOCH    = 11,      // Epoch date
   XF_SPVEC_REVNUM   = 12,      // Epoch revolution number
   XF_SPVEC_ELSETNUM = 13,      // Elset number
   XF_SPVEC_BTERM    = 14,      // Ballistic coefficient (m^2/kg)
   XF_SPVEC_AGOM     = 15,      // Radiation pressure coefficient (m^2/kg)
   XF_SPVEC_OGPARM   = 16,      // Outgassing parameter (km/s^2)
   XF_SPVEC_INPCOORD = 17;      // Inpute coordinate system
   
   
// Indexes of SPVEC numerical data in an array
static const int  
   XA_SPVEC_SATNUM   =   0,      // Satellite number
   XA_SPVEC_EPOCH    =   1,      // Epoch date in days since 1950 UTC
   XA_SPVEC_REVNUM   =   2,      // Epoch revolution number
   XA_SPVEC_ELSETNUM =   3,      // Elset number
   XA_SPVEC_BTERM    =   4,      // Ballistic coefficient (m^2/kg)
   XA_SPVEC_AGOM     =   5,      // Radiation pressure coefficient (m^2/kg)
   XA_SPVEC_OGPARM   =   6,      // Outgassing parameter (km/s^2)
   XA_SPVEC_INPCOORD =   7,      // Inpute coordinate system; = 0: use 4P, = 1:TMDAT, = 2: MMJ2K

   XA_SPVEC_POS1     =  20,      // X component of satellite's position (km)
   XA_SPVEC_POS2     =  21,      // Y component of satellite's position (km)
   XA_SPVEC_POS3     =  22,      // Z component of satellite's position (km)
   XA_SPVEC_VEL1     =  23,      // X component of satellite's velocity (m/s)
   XA_SPVEC_VEL2     =  24,      // Y component of satellite's velocity (m/s)
   XA_SPVEC_VEL3     =  25,      // Z component of satellite's velocity (m/s)
   
   XA_SPVEC_HASOWNCRL=  70,      // Flag to indicate SP vec has its own numerical integration control
   XA_SPVEC_GEOIDX   =  71,      // Geopotential model to use
   XA_SPVEC_BULGEFLG =  72,      // Earth gravity pertubations flag
   XA_SPVEC_DRAGFLG  =  73,      // Drag pertubations flag 
   XA_SPVEC_RADFLG   =  74,      // Radiation pressure pertubations flag
   XA_SPVEC_LUNSOL   =  75,      // Lunar/Solar pertubations flag
   XA_SPVEC_F10      =  76,      // F10 value
   XA_SPVEC_F10AVG   =  77,      // F10 average value
   XA_SPVEC_AP       =  78,      // Ap value
   XA_SPVEC_TRUNC    =  79,      // Geopotential truncation order/degree/zonals
   XA_SPVEC_CONVERG  =  80,      // Corrector step convergence criterion; exponent of 1/10; default = 10
   XA_SPVEC_OGFLG    =  81,      // Outgassing pertubations flag
   XA_SPVEC_TIDESFLG =  82,      // Solid earth and ocean tide pertubations flag
   XA_SPVEC_INCOORD  =  83,      // Input vector coordinate system
   XA_SPVEC_NTERMS   =  84,      // Nutation terms
   XA_SPVEC_REEVAL   =  85,      // Recompute pertubations at each corrector step
   XA_SPVEC_INTEGCTRL=  86,      // Variable of intergration control
   XA_SPVEC_VARSTEP  =  87,      // Variable step size control
   XA_SPVEC_INITSTEP =  88,      // Initial step size
   
   XA_SPVEC_RMS      =  99,      // weighted RM of last DC on the satellite 
   XA_SPVEC_COVELEMS = 100,      // the lower triangle portion of the full cov matrix (100-120: 6x6 covmtx, ..., 100-154: 10x10 covmtx)
   
   XA_SPVEC_SIZE     = 512;
   

// Indexes of SPVEC text data in an array of chars
static const int     
   XS_SPVEC_SECCLASS_1 =  0,      // Security classification
   XS_SPVEC_SATNAME_8  =  1,      // Satellite common name
   
   XS_SPVEC_SIZE       = 512;




// ========================= End of auto generated code ==========================
