clear all
close all
clc
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
toleranceAltitude = 1000;

toDelete_apo = table.apo < ISS.tle.peri/1000 - toleranceAltitude;
altTable(toDelete_apo, :) = [];
toDelete_peri = altTable.peri > ISS.tle.apo/1000 + toleranceAltitude;
altTable(toDelete_peri, :) = [];

%% Now fetch all sampled tle sets from past 30 days for each of the objects that passed the last filter
satellites = num2str(altTable(1, :).catID);
for i = 2 : height(altTable)
    satellites = join([satellites, ',', num2str(altTable(i, :).catID)]);
end
satellites2 = ['25544'];

gpHistoricOutput = char(mod.derek('robert.a.ballantyne@gmail.com', '5z6F7Q!.VhLYrxF', satellites2));
% Uses a variation on the space-track api script to find all tle samples
% from the last 30 days for every piece of debris that passes the altitude
% filter
%%
gpHistoricTable = tleTable(gpHistoricOutput);
% Turns the big historic tle text file into a more readable table, includes the epoch statevector 

[propForward] = Sgp4([pwd '/' gpHistoricOutput], 'historic', ISS.tle.SGP4Epoch);
%Sgp4Prop([pwd '/' gpHistoricOutput], 'historic');

% propagates all of the tles forward to the latest ISS tle epoch