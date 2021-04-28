clear all
close all
clc
fclose('all')
%%
tEverything = tic;
globals()

% checks if the python folder is on the PATH
if count(py.sys.path,strcat(pwd, '\Python_Scripts\spacetrack_api')) == 0
    insert(py.sys.path,int32(0),strcat(pwd, '\Python_Scripts\spacetrack_api'));
end

% imports the appropriate python script
mod = py.importlib.import_module('api_pull');
py.importlib.reload(mod);
tic

% executes the python API script, these are my details for logging into
% space-track.org, using your own details
pullDate = mod.steven('robert.a.ballantyne@gmail.com', '5z6F7Q!.VhLYrxF');

%%
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

% output is two files containing all the TLEs as well as the file names
%% generates the names of the newly generated files
debrisFile = ['debris.inp'];
ISSFile = ['ISS.inp'];
toc

%% Extract info from tles
outFile = 'test.out';
ISS.info = tleTable('ISS.INP');
deb.info = tleTable('debris.INP');
% [table] = Sgp4([pwd '/' debrisFile], outFile, ISS.info.epoch);
%Sgp42([pwd '/' debrisFile], outFile)
% originalTable = table;
tableInput = deb.info;
%% Remove ISS from table
findISS = tableInput.catID == num2str(ISS.info.catID);
tableInput(findISS, :) = [];

clear findISS

%firstProp = Sgp4([pwd '/' ISSFile], outFile, ISS.info.epoch + 1);
%t = linspace(0, 1*24*60*60, 1*24*60*6);
%state = [ISS.info.x, ISS.info.y, ISS.info.z, ISS.info.u, ISS.info.v, ISS.info.w];
%tolerance = 1E-8;
%secondProp = propagateState(state, t, tolerance);

%% Altitude filter
tic
altTable = tableInput;
% the empirically derived tolerance
toleranceAltitude = 3;

% creates a binary array, if the difference between the apo and peri is
% greater than the tolerance then it can be ignored, orbit below
toDelete_apo = tableInput.apo < ISS.info.peri - toleranceAltitude;
altTable(toDelete_apo, :) = [];
% same for the perigee, orbit above
toDelete_peri = altTable.peri > ISS.info.apo + toleranceAltitude;
altTable(toDelete_peri, :) = [];
% deletes any with a perigee less than 100km, the uncertainties are always
% way too high
toDelete_low = altTable.peri < 100;
altTable(toDelete_low, :) = [];

clear toDelete_apo toDelete_peri toleranceAltitude
toc
%% Pointwise Filter
maxTime = max(altTable.epoch, ISS.info.epoch);
maxTime = max(maxTime);
timeStep = 12 * 60 * 60;
finalDay = maxTime + 7;
dt = finalDay - maxTime;
dtS = dt * 60 * 60 * 24;
noSteps = dtS/timeStep;
t = linspace(maxTime, finalDay, noSteps);

pointTable = altTable;
safe = [];

factor = sqrt(chi2inv(0.9999994, 3));
timeSpan = 10;
LoadAstroStdDlls()
tic 
[ISSbins, ISScov] = CovGenSGP4(ISS.info.catID, timeSpan);
Utol = sqrt(ISScov.bin_14(1, 1)) * factor * 2.5;
Vtol = sqrt(ISScov.bin_14(2, 2)) * factor * 2.5;
Wtol = sqrt(ISScov.bin_14(3, 3)) * factor * 2.5;

safe = zeros(1, height(pointTable));
%%
tic
for i = 1:height(pointTable)
    
    multiTable = Sgp4GPW('debris.INP', pointTable(i, :).catID, t);
    for count = 1:height(multiTable)
        pieceOfDebris = multiTable(count, :);
        safeCheck = closestPoint(ISS.info, pieceOfDebris, [Utol, Vtol, Wtol]);
        if safeCheck == 1
            safe(i) = 1;
        end
    end
        
end
toc
toc

pointTable(logical(safe'), :) = [];

clear safe pieceOfDebris 

%% Geo filter
geoTable = pointTable;
tic
SatPoints = oe2rv(ISS.info.a, ISS.info.e, ISS.info.i, ISS.info.raan, ISS.info.omega, 0:360);
SatPlane = planeFit3(SatPoints);
SatEllipse = ellipsefit([SatPoints.x; SatPoints.y]);

safe = zeros(1, height(geoTable));
for i = 1:height(geoTable)
    multiTable = Sgp4GPW('debris.INP', geoTable(i, :).catID, t);
    for count = 1:height(multiTable)
        pieceOfDebris = multiTable(count, :);
        safeCheck = Sieve(SatPoints, SatPlane, SatEllipse, pieceOfDebris, Wtol);
        if safeCheck == 1
            safe(i) = 1;
        end
    end
end
toc
geoTable(logical(safe), :) = [];


% now have all of the statevectors up to the same time
%% Numerical propagation, positional filter
tolerance = 1E-8;
timeStep = 10;
finalDay = maxTime + 7;
dt = finalDay - maxTime;
dtS = dt * 60 * 60 * 24;
noSteps = dtS/timeStep;
t = linspace(maxTime, finalDay, noSteps);
tic
% ISSorbit = propagateState(statevectorISS, t, tolerance);
ISSorbit = Sgp4Propagation('ISS.INP', ISS.info.catID, t);
%fingersCrossed = Sgp4Propagation('testDebris.INP', '99999', t);

toc
stateOut = struct;

catIDs = strings(height(geoTable), 1);

for i = 1:height(geoTable)
    x = geoTable(i, :).x;
    y = geoTable(i, :).y;
    z = geoTable(i, :).z;
    u = geoTable(i, :).u;
    v = geoTable(i, :).v;
    w = geoTable(i, :).w;
    % state vector is in km and km/s, keep this in mind
   
    stateVector = [x, y, z, u, v, w];
    % define initial state vector
    
    tic
    disp(['ID', geoTable(i, :).catID])
%     stateOut.(append('ID', pointTable(i, :).catID)) = propagateState(stateVector, t, tolerance);
    stateOut.(append('ID', geoTable(i, :).catID)) = Sgp4Propagation('debris.INP', geoTable(i, :).catID, t);
    % propagate using the function we made
    toc
    disp(num2str(i))
end

%% Obtain covariance matrices for the ISS and the potential collision sat(s)
covTable = geoTable;
delFromTable = zeros(1, height(covTable));
timeSpan = ceil(finalDay + 3 - ISS.info.epoch);
% LoadAstroStdDlls()
[ISSbins, ISScov, error] = CovGenSGP4(ISS.info.catID, timeSpan);
sats = fieldnames(stateOut);
numsats = length(sats);
for i = 1:numsats
    timeSpan = ceil(finalDay + 3 - geoTable(i, :).epoch);
    if sats{i} == "ID99999"
        timeSpan = ceil(finalDay + 3 - maxTime);
        [satbins.(sats{i}), satcov.(sats{i}), error] = CovGenSGP4(ISS.info.catID, timeSpan);
        break;
    end
    [satbins.(sats{i}), satcov.(sats{i}), error] = CovGenSGP4(sats{i}(3:end), timeSpan);
    
    % removes empty covariance arrays, for when there werent enough tles
    if error
        satbins = rmfield(satbins, sats{i});
        satcov = rmfield(satcov, sats{i});
        stateOut = rmfield(stateOut, sats{i});
        delFromTable(i) = 1;
    end
end
covTable(logical(delFromTable), :) = [];
FreeAstroStdDlls()
% satcov.ID46477 = ISScov;

%% Positional filter

% this will return the positions at which each piece of debris in the
% stateOut structure gets too close to the ISS
sats = fieldnames(stateOut);
numsats = length(sats);
collisions = struct;
%parpool(10)
for i = 1:numsats
    if sats{i} == "ID99999"
        crash = posFilter(ISSorbit, stateOut.(sats{i}), ISScov, satcov.(sats{i}), ISS.info.epoch, ISS.info.epoch);
    if ~isempty(crash)
        collisions.(sats{i}) = crash;
    end
        break;
    else
        tic
        crash = posFilter(ISSorbit, stateOut.(sats{i}), ISScov, satcov.(sats{i}), ISS.info.epoch, covTable(i, :).epoch);
        toc
    end
    if ~isempty(crash)
        collisions.(sats{i}) = crash;
    end
end

toc(tEverything)
clear tEverything propagationEpoch

%% Delete ones with zero probability
backupCollision = collisions;
sats = fieldnames(collisions);
for i = 1:length(sats)
    currentObj = collisions.(sats{i});
    findZeros = currentObj(:, 8) == 0;
    collisions.(sats{i})(findZeros, :) = [];
end
%% Find dangerous collisions
sats = fieldnames(collisions);
catIDstore = cell(0);
xStore = [];
yStore = [];
zStore = [];
uStore = [];
vStore = [];
wStore = [];
epochStore = [];
PcStore = [];
for i = 1:length(sats)
    result = collisions.(sats{i});
    for j = 1:size(result, 1)
        if result(j, 8) > 1E-4
            catIDstore = [catIDstore, sats{i}];
            xStore = [xStore, result(j, 2)];
            yStore = [yStore, result(j, 3)];
            zStore = [zStore, result(j, 4)];
            uStore = [uStore, result(j, 5)];
            vStore = [vStore, result(j, 6)];
            wStore = [wStore, result(j, 7)];
            epochStore = [epochStore, result(j, 1)];
            PcStore = [PcStore, result(j, 8)];
        end
    end

end
vars = {'catID', 'x', 'y', 'z', 'u', 'v', 'w', 'epoch', 'Pc'};
vartypes = {'string', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double'};
actualCollision = table('Size', [length(xStore) length(vars)], 'VariableTypes', vartypes, 'VariableNames', vars);
actualCollision.catID = catIDstore';
actualCollision.x = xStore';
actualCollision.y = yStore';
actualCollision.z = zStore';
actualCollision.u = uStore';
actualCollision.v = vStore';
actualCollision.w = wStore';
actualCollision.epoch = epochStore';
actualCollision.Pc = PcStore';
%% Find nearest collision spread of the 'soonest' collision
actualCollision = sortrows(actualCollision,'epoch','ascend');

i = 1;
while(1)
    if actualCollision(i, :).epoch == actualCollision(i+1, :).epoch - 1 && actualCollision(i, :).Pc > actualCollision(i+1, :).Pc
        minTime = i;
        break
    else
        i = i + 1;
    end
end

% uses the smallest 't' from each sat and finds the minimum of these as well
% as the index as that will be the same as the sat index

% defines the satellite that will be avoided by the control system, as well
% as giving the time of collision
oneToAvoid = sats{i};

% Main outputs of this section are the time of collision (only?)
%% propagating the new orbits, from 500-1100m from the original one in the U direction

%originalState = table2array(ISSorbit(crashTime, :));

originalState = actualCollision(i, :);

[Ut, Vt, Wt] = orc([originalState.x, originalState.y, originalState.z, originalState.u, originalState.v, originalState.w]);
        
R = [Ut; Vt; Wt];

originalStateUVW = R * [originalState.x, originalState.y, originalState.z]';

URange = linspace(0, 50000, 500);

maxTime2 = 60 * 60 * 24 * 3;% + crashTime; % Propagation time is 3 days, converted to seconds
timeStep = 10; % needs a short time step since things are going so fast
t = 0:timeStep:maxTime2;
tolerance = 1E-8;

for i = 1:length(URange)
    newStateUVW = originalStateUVW;
    newStateUVW(1) = newStateUVW(1) + URange(i)/1000;
    
    newState = [(R \ newStateUVW)' [originalState.u, originalState.v, originalState.w]];
    
    newOut.(strcat('dU', num2str(round(URange(i))))) = propagateState(newState, t, tolerance);
end

% output of this section is the 'newOut' structure containing all of the
% propagated states.

%%% Collision analysis on the new propagated states

% take all the dU names so that they can be iterated
dUs = fieldnames(newOut);
sats = fieldnames(stateOut);
numsats = length(sats);

% create new structure to store all the collisions for each dU
newCollisions = struct;

for i = 1:length(dUs)
    for j = 1:numsats
        tic
        crash = posFilter(newOut.(dUs{i}), stateOut.(sats{j}), ISScov, satcov.(sats{j}), maxTime, maxTime);
        toc
        if ~isempty(crash)
            newCollisions.(dUs{i}).(sats{j}) = crash;
        end
    end
end

% output is the newCollisions structure containg the collisions for each
% satellite for each new dU position

%%
maxProbability = struct;
for i = 1:length(fieldnames(newCollisions))
    maxProbability.(dUs{i}) = table('Size', [length(newCollisions.(dUs{i}).(sats{1})) 2], 'VariableTypes', {'string', 'double'}, 'VariableNames', {'satellite', 'Pc'});
    satellites = cell(1, length(newCollisions.(dUs{i}).(sats{j})));
    satellites(:) = cellstr(sats{1});
    Pcs = newCollisions.(dUs{i}).(sats{1})(:, 8);
    for j = 1:numsats
        for k = 1:length(newCollisions.(dUs{i}).(sats{j}))
            if newCollisions.(dUs{i}).(sats{j})(k, 8) > Pcs(k)
                satellites(k) = cellstr(sats{j});
                Pcs(k) = max(newCollisions.(dUs{i}).(sats{j})(:, 8));
            end
        end
    end
    maxProbability.(dUs{i}).Pc = Pcs;
    maxProbability.(dUs{i}).satellite = satellites';
end

%%
numdU = length(dUs);
maxProp2 = zeros(length(maxProbability.(dUs{i}).Pc), numdU);
for i = 1:numdU
    maxProp2(:, i) = maxProbability.(dUs{i}).Pc;
end