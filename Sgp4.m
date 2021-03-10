%    Purpose:
%       This program shows how a Matlab program can call the Astrodynamic Standard DLLs to propagate
%       satellites to the requested time using SGP4 method.
%
%       The program reads in user's input and output files. The program generates an 
%       ephemeris of position and velocity for each satellite read in. In addition, the program 
%       also generates other sets of orbital elements such as osculating Keplerian elements, 
%       mean Keplerian elements, latitude/longitude/height/pos, and nodal period/apogee/perigee/pos. 
%       Totally, the program prints results to five different output files. 
%
%
%    Usage: Sgp4Prop(inFile, outFile)
%       inFile   : File contains TLEs and 6P-Card (which controls start, stop times and step size)
%       outFile  : Base name for five output files
%
%
%    Author:
%       HQ AFSPC/A2/3/6Z

% Example to run this application: >>Sgp4Prop('./input/rel14.inp', 'test.out')
function [table_out] = Sgp4(inFile, outFile, satEpoch)

% Add Astro Standards library folder to search path
fprintf('Please specify the correct path to the Astro Standards library by modifying the default ASLIBPATH\n');
ASLIBPATH = strcat(pwd, '\SpacetrackSGP4\Lib\Win64');

fprintf('Current Astro Standards library folder = %s\n', ASLIBPATH);

if ispc
  sysPath = getenv('PATH');
  setenv('PATH', [ASLIBPATH ';' sysPath]);
elseif isunix
  sysPath = getenv('LD_LIBRARY_PATH');
  setenv('LD_LIBRARY_PATH', [ASLIBPATH ';' sysPath]);
end

% Add SGP4 license file path
SGP4LICFILEPATH = [ASLIBPATH '/'];
fprintf('SGP4_Open_License.txt file path= %s\n', SGP4LICFILEPATH);



EPSI			= 0.00050;	% TIME TOLERANCE IN SEC.	
if(nargin ~= 3)
   fprintf('Error in number of parameters passed. Please see the usage.\n\n');
   fprintf('Usage    : Sgp4Prop(inFile, outFile)\n');
   fprintf('inFile   : File contains TLEs and 6P-Card (which controls start, stop times and step size)\n');
   fprintf('outFile  : Base name for five output files\n');
   error('myApp:argChk', 'Wrong number of input arguments');
end       



fprintf('Program starts.\n');
tStart = tic;

XF_SGP4OUT_REVNUM       = 1;  % Revolution number
XF_SGP4OUT_NODAL_AP_PER = 2;  % Nodal period, apogee, perigee
XF_SGP4OUT_MEAN_KEP     = 3;  % Mean Keplerian
XF_SGP4OUT_OSC_KEP      = 4;  % Osculating Keplerian

XF_TLE_EPOCH = 4;

% Predefined output file names
OSC_STATE    =  '_OscState.txt';
OSC_ELEM     =  '_OscElem.txt';
MEAN_ELEM    =  '_MeanElem.txt';

logFile = 'sgp4_log.txt';

sgp4DllInfo = blanks(128);

line1 = blanks(512);
line2 = blanks(512);

mse = (0);

% Arrays that store propagator output data
pos = zeros(3, 1);            % Position (km)
vel = zeros(3, 1);            % Velocity (km/s)
llh = zeros(3, 1);            % Latitude(deg), Longitude(deg), Height above Geoid (km)
meanKep = zeros(6, 1);        % Mean Keplerian elements
oscKep = zeros(6, 1);         % Osculating Keplerian elements
nodalApPer = zeros(3, 1);     % Nodal period, apogee, perigee

posPtr     = libpointer('doublePtr', pos);
velPtr     = libpointer('doublePtr', vel);
llhPtr     = libpointer('doublePtr', llh);
meanKepPtr    = libpointer('doublePtr', meanKep);
oscKepPtr     = libpointer('doublePtr', oscKep);
nodalApPerPtr = libpointer('doublePtr', nodalApPer);
msePtr = libpointer('doublePtr', mse);


fprintf('Input file  = %s\n', inFile);
fprintf('Output file = %s\n', outFile);



% Load all the dlls being used in the program
LoadAstroStdDlls();

% Specify folder that contains "SGP4_Open_License.txt" file
calllib('Sgp4Prop', 'Sgp4SetLicFilePath', SGP4LICFILEPATH);

% Initialize all the dlls being used in the program
InitAstroStdDlls();

% Log diagnostic information to a log file. This is optional
%-----------------------------------------------------------
% Enable log capability (optional)
% errCode = calllib('DllMain', 'OpenLogFile', logFile);
% 
% if(errCode ~= 0)
%    ShowMsgAndTerminate();
% end

% Load Tles from the input file
errCode = calllib('Tle', 'TleLoadFile', inFile);
if(errCode ~= 0)
   ShowMsgAndTerminate;
end

% Load 6P-Card 
errCode = calllib('TimeFunc', 'TConLoadFile', inFile);
if(errCode ~= 0)
   ShowMsgAndTerminate;
end


% Count number of satellites currently loaded in memory
numSats = calllib('Tle', 'TleGetCount');

% Using dinamic array
satKeys = int64(zeros(numSats, 1));

% Get all the satellites' ids from memory and store them in the local array
satKeysPtr = libpointer('int64Ptr', satKeys);
calllib('Tle', 'TleGetLoaded', 2, satKeysPtr);
satKeys = satKeysPtr.Value;



% Get information about the current DLL
sgp4DllInfo = calllib('Sgp4Prop', 'Sgp4GetInfo', sgp4DllInfo);
fprintf('%s\n', sgp4DllInfo);


% Open output files. Check to see if error occurs
fpOscState = fopen([outFile OSC_STATE], 'w');	   % Osculating state vector
fpOscElem = fopen([outFile OSC_ELEM], 'w');        % Osculating Keplerian elements
fpMeanElem = fopen([outFile MEAN_ELEM], 'w');	   % Mean Keplerian Elements

% Print header with output field names to files
PrintHeader(fpOscState, sgp4DllInfo, inFile);
fprintf(fpOscState, '%s\n', ...
   '     EPOCH (MIN)     TSINCE (MIN)           X (KM)           Y (KM)           Z (KM)      XDOT (KM/S)       YDOT(KM/S)    ZDOT (KM/SEC)');

PrintHeader(fpOscElem, sgp4DllInfo, inFile);
fprintf(fpOscElem, '%s\n', ...
   '     EPOCH (MIN)     TSINCE (MIN)           A (KM)          ECC (-)        INC (DEG)       RAAN (DEG)      OMEGA (DEG)   TRUE ANOM(DEG)');

PrintHeader(fpMeanElem, sgp4DllInfo, inFile);
fprintf(fpMeanElem, '%s\n', ...
   '     TSINCE (MIN)     N (REVS/DAY)          ECC (-)        INC (DEG)       RAAN (DEG)      OMEGA (DEG)         MA (DEG)');

global r_Earth

vars = {'catID', 'x', 'y', 'z', 'u', 'v', 'w', 'apo', 'peri', 'a', 'e', 'i', 'raan', 'omega', 'startTime'};
vartypes = {'string', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double'};
table_out = table('Size', [0 length(vars)], 'VariableTypes', vartypes, 'VariableNames', vars);
% Loop through all the TLEs in the input file

for i = 1:numSats
   
   % Return the two strings, line1 line2, representing the TLE
   [errCode, line1, line2] = calllib('Tle', 'TleGetLines', satKeys(i), line1, line2);
   
   % Print TLE for each satellite
   fprintf(fpOscState, '\n\n %s\n %s\n\n', line1, line2);
   fprintf(fpOscElem, '\n\n %s\n %s\n\n', line1, line2);
   fprintf(fpMeanElem, '\n\n %s\n %s\n\n', line1, line2);
   
   % Initialize the satellite before propagating it
   errCode = calllib('Sgp4Prop', 'Sgp4InitSat', satKeys(i));
   if(errCode ~= 0)
      ShowMsgAndTerminate();
   end
   
   valueStr = blanks(512);


   % Retrieve output coordinate system setting
   [errCode, valueStr] = calllib('Tle', 'TleGetField', satKeys(i), XF_TLE_EPOCH, valueStr);
   if(errCode ~= 0)
      ShowMsgAndTerminate();
   end

   epochDs50UTC = calllib('TimeFunc', 'DTGToUTC', valueStr);

   [startTime, ~, ~] = CalcStartStopTime(epochDs50UTC);
   
   step = 0;
   ds50UTC = startTime;
   stopTime = satEpoch;
   stepSize = 1440;
   if startTime > stopTime
        stepSize = -1440;
   elseif startTime == stopTime
       stepSize = 0;
   end
   % Loop through all the minute-since-epoch time steps
   while (1)
      if(stepSize >= 0 && ds50UTC >= stopTime)
         break;
      elseif(stepSize < 0 && ds50UTC <= stopTime)
         break;
      end

      ds50UTC = startTime + (step * stepSize / 1440.0);

      if ((stepSize >= 0 && ds50UTC + (EPSI / 86400) > stopTime) || (stepSize < 0 && ds50UTC - (EPSI / 86400) < stopTime))
         ds50UTC = stopTime;
      end
      
      % Propagate the current satellite to the time specified in days since 1950 UTC
      errCode = calllib('Sgp4Prop', 'Sgp4PropDs50UTC', satKeys(i), ds50UTC, msePtr, posPtr, velPtr, llhPtr);
      
      % Error or decay condition
      if(errCode ~= 0)
         errMsg = blanks(128);
         errMsg = calllib('DllMain', 'GetLastErrMsg', errMsg);
         
         % Display error message on screen
         fprintf('%s\n', errMsg);
         
         fprintf(fpOscState, '%s\n', errMsg);
         fprintf(fpOscElem, '%s\n', errMsg);
         fprintf(fpMeanElem, '%s\n', errMsg);
         
         break; % Move to the next satellite
      end
      
      pos = posPtr.Value;
      vel = velPtr.Value;
      mse = msePtr.Value;
      
      
      %Compute/Retrieve other propagator output data
      %----------------------------------------------------------------
      calllib('Sgp4Prop', 'Sgp4GetPropOut', satKeys(i), XF_SGP4OUT_OSC_KEP, oscKepPtr);
      calllib('Sgp4Prop', 'Sgp4GetPropOut', satKeys(i), XF_SGP4OUT_MEAN_KEP, meanKepPtr);
      calllib('Sgp4Prop', 'Sgp4GetPropOut', satKeys(i), XF_SGP4OUT_NODAL_AP_PER, nodalApPerPtr);
      
      oscKep = oscKepPtr.Value;
      meanKep = meanKepPtr.Value;

      % Using AstroFunc dll to compute/convert to other propagator output data if needed
      
      % Print position and velocity
      PrintPosVel(fpOscState, ds50UTC, mse, pos, vel);

      % Print osculating Keplerian elements
      PrintOscEls(fpOscElem, ds50UTC, mse, oscKep);
      
      % Print mean Keplerian elements
      PrintMeanEls(fpMeanElem, mse, meanKep);
            
      step = step + 1;

   end
   
   apo  = meanKep(1) * (1.0 + meanKep(2)) - r_Earth;
   peri = meanKep(1) * (1.0 - meanKep(2)) - r_Earth;
      
%    table_out = [table_out; {line1(3:7), ...
%        pos(1), pos(2), pos(3), ...
%        vel(1), vel(2), vel(3), ...
%        apo, peri, ...
%        oscKep(1), oscKep(2), oscKep(3), oscKep(5), oscKep(6), ...
%        stopTime}];

   catIDstr = line1(3:7);
   catID = string(catIDCheck(catIDstr));
   table_out = [table_out; {catID, ...
       pos(1), pos(2), pos(3), ...
       vel(1), vel(2), vel(3), ...
       apo, peri, ...
       meanKep(1), meanKep(2), meanKep(3), meanKep(5), meanKep(6), ...
       stopTime}];

   % Remove this satellite if no longer needed
   if(calllib('Sgp4Prop', 'Sgp4RemoveSat', satKeys(i)) ~= 0)
      ShowMsgAndTerminate();
   end
end

%-------------------------------------------------------------------------

% Remove all the satellites from memory if no longer needed
Sgp4RemoveAllSats();

% Close all output files
fclose(fpOscState);
fclose(fpOscElem);

% Close log file if needed
calllib('DllMain', 'CloseLogFile');

% Free loaded AstroStd dlls
FreeAstroStdDlls();

tElapsed = toc(tStart);

%Calculate the whole run time
fprintf('Program completed successfully.\n');
fprintf('Total run time = %10.2f seconds.\n', tElapsed );

function Sgp4RemoveAllSats
calllib('Sgp4Prop', 'Sgp4RemoveAllSats')                  


% Load all the dlls being used in the program
function LoadAstroStdDlls()
% Get current folder
s = pwd;

% Add relative path to header files
addpath([s '\SpacetrackSGP4\SampleCode\Matlab\DriverExamples/wrappers']);

% Load MainDll dll
loadlibrary DllMain   M_DllMainDll.h

% Load EnvConst dll and assign function pointers
loadlibrary EnvConst   M_EnvConstDll.h

% Load TimeFunc dll and assign function pointers
loadlibrary TimeFunc   M_TimeFuncDll.h

% Load AstroFunc dll and assign function pointers
loadlibrary AstroFunc  M_AstroFuncDll.h

% Load Tle dll and assign function pointers
loadlibrary Tle        M_TleDll.h

% Load Sgp4Prop dll and assign function pointers
loadlibrary Sgp4Prop   M_Sgp4PropDll.h


function FreeAstroStdDlls()
unloadlibrary DllMain
unloadlibrary EnvConst
unloadlibrary TimeFunc
unloadlibrary AstroFunc
unloadlibrary Tle
unloadlibrary Sgp4Prop


% Initialize all the dlls being used in the program
function InitAstroStdDlls()
% Get pointer to the global data (data pointers, function pointers, ...)
% that will be used among the dlls in the program
apPtr = calllib('DllMain', 'DllMainInit');

% Allow all the dlls access to the global data

errCode = calllib('EnvConst',  'EnvInit',       apPtr);
if(errCode ~= 0)
   ShowMsgAndTerminate();
end

errCode = calllib('TimeFunc',  'TimeFuncInit',  apPtr);
if(errCode ~= 0)
   ShowMsgAndTerminate();
end

errCode = calllib('AstroFunc', 'AstroFuncInit', apPtr);
if(errCode ~= 0)
   ShowMsgAndTerminate();
end

errCode = calllib('Tle',       'TleInit',       apPtr);
if(errCode ~= 0)
   ShowMsgAndTerminate();
end

errCode = calllib('Sgp4Prop',  'Sgp4Init',      apPtr);
if(errCode ~= 0)
   ShowMsgAndTerminate();
end


% Print header for the output files
function PrintHeader(fp, infoStr, inFile)
fprintf(fp, '%s\n\n\n', infoStr);
fprintf(fp, '%s\n',   'EPHEMERIS GENERATED BY SGP4 USING THE WGS-72 EARTH MODEL');
fprintf(fp, '%s\n',   'COORDINATE FRAME=TRUE EQUATOR AND MEAN EQUINOX OF EPOCH');
fprintf(fp, '%s\n\n', 'USING THE FK5 MEAN OF J2000 TIME AND REFERENCE FRAME');
fprintf(fp, '%s%s\n', 'INPUT FILE = ', inFile);

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
calllib('TimeFunc', 'Get6P', startFrEpochPtr, stopFrEpochPtr, startTimePtr, stopTimePtr, stepSizePtr);

startFrEpoch = startFrEpochPtr.Value;
stopFrEpoch  = stopFrEpochPtr.Value;
startTime = startTimePtr.Value;
stopTime = stopTimePtr.Value;
stepSize = stepSizePtr.Value;

dtg = blanks(20);
      
if(startFrEpoch == 1)
   fprintf(fp, '%s%14.4f%s\n', 'Start Time = ', startTime, ' min from epoch');
else
   dtg = calllib('TimeFunc', 'UTCToDTG20', startTime, dtg);
   fprintf(fp, '%s%s\n', 'Start Time = ', dtg);
end

if(stopFrEpoch == 1)
   fprintf(fp, '%s%14.4f%s\n', 'Stop Time  = ', stopTime,  ' min from epoch');
else
   dtg = calllib('TimeFunc', 'UTCToDTG20', stopTime, dtg);
   fprintf(fp, '%s%s\n', 'Stop Time  = ', dtg);
end    

fprintf(fp, '%s%14.4f%s\n\n\n', 'Step size  = ', stepSize,  ' min');


% Print position and velocity vectors
function PrintPosVel(fp,  epoch, mse,  pos,  vel)
fprintf(fp, ' %17.7f%17.7f%17.7f%17.7f%17.7f%17.7f%17.7f%17.7f\n', ...
   epoch, mse, pos(1), pos(2), pos(3), vel(1), vel(2), vel(3));


% Print osculating Keplerian elements
function PrintOscEls(fp,  epoch, mse,  oscKep)
trueAnomaly = calllib('AstroFunc', 'CompTrueAnomaly', oscKep);
fprintf(fp, ' %17.7f%17.7f%17.7f%17.7f%17.7f%17.7f%17.7f%17.7f\n', ...
   epoch, mse, oscKep(1), oscKep(2), oscKep(3), oscKep(5), oscKep(6), trueAnomaly);


% Print mean Keplerian elements
function PrintMeanEls(fp,  mse,  meanKep)
meanMotion = calllib('AstroFunc', 'AToN', meanKep(1));
eccAnomaly = calllib('AstroFunc', 'SolveKepEqtn', meanKep);
mnAnomaly = eccAnomaly - meanKep(2) * sin(eccAnomaly);
fprintf(fp, ' %17.7f%17.7f%17.7f%17.7f%17.7f%17.7f%17.7f%17.7f\n', ...
   mse, meanMotion, meanKep(1), meanKep(2), meanKep(3), meanKep(4), meanKep(5), rad2deg(mnAnomaly));


function errMsg=ShowErrMsg()
errMsg = blanks(128);
errMsg = calllib('DllMain', 'GetLastErrMsg', errMsg);
fprintf('%s\n', errMsg);


function ShowMsgAndTerminate
errMsg = ShowErrMsg();
error(errMsg);
UnloadDlls;


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
calllib('TimeFunc', 'Get6P', startFrEpochPtr, stopFrEpochPtr, startTimePtr, stopTimePtr, stepSizePtr);

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
