function dydt = force_model(t, state)
global mu_Earth

x = state(1);
y = state(2);
z = state(3);

vx = state(4);
vy = state(5);
vz = state(6);

r = sqrt(x^2+y^2+z^2);

ax = -mu_Earth*x/r^3; % generic gravitational acceleration equations, could be done in a matrix to be more efficient but cba
ay = -mu_Earth*y/r^3;
az = -mu_Earth*z/r^3;

dydt = [vx; vy; vz; ax; ay; az];
end