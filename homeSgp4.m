function [table_out] = homeSgp4(inFile, maxInterval)

%% initiate sgp4 dlls

ASLIBPATH = strcat(pwd, '\SpacetrackSGP4\Lib\Win64');

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

addpath([pwd '\SpacetrackSGP4\SampleCode\Matlab\DriverExamples/wrappers']);


% Load all the dlls being used in the program
LoadAstroStdDlls();

% Specify folder that contains "SGP4_Open_License.txt" file
calllib('Sgp4Prop', 'Sgp4SetLicFilePath', SGP4LICFILEPATH);
calllib('Sgp4Prop', 'Sgp4RemoveAllSats');
calllib('Tle', 'TleRemoveAllSats');
% Initialize all the dlls being used in the program
InitAstroStdDlls();

sgp4DllInfo = blanks(128);

line1 = blanks(512);
line2 = blanks(512);

mse = (0);
EPSI = 0.00050;

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

% Load Tles from the input file
calllib('Sgp4Prop', 'Sgp4RemoveAllSats');
calllib('Tle', 'TleRemoveAllSats');
errCode = calllib('Tle', 'TleLoadFile', inFile);
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

global r_Earth

vars = {'catID', 'x', 'y', 'z', 'u', 'v', 'w', 'apo', 'peri', 'a', 'e', 'i', 'raan', 'omega', 'startTime', 'stopTime', 'deltaT'};
vartypes = {'string', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double'};
table_out = table('Size', [0 length(vars)], 'VariableTypes', vartypes, 'VariableNames', vars);

epochs = zeros(1, numSats);

XF_TLE_EPOCH = 4;
XF_SGP4OUT_MEAN_KEP = 3;  % Mean Keplerian

for i = 1:numSats
    satEpochDTG = blanks(512);
    [errcode, satEpochDTG] = calllib('Tle', 'TleGetField', satKeys(i), XF_TLE_EPOCH, satEpochDTG);
    satEpochDs50UTC = calllib('TimeFunc', 'DTGToUTC', satEpochDTG);
    epochs(i) = satEpochDs50UTC;
end

stepSize = 1440;

for i = 1:numSats
    
    % Return the two strings, line1 line2, representing the TLE
    [errCode, line1, line2] = calllib('Tle', 'TleGetLines', satKeys(i), line1, line2);

    % Initialize the satellite before propagating it
    errCode = calllib('Sgp4Prop', 'Sgp4InitSat', satKeys(i));
    if(errCode ~= 0)
        ShowMsgAndTerminate();
    end
   
    for j = i:numSats
        
        startTime = epochs(i);
        stopTime  = epochs(j);
        
        deltaT = stopTime - startTime;
        
        if deltaT > maxInterval
            break;
        end

        errCode = calllib('Sgp4Prop', 'Sgp4PropDs50UTC', satKeys(i), stopTime, msePtr, posPtr, velPtr, llhPtr);
        calllib('Sgp4Prop', 'Sgp4GetPropOut', satKeys(i), XF_SGP4OUT_MEAN_KEP, meanKepPtr);
        % Error or decay condition
        if(errCode ~= 0)
            errMsg = blanks(128);
            errMsg = calllib('DllMain', 'GetLastErrMsg', errMsg);

            % Display error message on screen
            fprintf('%s\n', errMsg);
        end

        pos = posPtr.Value;
        vel = velPtr.Value;
        meanKep = meanKepPtr.Value;
        apo  = meanKep(1) * (1.0 + meanKep(2)) - r_Earth/1000;
        peri = meanKep(1) * (1.0 - meanKep(2)) - r_Earth/1000;
        table_out = [table_out; {line1(3:7), ...
            pos(1), pos(2), pos(3), ...
            vel(1), vel(2), vel(3), ...
            apo, peri, ...
            meanKep(1), meanKep(2), meanKep(3), meanKep(5), meanKep(6), ...
            startTime, stopTime, deltaT}];
                
    end

end
calllib('Sgp4Prop', 'Sgp4RemoveAllSats');
calllib('Tle', 'TleRemoveAllSats');
FreeAstroStdDlls()


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

function ShowMsgAndTerminate
errMsg = ShowErrMsg();
error(errMsg);
UnloadDlls;


function errMsg=ShowErrMsg()
errMsg = blanks(128);
errMsg = calllib('DllMain', 'GetLastErrMsg', errMsg);
fprintf('%s\n', errMsg);
