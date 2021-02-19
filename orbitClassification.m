clear all
clc
fclose('all')
tic
globals()

if count(py.sys.path,strcat(pwd, '\Python_Scripts\spacetrack_api')) == 0
    insert(py.sys.path,int32(0),strcat(pwd, '\Python_Scripts\spacetrack_api'));
end

mod = py.importlib.import_module('api_pull');
py.importlib.reload(mod);

historyFile = mod.orbitType('robert.a.ballantyne@gmail.com', '5z6F7Q!.VhLYrxF');
toc
analysisWindow = 10; % 10 day window for each tle

%% Uses the tle storage file created by python to and props each of them 
% forward appropriately, outputs a structure with a table for each 
% different catID
propOut = Sgp4classifier([pwd '\' char(historyFile)], analysisWindow);

%% Creates covariance matrices for each catID, binned at 0.5 days for now

% fieldNames = fields(propOut);
% for i = 1:length(fieldNames)
%     field = string(fieldNames(i));
%     [bin, cov, err] = CovGenofTable(propOut.(field), analysisWindow);
% end
[bin, cov, err] = CovGenofTable(propOut, analysisWindow);
