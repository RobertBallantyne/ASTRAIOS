// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// Initializes Tle DLL for use in the program.
// apPtr              The handle that was returned from DllMainInit. See the documentation for DllMain.dll for details. (in-Long)
// returns 0 if Tle.dll is initialized successfully, non-0 if there is an error.
int TleInit(__int64 apPtr);


// Returns the information about the Tle DLL.
// infoStr            A string to hold the information about the Tle DLL. (out-Character[128])
void TleGetInfo(char* infoStr);


// Loads TLEs (satellites) contained in a text file into the TLE DLL's binary tree.
// tleFile            The name of the file containing two line element sets to be loaded. (in-Character[512])
// returns 0 if the two line element sets in the file are successfully loaded, non-0 if there is an error.
int TleLoadFile(char* tleFile);


// Saves currently loaded TLEs to a file. 
// tleFile            The name of the file in which to save the TLE's. (in-Character[512])
// saveMode           Specifies whether to create a new file or append to an existing file. (0 = create new file, 1= append to existing file) (in-Integer)
// xf_tleForm         Specifies the format in which to save the file. (0 = two-line element set format, 1 =  CSV, others = future implementation) (in-Integer)
// returns 0 if the data is successfully saved to the file, non-0 if there is an error.
int TleSaveFile(char* tleFile, int saveMode, int xf_tleForm);


// Removes a TLE represented by the satKey from memory. 
// satKey             The unique key of the satellite to be removed. (in-Long)
// returns 0 if the TLE is removed successfully, non-0 if there is an error.
int TleRemoveSat(__int64 satKey);


// Removes all the TLEs from memory.
// returns 0 if all TLE's are removed successfully from memory, non-0 if there is an error.
int TleRemoveAllSats();


// Returns the number of TLEs currently loaded. 
// returns The number of TLEs currently loaded.
int TleGetCount();


// Retrieves all of the currently loaded satKeys. These satKeys can be used to access the internal data for the TLE's.
// order              Specifies the order in which the satKeys should be returned. 0 = sort in ascending order of satKeys, 1 = sort in descending order of satKeys, 2 = sort in the order in which the satKeys were loaded in memory, 9 = Quickest: sort in the order in which the satKeys were stored in the tree (in-Integer)
// satKeys            The array in which to store the satKeys. (out-Long[*])
void TleGetLoaded(int order, __int64* satKeys);


// Adds a TLE (satellite), using its directly specified first and second lines. 
// line1              The first line of a two line element set (or CSV Tle). (in-Character[512])
// line2              The second line of a two line element set (in-Character[512])
// returns The satKey of the newly added TLE on success, a negative value on error.
__int64 TleAddSatFrLines(char* line1, char* line2);


// This function is similar to TleAddSatFrLines but designed to be used in Matlab.
// line1              The first line of a two line element set (or CSV Tle). (in-Character[512])
// line2              The second line of a two line element set (in-Character[512])
// satKey             The satKey of the newly added TLE on success, a negative value on error. (out-Long)
void TleAddSatFrLinesML(char* line1, char* line2, __int64* satKey);


// Adds a TLE (satellite), using its CSV string format. 
// csvLine            Input CSV TLE string (in-Character[512])
// returns The satKey of the newly added TLE on success, a negative value on error.
__int64 TleAddSatFrCsv(char* csvLine);


// This function is similar to TleAddSatFrCsv but designed to be used in Matlab.
// csvLine            Input CSV TLE string (in-Character[512])
// satKey             The satKey of the newly added TLE on success, a negative value on error. (out-Long)
void TleAddSatFrCsvML(char* csvLine, __int64* satKey);


// Adds a GP TLE using its individually provided field values. 
// satNum             Satellite number (in-Integer)
// secClass           Security classification (in-Character)
// satName            Satellite international designator (in-Character[8])
// epochYr            Element epoch time - year, [YY]YY (in-Integer)
// epochDays          Element epoch time - day of year, DDD.DDDDDDDD (in-Double)
// bstar              B* drag term (1/er) (in-Double)
// ephType            Satellite ephemeris type (0: SGP, 2: SGP4) (in-Integer)
// elsetNum           Element set number (in-Integer)
// incli              Orbit inclination (degrees) (in-Double)
// node               Right ascension of ascending node (degrees) (in-Double)
// eccen              Eccentricity (in-Double)
// omega              Argument of perigee (degrees) (in-Double)
// mnAnomaly          Mean anomaly (degrees) (in-Double)
// mnMotion           Mean motion (rev/day) (ephType = 0: Kozai mean motion, ephType = 2: Brouwer mean motion) (in-Double)
// revNum             Revolution number at epoch (in-Integer)
// returns The satKey of the newly added TLE on success, a negative value on error.
__int64 TleAddSatFrFieldsGP(int satNum, char secClass, char* satName, int epochYr, double epochDays, double bstar, int ephType, int elsetNum, double incli, double node, double eccen, double omega, double mnAnomaly, double mnMotion, int revNum);


// This function is similar to TleAddSatFrFieldsGP but includes nDotO2 and n2DotO6. 
// satNum             Satellite number (in-Integer)
// secClass           Security classification (in-Character)
// satName            Satellite international designator (in-Character[8])
// epochYr            Element epoch time - year, [YY]YY (in-Integer)
// epochDays          Element epoch time - day of year, DDD.DDDDDDDD (in-Double)
// bstar              B* drag term (1/er) (in-Double)
// ephType            Satellite ephemeris type (0: SGP, 2: SGP4) (in-Integer)
// elsetNum           Element set number (in-Integer)
// incli              Orbit inclination (degrees) (in-Double)
// node               Right ascension of ascending node (degrees) (in-Double)
// eccen              Eccentricity (in-Double)
// omega              Argument of perigee (degrees) (in-Double)
// mnAnomaly          Mean anomaly (degrees) (in-Double)
// mnMotion           Mean motion (rev/day) (ephType = 0: Kozai mean motion, ephType = 2: Brouwer mean motion) (in-Double)
// revNum             Revolution number at epoch (in-Integer)
// nDotO2             Mean motion derivative (rev/day /2) (in-Double)
// n2DotO6            Mean motion second derivative (rev/day**2 /6) or agom (ephType = 4, XP) (m2/kg) (in-Double)
// returns The satKey of the newly added TLE on success, a negative value on error.
__int64 TleAddSatFrFieldsGP2(int satNum, char secClass, char* satName, int epochYr, double epochDays, double bstar, int ephType, int elsetNum, double incli, double node, double eccen, double omega, double mnAnomaly, double mnMotion, int revNum, double nDotO2, double n2DotO6);


// This function is similar to TleAddSatFrFieldsGP2 but designed to be used in Matlab. 
// satNum             Satellite number (in-Integer)
// secClass           Security classification (in-Character)
// satName            Satellite international designator (in-Character[8])
// epochYr            Element epoch time - year, [YY]YY (in-Integer)
// epochDays          Element epoch time - day of year, DDD.DDDDDDDD (in-Double)
// bstar              B* drag term (1/er) (in-Double)
// ephType            Satellite ephemeris type (0: SGP, 2: SGP4) (in-Integer)
// elsetNum           Element set number (in-Integer)
// incli              Orbit inclination (degrees) (in-Double)
// node               Right ascension of ascending node (degrees) (in-Double)
// eccen              Eccentricity (in-Double)
// omega              Argument of perigee (degrees) (in-Double)
// mnAnomaly          Mean anomaly (degrees) (in-Double)
// mnMotion           Mean motion (rev/day) (ephType = 0: Kozai mean motion, ephType = 2: Brouwer mean motion) (in-Double)
// revNum             Revolution number at epoch (in-Integer)
// nDotO2             Mean motion derivative (rev/day /2) (in-Double)
// n2DotO6            Mean motion second derivative (rev/day**2 /6) or agom (ephType = 4, XP) (m2/kg) (in-Double)
// satKey             The satKey of the newly added TLE on success, a negative value on error. (out-Long)
void TleAddSatFrFieldsGP2ML(int satNum, char secClass, char* satName, int epochYr, double epochDays, double bstar, int ephType, int elsetNum, double incli, double node, double eccen, double omega, double mnAnomaly, double mnMotion, int revNum, double nDotO2, double n2DotO6, __int64* satKey);


// Updates a GP satellite's data in memory by providing its individual field values. Note: satnum, year, day, and ephtype can't be updated.
// satKey             The satellite's unique key (in-Long)
// secClass           Security classification (in-Character)
// satName            Satellite international designator (in-Character[8])
// bstar              B* drag term (1/er) (in-Double)
// elsetNum           Element set number (in-Integer)
// incli              Orbit inclination (degrees) (in-Double)
// node               Right ascension of ascending node (degrees) (in-Double)
// eccen              Eccentricity (in-Double)
// omega              Argument of perigee (degrees) (in-Double)
// mnAnomaly          Mean anomaly (degrees) (in-Double)
// mnMotion           Mean motion  (rev/day) (ephType = 0: Kozai mean motion, ephType = 2: Brouwer mean motion) (in-Double)
// revNum             Revolution number at epoch (in-Integer)
// returns 0 if the TLE is successfully updated, non-0 if there is an error.
int TleUpdateSatFrFieldsGP(__int64 satKey, char secClass, char* satName, double bstar, int elsetNum, double incli, double node, double eccen, double omega, double mnAnomaly, double mnMotion, int revNum);


// This function is similar to TleUpdateSatFrFieldsGP but includes nDotO2 and n2DotO6. Note: satnum, year, day, and ephtype can't be updated.
// satKey             The satellite's unique key (in-Long)
// secClass           Security classification (in-Character)
// satName            Satellite international designator (in-Character[8])
// bstar              B* drag term (1/er) (in-Double)
// elsetNum           Element set number (in-Integer)
// incli              Orbit inclination (degrees) (in-Double)
// node               Right ascension of ascending node (degrees) (in-Double)
// eccen              Eccentricity (in-Double)
// omega              Argument of perigee (degrees) (in-Double)
// mnAnomaly          Mean anomaly (degrees) (in-Double)
// mnMotion           Mean motion  (rev/day) (ephType = 0: Kozai mean motion, ephType = 2: Brouwer mean motion) (in-Double)
// revNum             Revolution number at epoch (in-Integer)
// nDotO2             Mean motion derivative (rev/day /2) (in-Double)
// n2DotO6            Mean motion second derivative (rev/day**2 /6) or agom (ephType = 4, XP) (m2/kg) (in-Double)
// returns 0 if the TLE is successfully updated, non-0 if there is an error.
int TleUpdateSatFrFieldsGP2(__int64 satKey, char secClass, char* satName, double bstar, int elsetNum, double incli, double node, double eccen, double omega, double mnAnomaly, double mnMotion, int revNum, double nDotO2, double n2DotO6);


// Adds an SP satellite using the individually provided field values.
// satNum             Satellite number (in-Integer)
// secClass           Security classification (in-Character)
// satName            Satellite international designator (in-Character[8])
// epochYr            Element epoch time - year, [YY]YY (in-Integer)
// epochDays          Element epoch time - day of year, DDD.DDDDDDDD (in-Double)
// bTerm              Ballistic coefficient (m^2/kg) (in-Double)
// ogParm             Outgassing parameter/Thrust Acceleration (km/s^2) (in-Double)
// agom               Agom (m^2/kg) (in-Double)
// elsetNum           Element set number (in-Integer)
// incli              Orbit inclination (degrees) (in-Double)
// node               Right ascension of ascending node (degrees) (in-Double)
// eccen              Eccentricity (in-Double)
// omega              Argument of perigee (degrees) (in-Double)
// mnAnomaly          Mean anomaly (degrees) (in-Double)
// mnMotion           Mean motion (rev/day) (in-Double)
// revNum             Revolution number at epoch (in-Integer)
// returns The satKey of the newly added TLE on success, a negative value on error.
__int64 TleAddSatFrFieldsSP(int satNum, char secClass, char* satName, int epochYr, double epochDays, double bTerm, double ogParm, double agom, int elsetNum, double incli, double node, double eccen, double omega, double mnAnomaly, double mnMotion, int revNum);


// This function is similar to TleAddSatFrFieldsSP but designed to be used in Matlab.
// satNum             Satellite number (in-Integer)
// secClass           Security classification (in-Character)
// satName            Satellite international designator (in-Character[8])
// epochYr            Element epoch time - year, [YY]YY (in-Integer)
// epochDays          Element epoch time - day of year, DDD.DDDDDDDD (in-Double)
// bTerm              Ballistic coefficient (m^2/kg) (in-Double)
// ogParm             Outgassing parameter/Thrust Acceleration (km/s^2) (in-Double)
// agom               Agom (m^2/kg) (in-Double)
// elsetNum           Element set number (in-Integer)
// incli              Orbit inclination (degrees) (in-Double)
// node               Right ascension of ascending node (degrees) (in-Double)
// eccen              Eccentricity (in-Double)
// omega              Argument of perigee (degrees) (in-Double)
// mnAnomaly          Mean anomaly (degrees) (in-Double)
// mnMotion           Mean motion (rev/day) (in-Double)
// revNum             Revolution number at epoch (in-Integer)
// satKey             The satKey of the newly added TLE on success, a negative value on error. (out-Long)
void TleAddSatFrFieldsSPML(int satNum, char secClass, char* satName, int epochYr, double epochDays, double bTerm, double ogParm, double agom, int elsetNum, double incli, double node, double eccen, double omega, double mnAnomaly, double mnMotion, int revNum, __int64* satKey);


// Updates an SP satellite's data in memory using its individually provided field values. Note: satnum, year, day, and ephtype can't be updated.
// satKey             The satellite's unique key (in-Long)
// secClass           Security classification (in-Character)
// satName            Satellite international designator (in-Character[8])
// bterm              Ballistic coefficient (m^2/kg) (in-Double)
// ogParm             Outgassing parameter/Thrust Acceleration (km/s^2) (in-Double)
// agom               Agom (m^2/kg) (in-Double)
// elsetNum           Element set number (in-Integer)
// incli              Orbit inclination (degrees) (in-Double)
// node               Right ascension of ascending node (degrees) (in-Double)
// eccen              Eccentricity (in-Double)
// omega              Argument of perigee (degrees) (in-Double)
// mnAnomaly          Mean anomaly (degrees) (in-Double)
// mnMotion           Mean motion (rev/day) (in-Double)
// revNum             Revolution number at epoch (in-Integer)
// returns 0 if the TLE is successfully updated, non-0 if there is an error.
int TleUpdateSatFrFieldsSP(__int64 satKey, char secClass, char* satName, double bterm, double ogParm, double agom, int elsetNum, double incli, double node, double eccen, double omega, double mnAnomaly, double mnMotion, int revNum);


// Updates the value of a field of a TLE. This function can be used for both GP and SP satellites.
// satKey             The satellite's unique key. (in-Long)
// xf_Tle             Predefined number specifying which field to set. See remarks. (in-Integer)
// valueStr           The new value of the specified field, expressed as a string. (in-Character[512])
// returns 0 if the TLE is successfully updated, non-0 if there is an error
int TleSetField(__int64 satKey, int xf_Tle, char* valueStr);


// Retrieves the value of a specific field of a TLE. 
// satKey             The satellite's unique key. (in-Long)
// xf_Tle             Predefined number specifying which field to retrieve. See remarks. (in-Integer)
// valueStr           A string to contain the value of the requested field. (out-Character[512])
// returns 0 if the TLE data is successfully retrieved, non-0 if there is an error.
int TleGetField(__int64 satKey, int xf_Tle, char* valueStr);


// Retrieves all of the data for a GP satellite in a single function call. 
// satKey             The satellite's unique key (in-Long)
// satNum             Satellite number (out-Integer)
// secClass           Security classification (out-Character)
// satName            Satellite international designator (out-Character[8])
// epochYr            Element epoch time - year, [YY]YY (out-Integer)
// epochDays          Element epoch time - day of year, DDD.DDDDDDDD (out-Double)
// bstar              B* drag term (1/er) (out-Double)
// ephType            Satellite ephemeris type (0: SGP, 2: SGP4, 6: SP) (out-Integer)
// elsetNum           Element set number (out-Integer)
// incli              Orbit inclination (degrees) (out-Double)
// node               Right ascension of ascending node (degrees) (out-Double)
// eccen              Eccentricity (out-Double)
// omega              Argument of perigee (degrees) (out-Double)
// mnAnomaly          Mean anomaly (deg) (out-Double)
// mnMotion           Mean motion (rev/day) (ephType = 0: Kozai mean motion, ephType = 2: Brouwer mean motion) (out-Double)
// revNum             Revolution number at epoch (out-Integer)
// returns 0 if all values are retrieved successfully, non-0 if there is an error.
int TleGetAllFieldsGP(__int64 satKey, int* satNum, char* secClass, char* satName, int* epochYr, double* epochDays, double* bstar, int* ephType, int* elsetNum, double* incli, double* node, double* eccen, double* omega, double* mnAnomaly, double* mnMotion, int* revNum);


// Retrieves all of the data (including nDotO2 and n2DotO6) for a GP satellite in a single function call. 
// satKey             The satellite's unique key (in-Long)
// satNum             Satellite number (out-Integer)
// secClass           Security classification (out-Character)
// satName            Satellite international designator (out-Character[8])
// epochYr            Element epoch time - year, [YY]YY (out-Integer)
// epochDays          Element epoch time - day of year, DDD.DDDDDDDD (out-Double)
// bstar              B* drag term (1/er) (out-Double)
// ephType            Satellite ephemeris type (0: SGP, 2: SGP4, 6: SP) (out-Integer)
// elsetNum           Element set number (out-Integer)
// incli              Orbit inclination (degrees) (out-Double)
// node               Right ascension of ascending node (degrees) (out-Double)
// eccen              Eccentricity (out-Double)
// omega              Argument of perigee (degrees) (out-Double)
// mnAnomaly          Mean anomaly (degrees) (out-Double)
// mnMotion           Mean motion (rev/day) (ephType = 0: Kozai mean motion, ephType = 2: Brouwer mean motion) (out-Double)
// revNum             Revolution number at epoch (out-Integer)
// nDotO2             Mean motion derivative (rev/day /2) (out-Double)
// n2DotO6            Mean motion second derivative (rev/day**2 /6) or agom (ephType = 4, XP) (m2/kg) (out-Double)
// returns 0 if all values are retrieved successfully, non-0 if there is an error.
int TleGetAllFieldsGP2(__int64 satKey, int* satNum, char* secClass, char* satName, int* epochYr, double* epochDays, double* bstar, int* ephType, int* elsetNum, double* incli, double* node, double* eccen, double* omega, double* mnAnomaly, double* mnMotion, int* revNum, double* nDotO2, double* n2DotO6);


// Retrieves all of the data for an SP satellite in a single function call.
// satKey             The satellite's unique key (in-Long)
// satNum             Satellite number (out-Integer)
// secClass           Security classification (out-Character)
// satName            Satellite international designator (out-Character[8])
// epochYr            Element epoch time - year, [YY]YY (out-Integer)
// epochDays          Element epoch time - day of year, DDD.DDDDDDDD (out-Double)
// bTerm              Ballistic coefficient (m^2/kg) (out-Double)
// ogParm             Outgassing parameter/Thrust Acceleration (km/s^2) (out-Double)
// agom               Agom (m^2/kg) (out-Double)
// elsetNum           Element set number (out-Integer)
// incli              Orbit inclination (degrees) (out-Double)
// node               Right ascension of ascending node (degrees) (out-Double)
// eccen              Eccentricity (out-Double)
// omega              Argument of perigee (degrees) (out-Double)
// mnAnomaly          Mean anomaly (degrees) (out-Double)
// mnMotion           Mean motion (rev/day) (out-Double)
// revNum             Revolution number at epoch (out-Integer)
// returns 0 if all values are retrieved successfully, non-0 if there is an error.
int TleGetAllFieldsSP(__int64 satKey, int* satNum, char* secClass, char* satName, int* epochYr, double* epochDays, double* bTerm, double* ogParm, double* agom, int* elsetNum, double* incli, double* node, double* eccen, double* omega, double* mnAnomaly, double* mnMotion, int* revNum);


// Parses GP data from the input first and second lines of a two line element set.
// line1              The first line of the two line element set. (in-Character[512])
// line2              The second line of the two line element set. (in-Character[512])
// satNum             Satellite number (out-Integer)
// secClass           Security classification (out-Character)
// satName            Satellite international designator (out-Character[8])
// epochYr            Element epoch time - year, [YY]YY (out-Integer)
// epochDays          Element epoch time - day of year, DDD.DDDDDDDD (out-Double)
// nDotO2             n-dot/2 (for SGP, ephType = 0) (out-Double)
// n2DotO6            n-double-dot/6 (for SGP, ephType = 0) or agom (ephType = 4, XP) (m2/kg) (out-Double)
// bstar              B* drag term (1/er) (out-Double)
// ephType            Satellite ephemeris type (0: SGP, 2: SGP4, 6: SP) (out-Integer)
// elsetNum           Element set number (out-Integer)
// incli              Orbit inclination (degrees) (out-Double)
// node               Right ascension of ascending node (degrees). (out-Double)
// eccen              Eccentricity (out-Double)
// omega              Argument of perigee (degrees) (out-Double)
// mnAnomaly          Mean anomaly (degrees) (out-Double)
// mnMotion           Mean motion (rev/day) (ephType = 0: Kozai mean motion, ephType = 2: Brouwer mean motion) (out-Double)
// revNum             Revolution number at epoch (out-Integer)
// returns 0 if the TLE is parsed successfully, non-0 if there is an error.
int TleParseGP(char* line1, char* line2, int* satNum, char* secClass, char* satName, int* epochYr, double* epochDays, double* nDotO2, double* n2DotO6, double* bstar, int* ephType, int* elsetNum, double* incli, double* node, double* eccen, double* omega, double* mnAnomaly, double* mnMotion, int* revNum);


// Parses GP data from the input first and second lines of a two line element set and store that data back into the output parameters.
// line1              The first line of the two line element set (or CSV Tle). (in-Character[512])
// line2              The second line of the two line element set (in-Character[512])
// xa_tle             Array containing TLE's numerical fields, see XA_TLE_? for array arrangement (out-Double[64])
// xs_tle             Output string that contains all TLE's text fields, see XS_TLE_? for column arrangement (out-Character[512])
// returns 0 if the TLE is parsed successfully, non-0 if there is an error.
int TleLinesToArray(char* line1, char* line2, double* xa_tle, char* xs_tle);


// Parses SP data from the input first and second lines of a two line element set.
// line1              The first line of the two line element set (or CSV Tle). (in-Character[512])
// line2              The second line of the two line element set. (in-Character[512])
// satNum             Satellite number (out-Integer)
// secClass           Security classification (out-Character)
// satName            Satellite international designator (out-Character[8])
// epochYr            Element epoch time - year, [YY]YY (out-Integer)
// epochDays          Element epoch time - day of year, DDD.DDDDDDDD (out-Double)
// bTerm              Ballistic coefficient (m^2/kg). (out-Double)
// ogParm             Outgassing parameter/Thrust Acceleration (km/s^2) (out-Double)
// agom               Agom (m^2/kg) (out-Double)
// elsetNum           Element set number (out-Integer)
// incli              Orbit inclination (degrees) (out-Double)
// node               Right ascension of ascending node (degrees) (out-Double)
// eccen              Eccentricity (out-Double)
// omega              Argument of perigee (degrees) (out-Double)
// mnAnomaly          Mean anomaly (degrees) (out-Double)
// mnMotion           Mean motion (rev/day) (out-Double)
// revNum             Revolution number at epoch (out-Integer)
// returns 0 if the TLE is parsed successfully, non-0 if there is an error.
int TleParseSP(char* line1, char* line2, int* satNum, char* secClass, char* satName, int* epochYr, double* epochDays, double* bTerm, double* ogParm, double* agom, int* elsetNum, double* incli, double* node, double* eccen, double* omega, double* mnAnomaly, double* mnMotion, int* revNum);


// Returns the first and second lines representation of a TLE of a satellite. 
// satKey             The satellite's unique key. (in-Long)
// line1              A string to hold the first line of the TLE (out-Character[512])
// line2              A string to hold the second line of the TLE (out-Character[512])
// returns 0 if successful, non-0 on error.
int TleGetLines(__int64 satKey, char* line1, char* line2);


// Returns the CSV string representation of a TLE of a satellite. 
// satKey             The satellite's unique key. (in-Long)
// csvLine            A string to hold the TLE in csv format. (out-Character[512])
// returns 0 if successful, non-0 on error.
int TleGetCsv(__int64 satKey, char* csvLine);


// Constructs a TLE from individually provided GP data fields.
// satNum             Satellite number (in-Integer)
// secClass           Security classification (in-Character)
// satName            Satellite international designator (in-Character[8])
// epochYr            Element epoch time - year, [YY]YY (in-Integer)
// epochDays          Element epoch time - day of year, DDD.DDDDDDDD (in-Double)
// nDotO2             N Dot/2 (rev/day /2) (in-Double)
// n2DotO6            N Double Dot/6 (rev/day**2 /6) or agom (ephType = 4, XP) (m2/kg) (in-Double)
// bstar              B* drag term (1/er) (in-Double)
// ephType            Satellite ephemeris type (0: SGP, 2: SGP4) (in-Integer)
// elsetNum           Element set number (in-Integer)
// incli              Orbit inclination (degrees) (in-Double)
// node               Right ascension of ascending node (degrees) (in-Double)
// eccen              Eccentricity (in-Double)
// omega              Argument of perigee (degrees) (in-Double)
// mnAnomaly          Mean anomaly (degrees) (in-Double)
// mnMotion           Mean motion (rev/day) (ephType = 0: Kozai mean motion, ephType = 2: Brouwer mean motion) (in-Double)
// revNum             Revolution number at epoch (in-Integer)
// line1              Returned first line of a TLE. (out-Character[512])
// line2              Returned second line of a TLE. (out-Character[512])
void TleGPFieldsToLines(int satNum, char secClass, char* satName, int epochYr, double epochDays, double nDotO2, double n2DotO6, double bstar, int ephType, int elsetNum, double incli, double node, double eccen, double omega, double mnAnomaly, double mnMotion, int revNum, char* line1, char* line2);


// Constructs a TLE from GP data stored in the input parameters.
// xa_tle             Array containing TLE's numerical fields, see XA_TLE_? for array arrangement (in-Double[64])
// xs_tle             Input string that contains all TLE's text fields, see XS_TLE_? for column arrangement (in-Character[512])
// line1              Returned first line of a TLE (out-Character[512])
// line2              Returned second line of a TLE (out-Character[512])
void TleGPArrayToLines(double* xa_tle, char* xs_tle, char* line1, char* line2);


// Constructs a TLE from individually provided SP data fields.
// satNum             Satellite number (in-Integer)
// secClass           Security classification (in-Character)
// satName            Satellite international designator (in-Character[8])
// epochYr            Element epoch time - year, [YY]YY (in-Integer)
// epochDays          Element epoch time - day of year, DDD.DDDDDDDD (in-Double)
// bTerm              Ballistic coefficient (m^2/kg) (in-Double)
// ogParm             Outgassing parameter/Thrust Acceleration (km/s^2) (in-Double)
// agom               Agom (m^2/kg) (in-Double)
// elsetNum           Element set number (in-Integer)
// incli              Orbit inclination (degrees) (in-Double)
// node               Right ascension of ascending node (degrees) (in-Double)
// eccen              Eccentricity (in-Double)
// omega              Argument of perigee (degrees) (in-Double)
// mnAnomaly          Mean anomaly (degrees) (in-Double)
// mnMotion           Mean motion (rev/day) (in-Double)
// revNum             Revolution number at epoch (in-Integer)
// line1              Returned first line of a TLE. (out-Character[512])
// line2              Returned second line of a TLE. (out-Character[512])
void TleSPFieldsToLines(int satNum, char secClass, char* satName, int epochYr, double epochDays, double bTerm, double ogParm, double agom, int elsetNum, double incli, double node, double eccen, double omega, double mnAnomaly, double mnMotion, int revNum, char* line1, char* line2);


// Returns the first satKey from the currently loaded set of TLEs that contains the specified satellite number.
// satNum             Satellite number (in-Integer)
// returns The satellite's unique key
__int64 TleGetSatKey(int satNum);


// This function is similar to TleGetSatKey but designed to be used in Matlab. 
// satNum             Satellite number (in-Integer)
// satKey             The satKey of the satellite if a satellite with the requested number is found in the set of loaded satellites, a negative value if there is an error. (out-Long)
void TleGetSatKeyML(int satNum, __int64* satKey);


// Computes a satKey from the input data.
// satNum             Satellite number (in-Integer)
// epochYr            Element epoch time - year, [YY]YY (in-Integer)
// epochDays          Element epoch time - day of year, DDD.DDDDDDDD (in-Double)
// ephType            Ephemeris type (in-Integer)
// returns The resulting satellite key if the computation is successful; a negative value if there is an error.
__int64 TleFieldsToSatKey(int satNum, int epochYr, double epochDays, int ephType);


// This function is similar to TleFieldsToSatKey but designed to be used in Matlab. 
// satNum             Satellite number (in-Integer)
// epochYr            Element epoch time - year, [YY]YY (in-Integer)
// epochDays          Element epoch time - day of year, DDD.DDDDDDDD (in-Double)
// ephType            Ephemeris type (in-Integer)
// satKey             The satKey if the computation is successful, a negative value if there is an error. (out-Long)
void TleFieldsToSatKeyML(int satNum, int epochYr, double epochDays, int ephType, __int64* satKey);


// Adds a TLE (satellite), using its data stored in the input parameters.
// xa_tle             Array containing TLE's numerical fields, see XA_TLE_? for array arrangement (in-Double[64])
// xs_tle             Input string that contains all TLE's text fields, see XS_TLE_? for column arrangement (in-Character[512])
// returns The satKey of the newly added TLE on success, a negative value on error.
__int64 TleAddSatFrArray(double* xa_tle, char* xs_tle);


// This function is similar to TleAddSatFrArray but designed to be used in Matlab. 
// xa_tle             Array containing TLE's numerical fields, see XA_TLE_? for array arrangement (in-Double[64])
// xs_tle             Input string that contains all TLE's text fields, see XS_TLE_? for column arrangement (in-Character[512])
// satKey             The satKey of the newly added TLE on success, a negative value on error. (out-Long)
void TleAddSatFrArrayML(double* xa_tle, char* xs_tle, __int64* satKey);


// Updates existing TLE data with the provided new data stored in the input parameters. Note: satnum, year, day, and ephtype can't be updated.
// satKey             The satellite's unique key (in-Long)
// xa_tle             Array containing TLE's numerical fields, see XA_TLE_? for array arrangement (in-Double[64])
// xs_tle             Input string that contains all TLE's text fields, see XS_TLE_? for column arrangement (in-Character[512])
// returns 0 if the TLE is successfully updated, non-0 if there is an error.
int TleUpdateSatFrArray(__int64 satKey, double* xa_tle, char* xs_tle);


// Retrieves TLE data and stored it in the passing parameters
// satKey             The satellite's unique key (in-Long)
// xa_tle             Array containing TLE's numerical fields, see XA_TLE_? for array arrangement (out-Double[64])
// xs_tle             Output string that contains all TLE's text fields, see XS_TLE_? for column arrangement (out-Character[512])
// returns 0 if all values are retrieved successfully, non-0 if there is an error
int TleDataToArray(__int64 satKey, double* xa_tle, char* xs_tle);


// Converts TLE two line format to CSV format
// line1              The first line of a two line element set (in-Character[512])
// line2              The second line of a two line element set (in-Character[512])
// csvline            A string to hold the TLE in csv format. (out-Character[512])
// returns 0 if the conversion is successful, non-0 if there is an error.
int TleLinesToCsv(char* line1, char* line2, char* csvline);


// Converts TLE CSV format to two line format
// csvLine            The input TLE in CSV format (in-Character[512])
// newSatno           New satellite number to replace what's in CSV obs if desired (won't use/renumber if it's zero) (in-Integer)
// line1              The output first line of the two line element set (out-Character[512])
// line2              The output second line of the two line element set (out-Character[512])
// returns 0 if the conversion is successful, non-0 if there is an error.
int TleCsvToLines(char* csvLine, int newSatno, char* line1, char* line2);

// TLE types (TLE ephemeris types) - They are different than ELTTYPE
static const int  
   TLETYPE_SGP  = 0,    // TLE SGP elset (Kozai mean motion)
   TLETYPE_SGP4 = 2,    // TLE SGP4 elset (Brouwer mean motion)
   TLETYPE_XP   = 4,    // TLE SGP4-XP elset (Brouwer mean motion)
   TLETYPE_SP   = 6;    // TLE SP elset (osculating elements)

// Indexes of TLE data fields
static const int  
   XF_TLE_SATNUM     =  1,    // Satellite number
   XF_TLE_CLASS      =  2,    // Security classification U: unclass, C: confidential, S: Secret
   XF_TLE_SATNAME    =  3,    // Satellite name A8
   XF_TLE_EPOCH      =  4,    // Satellite's epoch time "YYYYJJJ.jjjjjjjj"
   XF_TLE_BSTAR      =  5,    // GP B* drag term (1/er)  (not the same as XF_TLE_BTERM) 
   XF_TLE_EPHTYPE    =  6,    // Satellite ephemeris type: 0=SGP, 2=SGP4, 6=SP
   XF_TLE_ELSETNUM   =  7,    // Element set number
   XF_TLE_INCLI      =  8,    // Orbit inclination (deg)
   XF_TLE_NODE       =  9,    // Right ascension of asending node (deg)
   XF_TLE_ECCEN      = 10,    // Eccentricity
   XF_TLE_OMEGA      = 11,    // Argument of perigee (deg)
   XF_TLE_MNANOM     = 12,    // Mean anomaly (deg)
   XF_TLE_MNMOTN     = 13,    // Mean motion (rev/day) (ephType=0: Kozai, ephType=2: Brouwer)
   XF_TLE_REVNUM     = 14,    // Revolution number at epoch 
   
   XF_TLE_NDOT       = 15,    // GP Mean motion derivative (rev/day /2)
   XF_TLE_NDOTDOT    = 16,    // GP Mean motion second derivative (rev/day**2 /6)
   XF_TLE_AGOMGP     = 16,    // Solar radiation pressure GP (m2/kg)

   XF_TLE_SP_AGOM    =  5,    // SP Radiation Pressure Coefficient
   XF_TLE_SP_BTERM   = 15,    // SP ballistic coefficient (m2/kg)
   XF_TLE_SP_OGPARM  = 16,    // SP outgassing parameter (km/s2)

   XF_TLE_ORGSATNUM  = 17,    // Original satellite number
   XF_TLE_BTERM      = 18,    // GP ballistic coefficient (m2/kg) (not the same as XF_TLE_BSTAR)
   XF_TLE_OBSTIME    = 19,    // Time of last observation relative to epoch +/- fractional days
   XF_TLE_EGR        = 20,    // Last calculated error growth rate (km/day)
   XF_TLE_EDR        = 21,    // Last calculated energy dissipation rate (w/kg)
   XF_TLE_VISMAG     = 22,    // Median Vismag 
   XF_TLE_RCS        = 23,    // Median RCS - diameter in centimeters (cm)
   XF_TLE_OBJTYPE    = 24,    // Object Type (Payload, Rocket Body, Platform, Debris, Unknown)
   XF_TLE_SATNAME_12 = 25;    // Satellite name A12 (upto 12 character long)
   
   
// Indexes of TLE numerical data in an array
static const int  
   // Line 1
   XA_TLE_SATNUM        =  0,    // Satellite number
   XA_TLE_EPOCH         =  1,    // Satellite's epoch time in DS50UTC
   XA_TLE_NDOT          =  2,    // GP Mean motion derivative (rev/day /2)
   XA_TLE_NDOTDOT       =  3,    // GP Mean motion second derivative (rev/day**2 /6)
   XA_TLE_BSTAR         =  4,    // GP B* drag term (1/er)  
   XA_TLE_EPHTYPE       =  5,    // Satellite ephemeris type: 0=SGP, 2=SGP4, 4=SGP4-XP, 6=SP
   
   // Line 2
   XA_TLE_INCLI         = 20,    // Orbit inclination (deg)
   XA_TLE_NODE          = 21,    // Right ascension of asending node (deg)
   XA_TLE_ECCEN         = 22,    // Eccentricity
   XA_TLE_OMEGA         = 23,    // Argument of perigee (deg)
   XA_TLE_MNANOM        = 24,    // Mean anomaly (deg)
   XA_TLE_MNMOTN        = 25,    // Mean motion (rev/day) (ephType=0, 4: Kozai, ephType=2: Brouwer)
   XA_TLE_REVNUM        = 26,    // Revolution number at epoch 
   XA_TLE_ELSETNUM      = 30,    // Element set number
   
   // CSV (or TLE-XP, ephemType=4) specific fields 
   XA_TLE_ORGSATNUM     = 31,    // Original satellite number
   XA_TLE_BTERM         = 32,    // SP/SGP4-XP ballistic coefficient (m2/kg) 
   XA_TLE_OBSTIME       = 33,    // Time of last observation relative to epoch +/- fractional days
   XA_TLE_EGR           = 34,    // Last calculated error growth rate (km/day)
   XA_TLE_EDR           = 35,    // Last calculated energy dissipation rate (w/kg)
   XA_TLE_VISMAG        = 36,    // Median Vismag 
   XA_TLE_RCS           = 37,    // Median RCS - diameter in centimeters (cm)

   // CSV (or TLE-XP, ephemType=4)
   XA_TLE_AGOMGP        = 38,    // Solar Radiation Pressure Coefficient GP (m2/kg)

   
   // SP specific fields
   XA_TLE_SP_BTERM      =  2,    // SP ballistic coefficient (m2/kg)
   XA_TLE_SP_OGPARM     =  3,    // SP outgassing parameter (km/s2)
   XA_TLE_SP_AGOM       =  4,    // SP Radiation Pressure Coefficient
   
   XA_TLE_SIZE          = 64;

// Indexes of TLE text data in an array of chars
static const int  
   XS_TLE_SECCLASS_1   =  0,    // Security classification of line 1 and line 2
   XS_TLE_SATNAME_12   =  1,    // Satellite name
   XS_TLE_OBJTYPE_11   = 13,    // Object Type (Payload, Rocket Body, Platform, Debris, Unknown)
   
   
   XS_TLE_SIZE         = 512;      
   
// Indexes of different TLE file's formats
static const int  
   XF_TLEFORM_ORG    =  0,    // Original TLE format
   XF_TLEFORM_CSV    =  1;    // CSV format
   
   



// ========================= End of auto generated code ==========================
