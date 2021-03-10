function [nu] = shadow_func(R,RS)
r_e = 6378;
r = norm(R);
rS = norm(RS);
theta = acosd((dot(R,RS))/(r*rS)); % large angle between satellite and sun
theta1 = acosd(r_e/r); %angle of satellite when at tangent to earth
theta2 = acosd(r_e/rS); %angle of sun when tangent to earth
if theta1+theta2 <= theta
 nu = 0;
else
 nu = 1;
end

