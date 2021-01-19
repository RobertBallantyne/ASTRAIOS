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

ISS.tle = tleRead(ISSFile);

ISS.tle.SGP4Epoch = epochConvertor(ISS.tle.Epoch);

[table] = Sgp4([pwd '/' debrisFile], outFile, ISS.tle.SGP4Epoch);
%Sgp42([pwd '/' debrisFile], outFile)
originalTable = table;

%% Remove ISS from table
findISS = table.catID == num2str(ISS.tle.catID);
table(findISS, :) = [];

%% Get r and v for the ISS starting conditions
ISS.state = oe2rv(ISS.tle.a, ISS.tle.e, ISS.tle.i, ISS.tle.raan, ISS.tle.omega, ISS.tle.nu);

%% Altitude filter
altTable = table;
toleranceAltitude = 5;

toDelete_apo = table.apo < ISS.tle.peri/1000 - toleranceAltitude;
altTable(toDelete_apo, :) = [];
toDelete_peri = altTable.peri > ISS.tle.apo/1000 + toleranceAltitude;
altTable(toDelete_peri, :) = [];

%% Geometry Filter
geoTable = altTable;
dist = [];
tic
for i = 1:height(geoTable)
    pieceOfDebris = geoTable(i, :);
    dist(i) = closestPoint(ISS.tle, pieceOfDebris);
end
toc
toleranceGeometric = 1;
toDelete_distance = dist > toleranceGeometric;
geoTable(toDelete_distance, :) = [];

%% Numerical propagation, positional filter

global propagationEpoch

propagationEpoch = ISS.tle.SGP4Epoch;

statevectorISS = [ISS.state.x, ISS.state.y, ISS.state.z, ISS.state.u, ISS.state.v, ISS.state.w];

maxTime = 60 * 60 * 24 * 7; % Propagation time is 7 days, converted to seconds
timeStep = 1000; % needs a short time step since things are going so fast
t = 1:timeStep:maxTime;
tolerance = 1E-5;
% set arbitrarily low tolerance, unsure on how this effects things

tic
ISSorbit = propagateState(statevectorISS, t, tolerance);
toc
stateOut = struct;

catIDs = strings(height(geoTable), 1);

for i = 1:height(geoTable)
    x = geoTable(i, :).x*1000;
    y = geoTable(i, :).y*1000;
    z = geoTable(i, :).z*1000;
    u = geoTable(i, :).u*1000;
    v = geoTable(i, :).v*1000;
    w = geoTable(i, :).w*1000;
    % state vector is in km and km/s, keep this in mind
    
    stateVector = [x, y, z, u, v, w];
    % define initial state vector
    
    tic
    stateOut.(append('ID', geoTable(i, :).catID)) = propagateState(stateVector, t, tolerance);
    % propagate using the function we made
    toc
    disp(num2str(i))
end

%% Positional filter

xToleranceIntegration = 100000;
yToleranceIntegration = 100000;
zToleranceIntegration = 100000;

collisions = xyzFilter(ISSorbit, stateOut, xToleranceIntegration, yToleranceIntegration, zToleranceIntegration);
toc(tEverything)