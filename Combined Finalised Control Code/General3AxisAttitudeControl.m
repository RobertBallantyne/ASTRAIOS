%% General 3-Axis Attitude Control Script - Angus McAllister 28/01/21
clear all

% This script simulates general 3 axis attitude control for both a
% regulator and tracking case

MRP_0 = [0.1; 0.2; -0.1];
w_0 = [30; 10; -20]/57.3;

global K P L DeltaL I

K = 5;
P = 10*eye(3);
L = 0;
DeltaL = 0; 
I = [100 0 0; 0 75 0; 0 0 80];
K_I = 0.005;

%% Regulator Case 

tracking = false;
f = 0;

dt = 0.01;%time step (s)
t_final = 120;

controltype = 1;

[X_BN, W_BN, U, X_BR, W_BR] = simulation(dt, t_final, MRP_0, w_0, f, I, L, K, P, tracking, DeltaL, controltype, K_I);

t = 0:dt:t_final;

figure(1)
plot(t,X_BN(1,:),'r')
hold on
plot(t,X_BN(2,:),'g')
hold on
plot(t,X_BN(3,:),'b')
grid on
legend(["$\sigma_1$","$\sigma_2$","$\sigma_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Modified Rodrigues Parameter","interpreter","latex")

figure(2)
plot(t,W_BN(1,:),'r')
hold on
plot(t,W_BN(2,:),'g')
hold on
plot(t,W_BN(3,:),'b')
grid on
legend(["$\omega_1$","$\omega_2$","$\omega_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Angular Velocity (rad/s)","interpreter","latex")

Nsteps = t_final/dt;

figure(3)
plot(t(1,1:Nsteps),U(1,:),'r')
hold on
plot(t(1,1:Nsteps),U(2,:),'g')
hold on
plot(t(1,1:Nsteps),U(3,:),'b')
grid on
legend(["$u_1$","$u_2$","$u_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Control Torque (Nm)","interpreter","latex")

index_30s = find(t==30);
MRP_norm_30s = norm(X_BN(:,index_30s));
fprintf("MRP norm at 30 seconds for regulator case is %f \n",MRP_norm_30s)
%% Tracking Case

clearvars -except MRP_0 w_0 K P L DeltaL I

tracking = true;
f = 0.05;

dt = 0.01;%time step (s)
t_final = 500;
K_I = 0;

controltype = 1;

[X_BN, W_BN, U, X_BR, W_BR] = simulation(dt, t_final, MRP_0, w_0, f, I, L, K, P, tracking, DeltaL, controltype, K_I);

t = 0:dt:t_final;

figure(4)
plot(t,X_BN(1,:),'r')
hold on
plot(t,X_BN(2,:),'g')
hold on
plot(t,X_BN(3,:),'b')
grid on
legend(["$\sigma_1$","$\sigma_2$","$\sigma_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Modified Rodrigues Parameter","interpreter","latex")

figure(5)
plot(t,W_BN(1,:),'r')
hold on
plot(t,W_BN(2,:),'g')
hold on
plot(t,W_BN(3,:),'b')
grid on
legend(["$\omega_1$","$\omega_2$","$\omega_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Angular Velocity (rad/s)","interpreter","latex")

Nsteps = t_final/dt;

figure(6)
plot(t(1,1:Nsteps),U(1,:),'r')
hold on
plot(t(1,1:Nsteps),U(2,:),'g')
hold on
plot(t(1,1:Nsteps),U(3,:),'b')
grid on

%% Tracking Control Linearised Control
clearvars -except MRP_0 w_0 K P L DeltaL I

f = 0.05;
controltype = 2;

dt = 0.01;%time step (s)
t_final = 500;
tracking = true;
[X_BN, W_BN, U, X_BR, W_BR] = simulation(dt, t_final, MRP_0, w_0, f, I, L, K, P, tracking, DeltaL, controltype, K_I);

t = 0:dt:t_final;

figure(7)
plot(t,X_BN(1,:),'r')
hold on
plot(t,X_BN(2,:),'g')
hold on
plot(t,X_BN(3,:),'b')
grid on
legend(["$\sigma_1$","$\sigma_2$","$\sigma_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Modified Rodrigues Parameter","interpreter","latex")

figure(8)
plot(t,W_BN(1,:),'r')
hold on
plot(t,W_BN(2,:),'g')
hold on
plot(t,W_BN(3,:),'b')
grid on
legend(["$\omega_1$","$\omega_2$","$\omega_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Angular Velocity (rad/s)","interpreter","latex")

Nsteps = t_final/dt;

figure(9)
plot(t(1,1:Nsteps),U(1,:),'r')
hold on
plot(t(1,1:Nsteps),U(2,:),'g')
hold on
plot(t(1,1:Nsteps),U(3,:),'b')
grid on
legend(["$u_1$","$u_2$","$u_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Control Torque (Nm)","interpreter","latex")

index_20s = find(t==20);
MRP_norm_20s = norm(X_BR(:,index_20s));
fprintf("MRP norm at 20 seconds for regulator case is %f \n",MRP_norm_20s)

%% Tracking - Nonlinear Control Law (excluding external torque) with External Torque Dynamics
clearvars -except MRP_0 w_0 K P L DeltaL I

tracking = true;
f = 0.05;

dt = 0.01;%time step (s)
t_final = 120;

controltype = 3;
L = [0.5; -0.3; 0.2];

[X_BN, W_BN, U, X_BR, W_BR] = simulation(dt, t_final, MRP_0, w_0, f, I, L, K, P, tracking, DeltaL, controltype, K_I);

t = 0:dt:t_final;

figure(10)
plot(t,X_BN(1,:),'r')
hold on
plot(t,X_BN(2,:),'g')
hold on
plot(t,X_BN(3,:),'b')
grid on
legend(["$\sigma_1$","$\sigma_2$","$\sigma_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Modified Rodrigues Parameter","interpreter","latex")

figure(11)
plot(t,W_BN(1,:),'r')
hold on
plot(t,W_BN(2,:),'g')
hold on
plot(t,W_BN(3,:),'b')
grid on
legend(["$\omega_1$","$\omega_2$","$\omega_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Angular Velocity (rad/s)","interpreter","latex")

Nsteps = t_final/dt;

figure(12)
plot(t(1,1:Nsteps),U(1,:),'r')
hold on
plot(t(1,1:Nsteps),U(2,:),'g')
hold on
plot(t(1,1:Nsteps),U(3,:),'b')
grid on
legend(["$u_1$","$u_2$","$u_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Control Torque (Nm)","interpreter","latex")

index_80s = find(t==80);
MRP_norm_80s = norm(X_BR(:,index_80s));
fprintf("MRP norm at 80 seconds for regulator case is %f \n",MRP_norm_80s)

%% Tracking - Nonlinear Control Law with External Torque

clearvars -except MRP_0 w_0 K P L DeltaL I

tracking = true;
f = 0.05;

dt = 0.01;%time step (s)
t_final = 120;

controltype = 1;
L = [0.5; -0.3; 0.2];

[X_BN, W_BN, U, X_BR, W_BR] = simulation(dt, t_final, MRP_0, w_0, f, I, L, K, P, tracking, DeltaL, controltype, K_I);

t = 0:dt:t_final;

figure(13)
plot(t,X_BN(1,:),'r')
hold on
plot(t,X_BN(2,:),'g')
hold on
plot(t,X_BN(3,:),'b')
grid on
legend(["$\sigma_1$","$\sigma_2$","$\sigma_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Modified Rodrigues Parameter","interpreter","latex")

figure(14)
plot(t,W_BN(1,:),'r')
hold on
plot(t,W_BN(2,:),'g')
hold on
plot(t,W_BN(3,:),'b')
grid on
legend(["$\omega_1$","$\omega_2$","$\omega_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Angular Velocity (rad/s)","interpreter","latex")

Nsteps = t_final/dt;

figure(15)
plot(t(1,1:Nsteps),U(1,:),'r')
hold on
plot(t(1,1:Nsteps),U(2,:),'g')
hold on
plot(t(1,1:Nsteps),U(3,:),'b')
grid on
legend(["$u_1$","$u_2$","$u_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Control Torque (Nm)","interpreter","latex")

index_70s = find(t==70);
MRP_norm_70s = norm(X_BR(:,index_70s));
fprintf("MRP norm at 70 seconds for regulator case is %f \n",MRP_norm_70s)

%% Regulation - Nonlinear Control Law with External Torque Disturbance

clearvars -except MRP_0 w_0 K P L DeltaL I

tracking = false;
f = 0;

dt = 0.01;%time step (s)
t_final = 120;

controltype = 1;
DeltaL = [0.5; -0.3; 0.2];

[X_BN, W_BN, U, X_BR, W_BR] = simulation(dt, t_final, MRP_0, w_0, f, I, L, K, P, tracking, DeltaL, controltype, K_I);

t = 0:dt:t_final;

figure(16)
plot(t,X_BN(1,:),'r')
hold on
plot(t,X_BN(2,:),'g')
hold on
plot(t,X_BN(3,:),'b')
grid on
legend(["$\sigma_1$","$\sigma_2$","$\sigma_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Modified Rodrigues Parameter","interpreter","latex")

figure(17)
plot(t,W_BN(1,:),'r')
hold on
plot(t,W_BN(2,:),'g')
hold on
plot(t,W_BN(3,:),'b')
grid on
legend(["$\omega_1$","$\omega_2$","$\omega_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Angular Velocity (rad/s)","interpreter","latex")

Nsteps = t_final/dt;

figure(18)
plot(t(1,1:Nsteps),U(1,:),'r')
hold on
plot(t(1,1:Nsteps),U(2,:),'g')
hold on
plot(t(1,1:Nsteps),U(3,:),'b')
grid on
legend(["$u_1$","$u_2$","$u_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Control Torque (Nm)","interpreter","latex")

index_35s = find(t==35);
MRP_norm_35s = norm(X_BR(:,index_35s));
fprintf("MRP norm at 35 seconds for regulator case is %f \n",MRP_norm_35s)

%% Tracking - Proportional Integral Control
% 
% clearvars -except MRP_0 w_0 K P L DeltaL I K_I
clear all

MRP_0 = [0.1; 0.2; -0.1];
% w_0 = [30; 10; -20]/57.3;

global K P L DeltaL I

K = 5;
P = 10*eye(3);
L = 0;
I = [100 0 0; 0 75 0; 0 0 80];

K_I = 0.005;
tracking = true;
f = 0.05;

dt = 0.01;%time step (s)
t_final = 240;

controltype = 4;

DeltaL = [0.5; -0.3; 0.2];
w_0 = [3; 1; -2]/57.3;

[X_BN, W_BN, U, X_BR, W_BR] = simulation(dt, t_final, MRP_0, w_0, f, I, L, K, P, tracking, DeltaL, controltype, K_I);

t = 0:dt:t_final;
Nsteps = t_final/dt;

figure(19)
plot(t(1,1:Nsteps),X_BR(1,:),'r')
hold on
plot(t(1,1:Nsteps),X_BR(2,:),'g')
hold on
plot(t(1,1:Nsteps),X_BR(3,:),'b')
grid on
legend(["$\sigma_1$","$\sigma_2$","$\sigma_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Modified Rodrigues Parameter $\sigma_{B/R}$","interpreter","latex")

figure(20)
plot(t(1,1:Nsteps),W_BR(1,:),'r')
hold on
plot(t(1,1:Nsteps),W_BR(2,:),'g')
hold on
plot(t(1,1:Nsteps),W_BR(3,:),'b')
grid on
legend(["$\omega_1$","$\omega_2$","$\omega_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Angular Velocity $\omega_{B/R}$ (rad/s)","interpreter","latex")

Nsteps = t_final/dt;

figure(21)
plot(t(1,1:Nsteps),U(1,:),'r')
hold on
plot(t(1,1:Nsteps),U(2,:),'g')
hold on
plot(t(1,1:Nsteps),U(3,:),'b')
grid on
legend(["$u_1$","$u_2$","$u_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Control Torque (Nm)","interpreter","latex")

index_45s = find(t==45);
MRP_norm_45s = norm(X_BR(:,index_45s));
fprintf("MRP norm at 45 seconds for regulator case is %f \n",MRP_norm_45s)

%% Regulation 

clear all

MRP_0 = [0.1; 0.2; -0.1];
w_0 = [30; 10; -20]/57.3;

global K P L DeltaL I

K = 5;
P = [22.3607 0 0; 0 19.3649 0; 0 0 20];
L = 0;
I = [100 0 0; 0 75 0; 0 0 80];
DeltaL = 0;

K_I = 0;
tracking = false;
f = 0;

dt = 0.01;%time step (s)
t_final = 240;

controltype = 5;


[X_BN, W_BN, U, X_BR, W_BR] = simulation(dt, t_final, MRP_0, w_0, f, I, L, K, P, tracking, DeltaL, controltype, K_I);

t = 0:dt:t_final;
Nsteps = t_final/dt;
%%
close all
figure(19)
plot(t(1,1:Nsteps),X_BR(1,:),'r')
hold on
plot(t(1,1:Nsteps),X_BR(2,:),'g')
hold on
plot(t(1,1:Nsteps),X_BR(3,:),'b')
grid on
legend(["$\sigma_1$","$\sigma_2$","$\sigma_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Modified Rodrigues Parameter $\sigma_{B/R}$","interpreter","latex")

figure(20)
plot(t(1,1:Nsteps),W_BR(1,:),'r')
hold on
plot(t(1,1:Nsteps),W_BR(2,:),'g')
hold on
plot(t(1,1:Nsteps),W_BR(3,:),'b')
grid on
legend(["$\omega_1$","$\omega_2$","$\omega_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Angular Velocity $\omega_{B/R}$ (rad/s)","interpreter","latex")

Nsteps = t_final/dt;

figure(21)
plot(t(1,1:Nsteps),U(1,:),'r')
hold on
plot(t(1,1:Nsteps),U(2,:),'g')
hold on
plot(t(1,1:Nsteps),U(3,:),'b')
grid on
legend(["$u_1$","$u_2$","$u_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Control Torque (Nm)","interpreter","latex")

index_45s = find(t==30);
MRP_norm_45s = norm(X_BR(:,index_45s));
fprintf("MRP norm at 45 seconds for regulator case is %f \n",MRP_norm_45s)

%% Regulation - Saturated Control

clear all

MRP_0 = [0.1; 0.2; -0.1];
w_0 = [30; 10; -20]/57.3;

global K P L DeltaL I

K = 5;
P = 10*eye(3);
L = 0;
I = [100 0 0; 0 75 0; 0 0 80];
DeltaL = 0;

K_I = 0;
tracking = true;
f = 0.05;

dt = 0.001;%time step (s)
t_final = 180;

controltype = 6;


[X_BN, W_BN, U, X_BR, W_BR] = simulation(dt, t_final, MRP_0, w_0, f, I, L, K, P, tracking, DeltaL, controltype, K_I);

t = 0:dt:t_final;
Nsteps = t_final/dt;
%%
figure(19)
plot(t(1,1:Nsteps),X_BR(1,:),'r')
hold on
plot(t(1,1:Nsteps),X_BR(2,:),'g')
hold on
plot(t(1,1:Nsteps),X_BR(3,:),'b')
grid on
legend(["$\sigma_1$","$\sigma_2$","$\sigma_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Modified Rodrigues Parameter $\sigma_{B/R}$","interpreter","latex")

figure(20)
plot(t(1,1:Nsteps),W_BR(1,:),'r')
hold on
plot(t(1,1:Nsteps),W_BR(2,:),'g')
hold on
plot(t(1,1:Nsteps),W_BR(3,:),'b')
grid on
legend(["$\omega_1$","$\omega_2$","$\omega_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Angular Velocity $\omega_{B/R}$ (rad/s)","interpreter","latex")

Nsteps = t_final/dt;

figure(21)
plot(t(1,1:Nsteps),U(1,:),'r')
hold on
plot(t(1,1:Nsteps),U(2,:),'g')
hold on
plot(t(1,1:Nsteps),U(3,:),'b')
grid on
legend(["$u_1$","$u_2$","$u_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Control Torque (Nm)","interpreter","latex")

index_45s = find(t==60);
MRP_norm_45s = norm(X_BR(:,index_45s));
fprintf("MRP norm at 45 seconds for regulator case is %f \n",MRP_norm_45s)

%% Regulation - Linearised Control

clear all

MRP_0 = [0.1; 0.2; -0.1];
w_0 = [3; 1; -2]/57.3;

global K P L DeltaL I

K = 0.11;
P = 3*eye(3);
L = 0;
I = [100 0 0; 0 75 0; 0 0 80];
DeltaL = 0;

K_I = 0;
tracking = false;
f = 0;

dt = 0.001;%time step (s)
t_final = 60;

controltype = 7;


[X_BN, W_BN, U, X_BR, W_BR] = simulation(dt, t_final, MRP_0, w_0, f, I, L, K, P, tracking, DeltaL, controltype, K_I);

t = 0:dt:t_final;
Nsteps = t_final/dt;
%%
figure(19)
plot(t(1,1:Nsteps),X_BR(1,:),'r')
hold on
plot(t(1,1:Nsteps),X_BR(2,:),'g')
hold on
plot(t(1,1:Nsteps),X_BR(3,:),'b')
grid on
legend(["$\sigma_1$","$\sigma_2$","$\sigma_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Modified Rodrigues Parameter $\sigma_{B/R}$","interpreter","latex")

figure(20)
plot(t(1,1:Nsteps),W_BR(1,:),'r')
hold on
plot(t(1,1:Nsteps),W_BR(2,:),'g')
hold on
plot(t(1,1:Nsteps),W_BR(3,:),'b')
grid on
legend(["$\omega_1$","$\omega_2$","$\omega_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Angular Velocity $\omega_{B/R}$ (rad/s)","interpreter","latex")

Nsteps = t_final/dt;

figure(21)
plot(t(1,1:Nsteps),U(1,:),'r')
hold on
plot(t(1,1:Nsteps),U(2,:),'g')
hold on
plot(t(1,1:Nsteps),U(3,:),'b')
grid on
legend(["$u_1$","$u_2$","$u_3$"],"interpreter","latex")
xlabel("Time (s)","interpreter","latex")
ylabel("Control Torque (Nm)","interpreter","latex")
%%
index_45s = find(t==50);
MRP_norm_45s = norm(X_BR(:,index_45s));
fprintf("MRP norm at 50 seconds for regulator case is %f \n",MRP_norm_45s)
