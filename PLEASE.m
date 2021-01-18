clear all
close all
clc

globals()

outFile = 'test.out';

ISS = tleRead('tleISS');

ISS.SGP4Epoch = epochConvertor(ISS.Epoch);

[x, v] = Sgp4([pwd '\out_on_12_09_2020_17_37_24.inp'], outFile, ISS.SGP4Epoch);
