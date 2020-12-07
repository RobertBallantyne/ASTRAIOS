clear 
clc
close all

ISS.oe = tle_read('tleISS');
Deb.oe = tle_read('tle2');

ISS = orbitGeometry(ISS);
tic
danger = Sieve(ISS, Deb, 10000);
toc