function [table_out] = Sgp4GPW(inFile, incatID, t)

global r_Earth

EPSI = 0.00050;
fprintf('Program starts.\n');
tStart = tic;

XF_TLE_EPOCH = 4;

sgp4DllInfo = blanks(128);

line1 = blanks(512);
line2 = blanks(512);

mse = (0);

% Arrays that store propagator output data
pos = zeros(3, 1);            % Position (km)
vel = zeros(3, 1);            % Velocity (km/s)
llh = zeros(3, 1);            % Latitude(deg), Longitude(deg), Height above Geoid (km)

posPtr     = libpointer('doublePtr', pos);
velPtr     = libpointer('doublePtr', vel);
llhPtr     = libpointer('doublePtr', llh);
msePtr = libpointer('doublePtr', mse);

% Specify folder that contains "SGP4_Open_License.txt" file
calllib('Sgp4Prop', 'Sgp4RemoveAllSats');
calllib('Tle', 'TleRemoveAllSats');
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

meanKep = zeros(6, 1);        % Mean Keplerian elements
meanKepPtr    = libpointer('doublePtr', meanKep);
XF_SGP4OUT_MEAN_KEP     = 3;  % Mean Keplerian

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

% Loop through all the TLEs in the input file

for i = 1:numSats
   
   % Return the two strings, line1 line2, representing the TLE
   [errCode, line1, line2] = calllib('Tle', 'TleGetLines', satKeys(i), line1, line2);
    catIDstr = line1(3:7);
	catID = string(catIDCheck(catIDstr));
    
    if str2double(catID) == str2double(incatID)
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
        
%       steps = ceil((stopTime - startTime)/(stepSize/60/24));
        vars = {'x', 'y', 'z', 'u', 'v', 'w', 'apo', 'peri', 'a', 'e', 'i', 'raan', 'omega', 'mm', 't'};
        vartypes = {'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double'};
        table_out = table('Size', [length(t), length(vars)], 'VariableTypes', vartypes, 'VariableNames', vars);
        X = zeros(1, length(t));
        Y = zeros(1, length(t));
        Z = zeros(1, length(t));
        U = zeros(1, length(t));
        V = zeros(1, length(t));
        W = zeros(1, length(t));
        APO = zeros(1, length(t));
        PERI = zeros(1, length(t));
        A = zeros(1, length(t));
        E = zeros(1, length(t));
        I = zeros(1, length(t));
        RAAN = zeros(1, length(t));
        OMEGA = zeros(1, length(t));
        MM = zeros(1, length(t));
        T = zeros(1, length(t));
        % Loop through all the minute-since-epoch time steps
        for j = 1:length(t)

            ds50UTC = t(j);

            % Propagate the current satellite to the time specified in days since 1950 UTC
            errCode = calllib('Sgp4Prop', 'Sgp4PropDs50UTC', satKeys(i), ds50UTC, msePtr, posPtr, velPtr, llhPtr);
            calllib('Sgp4Prop', 'Sgp4GetPropOut', satKeys(i), XF_SGP4OUT_MEAN_KEP, meanKepPtr);
            
            pos = posPtr.Value;
            vel = velPtr.Value;
            meanKep = meanKepPtr.Value;

            X(j) = pos(1);
            Y(j) = pos(2);
            Z(j) = pos(3);
            U(j) = vel(1);
            V(j) = vel(2);
            W(j) = vel(3);
            APO(j) = meanKep(1) * (1.0 + meanKep(2)) - r_Earth;
            PERI(j) = meanKep(1) * (1.0 - meanKep(2)) - r_Earth;
            A(j) = meanKep(1);
            E(j) = meanKep(2);
            I(j) = meanKep(3);
            RAAN(j) = meanKep(5);
            OMEGA(j) = meanKep(6);
            MM(j) = 0;
            T(j) = ds50UTC;

        end
      % Remove this satellite if no longer needed
    if(calllib('Sgp4Prop', 'Sgp4RemoveSat', satKeys(i)) ~= 0)
        ShowMsgAndTerminate();
    end
    table_out.x = X';
    table_out.y = Y';
    table_out.z = Z';
    table_out.u = U';
    table_out.v = V';
    table_out.w = W';
    table_out.apo = APO';
    table_out.peri = PERI';
    table_out.a = A';
    table_out.e = E';
    table_out.i = I';
    table_out.raan = RAAN';
    table_out.omega = OMEGA';
    table_out.mm = MM';
    table_out.t = T';
    return
    
    end
end

%-------------------------------------------------------------------------

% Remove all the satellites from memory if no longer needed
Sgp4RemoveAllSats();

tElapsed = toc(tStart);


% Free loaded AstroStd dlls
FreeAstroStdDlls();

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

