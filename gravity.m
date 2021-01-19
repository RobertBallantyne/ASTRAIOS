function g = gravity(x, y, z)
global mu_Earth

x = x * 1000;
y = y * 1000;
z = z * 1000;
r = sqrt(x^2+y^2+z^2); % calculates distance from the centre of the earth

ax = -mu_Earth*x/r^3; % generic gravitational acceleration equations, could be done in a matrix to be more efficient but cba
ay = -mu_Earth*y/r^3;
az = -mu_Earth*z/r^3;

g = [ax/1000 ay/1000 az/1000];
end