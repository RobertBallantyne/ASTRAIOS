function LoadAstroStdDlls()
% Get current folder
s = pwd;

% Add relative path to header file

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