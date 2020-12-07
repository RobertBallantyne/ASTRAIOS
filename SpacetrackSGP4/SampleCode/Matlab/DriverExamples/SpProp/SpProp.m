%    Purpose:
%       This program shows how a Matlab program can call Astrodynamic Standard Dlls to propagate
%       satellites to the requested time using the Air Force Special Pertubations (SP) method.
% 
%       The program reads in user specified file and generates an ephemeris of position and velocity 
%       for each satellite read in. The program also generates other propagator output 
%       data and write them to different output files. Here is the list:
%          1. outFile + "_Pos.txt"   : time, position, and velocity 
%          2. outFile + "_Sigma.txt" : 1, and sigma UVW 
%          3. outFile + "_CovMtx.txt": 2, and covariance matrix
%          4. outFile                  : 1, 2 (if apply), lat, lon, height, rev, and Keplerian elements
%       
% 
%    Usage: SpProp(inFile, outFile, EarthConstant)
%       inFile    : File contains sp related input data
%       outFile   : Base name for five output files
%       EarthConst: Optional gravitational constants ('WGS-72', 'WGS-84', 'EGM-96' ...)
% 
% 
%    Author:
%       Dinh Nguyen AFSPC/A9 - August 31, 2012

% Example too run this application: >>SpProp('./input/vcm1.inp', 'test.out')
function SpProp(inFile, outFile, geoConstStr)

% Add Astro Standards library folder to search path
fprintf('Please specify the correct path to the Astro Standards library by modifying the default ASLIBPATH\n');
ASLIBPATH = '../../../../Lib/Win64';

fprintf('Current Astro Standards library folder = %s\n', ASLIBPATH);

if ispc
  sysPath = getenv('PATH');
  setenv('PATH', [ASLIBPATH ';' sysPath]);
elseif isunix
  sysPath = getenv('LD_LIBRARY_PATH');
  setenv('LD_LIBRARY_PATH', [ASLIBPATH ';' sysPath]);
end

if(nargin < 2)
   fprintf('Error in number of parameters passed. Please see the usage.\n');
   fprintf('Usage     : SpProp(inFile, outFile, [EarthConstant])\n');
   fprintf('inFile    : File contains sp related input data');
   fprintf('outFile   : Base name for five output files');
   fprintf('EarthConst: Optional gravitational constants ("WGS-72", "WGS-84", "EGM-96")\n');
   error('myApp:argChk', 'Wrong number of input arguments');
end

fprintf('Program starts.\n');
tStart = tic;


% Indexes of SP application control (preference) paramters
XF_SPAPP_GEODIR   = 1;   % Geopotential directory path
XF_SPAPP_BUFSIZE  = 2;    % Buffer size
XF_SPAPP_RUNMODE  = 3;    % Run mode
XF_SPAPP_SAVEPART = 4;    % Save partials data
XF_SPAPP_SPECTR   = 5;    % Specter compatibility mode
XF_SPAPP_CONSIDER = 6;    % Consider paramter
XF_SPAPP_DECAYALT = 7;    % Decay altitude
XF_SPAPP_OUTCOORD = 8;     % Output coordinate system



spDllInfo = blanks(128);

logFile = 'splog.txt';

EPSI			= 0.00050;	%TIME TOLERANCE IN SEC.

% Declare AstroStd variables
% Declare propagator's output arrays
posJ2K = zeros(3, 1);
velJ2K = zeros(3, 1);
posDate = zeros(3, 1);
velDate = zeros(3, 1);
posEpoch = zeros(3, 1);
velEpoch = zeros(3, 1);
pos = zeros(3, 1);
vel = zeros(3, 1);

llh = zeros(3, 1);
kep = zeros(6, 1);

posJ2KPtr   = libpointer('doublePtr', posJ2K);
velJ2KPtr   = libpointer('doublePtr', velJ2K);
posDatePtr  = libpointer('doublePtr', posDate);
velDatePtr  = libpointer('doublePtr', velDate);
posEpochPtr = libpointer('doublePtr', posEpoch);
velEpochPtr = libpointer('doublePtr', velEpoch);
llhPtr      = libpointer('doublePtr', llh);
kepPtr      = libpointer('doublePtr', kep);

covUVW = zeros(6, 6);
covXYZ = zeros(6, 6);
covEQNX = zeros(6, 6);
covMtxPtr = libpointer('doublePtr', covUVW);
covSigma = zeros(6, 1);
covSigmaPtr = libpointer('doublePtr', covSigma);




satNum = int32(0);
satNumPtr = libpointer('int32Ptr', satNum);

epochDs50UTC = double(0);
epochDs50UTCPtr = libpointer('doublePtr', epochDs50UTC);

epochDs50TAI = double(0);
epochDs50TAIPtr = libpointer('doublePtr', epochDs50TAI);

mu = double(0);
muPtr = libpointer('doublePtr', mu);

hasCovMtx = int32(0);
hasCovMtxPtr = libpointer('int32Ptr', hasCovMtx);

integMode = int32(0);
integModePtr = libpointer('int32Ptr', integMode);

nTerms = int32(0);
nTermsPtr = libpointer('int32Ptr', nTerms);

isSpectr = int32(0);
isSpectrPtr = libpointer('int32Ptr', isSpectr);

revNum = int32(0);
revNumPtr = libpointer('int32Ptr', revNum);

timeTypes = zeros(5, 1);
timeTypesPtr = libpointer('doublePtr', timeTypes);


% Load all the dlls being used in the program
LoadAstroStdDlls();

% Initialize all the dlls being used in the program
InitAstroStdDlls();



% Enable log capability (optional)
errCode = calllib('DllMain', 'OpenLogFile', logFile);
if(errCode ~= 0)
   ShowMsgAndTerminate;
end


LoadInputsFrFile(inFile);


if(nargin == 3)
   % Select GEO constants
   calllib('EnvConst', 'EnvSetGeoStr', geoConstStr);
end   



% Create and open output files
fpOutFile = fopen(outFile, 'w');
fpPosition = fopen([outFile '_C_Pos.txt'], 'w');
fpSigma = fopen([outFile '_C_Sigma.txt'], 'w');        % Osculating Keplerian elements
fpCovMtx = fopen([outFile '_C_CovMtx.txt'], 'w');	   % Mean Keplerian Elements



% Get information about the current DLL. This is optional
spDllInfo = calllib('SpProp', 'SpGetInfo', spDllInfo);
fprintf('%s\n', spDllInfo);

PrintHeader(fpOutFile, spDllInfo);

fprintf(fpPosition, '\n%s\n', spDllInfo);
fprintf(fpSigma, '\n%s\n', spDllInfo);
fprintf(fpCovMtx, '\n%s\n', spDllInfo);


% Count number of satellites currently loaded in all sp-typed state vectors
tleSats = calllib('Tle', 'TleGetCount');
spVecSats = calllib('SpVec', 'SpVecGetCount');
vcmSats = calllib('Vcm', 'VcmGetCount');

totalSats = tleSats + spVecSats + vcmSats;


% Using dinamic array
pSatKeys = int64(zeros(totalSats, 1));

% Get TLEs, if loaded
if(tleSats > 0)
   tmpKeys = zeros(tleSats, 1);
   satKeysPtr = libpointer('int64Ptr', tmpKeys);
   calllib('Tle', 'TleGetLoaded', 2, satKeysPtr);
   tmpKeys = satKeysPtr.Value;
   pSatKeys(1:tleSats) = tmpKeys;
end

% Get SP vectors, if loaded
if(spVecSats > 0)
   tmpKeys = zeros(spVecSats, 1);
   satKeysPtr = libpointer('int64Ptr', tmpKeys);
   calllib('SpVec', 'SpVecGetLoaded', 2, satKeysPtr);
   tmpKeys = satKeysPtr.Value;
   pSatKeys(tleSats+1:tleSats+spVecSats) = tmpKeys;
end

% Get VCMs, if loaded
if(vcmSats > 0)
   tmpKeys = zeros(vcmSats, 1);
   satKeysPtr = libpointer('int64Ptr', tmpKeys);
   calllib('Vcm', 'VcmGetLoaded', 2, satKeysPtr);
   tmpKeys = satKeysPtr.Value;
   pSatKeys(tleSats+spVecSats+1:tleSats+spVecSats+vcmSats) = tmpKeys;
end


prefStr = blanks(512);


% Retrieve output coordinate system setting
prefStr = calllib('SpProp', 'SpGetApCtrl', XF_SPAPP_OUTCOORD, prefStr);
outCoord = str2num(prefStr);

% Retrieve decay altitude setting
prefStr = calllib('SpProp', 'SpGetApCtrl', XF_SPAPP_DECAYALT, prefStr);
decayAlt = str2num(prefStr);

% Retrieve output coordinate system setting
prefStr = calllib('SpProp', 'SpGetApCtrl', XF_SPAPP_SAVEPART, prefStr);
savePartials = str2num(prefStr);


% Loop through all the satellites in the array
for i = 1:totalSats
   
   % Initialize Sp satellite before propagation
   errCode = calllib('SpProp', 'SpInitSat', pSatKeys(i));
   if(errCode ~= 0)
      ShowMsgAndTerminate;
   end
   
   % Retrieve data of the initialized satellite
   errCode = calllib('SpProp', 'SpGetSatDataAll', pSatKeys(i), satNumPtr, epochDs50UTCPtr, ...
      epochDs50TAIPtr, muPtr, hasCovMtxPtr, integModePtr, nTermsPtr, isSpectrPtr);
   
   if(errCode ~= 0)
      ShowMsgAndTerminate;
   end
   
   satNum = satNumPtr.Value;
   epochDs50TAI = epochDs50TAIPtr.Value;
   mu = muPtr.Value;
   hasCovMtx = hasCovMtxPtr.Value;
   integMode = integModePtr.Value;
   nTerms = nTermsPtr.Value;
   isSpectr = isSpectrPtr.Value;
   
   PrintSatHeader(fpOutFile, satNum, hasCovMtx, integMode);
   
   % Compute start & stop time in internal unit, days since 1950, UTC
   epochDs50UTC = epochDs50UTCPtr.Value;
   [startTime, stopTime, stepSize] = CalcStartStopTime(epochDs50UTC);
   
   
   step = 0;
   ds50UTC = startTime;
   
   % Loop through all the requested time steps
   while (ds50UTC < stopTime)
      ds50UTC = startTime + (step * stepSize / 1440);
      
      if (ds50UTC + (EPSI / 86400) > stopTime)
         ds50UTC = stopTime;
      end
      
      % Propagate the current satellite to the time specified in ds50UTC - returned results in J2K coordinate system
      errCode = calllib('SpProp', 'SpPropDs50UTC', pSatKeys(i), ds50UTC, timeTypesPtr, revNumPtr, posJ2KPtr, velJ2KPtr);
      
      if(errCode ~= 0)
         ShowErrMsg;
         
         % Skip this satellite and move to the next one
         break;
      end
      
      revNum = revNumPtr.Value;
      timeTypes = timeTypesPtr.Value;
      mse     = timeTypes(1);
      ds50TAI = timeTypes(4);
      ds50UT1 = timeTypes(3);

      % DHN 03Jul14 - Compute posDate so that it can be used to compute LLH
      calllib('AstroFunc', 'RotJ2KToDate', isSpectr, nTerms, ds50TAI, posJ2KPtr, velJ2KPtr, posDatePtr, velDatePtr);

      % Compute lat lon height
      llh = PosToLLH(ds50UT1, posDatePtr, calllib('EnvConst', 'EnvGetFkPtr'));
      
      % Compute position and velocity vectors based on the selected coordinate system
      if(outCoord == 1)
         calllib('AstroFunc', 'RotJ2KToDate', isSpectr, nTerms, epochDs50TAI, posJ2KPtr, velJ2KPtr, posEpochPtr, velEpochPtr);
         pos = posEpochPtr.Value;
         vel = velEpochPtr.Value;
      elseif(outCoord == 0)
         pos = posDatePtr.Value;
         vel = velDatePtr.Value;
      else %J2K
         pos = posJ2KPtr.Value;
         vel = velJ2KPtr.Value;
      end
      
      posPtr = libpointer('doublePtr', pos);
      velPtr = libpointer('doublePtr', vel);

      
      PrintPosVel(fpOutFile, mse, pos, vel);
      
      fprintf(fpPosition, '%s', '  NLEXYZ');
      PrintPosVel(fpPosition, mse, pos, vel);
      
      fprintf(fpCovMtx, '%s', '  NLEXYZ');
      PrintPosVel(fpCovMtx, mse, pos, vel);
      
      dtg = blanks(20);
      dtg = calllib('TimeFunc', 'UTCToDTG20', ds50UTC, dtg);
      
      PrintLLH(fpOutFile, dtg(3:20), llh, revNum);
      
      % Convert position velocity vectors to Keplerian elements
      % Use mu for sp satellites to obtain more accurate results
      calllib('AstroFunc', 'PosVelMuToKep', posPtr, velPtr, mu, kepPtr);
      kep = kepPtr.Value;
      
      PrintKepElts(fpOutFile, kep);
      
      % Indexes of different covariance matrix type
      XF_COVMTX_UVW  = 1;    % UVW convariance matrix
      XF_COVMTX_XYZ  = 2;    % Cartesian covariance matrix
      XF_COVMTX_EQNX = 3;    % Equinoctial covariance matrix

      if(savePartials == 1 && hasCovMtx == 1)
         % Compute covariance matrix and covariance sigma
         
         % Compute UVW covariance matrix
         errCode = calllib('SpProp', 'SpGetCovMtx', pSatKeys(i), XF_COVMTX_UVW, covMtxPtr);
         covUVW = covMtxPtr.Value;
         
         calllib('SpProp', 'SpCompCovSigma', covMtxPtr, covSigmaPtr);
         covSigma = covSigmaPtr.Value;
         
         PrintCovSigma(fpOutFile, integMode, covSigma);
         PrintCovSigma(fpSigma, integMode, covSigma);
         fprintf(fpOutFile, '\n');
         
         fprintf(fpCovMtx, '\n  UVW COVARIANCE MATRIX\n');
         PrintCovMtx(fpCovMtx, covUVW);
         PrintCovSigma(fpCovMtx, integMode, covSigma);

         
         % Compute XYZ covariance matrix
         errCode = calllib('SpProp', 'SpGetCovMtx', pSatKeys(i), XF_COVMTX_XYZ, covMtxPtr);
         covXYZ = covMtxPtr.Value;
         fprintf(fpCovMtx, '\n  CARTESIAN COVARIANCE MATRIX\n');
         PrintCovMtx(fpCovMtx, covXYZ);         
         
         
         % Compute equinoctial covariance matrix
         errCode = calllib('SpProp', 'SpGetCovMtx', pSatKeys(i), XF_COVMTX_EQNX, covMtxPtr);
         covEQNX = covMtxPtr.Value;
         fprintf(fpCovMtx, '\n  EQUINOCTIAL COVARIANCE MATRIX\n');
         PrintCovMtx(fpCovMtx, covEQNX);         
         fprintf(fpCovMtx, '\n\n');
      end
      
      step = step + 1;
   end
   
  
   % Remove this satellite if no longer needed
   if(calllib('SpProp', 'SpRemoveSat', pSatKeys(i))~= 0)
      ShowMsgAndTerminate;
   end
end


% Remove all the satellites from memory if no longer needed
%calllib('SpProp', 'SpRemoveAllSats');
%calllib('SpProp', 'SpReset');

% Close all output files
fclose(fpPosition);
fclose(fpSigma);
fclose(fpCovMtx);

% Free loaded AstroStd dlls
FreeAstroStdDlls();

tElapsed = toc(tStart);

%Calculate the whole run time
fprintf('Program completed successfully.\n');

fprintf('Total run time = %10.2f seconds.\n', tElapsed );
fprintf(fpOutFile, 'Total run time = %10.2f seconds.\n', tElapsed);
fclose(fpOutFile);

%******************************************************************************
% Program completed successfully here





% Load all the dlls being used in the program
function LoadAstroStdDlls()
% Get current folder
s = pwd;

% Add relative path to header files (.\..\Include folder)
addpath([s '/../wrappers'])

% Load MainDll dll
loadlibrary DllMain    M_DllMainDll.h

% Load EnvConst dll and assign function pointers
loadlibrary EnvConst   M_EnvConstDll.h

% Load TimeFunc dll and assign function pointers
loadlibrary TimeFunc   M_TimeFuncDll.h

% Load AstroFunc dll and assign function pointers
loadlibrary AstroFunc  M_AstroFuncDll.h

% Load Tle dll and assign function pointers
loadlibrary Tle        M_TleDll.h

% Load Sp Vector dll and assign function pointers
loadlibrary SpVec      M_SpVecDll.h

% Load Vcm dll and assign function pointers
loadlibrary Vcm        M_VcmDll.h

% Load SpProp dll and assign function pointers
loadlibrary SpProp     M_SpPropDll.h


% Initialize all the dlls being used in the program
function InitAstroStdDlls()

% Get pointer to the global data (data pointers, function pointers, ...)
% that will be used among the dlls in the program

apPtr = calllib('DllMain', 'DllMainInit');

% Initialize EnvConst & check for error
errCode = calllib('EnvConst',  'EnvInit',       apPtr);
if(errCode ~= 0)
   ShowMsgAndTerminate();
end

% Initialize TimeFunc & check for error
errCode = calllib('TimeFunc',  'TimeFuncInit',  apPtr);
if(errCode ~= 0)
   ShowMsgAndTerminate();
end

% Initialize AstroFunc & check for error
errCode = calllib('AstroFunc', 'AstroFuncInit', apPtr);
if(errCode ~= 0)
   ShowMsgAndTerminate();
end

% Initialize Tle & check for error
errCode = calllib('Tle',       'TleInit',       apPtr);
if(errCode ~= 0)
   ShowMsgAndTerminate();
end

% Initialize SpVec & check for error
errCode = calllib('SpVec',     'SpVecInit',     apPtr);
if(errCode ~= 0)
   ShowMsgAndTerminate();
end

% Initialize Vcm & check for error
errCode = calllib('Vcm',       'VcmInit',       apPtr);
if(errCode ~= 0)
   ShowMsgAndTerminate();
end

% Initialize SpProp & check for error
errCode = calllib('SpProp',    'SpInit',        apPtr);
if(errCode ~= 0)
   ShowMsgAndTerminate();
end



% Each dll read the main input file
function LoadInputsFrFile(inFile)

% Load SP's control parameters from a file
errCode = calllib('SpProp', 'SpLoadFile', inFile);
if(errCode ~= 0)
   ShowMsgAndTerminate();
end

% Load environmental data from a file
errCode = calllib('EnvConst', 'EnvLoadFile', inFile);
if(errCode ~= 0)
   ShowMsgAndTerminate;
end

% Load timing constants from a file
errCode = calllib('TimeFunc', 'TConLoadFile', inFile);
if(errCode ~= 0)
   ShowMsgAndTerminate;
end

% Load Tles from a file
errCode = calllib('Tle', 'TleLoadFile', inFile);
if(errCode ~= 0)
   ShowMsgAndTerminate;
end

% Load Sp vectors from a file
errCode = calllib('SpVec', 'SpVecLoadFile', inFile);
if(errCode ~= 0)
   ShowMsgAndTerminate;
end

% Load Vcms from a file
errCode = calllib('Vcm', 'VcmLoadFile', inFile);
if(errCode ~= 0)
   ShowMsgAndTerminate;
end



% Compute start stop time for each satellite using unit of days since 1950
function [tStart, tStop, tStep] = CalcStartStopTime(epoch)

startFrEpoch = int32(0);
stopFrEpoch  = int32(0);
startTime = double(0);
stopTime = double(0);
stepSize = double(0);


startFrEpochPtr = libpointer('int32Ptr', startFrEpoch);
stopFrEpochPtr  = libpointer('int32Ptr', stopFrEpoch);
startTimePtr = libpointer('doublePtr', startTime);
stopTimePtr = libpointer('doublePtr', stopTime);
stepSizePtr = libpointer('doublePtr', stepSize);


% Get prediction control data
calllib('SpProp', 'SpGetPredCtrl', startFrEpochPtr, stopFrEpochPtr, startTimePtr, stopTimePtr, stepSizePtr);

startFrEpoch = startFrEpochPtr.Value;
stopFrEpoch  = stopFrEpochPtr.Value;
startTime = startTimePtr.Value;
stopTime = stopTimePtr.Value;
stepSize = stepSizePtr.Value;

% Compute start/stop times - using days since 1950 UTC

% user selects start time in minutes since epoch
if (startFrEpoch == 1)
   tStart = epoch + (startTime / 1440.0);
else
   tStart = startTime;
end

% user selects stop time in minutes since epoch
if (stopFrEpoch == 1)
   tStop = epoch + (stopTime / 1440.0);
else
   tStop = stopTime;
end

tStep = stepSize;

function PrintHeader(fp, dllInfoStr)

geoDirPath = blanks(512);
bufSize = int32(0);
runMode = int32(0);
savePartials = int32(0);
isSpectr = int32(0);
decayAlt = int32(0);
outCoord = int32(0);
consider = double(0);

bufSizePtr = libpointer('int32Ptr', bufSize);
runModePtr = libpointer('int32Ptr', runMode);
savePartialsPtr = libpointer('int32Ptr', savePartials);
isSpectrPtr = libpointer('int32Ptr', isSpectr);
decayAltPtr = libpointer('int32Ptr', decayAlt);
outCoordPtr = libpointer('int32Ptr', outCoord);
considerPtr = libpointer('doublePtr', consider);



outCoordSys = {'true equator, mean equinox of date '; ...
   'true equator, mean equinox of Epoch'; ...
   'mean equator, mean equinox of FK5  '};

fprintf(fp, '%s\n\n', '             SPECIAL PERTURBATIONS EPHEMERIS              ');
fprintf(fp, '%s\n\n', dllInfoStr);
fprintf(fp, '%s\n', '**********************************************************');
fprintf(fp, '%s\n', '*                                                        *');
fprintf(fp, '%s\n', '*                      W A R N I N G                     *');
fprintf(fp, '%s\n', '*  THIS SOFTWARE CONTAINS TECHNICAL DATA WHOSE EXPORT IS *');
fprintf(fp, '%s\n', '*  RESTRICTED BY THE ARMS EXPORT CONTROL ACT (TITLE 22,  *');
fprintf(fp, '%s\n', '*  USC, SEC 2751 ) OR EXECUTIVE ORDER 12470. VIOLATORS   *');
fprintf(fp, '%s\n', '*  OF EXPORT LAWS ARE SUBJECT TO SEVERE CRIMINAL         *');
fprintf(fp, '%s\n', '*  PENALTIES.                                            *');
fprintf(fp, '%s\n', '*                 D I S T R I B U T I O N                *');
fprintf(fp, '%s\n', '*  DISTRIBUTION IS AUTHORIZED TO US GOVERNMENT AGENCIES  *');
fprintf(fp, '%s\n', '*  AND THEIR CONTRACTORS FOR OFFICIAL USE ON A NEED TO   *');
fprintf(fp, '%s\n', '*  KNOW BASIS ONLY. ALL REQUESTS FOR THIS SOFTWARE SHALL *');
fprintf(fp, '%s\n', '*  BE REFERRED TO AFSPC/A9.  NO SOFTWARE CODE, MANUAL,   *');
fprintf(fp, '%s\n', '*  OR MEDIA CONTAINING ANY REPRESENTATION OF THE UNITED  *');
fprintf(fp, '%s\n', '*  STATES AIR FORCE (USAF), HQ AIR FORCE SPACE COMMAND   *');
fprintf(fp, '%s\n', '*  (AFSPC) SPACE ANALYSIS CENTER (ASAC) [AFSPC/A9]       *');
fprintf(fp, '%s\n', '*                        SPEPH                           *');
fprintf(fp, '%s\n', '*  CAPABILITY MAY BE ASSIGNED, COPIED, OR TRANSFERRED TO *');
fprintf(fp, '%s\n', '*  ANY NON-AUTHORIZED PERSON, CONTRACTOR, OR GOVERNMENT  *');
fprintf(fp, '%s\n', '*  AGENCY WITHOUT THE EXPRESSED WRITTEN CONSENT OF       *');
fprintf(fp, '%s\n', '*               USAF, HQ AFSPC/A9.                       *');
fprintf(fp, '%s\n', '**********************************************************');


% Retrieve SP control parameters
geoDirPath = calllib('SpProp', 'SpGetApCtrlAll', geoDirPath, bufSizePtr, ...
   runModePtr, savePartialsPtr, isSpectrPtr, considerPtr, ...
   decayAltPtr, outCoordPtr);
bufSize = bufSizePtr.Value;
runMode = runModePtr.Value;
savePartials = savePartialsPtr.Value;
isSpectr = isSpectrPtr.Value;
decayAlt = decayAltPtr.Value;
outCoord = outCoordPtr.Value;
consider = considerPtr.Value;


runModeStr = {'Performance Priority'  'Memory Priority'};
isSpectrStr = {'Not Compatible' 'Compatible'};
savePartialsStr = {'No' 'Yes'};

fprintf(fp, '\n\n');
fprintf(fp, 'SP Application Control Options\n');
fprintf(fp, '==============================\n');
fprintf(fp, 'Geo Dir Path   = %s\n', geoDirPath);
fprintf(fp, 'Buffer size    = %-6d\n', bufSize);
fprintf(fp, 'Run Mode       = %s\n', runModeStr{runMode + 1}); % ? 'Memory Priority' : 'Performance Priority');
fprintf(fp, 'Specter Mode   = %s\n', isSpectrStr{isSpectr + 1}); % ? 'Compatible' : );
fprintf(fp, 'Consider       = %-8.3f\n', consider);
fprintf(fp, 'Decay Altitude = %-6d km\n', decayAlt);
fprintf(fp, 'Output CoordSys= %s\n', outCoordSys{outCoord + 1});
fprintf(fp, 'Save Partials  = %s\n', savePartialsStr{savePartials + 1}); % ? 'Yes' : 'No');
fprintf(fp, '==============================\n\n');




function PrintSatHeader(fp, satNum, hasCovMtx, integMode)
INTEG_NUMERICAL  = 1;
INTEG_ANALYTIC   = 2;

fprintf(fp,'\n\n%s%5d\n', 'SATELLITE NUMBER ', satNum);

if(hasCovMtx == 0)
   fprintf( fp,'\n%s\n\n\n', '>>> No covariance input <<<');
end

fprintf(fp, '%s\n%s%s\n%s%s\n%s%s\n%s%s\n', ...
   '                EPHEM EPHEMERIS  MODE', ...
   '     TIME (min)          X (km)          Y (km)          Z (km', ...
   ')        Xdot (km/sec)   Ydot (km/sec)   Zdot (km/sec)', ...
   ' YY/DDD HHMM SS.SSS  Latitude (deg)   Longitude (deg)   Height', ...
   ' (km)     REV', ...
   '                       N (revs/day)       E               I ', ...
   '(deg)       NODE (deg)      OMEGA (deg)     M (deg)', ...
   ' =========================================================', ...
   '=========================================================');
if(hasCovMtx == 1)
   fprintf (fp,'\n%s\n','         Propagate covariance matrix: Yes');
else
   fprintf (fp,'\n%s\n','         Propagate covariance matrix: No');
end

if(integMode == INTEG_NUMERICAL)
   fprintf (fp,'%s\n\n', '         Partials computation method: Numerical');
elseif(integMode == INTEG_ANALYTIC)
   fprintf (fp,'%s\n\n', '         Partials computation method: Semi-analytic');
end



function PrintPosVel(fp, mse,  pos,  vel)
fprintf(fp, '%19.6f%16.6f%16.6f%16.6f%16.9f%16.9f%16.9f\n', ...
   mse, pos(1), pos(2), pos(3), vel(1), vel(2), vel(3));




function PrintCovMtx(fp, covMtx)

fprintf(fp, [' %s\n' ...
   '%6s%+.6E \n' ...
   '%6s%+.6E %+.6E \n' ...
   '%6s%+.6E %+.6E %+.6E \n' ...
   '%6s%+.6E %+.6E %+.6E %+.6E \n' ...
   '%6s%+.6E %+.6E %+.6E %+.6E %+.6E \n' ...
   '%6s%+.6E %+.6E %+.6E %+.6E %+.6E %+.6E \n'], ...
   ' LOWER TRIANG 6x6 by row: ', ...
   ' ', covMtx(1,1), ...
   ' ', covMtx(2,1),covMtx(2,2), ...
   ' ', covMtx(3,1),covMtx(3,2),covMtx(3,3), ...
   ' ', covMtx(4,1),covMtx(4,2),covMtx(4,3),covMtx(4,4), ...
   ' ', covMtx(5,1),covMtx(5,2),covMtx(5,3),covMtx(5,4),covMtx(5,5), ...
   ' ', covMtx(6,1),covMtx(6,2),covMtx(6,3),covMtx(6,4),covMtx(6,5),covMtx(6,6));




function PrintKepElts(fp,  kep)

% N (revs/days) is computed from semi major axis A kep(1)
fprintf(fp, '%19s%16.9f%16.9f%16.9f%16.9f%16.9f%16.9f\n', ' ', ...
   calllib('AstroFunc', 'AToN', kep(1)), kep(2), kep(3), kep(5), kep(6), kep(4));




function PrintCovSigma(fp, integMode,  covSigma)
INTEG_NUMERICAL  = 1;
INTEG_ANALYTIC   = 2;

if(integMode == INTEG_NUMERICAL)
   mode = 'n';
elseif(integMode == INTEG_ANALYTIC)
   mode = 'a';
else
   return;
end

fprintf(fp, '     Sigma UVW (%c):%16.6f%16.6f%16.6f%16.6f%16.6f%16.6f\n', mode, ...
   covSigma(1), covSigma(2), covSigma(3), covSigma(4), covSigma(5), covSigma(6));




function PrintLLH(fp, dtg,  llh, revNum)
fprintf(fp, ' %18s%16.7f%16.7f%16.7f%8d\n', dtg, llh(1), llh(2), llh(3), revNum);



% Compute LLH from position vector
function [llh]=PosToLLH(ds50UT1, posPtr, envFkPtr)
thetaG = calllib('TimeFunc', 'ThetaGrnwch', ds50UT1, envFkPtr);

llh = zeros(3, 1);
llhPtr = libpointer('doublePtr', llh);
calllib('AstroFunc', 'XYZToLLH', thetaG, posPtr, llhPtr);
llh = llhPtr.Value;



% Unload the library before leaving the program
function FreeAstroStdDlls
calllib('DllMain', 'CloseLogFile')
unloadlibrary DllMain
unloadlibrary EnvConst
unloadlibrary AstroFunc
unloadlibrary TimeFunc
unloadlibrary Tle
unloadlibrary SpVec
unloadlibrary Vcm
unloadlibrary SpProp
close all
clear all


function errMSg=ShowErrMsg()
errMsg = blanks(128);
errMsg = calllib('DllMain', 'GetLastErrMsg', errMsg);
fprintf('%s\n', errMsg);

function ShowMsgAndTerminate
errMsg = ShowErrMsg();
error(errMsg);
UnloadDlls;


