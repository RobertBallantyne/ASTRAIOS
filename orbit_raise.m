%% Orbit Raising Manoeuvre OCP - Angus McAllister 24/11/20

clear all
close all

t_f = 4;

global mu m0 m1 T

mu = 1;
m0 = 1;
m1 = -0.07485;
T = 0.1405;

%Create Initial Guess

n = 100;

y = [ones(1,n)
    zeros(1,n)
    ones(1,n)
    -ones(1,n)
    -ones(1,n)
    -ones(1,n)];

x = linspace(0,t_f,n);%time vector

solinit.x = x;
solinit.y = y;
tol = 1e-10;
options = bvpset("RelTol",tol,"AbsTol",[tol tol tol tol tol tol],"Nmax", 2000);

sol = bvp4c(@orbit_ivp,@orbit_bound,solinit,options);
Nstep=40;

%%

figure
plot(sol.x,sol.y(1,:))

hold on
plot(sol.x,sol.y(2,:))
hold on
plot(sol.x,sol.y(3,:))
legend("Radius","Radial Velocity","Tangential Velocity","location","northwest","interpreter","latex")
grid on
% axis([0 4 0 2])
title("HBVP Solution","interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("States","interpreter","latex")
%%
figure
plot(sol.x,sol.y(4:6,:))
legend("$P_1(t)$","$P_2(t)$","$P_3(t)$","interpreter","latex","location","northeast")
grid on
% axis([0 4 -3 2])
title("HBVP Solution","interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Co-States","interpreter","latex")
%%
ang2=atan2(sol.y(5,:),sol.y(6,:))+pi;

figure
plot(sol.x,180/pi*ang2,"LineWidth",2)
grid on
axis([0 4 0 360])
title("HVBP Solution","interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Control Input Angle (degrees)","interpreter","latex")
norm([tan(ang2)-(sol.y(5,:)./sol.y(6,:))])
%%
dt = diff(sol.x);
dth=(sol.y(3,1:end-1)./sol.y(1,1:end-1)).*dt; % \dot \theta = v_t/r
th = 0 + cumsum(dth');
pathloc=[sol.y(1,1:end-1)'.*cos(th) sol.y(1,1:end-1)'.*sin(th)];
%%

figure
plot(pathloc(:,1),pathloc(:,2),'k-',"LineWidth",2)
hold on
zz = exp(sqrt(-1)*[0:0.01:pi]');
r0 = sol.y(1,1);
rf = sol.y(1,end);
plot(r0*real(zz),r0*imag(zz),"r--","LineWidth",2)
plot(rf*real(zz),rf*imag(zz),"b--","LineWidth",2)
plot(r0,0,"ro","MarkerFace","r")
plot(rf*cos(th(end)),rf*sin(th(end)),"bo","MarkerFace","b")
fact = 0.2;
ep = ones(size(th,1),1)*pi/2+th-ang2(1,end-1)';
xt = fact*cos(ang2);
yt = fact*sin(ang2);

for i = 1:Nstep:size(th,1)
    quiver(pathloc(i,1),pathloc(i,2), xt(i), yt(i),"m");
end

axis([-2 2 -0.1 1.8])
axis("equal")
hold off
grid on