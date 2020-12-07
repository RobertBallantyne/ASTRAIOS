%    Purpose:
%       This program shows how a Matlab program can call the Astrodynamic Standard Dlls to propagate
%       satellites to the requested time using SGP4 propagator.
% 
%       The program is simplified to show only the core functionalities of the involved dlls. 
%       File I/O and other output statements are intentionally not included for this purpose.
% 
%       Steps to implement the SGP4 propagator:
%       1. Load and initialize all the required dlls  (LoadAstroStdDlls and InitAstroStdDlls)  
%       2. Load TLE(s) (TleAddSatFrLines, TleLoadFile, TleAddSatFrFieldsGP)
%       3. Initialize the loaded TLE(s) (Sgp4InitSat)
%       4. Propagate the initialized TLE(s) to the requested time 
%          (either minutes since epoch: Sgp4PropMse, or specific date: Sgp4PropDs50UTC, Sgp4PropDs50UtcPos, Sgp4PropDs50UtcLLH)
%       5. Deallocate loaded dlls (FreeAstroStdDlls)
% 
%    Author:
%       HQ AFSPC/A2/3/6Z


function Sgp4Prop_Simple()

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

% Add SGP4 license file path
SGP4LICFILEPATH = [ASLIBPATH '/'];
fprintf('SGP4_Open_License.txt file path= %s\n', SGP4LICFILEPATH);

% Arrays that store propagator output data
pos = zeros(3, 1);            %Position (km) in TEME of Epoch
vel = zeros(3, 1);            %Velocity (km/s) in TEME of Epoch
llh = zeros(3, 1);            % Latitude(deg), Longitude(deg), Height above Geoid (km)
mse = 0;
ds50UTC = 0;
satKey = 0;

posPtr     = libpointer('doublePtr', pos);
velPtr     = libpointer('doublePtr', vel);
llhPtr     = libpointer('doublePtr', llh);
msePtr     = libpointer('doublePtr', mse);
ds50UTCPtr = libpointer('doublePtr', ds50UTC);
satKeyPtr  = libpointer('int64Ptr', satKey); 

% Load all the dlls being used in the program
LoadAstroStdDlls();

% Specify folder that contains "SGP4_Open_License.txt" file
calllib('Sgp4Prop', 'Sgp4SetLicFilePath', SGP4LICFILEPATH);

% Initialize all the dlls being used in the program
InitAstroStdDlls();

% note: you can't use any function that returns a 19-digit key directly in
% Matlab because Matlab seems to truncate the returned 19-digit key.
% You have to use alternative methods which return the key to the
% passing parameter. These are especifically designed to work with Matlab 
% and are designated by "ML" at the end of the function names

% can't use this method since satKey will be truncated
%satKey = calllib('Tle', 'TleAddSatFrLines', ...
%                 '1 90021U RELEAS14 00051.47568104 +.00000184 +00000+0 +00000-4 0 0814', ...
%                 '2 90021   0.0222 182.4923 0000720  45.6036 131.8822  1.00271328 1199');

% ... use this alternative method which is especially designed for Matlab
% load a TLE using strings (see TLE dll document)
calllib('Tle', 'TleAddSatFrLinesML', ...
        '1 90021U RELEAS14 00351.47568104 +.00000184 +00000+0 +00000-4 0 0814', ...
        '2 90021   0.0222 182.4923 0000720  45.6036 131.8822  1.00271328 1199', satKeyPtr);
satKey = satKeyPtr.Value;      

% other ways to load TLEs into memory to work with
%TleLoadFile(fileName);  % load TLEs from a text file
%TleAddSatFrFieldsGP();  % load a TLE by passing its data fields


% initialize the loaded TLE before it can be propagated (see Sgp4Prop dll document)
% This is important!!!
errCode = calllib('Sgp4Prop', 'Sgp4InitSat', satKey);

% check to see if initialization was successful
if (errCode ~= 0)
  return;
end

% propagate using specific date, days since 1950 UTC (for example using "2000 051.051.47568104" as a start time)
% convert date time group string "YYDDD.DDDDDDDD" to days since 1950, UTC (see TimeFunc dll document)
startTime = calllib('TimeFunc', 'DTGToUTC', '00051.47568104'); 
endTime = startTime + 10;               % from start time propagate for 10 days 

% propagate for 10 days from start time with 0.5 day step size
for ds50UTC = startTime:0.5:endTime
  % see Sgp4Prop dll document
  errCode = calllib('Sgp4Prop', 'Sgp4PropDs50UTC', satKey, ds50UTC, msePtr, posPtr, velPtr, llhPtr);
  % other available propagation methods
  %Sgp4PropDs50UtcLLH(satKey, ds50UTC, llh);
  %Sgp4PropDs50UtcPos(satKey, ds50UTC, pos);
end

% propagate using minutes since satellite's epoch
% propagate for 30 days since satellite's epoch with 1 day (1440 minutes) step size
for mse = 0:1440:(30 * 1440)
  % propagate the initialized TLE to the specified time in minutes since epoch
  % see Sgp4Prop dll document
  errCode = calllib('Sgp4Prop', 'Sgp4PropMse', satKey, mse, ds50UTCPtr, posPtr, velPtr, llhPtr);
  %pos = posPtr.value;
  %fprintf('%f %f %f\n', pos(1), pos(2), pos(3));
end 

% Remove loaded satellites if no longer needed
errCode = calllib('Tle', 'TleRemoveSat', satKey);   % remove loaded TLE from memory
errCode = calllib('Sgp4Prop', 'Sgp4RemoveSat', satKey);  % remove initialized TLE from memory
%errCode = calllib('Tle', 'TleRemoveAllSats');   % remove all loaded TLEs from memory
%errCode = calllib('Sgp4Prop', 'Sgp4RemoveAllSats');  % remove all initialized TLEs from memory

% Deallocate loaded AstroStd dlls
FreeAstroStdDlls();

fprintf('Program completed.\n');
end


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

% Load Sgp4Prop dll and assign function pointers
loadlibrary Sgp4Prop   M_Sgp4PropDll.h

end


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
end

% Free all the dlls being used in the program
function FreeAstroStdDlls()
unloadlibrary DllMain
unloadlibrary EnvConst
unloadlibrary TimeFunc
unloadlibrary AstroFunc
unloadlibrary Tle
unloadlibrary Sgp4Prop
end

function errMsg=ShowErrMsg()
errMsg = blanks(128);
errMsg = calllib('DllMain', 'GetLastErrMsg', errMsg);
fprintf('%s\n', errMsg);
end

function ShowMsgAndTerminate
errMsg = ShowErrMsg();
error(errMsg);
UnloadDlls;
end
