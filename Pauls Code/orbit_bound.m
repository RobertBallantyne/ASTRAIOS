function res = orbit_bound(x,x2)
global mu r_0

%Initial State
r = x(1);
u = x(2);
v = x(3);
theta = x(4);
lamr = x(5);
lamu = x(6);
lamv = x(7);

%Final State
r2 = x2(1);
u2 = x2(2);
v2 = x2(3);
theta2 = x2(4);
lamr2 = x2(5);
lamu2 = x2(6);
lamv2 = x2(7);

%Boundary Constraints

b1 = r-r_0;
b2 = u;
b3 = v - sqrt(mu/r);
b4 = theta;
b5 = u2;
b6 = v2 - sqrt(mu/r2);
b7 = -lamr2 + 1/2*lamv2/r2^(3/2) - 1;

%Residual

res = [b1;b2;b3;b4;b5;b6;b7];