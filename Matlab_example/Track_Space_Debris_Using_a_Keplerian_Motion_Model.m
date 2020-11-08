rng(2020);
scene = trackingScenario;

% Generate a population of debris
numDebris = 100;

range = 7e6 + 1e5*randn(numDebris,1);
ecc = 0.015 + 0.005*randn(numDebris,1);
inc = 80 + 10*rand(numDebris,1);
lan = 360*rand(numDebris,1);
w = 360*rand(numDebris,1);
nu = 360*rand(numDebris,1);

% Convert to initial position and velocity
for i = 1:numDebris
    [r,v] = oe2rv(range(i),ecc(i),inc(i),lan(i),w(i),nu(i));
    data(i).InitialPosition = r; %#ok<SAGROW>
    data(i).InitialVelocity = v; %#ok<SAGROW>
end

% Create platforms and assign them trajectories using the keplerorbit motion model
debris = repmat(fusion.scenario.Platform(1),1,numDebris);
for i=1:numDebris
    debris(i) = platform(scene);
    debris(i).Trajectory = helperMotionTrajectory(@keplerorbit,...
        'SampleRate',0.1,... % integration step 10sec
        'Position',data(i).InitialPosition,...
        'Velocity',data(i).InitialVelocity);
end

% Create a space surveillance station in the Pacific ocean
station1 = platform(scene);
% ECEF coordinates corresponding to a latitude of 10 deg and a longitude of 180 deg
station1.Trajectory.Position = [-6281.8 0 1100.2]*1e3; % meters

% Create a second surveillance station in the Atlantic ocean
station2 = platform(scene);
% ECEF coordinates corresponding to a latitude of 0 deg and a longitude of -20 deg
station2.Trajectory.Position = [5993.4 -2181.4 0]*1e3; % meters

% Near the North Pole, create a third surveillance station in Iceland
station3 = platform(scene);
% ECEF coordinates corresponding to a latitude of 65 deg and a longitude of -20 deg
station3.Trajectory.Position = [2534.0 -924.5 5757.7]*1e3; % meters

% Create a fourth surveillance station near the south pole
station4 = platform(scene);
% ECEF coordinates corresponding to a latitude of -90 deg and a longitude of 0 deg
station4.Trajectory.Position = [0 0 -6356.8]*1e3; % meters

% Create fan-shaped monostatic radars to monitor space debris objects
radar1 = monostaticRadarSensor(1,...
    'UpdateRate',0.1,... 10 sec
    'ScanMode','No scanning',...
    'MountingLocation',[0 0 0],...
    'MountingAngles',[180 -10 0],... orient sensor
    'FieldOfView',[120;30],... degrees
    'ReferenceRange',2000000,... m
    'ReferenceRCS', 10,... dBsm
    'HasFalseAlarms',false,...
    'HasElevation',true,...
    'AzimuthResolution',0.01,... degrees
    'ElevationResolution',0.01,... degrees
    'RangeResolution',100,... m
    'HasINS',true,...
    'DetectionCoordinates','Scenario');
station1.Sensors = radar1;

radar2 = clone(radar1);
radar2.SensorIndex = 2;
radar2.MountingAngles = [-20, 0, 0];
station2.Sensors = radar2;

radar3 = clone(radar1);
radar3.SensorIndex = 3;
radar3.MountingAngles = [-20 -65 0];
station3.Sensors = radar3;

radar4 = clone(radar1);
radar4.SensorIndex = 4;
radar4.MountingAngles = [0 90 0];
station4.Sensors = radar4;

globeDisplay = helperScenarioGlobeViewer;

% Show radar beams on the globe
covcon = coverageConfig(scene);
plotCoverage(globeDisplay,covcon);

% Set TargetHistoryLength to visualize the full trajectory of the debris objects
globeDisplay.TargetHistoryLength = 1000;

scene.StopTime = 3600;
scene.UpdateRate = 0.1;

while advance(scene)
    time = scene.SimulationTime;
    updateDisplay(globeDisplay,time,debris);
end
snap(globeDisplay);

% Define Tracker
tracker = trackerJPDA('FilterInitializationFcn',@initKeplerUKF,...
    'HasDetectableTrackIDsInput',true,...
    'ClutterDensity',1e-20,...
    'AssignmentThreshold',1e4,...
    'DeletionThreshold',[7 10]);

% Reset scenario and globe display
restart(scene)
scene.StopTime = 1800; % 30 min
clear(globeDisplay);
globeDisplay.TargetHistoryLength = 2;
plotCoverage(globeDisplay,covcon);

% Initialize tracks

confTracks = objectTrack.empty(0,1);
while advance(scene)
    time = scene.SimulationTime;
    
    % Generate detections
    detections = detect(scene);
    
    % Generate and update tracks
    detectableInput = isDetectable(tracker,time, covcon);
    if ~(isempty(detections) && ~isLocked(tracker))
        [confTracks, ~, allTracks,info] = tracker(detections,time,detectableInput);
        confTracks = deleteBadTracks(tracker,confTracks);
    end

    % Update globe display
    updateDisplay(globeDisplay,time,debris,detections,[],confTracks);
    
    % Move camera during simulation and take snapshots
    switch time
        case 100
            positionCamera(globeDisplay,[90 150 5e6],[0 -65 345]);
            im1 = snap(globeDisplay);
        case 270
            positionCamera(globeDisplay,[60 -120 2.6e6],[20 -45 20]);
        case 380
            positionCamera(globeDisplay,[60 -120 2.6e6],[20 -45 20]);
            im2 = snap(globeDisplay);
        case 400
            % reset
            positionCamera(globeDisplay,[17.3 -67.2 2.400e7], [360 -90 0]);
        case 1500
            positionCamera(globeDisplay,[54 2.3 6.09e6], [0 -73 348]);
        case 1560
            im3 = snap(globeDisplay);
    end
        
end

function state = keplerorbit(state,dt)
% keplerorbit performs numerical integration to predict the state of
% keplerian bodies. The state is [x;vx;y;vy;z;vz]

% Runge-Kutta 4 integration method:
k1 = kepler(state);
k2 = kepler(state + dt*k1/2);
k3 = kepler(state + dt*k2/2);
k4 = kepler(state + dt*k3);

state = state + dt*(k1+2*k2+2*k3+k4)/6;

    function dstate=kepler(state)
        x =state(1,:);
        vx = state(2,:);
        y=state(3,:);
        vy = state(4,:);
        z=state(5,:);
        vz = state(6,:);

        mu = 398600.4405*1e9; % m^3 s^-2
        omega = 7.292115e-5; % rad/s
        
        r = norm([x y z]);
        g = mu/r^2;
        
        % Coordinates are in a non-intertial frame, account for Coriolis
        % and centripetal acceleration
        ax = -g*x/r + 2*omega*vy + omega^2*x;
        ay = -g*y/r - 2*omega*vx + omega^2*y;
        az = -g*z/r;
        dstate = [vx;ax;vy;ay;vz;az];
    end
end

function filter = initKeplerUKF(detection)

% assumes radar returns [x y z]
measmodel= @(x,varargin) x([1 3 5],:);
detNoise = detection.MeasurementNoise;
sigpos = 0.4;% m
sigvel = 0.4;% m/s^2
meas = detection.Measurement;
initState = [meas(1); 0; meas(2); 0; meas(3);0];
filter = trackingUKF(@keplerorbit,measmodel,initState,...
    'StateCovariance', diag(repmat([10, 10000].^2,1,3)),...
    'ProcessNoise',diag(repmat([sigpos, sigvel].^2,1,3)),...
    'MeasurementNoise',detNoise);

end

function [r,v] = oe2rv(a,e,i,lan,w,nu)
% Reference: Bate, Mueller & White, Fundamentals of Astrodynamics Sec 2.5

mu = 398600.4405*1e9; % m^3 s^-2

% Express r and v in perifocal system
cnu = cosd(nu);
snu = sind(nu);
p = a*(1 - e^2);
r = p/(1 + e*cnu);
r_peri = [r*cnu ; r*snu ; 0];
v_peri = sqrt(mu/p)*[-snu ; e + cnu ; 0];

% Tranform into Geocentric Equatorial frame
clan = cosd(lan);
slan = sind(lan);
cw = cosd(w);
sw = sind(w);
ci = cosd(i);
si = sind(i);
R = [ clan*cw-slan*sw*ci  ,  -clan*sw-slan*cw*ci   ,    slan*si; ...
    slan*cw+clan*sw*ci  ,   -slan*sw+clan*cw*ci  ,   -clan*si; ...
    sw*si                  ,   cw*si                   ,   ci];
r = R*r_peri;
v = R*v_peri;
end