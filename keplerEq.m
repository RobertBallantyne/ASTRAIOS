function E = keplerEq(M,e,tol)
% Function solves Kepler's equation M = E-e*sin(E)
% Input - Mean anomaly M [rad] , Eccentricity e and Epsilon 
% Output  eccentric anomaly E [rad]. 
En  = M;
Ens = En - (En-e*sin(En)- M)/(1 - e*cos(En));
while (abs(Ens-En) > tol )
    En = Ens;
    Ens = En - (En - e*sin(En) - M)/(1 - e*cos(En));
end
E = Ens;
end