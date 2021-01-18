globals()
global mu_Earth
M_deg = 45;
e = 0.5;
a_m = 25000000;
n = sqrt(mu_Earth/a_m^3);
M_rad = deg2rad(M_deg);
E_rad = M_rad; 
dE = 99999;
eps = 1e-6; % [rad] control precision of Newton's method solution
while (abs(dE) > eps)
    dE = (E_rad - e * sin(E_rad) - M_rad)/(1 - e * cos(E_rad));
    E_rad = E_rad -  dE;
end
p_m = a_m*(cos(E_rad) - e);
q_m = a_m*sqrt(1 - e^2)*sin(E_rad);
dMdt_rad_per_s = n;
dEdt_rad_per_s = dMdt_rad_per_s/(1 - e*cos(E_rad));
dpdt_m_per_s = -a_m*sin(E_rad)*dEdt_rad_per_s;
dqdt_m_per_s = a_m*cos(E_rad)*dEdt_rad_per_s*sqrt(1 - e^2);

%% *Plot the Plane of the Orbit*
ra_m = a_m*(1 + e);  % [m] apogee 
rp_m = a_m*(1 - e);  % [m] perigee
rEarth_m = 6378e3; % [m] Earth radius at equator
Evals = 0:0.01:360.0; % [deg] values of the eccentric anomaly around orbit 
pvals = a_m*(cosd(Evals)-e); % [m] orbit positions
qvals = a_m*sqrt(1 - e^2)*sind(Evals); % [m] orbit positions
figure('color','white');
fill(rEarth_m.*cosd(Evals),rEarth_m.*sind(Evals),[0.75 1.00 0.75]);
hold on;
plot(pvals,qvals,'k');
plot(p_m,q_m,'.r','MarkerSize',25);
p1_m = p_m+dpdt_m_per_s*300;
q1_m = q_m+dqdt_m_per_s*300;
plot([p_m p1_m],[q_m q1_m],'r');
theta = -atan2d(dqdt_m_per_s,dpdt_m_per_s);
plot(p1_m+[0 -0.1*rEarth_m*cosd(theta+30)],q1_m+[0  0.1*rEarth_m*sind(theta+30)],'r');
plot(p1_m+[0 -0.1*rEarth_m*cosd(theta-30)],q1_m+[0  0.1*rEarth_m*sind(theta-30)],'r');

axis equal

axis off
box on

r = sqrt(pvals.^2 + qvals.^2);

[minR, minI] = min(r);
[maxR, maxI] = max(r);
plot(pvals(minI), qvals(minI),'.g', 'MarkerSize', 25);
plot(pvals(maxI), qvals(maxI),'.b', 'MarkerSize', 25);

%% adding apogee and perigee circles
n = 1000;
t = linspace(0,2*pi,n);

% apogee
xa = maxR*sin(t);
ya = maxR*cos(t);
line(xa,ya, 'color', 'b')

% perigee

% xp = minR*sin(t);
% yp = minR*cos(t);
% line(xp, yp, 'color', 'g')

%% finding closest points

M1_deg = 45;
e1 = 0.7;
a1_m = 25000000;
n1 = sqrt(mu_Earth/a1_m^3);
M1_rad = deg2rad(M1_deg);
E1_rad = M1_rad; 
dE = 99999;
eps = 1e-6; % [rad] control precision of Newton's method solution
while (abs(dE) > eps)
    dE = (E1_rad - e1 * sin(E1_rad) - M1_rad)/(1 - e1 * cos(E1_rad));
    E1_rad = E1_rad -  dE;
end
p1_m = a1_m*(cos(E1_rad) - e1);
q1_m = a1_m*sqrt(1 - e1^2)*sin(E1_rad);
dMdt1_rad_per_s = n;
dEdt1_rad_per_s = dMdt1_rad_per_s/(1 - e1*cos(E1_rad));
dpdt1_m_per_s = -a1_m*sin(E1_rad)*dEdt1_rad_per_s;
dqdt1_m_per_s = a1_m*cos(E1_rad)*dEdt1_rad_per_s*sqrt(1 - e1^2);
ra1_m = a1_m*(1 + e1);  % [m] apogee 
rp1_m = a1_m*(1 - e1);  % [m] perigee
p1vals = a1_m*(cosd(Evals)-e1); % [m] orbit positions
q1vals = a1_m*sqrt(1 - e1^2)*sind(Evals); % [m] orbit positions

M2_deg = 275;
e2 = 0;
a2_m = 50000000;
n2 = sqrt(mu_Earth/a2_m^3);
M2_rad = deg2rad(M2_deg);
E2_rad = M2_rad; 
dE = 99999;
eps = 1e-6; % [rad] control precision of Newton's method solution
while (abs(dE) > eps)
    dE = (E2_rad - e2 * sin(E2_rad) - M2_rad)/(1 - e2 * cos(E2_rad));
    E2_rad = E2_rad -  dE;
end
p2_m = a2_m*(cos(E2_rad) - e2);
q2_m = a2_m*sqrt(1 - e2^2)*sin(E2_rad);
dMdt2_rad_per_s = n;
dEdt2_rad_per_s = dMdt2_rad_per_s/(1 - e2*cos(E2_rad));
dpdt2_m_per_s = -a2_m*sin(E2_rad)*dEdt2_rad_per_s;
dqdt2_m_per_s = a2_m*cos(E2_rad)*dEdt2_rad_per_s*sqrt(1 - e2^2);
ra2_m = a2_m*(1 + e2);  % [m] apogee 
rp2_m = a2_m*(1 - e2);  % [m] perigee
p2vals = a2_m*(cosd(Evals)-e2); % [m] orbit positions
q2vals = a2_m*sqrt(1 - e2^2)*sind(Evals); % [m] orbit positions
%% *Plot the Plane of the Orbit*

rEarth_m = 6378e3; % [m] Earth radius at equator
Evals = 0:0.01:360.0; % [deg] values of the eccentric anomaly around orbit 

figure('color','white');
fill(rEarth_m.*cosd(Evals),rEarth_m.*sind(Evals),[0.75 1.00 0.75]);
hold on;
plot(p1vals,q1vals,'k');
plot(p2vals,q2vals,'k');
axis equal

axis off
box on
%%
[find, distance] = dsearchn([p1vals; q1vals]', [p2vals; q2vals]');
[minval, index] = min(distance);
curve1 = [p1vals(index), q1vals(index)]f;
curve2 = [p2vals(find(index)), q2vals(find(index))];

plot(curve1(1), qvals(2),'.r', 'MarkerSize', 25);
plot(curve2(1), curve2(2),'.r', 'MarkerSize', 25);