function [res] = orbit_bound(x,x2)
global mu 

%Initial State
r = x(1);
u = x(2);
v = x(3);
lamr = x(4);
lamu = x(5);
lamv = x(6);

%Final State
r2 = x2(1);
u2 = x2(2);
v2 = x2(3);
lamr2 = x2(4);
lamu2 = x2(5);
lamv2 = x2(6);

%Boundary Constraints

b1 = r-1;
b2 = u;
b3 = v - sqrt(mu/r);
b4 = u2;
b5 = v2 - sqrt(mu/r2);
b6 = lamr2 + 1 - lamv2*sqrt(mu)/2/r2^(3/2);

%Residual

res = [b1;b2;b3;b4;b5;b6];