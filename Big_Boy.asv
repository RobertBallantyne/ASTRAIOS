 clear 
clc
tic
global mu_Earth r_Earth

mu_Earth = 3.986004418 * 10^14; %GM for the earth
r_Earth = 6378000;

if count(py.sys.path,'C:\Users\rober\Documents\MATLAB\ASTRAIOS\ASTRAIOS\Python_Scripts\spacetrack_api') == 0
    insert(py.sys.path,int32(0),'C:\Users\rober\Documents\MATLAB\ASTRAIOS\ASTRAIOS\Python_Scripts\spacetrack_api');
end

mod = py.importlib.import_module('api_pull');
py.importlib.reload(mod)
name = mod.gerald('robert.a.ballantyne@gmail.com', '5z6F7Q!.VhLYrxF', 'out');
%%

name = string(name);
opts = detectImportOptions(name);
all_objects = readtable(name, opts);
Results = zeros(size(all_objects, 1), 7);
iss = tle_read('tle1');

for i = 1:size(all_objects, 1)
    currentline = all_objects(i, :);
    Results(i, :) = Sieve(iss(2:end), table2array(currentline(1, 2:end)));
end

toc
