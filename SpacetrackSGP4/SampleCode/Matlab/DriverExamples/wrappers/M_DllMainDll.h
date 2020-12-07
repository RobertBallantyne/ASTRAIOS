// This wrapper file was generated automatically by the A3\GenDllWrappers program.



// This is the most important function call of the Standardized Astrodynamic Algorithms library. It returns a handle which can be used to access the 
// static global data set needed by the Standardized Astrodynamic Algorithms DLLs to communicate among themselves. 
// All other function calls within the API will use this handle, so make sure you save this function's return value. 
// returns A handle to the global data set. You will pass this handle to other initialization functions within other DLLs in the API.
__int64 DllMainInit();


// Returns information about the DllMain DLL. 
// infoStr            A string to hold the information about DllMain.dll. (out-Character[128])
void DllMainGetInfo(char* infoStr);


// Opens a log file and enables the writing of diagnostic information into it. 
// All of the DLLs in the library will write diagnostic information into the log file once this function has been called.
// fileName           The name of the log file to use. (in-Character[512])
// returns 0 if the file was opened successfully. Other values indicate an error.
int OpenLogFile(char* fileName);


// Closes the currently open log file and reset the last logged error message to null. 
void CloseLogFile();


// Writes a message into the log file.
// msgStr             A message to be written into the log file. (in-Character[128])
void LogMessage(char* msgStr);


// Returns a character string describing the last error that occurred. 
// lastErrMsg         A string that stores the last logged error message. The message will be placed in the string you pass to this function. (out-Character[128])
void GetLastErrMsg(char* lastErrMsg);


// Returns a character string describing the last informational message that was recorded. 
// lastInfoMsg        A string that stores the last logged informational message. The message will be placed in the string you pass to this function. (out-Character[128])
void GetLastInfoMsg(char* lastInfoMsg);


// Returns a list of names of the Standardized Astrodynamic Algorithms DLLs that were initialized successfully.
// initDllNames       A string that stores names of the DLLs that were initialized successfully. (out-Character[512])
void GetInitDllNames(char* initDllNames);


// Tests different input/output data types that are supported by the Astrodynamic Standards library.
// cIn                an input character (in-Character)
// cOut               an output character - should return the same value as the input cIn (out-Character)
// intIn              an input 32-bit integer (in-Integer)
// intOut             an output 32-bit integer - should return the same value as the input intIn (out-Integer)
// longIn             an input 64-bit integer (in-Long)
// longOut            an output 64-bit integer - should return the same value as the input longIn (out-Long)
// realIn             an input 64-bit real (in-Double)
// realOut            an output 64-bit real - should return the same value as the input realIn (out-Double)
// strIn              input string (in-Character[512])
// strOut             output string - should return the same value as the input strIn (out-Character[512])
// int1DIn            an input array of 32-bit integers (in-Integer[3])
// int1DOut           an output array of 32-bit integers - should return the same values as the input int1DIn (out-Integer[3])
// long1DIn           an input array of 64-bit integers (in-Long[3])
// long1DOut          an output array of 64-bit integers - should return the same values as the input long1DIn (out-Long[3])
// real1DIn           an input array of 64-bit reals (in-Double[3])
// real1DOut          an output array of 64-bit reals - should return the same values as the input real1DIn (out-Double[3])
// int2DIn            an input 2D-array of 32-bit integers (2 rows, 3 columns) - for column-major order language, reverse the order (in-Integer[2, 3])
// int2DOut           an output 2D-array of 32-bit integers - should return the same values as the input int2DIn (out-Integer[2, 3])
// long2DIn           an input 2D-array of 64-bit integers (2 rows, 3 columns) - for column-major order language, reverse the order (in-Long[2, 3])
// long2DOut          an output 2D-array of 64-bit integers - should return the same values as the input long2DIn (out-Long[2, 3])
// real2DIn           an input 2D-array of 64-bit reals (2 rows, 3 columns) - for column-major order language, reverse the order (in-Double[2, 3])
// real2DOut          an output 2D-array of 64-bit reals - should return the same values as the input real2DIn (out-Double[2, 3])
void TestInterface(char cIn, char* cOut, int intIn, int* intOut, __int64 longIn, __int64* longOut, double realIn, double* realOut, char* strIn, char* strOut, int* int1DIn, int* int1DOut, __int64* long1DIn, __int64* long1DOut, double* real1DIn, double* real1DOut, int* int2DIn, int* int2DOut, __int64* long2DIn, __int64* long2DOut, double* real2DIn, double* real2DOut);

// log message string length
#define LOGMSGLEN   128    

// DHN 06Feb12 - Increase file path length to 512 characters from 128 characters to handle longer file path
#define FILEPATHLEN   512 

// DHN 10Feb12 - Uniformally using 512 characters to passing/receiving string in all Get/Set Field functions
#define GETSETSTRLEN   512 

#define INFOSTRLEN   128 

// DHN 10Feb12 - All input card types' (elsets, ob, sensors, ...) can now have maximum of 512 characters
#define INPUTCARDLEN   512 

// Element types (last digit of satKey)
static const int  
   ELTTYPE_TLE_SGP   = 1,    // Element type - SGP Tle type 0
   ELTTYPE_TLE_SGP4  = 2,    // Element type - SGP4 Tle type 2
   ELTTYPE_TLE_SP    = 3,    // Element type - SP Tle type 6
   ELTTYPE_SPVEC_B1P = 4,    // Element type - SP Vector
   ELTTYPE_VCM       = 5,    // Element type - VCM
   ELTTYPE_EXTEPH    = 6,    // Element type - External ephemeris
   ELTTYPE_TLE_XP   = 7;    // Element type - SGP Tle type 4 - XP

//*******************************************************************************

// Propagation types
static const int  
   PROPTYPE_GP  = 1,       // GP/SGP4 propagator
   PROPTYPE_SP  = 2,       // SP propagator
   PROPTYPE_X   = 3,       // External ephemeris
   PROPTYPE_UK  = 4;       // Unknown
//*******************************************************************************

// Add sat error 
static const int  
   BADSATKEY = -1,      // Bad satellite key
   DUPSATKEY =  0;      // Duplicate satellite key

//*******************************************************************************
// Options used in GetLoaded()   
static const int  
   IDX_ORDER_ASC   = 0,    // ascending order
   IDX_ORDER_DES   = 1,    // descending order
   IDX_ORDER_READ  = 2,    // order as read
   IDX_ORDER_QUICK = 9;    // tree traversal order

//*******************************************************************************
   



// ========================= End of auto generated code ==========================
