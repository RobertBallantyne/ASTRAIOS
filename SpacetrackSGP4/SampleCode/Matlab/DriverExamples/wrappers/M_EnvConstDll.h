// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// apPtr              The handle that was returned from DllMainInit, see the documentation for DllMain.dll for details. (in-Long)
// returns Returns zero indicating the EnvConst DLL has been initialized successfully. Other values indicate an error.
int EnvInit(__int64 apPtr);


// Returns information about the EnvConst DLL.
// infoStr            A string to hold the information about EnvConst.dll. (out-Character[128])
void EnvGetInfo(char* infoStr);


// Reads Earth constants (GEO) model and fundamental catalogue (FK) model settings from a file.
// envFile            The name of the input file. (in-Character[512])
// returns Returns zero indicating the input file has been loaded successfully. Other values indicate an error.
int EnvLoadFile(char* envFile);


// Saves the current Earth constants (GEO) model and fundamental catalogue (FK) model settings to a file.
// envConstFile       The name of the file in which to save the settings. (in-Character[512])
// saveMode           Specifies whether to create a new file or append to an existing one. (0 = create, 1= append) (in-Integer)
// saveForm           Specifies the mode in which to save the file. (0 = text format, 1 = xml (not yet implemented, reserved for future)) (in-Integer)
// returns Returns zero indicating the GEO and FK settings have been successfully saved to the file. Other values indicate an error.
int EnvSaveFile(char* envConstFile, int saveMode, int saveForm);


// Returns the current fundamental catalogue (FK) setting. 
// returns Return the current FK setting as an integer. Valid values are: (4 = FK4, 5 = FK5)
int EnvGetFkIdx();


// Changes the fundamental catalogue (FK) setting to the specified value. 
// xf_FkMod           Specifies the FK model to use. The following values are accepted: xf_FkMod= 4: FK4, xf_FkMod= 5: FK5 (in-Integer)
void EnvSetFkIdx(int xf_FkMod);


// Returns the current Earth constants (GEO) setting. 
// returns The current GEO setting, expressed as an integer.
int EnvGetGeoIdx();


// Changes the Earth constants (GEO) setting to the specified value.
// xf_GeoMod          Specifies the GEO model to use. (in-Integer)
void EnvSetGeoIdx(int xf_GeoMod);


// Returns the name of the current Earth constants (GEO) model. 
// geoStr             A string to store the name of the current GEO model. (out-Character[6])
void EnvGetGeoStr(char* geoStr);


// Changes the Earth constants (GEO) setting to the model specified by a string literal. 
// geoStr             The GEO model to use, expressed as a string. (in-Character[6])
void EnvSetGeoStr(char* geoStr);


// Retrieves the value of one of the constants from the current Earth constants (GEO) model. 
// xf_GeoCon          An index specifying the constant you wish to retrieve, see XF_GEOCON_? for field specification (in-Integer)
// returns Value of the requested GEO constant
double EnvGetGeoConst(int xf_GeoCon);


// Retrieves the value of one of the constants from the current fundamental catalogue (FK) model.
// xf_FkCon           An index specifying the constant you wish to retrieve, , see XF_FKCON_? for field specification (in-Integer)
// returns Value of the requested FK constant
double EnvGetFkConst(int xf_FkCon);


// Returns a handle that can be used to access the fundamental catalogue (FK) data structure. 
// returns A handle which can be used to access the FK data structure.
__int64 EnvGetFkPtr();


// Specifies the shape of the earth that will be used by the Astro Standards software, either spherical earth or oblate earth
// earthShape         The value indicates the shape of the earth: 0=spherical earth, 1= oblate earth (default) (in-Integer)
void EnvSetEarthShape(int earthShape);


// Returns the value representing the shape of the earth being used by the Astro Standards software, either spherical earth or oblate earth
// returns The value indicates the shape of the earth that is being used in the Astro Standards software: 0=spherical earth, 1= oblate earth
int EnvGetEarthShape();

// Indexes of Earth Constant fields
static const int     
   XF_GEOCON_FF    = 1,         // Earth flattening (reciprocal; unitless)
   XF_GEOCON_J2    = 2,         // J2 (unitless)
   XF_GEOCON_J3    = 3,         // J3 (unitless)
   XF_GEOCON_J4    = 4,         // J4 (unitless)
   XF_GEOCON_KE    = 5,         // Ke (er**1.5/min)
   XF_GEOCON_KMPER = 6,         // Earth radius (km/er)
   XF_GEOCON_RPTIM = 7,         // Earth rotation rate w.r.t. fixed equinox (rad/min)

   XF_GEOCON_CK2   = 8,         // J2/2 (unitless)
   XF_GEOCON_CK4   = 9,         // -3/8 J4 (unitless)
   XF_GEOCON_KS2EK = 10,        // Converts km/sec to er/kem
   XF_GEOCON_THDOT = 11,        // Earth rotation rate w.r.t. fixed equinox (rad/kemin)
   XF_GEOCON_J5    = 12;        // J5 (unitless)
   

// Indexes of FK Constant fields
static const int                     
   XF_FKCON_C1     = 1,         // Earth rotation rate w.r.t. moving equinox (rad/day) 
   XF_FKCON_C1DOT  = 2,         // Earth rotation acceleration(rad/day**2) 
   XF_FKCON_THGR70 = 3;         // Greenwich angle (1970; rad) 

// Indexes represent geopotential models GEO
static const int  
   XF_GEOMOD_WGS84  =   84,     // Earth constants - WGS-84
   XF_GEOMOD_EGM96  =   96,     // Earth constants - EGM-96
   XF_GEOMOD_EGM08  =    8,     // Earth constants - EGM-08
   XF_GEOMOD_WGS72  =   72,     // Earth constants - WGS-72
   XF_GEOMOD_JGM2   =    2,     // Earth constants - JGM2
   XF_GEOMOD_STEM68 =   68,     // Earth constants - STEM68
   XF_GEOMOD_GEM5   =    5,     // Earth constants - GEM5
   XF_GEOMOD_GEM9   =    9,     // Earth constants - GEM9
   XF_GEOMOD_UNKNOWN=  100;

//*******************************************************************************

// Indexes represent fundamental catalogue FK
static const int  
   XF_FKMOD_4 = 4,    // Fundamental Catalog - FK5
   XF_FKMOD_5 = 5;    // Fundamental Catalog - FK4





// ========================= End of auto generated code ==========================
