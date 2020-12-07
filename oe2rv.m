function [r,v] = oe2rv(a,e,i,raan,w,nu)
% semi-major axis, eccentricity, inclination, longitude of the ascending
% node, argument of periapsis, and true anomaly angles || degrees where
% angles

% Reference: Bate, Mueller & White, Fundamentals of Astrodynamics Sec 2.5

global mu_Earth

% Express r and v in perifocal system
cnu = cosd(nu);
snu = sind(nu);
p = a*(1 - e^2);
r = p./(1 + e*cnu);
r_peri = [r.*cnu ; r.*snu; zeros(1, length(r))];
v_peri = sqrt(mu_Earth/p)*[-snu ; e + cnu ; zeros(1, length(r))];

% Tranform into Geocentric Equatorial frame
clan = cosd(raan);
slan = sind(raan);
cw = cosd(w);
sw = sind(w);
ci = cosd(i);
si = sind(i);
R = [ clan*cw-slan*sw*ci  ,  -clan*sw-slan*cw*ci   ,    slan*si; ...
    slan*cw+clan*sw*ci  ,   -slan*sw+clan*cw*ci  ,   -clan*si; ...
    sw*si                  ,   cw*si                   ,   ci];
r = R*r_peri;
v = R*v_peri;
end
