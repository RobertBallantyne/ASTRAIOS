clear all
close all
clc
tEverything = tic;
globals()

if count(py.sys.path,strcat(pwd, '\Python_Scripts\spacetrack_api')) == 0
    insert(py.sys.path,int32(0),strcat(pwd, '\Python_Scripts\spacetrack_api'));
end

mod = py.importlib.import_module('api_pull');
py.importlib.reload(mod);
tic
pullDate = mod.steven('robert.a.ballantyne@gmail.com', '5z6F7Q!.VhLYrxF');
%% generates the names of the newly generated files
debrisFile = ['debris_on_' char(pullDate)];
ISSFile = ['ISS_on_' char(pullDate)];
toc
%%
outFile = 'test.out';

ISS.info = tleTable(ISSFile);
%%
[table] = Sgp4([pwd '/' debrisFile], outFile, ISS.info.epoch);
%Sgp42([pwd '/' debrisFile], outFile)
originalTable = table;

%% Remove ISS from table
findISS = table.catID == num2str(ISS.info.catID);
table(findISS, :) = [];

clear findISS

%% Altitude filter
altTable = table;
toleranceAltitude = 100;

toDelete_apo = table.apo < ISS.info.peri - toleranceAltitude;
altTable(toDelete_apo, :) = [];
toDelete_peri = altTable.peri > ISS.info.apo + toleranceAltitude;
altTable(toDelete_peri, :) = [];
toDelete_low = altTable.peri < 200;
altTable(toDelete_low, :) = [];

clear toDelete_apo toDelete_peri toleranceAltitude toDelete_low

%% Splitting by perigee altitude
table2 = altTable;
alt200find = altTable.peri < 300;
alt200all = altTable(alt200find, :);
altTable(alt200find, :) = [];

alt300find = altTable.peri < 400;
alt300all = altTable(alt300find, :);
altTable(alt300find, :) = [];

alt400find = altTable.peri < 500;
alt400all = altTable(alt400find, :);
altTable(alt400find, :) = [];

alt500find = altTable.peri < 600;
alt500all = altTable(alt500find, :);
altTable(alt500find, :) = [];

%% Splitting by eccentricity
alt200Backup = alt200all;
findIt = alt200all.e < 0.02;
alt200.e00_e02 = alt200all(findIt, :);
alt200all(findIt, :) = [];
findIt = alt200all.e < 0.2;
alt200.e02_e2 = alt200all(findIt, :);
alt200all(findIt, :) = [];
findIt = alt200all.e < 0.7;
alt200.e2_e7 = alt200all(findIt, :);
alt200all(findIt, :) = [];
findIt = alt200all.e <= 1;
alt200.e7_e = alt200all(findIt, :);
alt200all(findIt, :) = [];

alt300Backup = alt300all;
findIt = alt300all.e < 0.02;
alt300.e00_e02 = alt300all(findIt, :);
alt300all(findIt, :) = [];
findIt = alt300all.e < 0.2;
alt300.e02_e2 = alt300all(findIt, :);
alt300all(findIt, :) = [];
findIt = alt300all.e < 0.7;
alt300.e2_e7 = alt300all(findIt, :);
alt300all(findIt, :) = [];
findIt = alt300all.e <= 1;
alt300.e7_e = alt300all(findIt, :);
alt300all(findIt, :) = [];

alt400Backup = alt400all;
findIt = alt400all.e < 0.02;
alt400.e00_e02 = alt400all(findIt, :);
alt400all(findIt, :) = [];
findIt = alt400all.e < 0.2;
alt400.e02_e2 = alt400all(findIt, :);
alt400all(findIt, :) = [];
findIt = alt400all.e < 0.7;
alt400.e2_e7 = alt400all(findIt, :);
alt400all(findIt, :) = [];
findIt = alt400all.e <= 1;
alt400.e7_e = alt400all(findIt, :);
alt400all(findIt, :) = [];

alt500Backup = alt500all;
findIt = alt500all.e < 0.02;
alt500.e00_e02 = alt500all(findIt, :);
alt500all(findIt, :) = [];
findIt = alt500all.e < 0.2;
alt500.e02_e2 = alt500all(findIt, :);
alt500all(findIt, :) = [];
findIt = alt500all.e < 0.7;
alt500.e2_e7 = alt500all(findIt, :);
alt500all(findIt, :) = [];
findIt = alt500all.e <= 1;
alt500.e7_e = alt500all(findIt, :);
alt500all(findIt, :) = [];

%% getting covariance matrices for each option, only last one is needed since the worst case is assumed
global analWindow fetch tThrottle
analWindow = 5;
fetch = 0;
tThrottle = tic;

% %% initiate sgp4 dlls
% 
% ASLIBPATH = strcat(pwd, '\SpacetrackSGP4\Lib\Win64');
% 
% if ispc
%   sysPath = getenv('PATH');
%   setenv('PATH', [ASLIBPATH ';' sysPath]);
% elseif isunix
%   sysPath = getenv('LD_LIBRARY_PATH');
%   setenv('LD_LIBRARY_PATH', [ASLIBPATH ';' sysPath]);
% end
% 
% % Add SGP4 license file path
% SGP4LICFILEPATH = [ASLIBPATH '/'];
% fprintf('SGP4_Open_License.txt file path= %s\n', SGP4LICFILEPATH);
% 
% addpath([pwd '\SpacetrackSGP4\SampleCode\Matlab\DriverExamples/wrappers']);
% 
% 
% % Load all the dlls being used in the program
% LoadAstroStdDlls();
% 
% % Specify folder that contains "SGP4_Open_License.txt" file
% calllib('Sgp4Prop', 'Sgp4SetLicFilePath', SGP4LICFILEPATH);
% calllib('Sgp4Prop', 'Sgp4RemoveAllSats');
% calllib('Tle', 'TleRemoveAllSats');
% % Initialize all the dlls being used in the program
% InitAstroStdDlls();
%% alt is 200-300km
fields = fieldnames(alt200);
for i = 3:length(fields)
    field = string(fields(i));
    cov200.(field) = meanCov(alt200.(field));
    writematrix(cov200.(field), strcat(pwd, '/cov200/', field, '.csv'))
end

%% alt is 300-400km
fields = fieldnames(alt300);
for i = 1:length(fields)
    field = string(fields(i));
    cov300.(field) = meanCov(alt300.(field));
    writematrix(cov300.(field), strcat(pwd, '/cov300/', field, '.csv'))
end
%% alt is 400-500km
fields = fieldnames(alt400);
for i = 1:length(fields)
    field = string(fields(i));
    cov400.(field) = meanCov(alt400.(field));
    writematrix(cov400.(field), strcat(pwd, '/cov400/', field, '.csv'))
end
%% alt is 500-600km
fields = fieldnames(alt500);
for i = 1:length(fields)
    field = string(fields(i));
    cov500.(field) = meanCov(alt500.(field));
    writematrix(cov500.(field), strcat(pwd, '/cov500/', field, '.csv'))
end
% 
% FreeAstroStdDlls()


function FreeAstroStdDlls()
unloadlibrary DllMain
unloadlibrary EnvConst
unloadlibrary TimeFunc
unloadlibrary AstroFunc
unloadlibrary Tle
unloadlibrary Sgp4Prop
end

% Load all the dlls being used in the program
function LoadAstroStdDlls()
% Get current folder
s = pwd;

% % Add relative path to header files
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