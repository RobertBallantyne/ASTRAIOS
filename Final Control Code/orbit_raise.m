%% Orbit Raising Manoeuvre OCP - Angus McAllister 24/11/20

clear all
close all

% t_f_init = 3.8;
% t_f_fin = 10;
% N_steps = 20;
% 
% t_f_array = linspace(t_f_init,t_f_fin,N_steps);

global mu m0 m1 T r_0

mu_E = 3.986e5; %Gravitational Parameter of Earth (km^3/s^2)
I_sp = 0.3; % Specific Impulse (kN/s)
F = 0.5*2.95; %Nominal Thrust (kN)
DU = 6371; %Distance Unit (Earth's Radius) (km)
TU = sqrt(DU^3/mu_E); %Time Unit (s)
MU = 300400; %Mass Unit (kg)

ISS_alt = 420;

m_dot = F/(I_sp*9.81);

mu = 1; % = DU^3/TU^2
m0 = 1; % = MU
m1 = m_dot*TU/MU;
T = F*TU^2/(MU*DU);
r_0 = (DU+ISS_alt)/DU;

t_f = 5;

n = 100;

% for i=1:N_steps
    
y = r_0*[ones(1,n)
zeros(1,n)
ones(1,n)
-ones(1,n)
-ones(1,n)
-ones(1,n)];

% t_f = t_f_array(1,i);

x = linspace(0,t_f,n);%time vector

solinit.x = x;
solinit.y = y;
tol = 1e-10;
options = bvpset("RelTol",tol,"AbsTol",[tol tol tol tol tol tol],"Nmax", 2000);

sol = bvp4c(@orbit_ivp,@orbit_bound,solinit,options);

% r_f(1,i) = sol.y(1,end);
% i
% end
%%
% figure(1)
% plot(t_f_array*DU,DU*(r_f-1))
%%

figure
subplot(3,1,1)
plot(sol.x*TU,sol.y(1,:)*DU,'r')
ylabel("r (km)", "interpreter","latex")
grid on
subplot(3,1,2)
plot(sol.x*TU,sol.y(2,:)*DU/TU,'g')
ylabel("$V_r$(km/s)", "interpreter","latex")
grid on
subplot(3,1,3)
plot(sol.x*TU,sol.y(3,:)*DU/TU,'b')
ylabel("$V_t$ (km/s)", "interpreter","latex")
grid on
xlabel("Time (s)","interpreter","latex")
sgtitle("States","interpreter","latex")
%%
figure
plot(sol.x*TU,sol.y(4:6,:))
legend("P_1(t)","P_2(t)","P_3(t)")
grid on
title("HBVP Solution")
xlabel("Time (s)")
ylabel("Co-States")
%%
ang2=pi + atan2(sol.y(5,:),sol.y(6,:));

figure
plot(sol.x*TU,180/pi*ang2,"LineWidth",2)
grid on
title("HVBP Solution")
xlabel("Time (s)")
ylabel("Control Input Angle")
norm([tan(ang2)-(sol.y(5,:)./sol.y(6,:))])

%% Preconditioning for control system
% 
DCM = zeros(3,3,length(ang2));
eulerAngles = zeros(length(ang2),3);
MRP = zeros(length(ang2),3);

for i=1:length(ang2)
    if ang2(1,i) > pi
        ang2(1,i) = ang2(1,i) - 2*pi;
    end
    eulerAngles(i, 3) = ang2(i);
    DCM(:,:,i) = DCM_321(eulerAngles(i,:));
    MRP(i,:) = DCMtoMRP(DCM(:,:,i));
end
figure
plot(sol.x*TU,MRP,"LineWidth",2)
grid on
title("HVBP Solution in Modified Rodrigues Parameters")
xlabel("Time (s)")
ylabel("Control Input Angle")
norm([tan(ang2)-(sol.y(5,:)./sol.y(6,:))])


%%
%
dt = diff(sol.x);
dth=(sol.y(3,1:end-1)./sol.y(1,1:end-1)).*dt; % \dot \theta = v_t/r
th = cumsum(dth');
pathloc=[sol.y(1,1:end-1)'.*cos(th) sol.y(1,1:end-1)'.*sin(th)];


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

% for i = 1:1:size(th,1)
%     quiver(pathloc(i,1),pathloc(i,2), xt(i), yt(i),"m");
% end

grid on