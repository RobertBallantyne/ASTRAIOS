clear all
close all
clc
fclose('all')
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
% space-track.org
%pullDate = mod.steven2('robert.a.ballantyne@gmail.com', '5z6F7Q!.VhLYrxF');

% output is two files containing all the TLEs as well as the file names
%% generates the names of the newly generated files
debrisFile = ['debris.inp'];
ISSFile = ['ISS.inp'];
toc

%% Propagating all the TLEs forwards/backwards to the epoch of the ISS
outFile = 'test.out';
ISS.info = tleTable(ISSFile);
deb.info = tleTable(debrisFile);
[table] = Sgp4([pwd '/' debrisFile], outFile, ISS.info.epoch);
%Sgp42([pwd '/' debrisFile], outFile)
originalTable = table;

%% Remove ISS from table
findISS = table.catID == num2str(ISS.info.catID);
table(findISS, :) = [];

clear findISS

%% Altitude filter
altTable = table;
% the empirically derived tolerance
toleranceAltitude = 30;

% creates a binary array, if the difference between the apo and peri is
% greater than the tolerance then it can be ignored, orbit below
toDelete_apo = table.apo < ISS.info.peri - toleranceAltitude;
altTable(toDelete_apo, :) = [];
% same for the perigee, orbit above
toDelete_peri = altTable.peri > ISS.info.apo + toleranceAltitude;
altTable(toDelete_peri, :) = [];
% deletes any with a perigee less than 100km, the uncertainties are always
% way too high
toDelete_low = altTable.peri < 100;
altTable(toDelete_low, :) = [];

clear toDelete_apo toDelete_peri toleranceAltitude

%% Pointwise Filter
pointTable = altTable;
safe = [];
tic
factor = sqrt(chi2inv(0.9, 3));
%[ISSbins, ISScov] = CovGen(ISS.info.catID, 10);
Utol = 20;%sqrt(ISScov.bin_10(1, 1)) * factor;
Vtol = 200;%sqrt(ISScov.bin_10(2, 2)) * factor;
Wtol = 20;%sqrt(ISScov.bin_10(3, 3)) * factor;

for i = 1:height(pointTable)
    pieceOfDebris = pointTable(i, :);
    safe = [safe; closestPoint(ISS.info, pieceOfDebris, [Utol, Vtol, Wtol])];
end
toc

pointTable(logical(safe'), :) = [];

clear safe pieceOfDebris 

% %% Geo filter
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

maxTime = 60 * 60 * 24 * 3; % Propagation time is 7 days, converted to seconds
timeStep = 1; % needs a short time step since things are going so fast
t = 1:timeStep:maxTime;
tolerance = 1E-8;
% set arbitrarily low tolerance, unsure on how this effects things
tic
ISSorbit = propagateState(statevectorISS, t, tolerance);
toc
stateOut = struct;

catIDs = strings(height(pointTable), 1);

for i = 1:height(pointTable)
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

days = 10;
[ISSbins, ISScov] = CovGen('25544', days);

% sats = fieldnames(stateOut);
% numsats = length(sats);
% for i = 1:numsats
%     sats{i}(3:end)
%     [satbins.(sats{i}), satcov.(sats{i})] = CovGen(sats{i}(3:end), 10);
%     
%     % removes empty covariance arrays, for when there werent enough tles
%     if or(~isstruct(satcov.(sats{i})), ...
%           length(fieldnames(satbins.(sats{i}))) < days * 2)
%         satbins = rmfield(satbins, sats{i});
%         satcov = rmfield(satcov, sats{i});
%         stateOut = rmfield(stateOut, sats{i});
%     end
% end

satcov.ID46477 = ISScov;

%% Positional filter

% this will return the positions at which each piece of debris in the
% stateOut structure gets too close to the ISS
sats = fieldnames(stateOut);
numsats = length(sats);
collisions = struct;

for i = 1:numsats
    
    crash = posFilter(ISSorbit, stateOut.(sats{i}), ISScov, satcov.(sats{i}), 100, 20);
    if ~isempty(crash)
        collisions.(sats{i}) = crash;
    end
end

toc(tEverything)
clear tEverything propagationEpoch


%% Find nearest collision spread of the 'soonest' collision

sats = fieldnames(collisions);
minTimes = [];
for i = 1:length(sats)
    sats{i}(3:end)
    minTime(i) = min(collisions.(sats{i})(1));
end

% uses the smallest 't' from each sat and finds the minimum of these as well
% as the index as that will be the same as the sat index
[crashTime, DebIndex] = max(minTime);

% defines the satellite that will be avoided by the control system, as well
% as giving the time of collision
oneToAvoid = sats{DebIndex};

% Main outputs of this section are the time of collision (only?)
%% propagating the new orbits, from 500-1100m from the original one in the U direction

originalState = table2array(ISSorbit(crashTime, :));

[Ut, Vt, Wt] = orc(originalState(2:7));
        
R = [Ut; Vt; Wt];

originalStateUVW = R * originalState(2:4)';

URange = linspace(500, 1100, 10);

maxTime = 60 * 60 * 24 * 3 + crashTime; % Propagation time is 3 days, converted to seconds
timeStep = 1; % needs a short time step since things are going so fast
t = crashTime:timeStep:maxTime;
tolerance = 1E-8;

for i = 1:length(URange)
    newStateUVW = originalStateUVW;
    newStateUVW(1) = newStateUVW(1) + URange(i)/1000;
    
    newState = [(R \ newStateUVW)' originalState(5:7)];
    
    newOut.(strcat('dU', num2str(round(URange(i))))) = propagateState(newState, t, tolerance);
end

% output of this section is the 'newOut' structure containing all of the
% propagated states.

%% Collision analysis on the new propagated states

% take all the dU names so that they can be iterated
dUs = fieldnames(newOut);
sats = fieldnames(collisions);
numsats = length(sats);

% create new structure to store all the collisions for each dU
newCollisions = struct;

for i = 1:length(dUs)
    for j = 1:numsats
    
        crash = posFilter(newOut.(dUs{i}), stateOut.(sats{j}), ISScov, satcov.(sats{j}), 100, 20);
        if ~isempty(crash)
            newCollisions.(dUs{i}).(sats{j}) = crash;
        end
    end
end

% output is the newCollisions structure containg the collisions for each
% satellite for each new dU position