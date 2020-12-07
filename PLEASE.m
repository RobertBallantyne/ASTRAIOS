clear all
clc

j = 1;
for i = logspace(1, 10)
    [x(:, :, j), y(:, :, j)] = Sgp4('C:\Users\rober\Documents\MATLAB\ASTRAIOS\ASTRAIOS\SpacetrackSGP4\SampleCode\Matlab\DriverExamples\Sgp4Prop\input/rel14.inp', 'test.out', i);
    j = j + 1;
end