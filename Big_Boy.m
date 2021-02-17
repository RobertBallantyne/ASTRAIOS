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
[ISSbins, ISScov] = CovGen(ISS.info.catID, 5);
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
toleranceAltitude = 50;

toDelete_apo = table.apo < ISS.info.peri - toleranceAltitude;
altTable(toDelete_apo, :) = [];
toDelete_peri = altTable.peri > ISS.info.apo + toleranceAltitude;
altTable(toDelete_peri, :) = [];
toDelete_low = altTable.peri < 100;
altTable(toDelete_low, :) = [];

clear toDelete_apo toDelete_peri toleranceAltitude

%% Pointwise Filter
pointTable = altTable;
safe = [];
tic
for i = 1:height(pointTable)
    pieceOfDebris = pointTable(i, :);
    safe = [safe; closestPoint(ISS.info, pieceOfDebris)];
end
toc

pointTable(logical(safe'), :) = [];

clear safe pieceOfDebris 

%% Geo filter
% geoTable = pointTable;
% tic
% SatPoints = oe2rv(ISS.info.a, ISS.info.e, ISS.info.i, ISS.info.raan, ISS.info.omega, 0:360);
% SatPlane = planeFit3(SatPoints);
% SatEllipse = ellipsefit([SatPoints.x; SatPoints.y]);
% 
% safe = [];
% for i = 1:height(geoTable)
%     pieceOfDebris = geoTable(i, :);
%     safe = [safe; Sieve(SatPoints, SatPlane, SatEllipse, pieceOfDebris, 15)];
% end
% toc
% geoTable(logical(safe), :) = [];
%% Numerical propagation, positional filter

statevectorISS = [ISS.info.x, ISS.info.y, ISS.info.z, ISS.info.u, ISS.info.v, ISS.info.w];

maxTime = 60 * 60 * 24 * 7; % Propagation time is 7 days, converted to seconds
timeStep = 1; % needs a short time step since things are going so fast
t = 1:timeStep:maxTime;
tolerance = 1E-8;
% set arbitrarily low tolerance, unsure on how this effects things
tic
ISSorbit = propagateState(statevectorISS, t, tolerance);
toc
stateOut = struct;

catIDs = strings(height(geoTable), 1);

for i = 1:height(geoTable)
    x = pointTable(i, :).x;
    y = pointTable(i, :).y;
    z = pointTable(i, :).z;
    u = pointTable(i, :).u;
    v = pointTable(i, :).v;
    w = pointTable(i, :).w;
    % state vector is in km and km/s, keep this in mind
    
    stateVector = [x, y, z, u, v, w];
    % define initial state vector
    
    tic
    stateOut.(append('ID', pointTable(i, :).catID)) = propagateState(stateVector, t, tolerance);
    % propagate using the function we made
    toc
    disp(num2str(i))
end
clear x y z u v w t timeStep stateVector statevectorISS tolerance maxTime

%% Obtain covariance matrices for the ISS and the potential collision sat(s)

[ISSbins, ISScov] = CovGen(ISS.info.catID, 5);
sats = fieldnames(collisions);
for i = 1:length(sats)
    [satbins.(sats{i}), satcov.(sats{i})] = CovGen(sats{i}(3:end), 5);
end

%% Positional filter

xToleranceIntegration = 100;
yToleranceIntegration = 100;
zToleranceIntegration = 100;

collisions = posFilter(ISSorbit, stateOut, xToleranceIntegration, yToleranceIntegration, zToleranceIntegration);

clear xToleranceIntegration yToleranceIntegration zToleranceIntegration

toc(tEverything)
clear tEverything propagationEpoch