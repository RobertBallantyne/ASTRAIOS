%% Finalised Control Code Script - Written by Angus McAllister 17/03/2021
close all
clear all

warning off

%% Load in thrust and delta R map
load dF;
load dR;
%%
R = 13000; %target radius

t_f_min = 6;
t_f_max = 7;
t_f_step = 0.02;
n_t_f = (t_f_max-t_f_min)/t_f_step + 1;
t_f_array = linspace(t_f_min,t_f_max,n_t_f);
%%
thrust_location = 3; %1 for Progress, 2 for Soyuz, 3 for ATV

if thrust_location == 1 % 
    
    if R<1715 && R>735.1
    MU = 300400;
    r_PN = [-23.701; -6e-3; 16.335];
    r_CN = [-6.06 ; -2.69 ; 3.37];
    I = [72170517 5612326 3106490; 
        5612326 67072203 -2727715; 
        3106490 -2727715 132841047]; 
    I_sp = 300;
    t_f = interp1(dR.P, t_f_array, R);
    F = polyval(dF.P, t_f);
    F_PS = [0 ;0 ; -F];
    
    else
    error("Invalid Inputs")
    quit
    
    end
    

end

if thrust_location == 2
    if R<4168 && R>1232
    MU = 314360;
    r_PN = [-11.134; -6e-3; 12.304];
    r_CN = [-4.19; -0.93; 3.22];
    I = [104643956 2655014 2702459; 
        2655014 60362756 -707488; 
        2702459 -707468 158216940];
    I_sp = 305;
    t_f = interp1(dR.S, t_f_array, R);
    F = polyval(dF.S, t_f);
    F_PS = [0; 0; -F];
    
    else
    error("Invalid Input")
    quit
    
    end

end

if thrust_location == 3
    
    if R<14010 && R>4354
    MU = 344242;
    r_PN = [-42.913; -6e-3; 4.142];
    r_CN = [-5.08; -0.86; 3.14];
    I = [112719909 3349035 26311761; 
        3349035 74123914 757450;
        2631761 77450 178976655];
    I_sp = 270;
    t_f = interp1(dR.ATV, t_f_array, R);
    F = polyval(dF.ATV, t_f); 
    F_PS = [F; 0; 0];
    
    else
    error("Invalid Inputs")
    quit
    
    end
    

end
%%
global mu m0 m1 T r_0

mu_E = 3.986e14; %Gravitational Parameter of Earth (m^3/s^2)
I_sp = 270; % Specific Impulse (N/s)
DU = 6371000; %Distance Unit (Earth's Radius) (m)
TU = sqrt(DU^3/mu_E); %Time Unit (s)
MU = 344242; %Mass Unit (kg)

ISS_alt = 420000;

m_dot = F/(I_sp*9.81);

mu = 1; % = DU^3/TU^2
m0 = 1; % = MU
m1 = m_dot*TU/MU;
T = F*TU^2/(MU*DU);
r_0 = (DU+ISS_alt)/DU;

n = 10000;

y = [1
0
1
0
0
-1
0];

x = linspace(0,t_f,n);%time vector

solinit = bvpinit(x,y);

tol = 1e-10;
options = bvpset("RelTol",tol,"AbsTol",[tol tol tol tol tol tol tol],"Nmax", n);

sol = bvp5c(@orbit_ivp,@orbit_bound,solinit,options);

ang2=pi + atan2(sol.y(6,:),sol.y(7,:));

figure(1)
subplot(3,1,1)
plot(sol.x*TU,sol.y(1,:)*DU/1000,'r')
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

dt = diff(sol.x);
dth=(sol.y(3,1:end-1)./sol.y(1,1:end-1)).*dt; % \dot \theta = v_t/r
th = cumsum(dth');
pathloc=[sol.y(1,1:end-1)'.*cos(th) sol.y(1,1:end-1)'.*sin(th)];


figure(2)
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
step = floor(size(th,1)/50);
for i = 1:step:size(th,1)
    quiver(pathloc(i,1),pathloc(i,2), xt(i), yt(i),"m");
end
grid on
title("Orbital Maneuver","interpreter","latex")
%% Preconditioning for control system

DCM = zeros(3,3,length(ang2));
eulerAngles = zeros(length(ang2),3);
MRP = zeros(length(ang2),3);

t_f = t_f*TU;
dt = t_f/length(sol.x);

for i=1:length(ang2)
    if ang2(1,i) > pi
        ang2(1,i) = ang2(1,i) - 2*pi;
    end
    eulerAngles(i, 3) = ang2(i);
    DCM(:,:,i) = DCM_321(eulerAngles(i,:));
    MRP(i,:) = DCMtoMRP(DCM(:,:,i));
end

MRP_dot = zeros(length(sol.x) , 3);

for i = 1 : length(sol.x)
    if i == 1
        MRP_dot(i,:) = (MRP(i+1,:)-MRP(i,:))/dt;

    elseif i == length(sol.x)
        MRP_dot(i,:) = (MRP(i,:)-MRP(i-1,:))/dt;

    else 
        MRP_dot(i,:) = (MRP(i+1,:)-MRP(i-1,:))/(2*dt);
    end

end

MRP = transpose(MRP);
MRP_dot = transpose(MRP_dot);

%%

MRP_0 = MRP(:,1);
w_0 = [0; 0; 0];
f = 0;

r_PC = r_PN - r_CN;
L_p = cross(r_PC, F_PS);

T_F = 0.025*t_f*eye(3);
P = 2* I / T_F;
K = P.^2 / (1.2^2 * I);
tracking = true;
DeltaL = 0;
controltype = 1;
K_I = 0;

%%
soly = sol.y(1,:)*DU;
[X_BN, W_BN, U, sum_U, X_BR, W_BR, L_G] = simulation(dt, t_f, MRP_0, w_0, f, I, L_p, K, P, tracking, DeltaL, controltype, K_I, MRP, MRP_dot, soly);

%%
t = 0:dt:t_f;
Nsteps = t_f/dt;

figure(3)

plot(t(1,1:Nsteps),MRP(1,:),'r--')
hold on
plot(t,X_BN(1,:),'r')
hold on
plot(t(1,1:Nsteps),X_BR(2,:),'g')
hold on
plot(t(1,1:Nsteps),X_BR(3,:),'b')
legend(["Reference","1","2","3"],"orientation","horizontal","location","northeast","interpreter","latex")
grid on
ylabel("$\sigma_{B/N}$","interpreter","latex")

figure(4)
plot(t,W_BN(1,:),'r')
hold on
plot(t,W_BN(2,:),'g')
hold on
plot(t,W_BN(3,:),'b')
grid on
legend(["$\omega_1$","$\omega_2$","$\omega_3$"],"interpreter","latex")
ylabel("$\omega_{B/N}$ (rad/s)","interpreter","latex")


figure(5)
plot(t(1,1:Nsteps),U(1,:),'r')
hold on
plot(t(1,1:Nsteps),U(2,:),'g')
hold on
plot(t(1,1:Nsteps),U(3,:),'b')
grid on
legend(["$u_1$","$u_2$","$u_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("U (Nm)","interpreter","latex")

figure(6)
plot(t(1,1:Nsteps),L_G(1,:),'r')
hold on
plot(t(1,1:Nsteps),L_G(2,:),'g')
hold on
plot(t(1,1:Nsteps),L_G(3,:),'b')
grid on
legend(["$lg_1$","$lg_2$","$lg_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Grav Grad (Nm)","interpreter","latex")