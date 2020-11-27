// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// Initializes Obs DLL for use in the program
// apPtr              The handle that was returned from DllMainInit() (in-Long)
// returns 0 if Obs.dll is initialized successfully, non-0 if there is an error
int ObsInit(__int64 apPtr);


// Returns information about the current version of Obs DLL. 
// infoStr            A string to hold the information about Obs.dll (out-Character[128])
void ObsGetInfo(char* infoStr);


// Sets the year for transmission observation format (TTY) input files
// ttyYear            2 or 4 digits year (in-Integer)
void ObsSetTTYYear(int ttyYear);


// Loads observation data from an input text file
// obsFile            The name of the file containing obs-related data (in-Character[512])
// returns 0 if the input file is read successfully, non-0 if there is an error
int ObsLoadFile(char* obsFile);


// Saves the currently loaded obs data to a file
// obsFile            The name of the file in which to save the loaded obs (in-Character[512])
// saveMode           Specifies whether to create a new file or append to an existing one (0 = create, 1= append) (in-Integer)
// obsForm            Specifies the mode in which to save the file (0 = B3 format, 1 = TTY, 2 = CSV) (in-Integer)
// returns 0 if the data is successfully saved to the file, non-0 if there is an error
int ObsSaveFile(char* obsFile, int saveMode, int obsForm);


// Removes an obs, represented by the obsKey, from the set of currently loaded observations
// obsKey             The observation's unique key (in-Long)
// returns 0 if the observation is successfully removed, non-0 if there is an error
int ObsRemove(__int64 obsKey);


// Removes all currently loaded observations from memory
// returns 0 if all the loaded observations are removed successfully, non-0 if there is an error
int ObsRemoveAll();


// Returns the number of observations currently loaded
// returns the number of observations currently loaded
int ObsGetCount();


// Retrieves all of the currently loaded obsKeys. These obsKeys can be used to access the internal data for the observations
// order              Specifies the order in which the obsKeys should be returned (in-Integer)
// obsKeys            The array in which to store the obsKeys (out-Long[*])
void ObsGetLoaded(int order, __int64* obsKeys);


// Loads a single observation-typed card
// card               Any single observation-typed card (B3, B3E, TTY, ...) but not OBSFIL= (in-Character[512])
// returns 0 if the input card is read successfully, non-0 if there is an error
int ObsLoadCard(char* card);


// Loads a one-line or two-line observation 
// card1              Any single observation-typed card (B3, B3E, TTY, ...) or Card #1 of TTY obs type 4, 7, 8, 9 (in-Character[512])
// card2              Card #2 of TTY obs type 4, 7, 8, 9 (in-Character[512])
// returns 0 if the input card1/card2 are read successfully, non-0 if there is an error
int ObsLoadTwoCards(char* card1, char* card2);


// Adds an observation from a string in B3 observation format
// card               The input string in B3 observation format (in-Character[512])
// returns The obsKey of the newly added observation on success, a negative value on error
__int64 ObsAddFrB3Card(char* card);


// Works like ObsAddFrB3Card but designed for Matlab
// card               The input string in B3 observation format (in-Character[512])
// obsKey             The obsKey of the newly added observation on success, a negative value on error (out-Long)
void ObsAddFrB3CardML(char* card, __int64* obsKey);


// Converts B3 format to csv format without loading B3 obs into memory
// card               The input string in B3 observation format (in-Character[512])
// csvLine            The output string in csv observation format (out-Character[512])
// returns 0 if the conversion is successful, non-0 if there is an error
int ObsB3ToCsv(char* card, char* csvLine);


// Converts CSV format to B3 format without loading CSV obs into memory
// csvLine            The input string in csv observation format (in-Character[512])
// newSatno           New satellite number to replace what's in CSV obs if desired (value of zero does not renumber) (in-Integer)
// card               The output string in B3 observation format (out-Character[512])
// returns 0 if the conversion is successful, non-0 if there is an error
int ObsCsvToB3(char* csvLine, int newSatno, char* card);


// Adds an observation from a TTY (1 line or 2 lines) observation format
// card1              Card #1 of a TTY obs (in-Character[512])
// card2              Card #2 of TTY obs type 4, 7, 8, 9 or an empty string for other TTY obs types (in-Character[512])
// returns The obsKey of the newly added observation on success, a negative value on error
__int64 ObsAddFrTTYCards(char* card1, char* card2);


// Works like ObsAddFrTTYCards but designed for Matlab
// card1              Card #1 of a TTY obs (in-Character[512])
// card2              Card #2 of TTY obs type 4, 7, 8, 9 or an empty string for other TTY obs types (in-Character[512])
// obsKey             The obsKey of the newly added observation on success, a negative value on error (out-Long)
void ObsAddFrTTYCardsML(char* card1, char* card2, __int64* obsKey);


// Converts TTY format to CSV format without loading TTY obs into memory
// card1              Card #1 of a TTY obs (in-Character[512])
// card2              Card #2 of TTY obs type 4, 7, 8, 9 or an empty string for other TTY obs types (in-Character[512])
// csvLine            The obs in csv format (out-Character[512])
// returns 0 if the conversion is successful, non-0 if there is an error
int ObsTTYToCsv(char* card1, char* card2, char* csvLine);


// Converts CSV format to TTY format without loading CSV obs into memory
// csvLine            The obs in csv format (in-Character[512])
// newSatno           New satellite number to replace what's in CSV obs if desired (value of zero does not renumber) (in-Integer)
// card1              Card #1 of a TTY obs (out-Character[512])
// card2              Card #2 of TTY obs type 4, 7, 8, 9 or an empty string for other TTY obs types (out-Character[512])
// returns 0 if the conversion is successful, non-0 if there is an error
int ObsCsvToTTY(char* csvLine, int newSatno, char* card1, char* card2);


// Adds one observation using csv obs string 
// csvLine            Input csv obs string (in-Character[512])
// returns The obsKey of the newly added observation on success, a negative value on error
__int64 ObsAddFrCsv(char* csvLine);


// Adds one observation using csv obs string - for MatLab
// csvLine            Input csv obs string (in-Character[512])
// obsKey             The obsKey of the newly added observation on success, a negative value on error (out-Long)
void ObsAddFrCsvML(char* csvLine, __int64* obsKey);


// Adds one observation using its input data. Depending on the observation type, some input data might be unavailable and left blank
// secClass           security classification (in-Character)
// satNum             satellite number (in-Integer)
// senNum             sensor number (in-Integer)
// obsTimeDs50UTC     observation time in days since 1950 UTC (in-Double)
// elOrDec            elevation or declination (deg) (in-Double)
// azOrRA             azimuth or right-ascension (deg) (in-Double)
// range              range (km) (in-Double)
// rangeRate          range rate (km/s), or equinox indicator (0-3) for obs type 5/9 (in-Double)
// elRate             elevation rate (deg/s) (in-Double)
// azRate             azimuth rate (deg/s) (in-Double)
// rangeAccel         range acceleration (km/s^2) (in-Double)
// obsType            observation type (in-Character)
// trackInd           track position indicator (3=start track ob, 4=in track ob, 5=end track ob) (in-Integer)
// ASTAT              association status assigned by SPADOC (in-Integer)
// siteTag            original satellite number (in-Integer)
// spadocTag          SPADOC-asssigned tag number (in-Integer)
// pos                position XYZ (km) (ECI or EFG) (in-Double[3])
// vel                velocity XYZ (km/s) (ECI or EFG) (in-Double[3])
// extArr             extra array - future use (in-Double[128])
// returns The obsKey of the newly added observation on success, a negative value on error
__int64 ObsAddFrFields(char secClass, int satNum, int senNum, double obsTimeDs50UTC, double elOrDec, double azOrRA, double range, double rangeRate, double elRate, double azRate, double rangeAccel, char obsType, int trackInd, int ASTAT, int siteTag, int spadocTag, double* pos, double* vel, double* extArr);


// Works like ObsAddFrFields but designed for Matlab
// secClass           security classification (in-Character)
// satNum             satellite number (in-Integer)
// senNum             sensor number (in-Integer)
// obsTimeDs50UTC     observation time in days since 1950 UTC (in-Double)
// elOrDec            elevation or declination (deg) (in-Double)
// azOrRA             azimuth or right-ascension (deg) (in-Double)
// range              range (km) (in-Double)
// rangeRate          range rate (km/s), or equinox indicator (0-3) for obs type 5/9 (in-Double)
// elRate             elevation rate (deg/s) (in-Double)
// azRate             azimuth rate (deg/s) (in-Double)
// rangeAccel         range acceleration (km/s^2) (in-Double)
// obsType            observation type (in-Character)
// trackInd           track position indicator (3=start track ob, 4=in track ob, 5=end track ob) (in-Integer)
// ASTAT              association status assigned by SPADOC (in-Integer)
// siteTag            original satellite number (in-Integer)
// spadocTag          SPADOC-asssigned tag number (in-Integer)
// pos                position XYZ (km) (ECI or EFG) (in-Double[3])
// vel                velocity XYZ (km/s) (ECI or EFG) (in-Double[3])
// extArr             extra array - future use (in-Double[128])
// obsKey             The obsKey of the newly added observation on success, a negative value on error (out-Long)
void ObsAddFrFieldsML(char secClass, int satNum, int senNum, double obsTimeDs50UTC, double elOrDec, double azOrRA, double range, double rangeRate, double elRate, double azRate, double rangeAccel, char obsType, int trackInd, int ASTAT, int siteTag, int spadocTag, double* pos, double* vel, double* extArr, __int64* obsKey);


// Adds one observation using its input data stored in an array. Depending on the observation type, some input data might be unavailable and left blank
// xa_obs             Array containing observation data, see XA_OBS_? for array arrangement (in-Double[64])
// returns The obsKey of the newly added observation on success, a negative value on error
__int64 ObsAddFrArray(double* xa_obs);


// Works like ObsAddFrArray but designed for Matlab
// xa_obs             Array containing observation data, see XA_OBS_? for array arrangement (in-Double[64])
// obsKey             The obsKey of the newly added observation on success, a negative value on error (out-Long)
void ObsAddFrArrayML(double* xa_obs, __int64* obsKey);


// Retrieves all observation data in a single function call. Depending on the observation type, some input data might be unavailable
// obsKey             The unique key of the requested observation (in-Long)
// secClass           security classification (out-Character)
// satNum             satellite number (out-Integer)
// senNum             sensor number (out-Integer)
// obsTimeDs50UTC     observation time in days since 1950 UTC (out-Double)
// elOrDec            elevation or declination (deg) (out-Double)
// azOrRA             azimuth or right-ascension (deg) (out-Double)
// range              range (km) (out-Double)
// rangeRate          range rate (km/s) (out-Double)
// elRate             elevation rate (deg/s) (out-Double)
// azRate             azimuth rate (deg/s) (out-Double)
// rangeAccel         range acceleration (km/s^2) (out-Double)
// obsType            observation type (out-Character)
// trackInd           track position indicator (3=start track ob, 4=in track ob, 5=end track ob) (out-Integer)
// ASTAT              association status assigned by SPADOC (out-Integer)
// siteTag            original satellite number (out-Integer)
// spadocTag          SPADOC-asssigned tag number (out-Integer)
// pos                position XYZ (km) (ECI or EFG) (out-Double[3])
// vel                velocity XYZ (km/s) (ECI or EFG) (out-Double[3])
// extArr             extra array - future use (out-Double[128])
// returns 0 if all values are retrieved successfully, non-0 if there is an error
int ObsGetAllFields(__int64 obsKey, char* secClass, int* satNum, int* senNum, double* obsTimeDs50UTC, double* elOrDec, double* azOrRA, double* range, double* rangeRate, double* elRate, double* azRate, double* rangeAccel, char* obsType, int* trackInd, int* ASTAT, int* siteTag, int* spadocTag, double* pos, double* vel, double* extArr);


// Retrieves observation data and stored it in the passing array. Depending on the observation type, some data fields might be unavailable
// obsKey             The unique key of the requested observation (in-Long)
// xa_obs             The array containing observation data, see XA_OBS_? for array arrangement (out-Double[64])
// returns 0 if all values are retrieved successfully, non-0 if there is an error
int ObsDataToArray(__int64 obsKey, double* xa_obs);


// Updates existing observation data with the provided new data
// obsKey             The unique key of the requested observation (in-Long)
// secClass           security classification (in-Character)
// elOrDec            elevation or declination (deg) (in-Double)
// azOrRA             azimuth or right-ascension (deg) (in-Double)
// range              range (km) (in-Double)
// rangeRate          range rate (km/s) (in-Double)
// elRate             elevation rate (deg/s) (in-Double)
// azRate             azimuth rate (deg/s) (in-Double)
// rangeAccel         range acceleration (km/s^2) (in-Double)
// obsType            observation type (in-Character)
// trackInd           track position indicator (3=start track ob, 4=in track ob, 5=end track obs) (in-Integer)
// ASTAT              association status assigned by SPADOC (in-Integer)
// siteTag            original satellite number (in-Integer)
// spadocTag          SPADOC-asssigned tag number (in-Integer)
// pos                position XYZ (km) (ECI or EFG) (in-Double[3])
// vel                velocity XYZ (km/s) (ECI or EFG) (in-Double[3])
// extArr             extra array - future use (in-Double[128])
// returns 0 if the requested observation is successfully updated, non-0 if there is an error
int ObsUpdateFrFields(__int64 obsKey, char secClass, double elOrDec, double azOrRA, double range, double rangeRate, double elRate, double azRate, double rangeAccel, char obsType, int trackInd, int ASTAT, int siteTag, int spadocTag, double* pos, double* vel, double* extArr);


// Retrieves the value of a specific field of an observation
// obsKey             The observation's unique key (in-Long)
// xf_Obs             The predefined number specifying which field to retrieve, see XF_OBS_? for field specification (in-Integer)
// strValue           A string to contain the value of the requested field (out-Character[512])
// returns 0 if the observation data is successfully retrieved, non-0 if there is an error
int ObsGetField(__int64 obsKey, int xf_Obs, char* strValue);


// Updates the value of a field of an observation
// obsKey             The observation's unique key (in-Long)
// xf_Obs             The predefined number specifying which field to update, see XF_OBS_? for field specification (in-Integer)
// strValue           The new value of the specified field, expressed as a string (in-Character[512])
// returns 0 if the observation is successfully updated, non-0 if there is an error
int ObsSetField(__int64 obsKey, int xf_Obs, char* strValue);


// Returns observation in B3-card string
// obsKey             The observation's unique key (in-Long)
// b3Card             A string to hold the B3 observation format (out-Character[512])
// returns 0 if successful, non-0 on error
int ObsGetB3Card(__int64 obsKey, char* b3Card);


// Returns observation in TTY-card string
// obsKey             The observation's unique key (in-Long)
// ttyCard1           first line of a TTY card (out-Character[512])
// ttyCard2           second line of a TTY card (might be unavailable for certain obs type) (out-Character[512])
// returns 0 if successful, non-0 on error
int ObsGetTTYCard(__int64 obsKey, char* ttyCard1, char* ttyCard2);


// Returns observation in CSV-format string
// obsKey             The observation's unique key (in-Long)
// csvline            A string to hold the CSV observation format (out-Character[512])
// returns 0 if successful, non-0 on error
int ObsGetCsv(__int64 obsKey, char* csvline);


// Constructs a B3-card string from the input observation data fields
// secClass           security classification (in-Character)
// satNum             satellite number (in-Integer)
// senNum             sensor number (in-Integer)
// obsTimeDs50UTC     observation time in days since 1950 UTC (in-Double)
// elOrDec            elevation or declination (deg) (in-Double)
// azOrRA             azimuth or right-ascension (deg) (in-Double)
// range              range (km) (in-Double)
// rangeRate          range rate (km/s) (in-Double)
// elRate             elevation rate (deg/s) (in-Double)
// azRate             azimuth rate (deg/s) (in-Double)
// rangeAccel         range acceleration (km/s^2) (in-Double)
// obsType            observation type (in-Character)
// trackInd           track position indicator (3=start track ob, 4=in track ob, 5=end track ob) (in-Integer)
// ASTAT              association status assigned by SPADOC (in-Integer)
// siteTag            original satellite number (in-Integer)
// spadocTag          SPADOC-asssigned tag number (in-Integer)
// pos                position XYZ (km) (ECI or EFG) (in-Double[3])
// b3Card             A string to hold the B3 observation format (out-Character[512])
void ObsFieldsToB3Card(char secClass, int satNum, int senNum, double obsTimeDs50UTC, double elOrDec, double azOrRA, double range, double rangeRate, double elRate, double azRate, double rangeAccel, char obsType, int trackInd, int ASTAT, int siteTag, int spadocTag, double* pos, char* b3Card);


// Constructs a TTY-card string from the input observation data fields
// secClass           security classification (in-Character)
// satNum             satellite number (in-Integer)
// senNum             sensor number (in-Integer)
// obsTimeDs50UTC     observation time in days since 1950 UTC (in-Double)
// elOrDec            elevation or declination (deg) (in-Double)
// azOrRA             azimuth or right-ascension (deg) (in-Double)
// range              range (km) (in-Double)
// rangeRate          range rate (km/s) (in-Double)
// elRate             elevation rate (deg/s) (in-Double)
// azRate             azimuth rate (deg/s) (in-Double)
// rangeAccel         range acceleration (km/s^2) (in-Double)
// obsType            observation type (in-Character)
// pos                position XYZ (km) (ECI or EFG) (in-Double[3])
// ttyCard1           first line of a TTY card (out-Character[512])
// ttyCard2           second line of a TTY card (might be unavailable for certain obs type) (out-Character[512])
void ObsFieldsToTTYCard(char secClass, int satNum, int senNum, double obsTimeDs50UTC, double elOrDec, double azOrRA, double range, double rangeRate, double elRate, double azRate, double rangeAccel, char obsType, double* pos, char* ttyCard1, char* ttyCard2);


// Computes an obsKey from individually provided fields
// satNum             input satellite's number (in-Integer)
// senNum             input sensor's number (in-Integer)
// obsTimeDs50UTC     input observation time in days since 1950, UTC (in-Double)
// returns The newly created observation Key
__int64 ObsFieldsToObsKey(int satNum, int senNum, double obsTimeDs50UTC);


// Works like ObsFieldsToObsKey but designed for Matlab
// satNum             input satellite's number (in-Integer)
// senNum             input sensor's number (in-Integer)
// obsTimeDs50UTC     input observation time in days since 1950, UTC (in-Double)
// obsKey             The newly created observation Key (out-Long)
void ObsFieldsToObsKeyML(int satNum, int senNum, double obsTimeDs50UTC, __int64* obsKey);


// Parses observation data from a B3-card (or B3E) string / one-line TTY / or CSV - Converts obs data to TEME of Date if neccessary
// b3ObsCard          input B3 observation string (in-Character[512])
// secClass           security classification (out-Character)
// satNum             satellite number (out-Integer)
// senNum             sensor number (out-Integer)
// obsTimeDs50UTC     observation time in days since 1950 UTC (out-Double)
// elOrDec            elevation or declination (deg) (out-Double)
// azOrRA             azimuth or right-ascension (deg) (out-Double)
// range              range (km) (out-Double)
// rangeRate          range rate (km/s) (out-Double)
// elRate             elevation rate (deg/s) (out-Double)
// azRate             azimuth rate (deg/s) (out-Double)
// rangeAccel         range acceleration (km/s^2) (out-Double)
// obsType            observation type (out-Character)
// trackInd           track position indicator (3=start track ob, 4=in track ob, 5=end track ob) (out-Integer)
// ASTAT              association status assigned by SPADOC (out-Integer)
// siteTag            original satellite number (out-Integer)
// spadocTag          SPADOC-asssigned tag number (out-Integer)
// pos                position XYZ (km) (ECI or EFG) (out-Double[3])
// returns 0 if the data is successfully parsed, non-0 if there is an error
int ObsB3Parse(char* b3ObsCard, char* secClass, int* satNum, int* senNum, double* obsTimeDs50UTC, double* elOrDec, double* azOrRA, double* range, double* rangeRate, double* elRate, double* azRate, double* rangeAccel, char* obsType, int* trackInd, int* ASTAT, int* siteTag, int* spadocTag, double* pos);


// Parses any observation data format (B3-card (or B3E) string / one or two line TTY / CSV - No conversion takes place
// line1              input observation string 1 (B3/B3E/line 1 TTY/CSV) (in-Character[512])
// line2              input observation string 2 (line 2 of two-line TTY) (in-Character[512])
// xa_obs             The array containing observation data, see XA_OBS_? for array arrangement (out-Double[64])
// returns 0 if the data is successfully parsed, non-0 if there is an error
int ObsParse(char* line1, char* line2, double* xa_obs);


// Loads observation data from an input text file and group them together in the specified groupd id (gid).
// This allows the users to easily manage (load/retrieve/remove/save) a group of observations using the group id (gid)
// obsFile            The name of the file containing obs-related data (in-Character[512])
// gid                user specified group id (in-Integer)
// returns 0 if the input file is read successfully, non-0 if there is an error
int ObsLoadFileGID(char* obsFile, int gid);


// Saves the currently loaded obs data belong to the specified group id (gid) to a file 
// obsFile            The name of the file in which to save the settings (in-Character[512])
// gid                Group ID number (in-Integer)
// saveMode           Specifies whether to create a new file or append to an existing one (0 = create, 1= append) (in-Integer)
// obsForm            Specifies the obs format in which to save the file (0 = B3 format, 1 = TTY, 2 = CSV) (in-Integer)
// returns 0 if the data is successfully saved to the file, non-0 if there is an error
int ObsSaveFileGID(char* obsFile, int gid, int saveMode, int obsForm);


// Removes all observations belong to the specified group id (gid) from the set of currently loaded observations
// gid                Group ID number (in-Integer)
// returns 0 if the observations are successfully removed, non-0 if there is an error
int ObsRemoveGID(int gid);


// Returns the number of observations currently loaded that have the same gid
// gid                Group ID number (in-Integer)
// returns The number of observations currently loaded that have the same group id
int ObsGetCountGID(int gid);


// Retrieves all of the currently loaded obsKeys that have the same gid. These obsKeys can be used to access the internal data for the observations
// gid                Group ID number (in-Integer)
// order              Specifies the order in which the obsKeys should be returned (in-Integer)
// obsKeys            The array in which to store the obsKeys (out-Long[*])
void ObsGetLoadedGID(int gid, int order, __int64* obsKeys);


// Converts obs type from character to integer
// obsTypeChar        The input obs type character (in-Character)
// returns The resulting obs type integer
int ObsTypeCToI(char obsTypeChar);


// Converts obs type from integer to character
// obsTypeInt         The input obs type integer (in-Integer)
// returns The resulting obs type character
char ObsTypeIToC(int obsTypeInt);


// Resets obs selection settings
void ObsResetSelObs();


// Computes other states of the input observation
// obsKey             The observation's unique key (in-Long)
// range_km           Use this default range (km) for angle only obs (in-Double)
// xa_obState         Data derived from the obs data (out-Double[64])
// returns 0 if the observation states are successfully computed
int ObsGetStates(__int64 obsKey, double range_km, double* xa_obState);


// Computes observation states from the observation data
// xa_obs             Array containing observation data, see XA_OBS_? for array arrangement (in-Double[64])
// xa_obState         Data derived from the obs data (out-Double[64])
// returns 0 if the observation states are successfully computed
int ObsDataToStates(double* xa_obs, double* xa_obState);


// Reconstructs obs string (B3-card/one or two line TTY/CSV) from obs data in the input array xa_obs
// xa_obs             The array containing observation data, see XA_OBS_? for array arrangement (in-Double[64])
// obsForm            Desired obs string format (B3 = 0, TTY=1, CSV=2) (in-Integer)
// line1              output observation string 1 (B3/B3E/line 1 TTY/CSV) (out-Character[512])
// line2              output observation string 2 (line 2 of two-line TTY if obsForm = 1) (out-Character[512])
// returns 0 if the data is successfully , non-0 if there is an error
int ObsArrToLines(double* xa_obs, int obsForm, char* line1, char* line2);

// Indexes of Observation data fields
static const int  
   XF_OBS_SECCLASS     =  1,     // security classification
   XF_OBS_SATNUM       =  2,     // satellite number
   XF_OBS_SENNUM       =  3,     // sensor number
   XF_OBS_DS50UTC      =  4,     // observation time in days since 1950 UTC
   XF_OBS_ELEVATION    =  5,     // elevation (deg)
   XF_OBS_DECLINATION  =  6,     // declination (deg)
   XF_OBS_AZIMUTH      =  7,     // azimuth (deg)
   XF_OBS_RA           =  8,     // right-ascension (deg)
   XF_OBS_RANGE        =  9,     // range (km)
   XF_OBS_RANGERATE    = 10,     // range rate (km/s)
   XF_OBS_ELRATE       = 11,     // elevation rate (deg/s)
   XF_OBS_AZRATE       = 12,     // azimuth rate (deg/s)
   XF_OBS_RANGEACCEL   = 13,     // range acceleration (km/s^2)
   XF_OBS_OBSTYPE      = 14,     // observation type
   XF_OBS_TRACKIND     = 15,     // track position indicator (3=start track ob, 4=in track ob, 5=end track ob)
   XF_OBS_ASTAT        = 16,     // association status assigned by SPADOC
   XF_OBS_SITETAG      = 17,     // original satellite number
   XF_OBS_SPADOCTAG    = 18,     // SPADOC-asssigned tag number
   XF_OBS_POSE         = 19,     // position E/EFG (km)
   XF_OBS_POSF         = 20,     // position F/EFG (km)
   XF_OBS_POSG         = 21,     // position G/EFG (km)
   XF_OBS_POSX         = 22,     // position X/ECI (km)
   XF_OBS_POSY         = 23,     // position Y/ECI (km)
   XF_OBS_POSZ         = 24;     // position Z/ECI (km)
   
// Indexes of observation data in an array
static const int  
   XA_OBS_SECCLASS     =  0,     // security classification, 1 = Unclassified, 2 = Confidential, 3 = Secret
   XA_OBS_SATNUM       =  1,     // satellite number
   XA_OBS_SENNUM       =  2,     // sensor number
   XA_OBS_DS50UTC      =  3,     // observation time in days since 1950 UTC
   XA_OBS_ELORDEC      =  4,     // elevation (for ob type 1, 2, 3, 4, 8) or declination (for ob type 5, 9) (deg)
   XA_OBS_AZORRA       =  5,     // azimuth (for ob type 1, 2, 3, 4, 8) or right ascesion (for ob type 5, 9) (deg)
   XA_OBS_RANGE        =  6,     // range (km)
   XA_OBS_RANGERATE    =  7,     // range rate (km/s) for non-optical obs type
   XA_OBS_ELRATE       =  8,     // elevation rate (deg/s)
   XA_OBS_AZRATE       =  9,     // azimuth rate (deg/s)
   XA_OBS_RANGEACCEL   = 10,     // range acceleration (km/s^2)
   XA_OBS_OBSTYPE      = 11,     // observation type   
   XA_OBS_TRACKIND     = 12,     // track position indicator (3=start track ob, 4=in track ob, 5=end track ob)
   XA_OBS_ASTAT        = 13,     // association status assigned by SPADOC
   XA_OBS_SITETAG      = 14,     // original satellite number
   XA_OBS_SPADOCTAG    = 15,     // SPADOC-asssigned tag number
   XA_OBS_POSX         = 16,     // position X/ECI or E/EFG (km)
   XA_OBS_POSY         = 17,     // position Y/ECI or F/EFG (km)
   XA_OBS_POSZ         = 18,     // position Z/ECI or G/EFG (km)   
   XA_OBS_VELX         = 19,     // velocity X/ECI (km/s)  (or Edot/EFG (km) for ob type 7 TTY)
   XA_OBS_VELY         = 20,     // velocity Y/ECI (km/s)  (or Fdot/EFG (km) for ob type 7 TTY)
   XA_OBS_VELZ         = 21,     // velocity Z/ECI (km/s)  (or Gdot/EFG (km) for ob type 7 TTY)
   XA_OBS_YROFEQNX     = 22,     // year of equinox indicator for obs type 5/9 (0= Time of obs, 1= 0 Jan of date, 2= J2000, 3= B1950)
   
   XA_OBS_SIGMATYPE    = 40,     // individual obs's sigmas type (6: 6 elements, 21: 21 elements)
   XA_OBS_SIGMAEL1     = 41,     // sigma\covariance element 1
   XA_OBS_SIGMAEL2     = 42,     // sigma\covariance element 2
   XA_OBS_SIGMAEL3     = 43,     // sigma\covariance element 3
   XA_OBS_SIGMAEL4     = 44,     // sigma\covariance element 4
   XA_OBS_SIGMAEL5     = 45,     // sigma\covariance element 5
   XA_OBS_SIGMAEL6     = 46,     // sigma\covariance element 6
   XA_OBS_SIGMAEL7     = 47,     // sigma\covariance element 7 
   XA_OBS_SIGMAEL8     = 48,     // sigma\covariance element 8
   XA_OBS_SIGMAEL9     = 49,     // sigma\covariance element 9
   XA_OBS_SIGMAEL10    = 50,     // sigma\covariance element 10
   XA_OBS_SIGMAEL11    = 51,     // sigma\covariance element 11
   XA_OBS_SIGMAEL12    = 52,     // sigma\covariance element 12
   XA_OBS_SIGMAEL13    = 53,     // sigma\covariance element 13
   XA_OBS_SIGMAEL14    = 54,     // sigma\covariance element 14
   XA_OBS_SIGMAEL15    = 55,     // sigma\covariance element 15
   XA_OBS_SIGMAEL16    = 56,     // sigma\covariance element 16
   XA_OBS_SIGMAEL17    = 57,     // sigma\covariance element 17
   XA_OBS_SIGMAEL18    = 58,     // sigma\covariance element 18
   XA_OBS_SIGMAEL19    = 59,     // sigma\covariance element 19
   XA_OBS_SIGMAEL20    = 60,     // sigma\covariance element 20
   XA_OBS_SIGMAEL21    = 61,     // sigma\covariance element 21

   XA_OBS_SIZE         = 64;
   
   
// Indexes of observation data in an array
static const int  
   XA_OBSTATE_SATNUM       =  0,     // satellite number
   XA_OBSTATE_SENNUM       =  1,     // sensor number
   XA_OBSTATE_DS50UTC      =  2,     // observation time in days since 1950 UTC
   
   XA_OBSTATE_POSX         = 10,     // position X/ECI (km)
   XA_OBSTATE_POSY         = 11,     // position Y/ECI (km)
   XA_OBSTATE_POSZ         = 12,     // position Z/ECI (km)   
   XA_OBSTATE_VELX         = 13,     // velocity X/ECI (km/s)
   XA_OBSTATE_VELY         = 14,     // velocity Y/ECI (km/s)
   XA_OBSTATE_VELZ         = 15,     // velocity Z/ECI (km/s)   
   XA_OBSTATE_LAT          = 16,     // geodetic latitude (deg)
   XA_OBSTATE_LON          = 17,     // geodetic longitude (deg)
   XA_OBSTATE_HGHT         = 18,     // geodetic height (km)   
   XA_OBSTATE_POSE         = 19,     // position E/EFG (km)
   XA_OBSTATE_POSF         = 20,     // position F/EFG (km)   
   XA_OBSTATE_POSG         = 21,     // position G/EFG (km)

   
   XA_OBSTATE_SIZE         = 64;   
   

// Equinox indicator
static const int  
   EQUINOX_OBSTIME = 0,       // time of observation
   EQUINOX_OBSYEAR = 1,       // time @ 0 Jan Year of Date
   EQUINOX_J2K     = 2,       // J2000
   EQUINOX_B1950   = 3;       // B1950
   
// Indexes for sorting ob
// Sort options:
// (+/-) 1 = (descending/ascending) time, sensor, obstype, elev
// (+/-) 2 = (descending/ascending) time, elevation
// (+/-) 3 = (descending/ascending) time, sensor, otype, el, satno
// (+/-) 4 = (descending/ascending) sensor, satno, time, elev
// (+/-) 5 = (descending/ascending) sensor, time, elevation
// (+/-) 6 = (descending/ascending) sensor, satno, obstype, time, elev
// (+/-) 7 = (descending/ascending) satno, time, sensor, otype, el
// (+/-)10 = (descending/ascending) satno, sensor, time     
   
static const int  
   SORT_TIMESENTYPEEL      =  1,  
   SORT_TIMEEL             =  2,  
   SORT_TIMESENTYPEELSAT   =  3,  
   SORT_SENSATTIMEEL       =  4,  
   SORT_SENTIMEEL          =  5,  
   SORT_SENSATTYPETIMEEL   =  6,  
   SORT_SATTIMESENTYPEEL   =  7,  
   SORT_ORDERASREAD        =  8,  
   SORT_SATSENTIME         = 10;
   
   
// Indexes of different obs file format
static const int  
   OBSFORM_B3   = 0,   // B3 obs format
   OBSFORM_TTY  = 1,   // Transmission obs format
   OBSFORM_CSV  = 2;   // CSV obs format
   
static const int BADOBSKEY = -1;   
static const int DUPOBSKEY = 0;
   
   
//*******************************************************************************   
   



// ========================= End of auto generated code ==========================
