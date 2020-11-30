function [dx] = orbit_ivp(t,x)
global mu m0 m1 T

%State

r = x(1);
u = x(2);
v = x(3);
lamr = x(4);
lamu = x(5);
lamv = x(6);

%Substitution for control
sinphi = -lamu./sqrt(lamu.^2+lamv.^2);
cosphi = -lamv./sqrt(lamu.^2+lamv.^2);

%Dynamic Equations

dr = u;
du = v^2/r - mu/r^2 + T*sinphi/(m0+ m1*t);
dv = -u*v/r + T*cosphi/(m0+m1*t);

dlamr = -lamu*(-v^2/r^2 + 2*mu/r^3)-lamv*(u*v/r^2);
dlamu = -lamr + lamv*v/r;
dlamv = -lamu*2*v/r + lamv*u/r;

dx = [dr; du; dv; dlamr; dlamu; dlamv];