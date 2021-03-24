%% Un-Modelled Torque Disturbance
close all
clear all

%% Get Progress Data

cd("C:\Users\Angus\Documents\5th Year\Group Project\Final Control Code\UnModelled Torque Disturbance\Progress\No Torque Disturbance")
load U.mat
load X_BR.mat
load t.mat

Progress.Nominal.U = sum_U;
Progress.Nominal.X_BR = X_BR;
Progress.t = t;

cd("C:\Users\Angus\Documents\5th Year\Group Project\Final Control Code\UnModelled Torque Disturbance\Progress\Torque Disturbance")
load U.mat
load X_BR.mat

Progress.Disturbed.U = sum_U;
Progress.Disturbed.X_BR = X_BR;

% Progress.ErrorDiff = abs(Progress.Nominal.X_BR(2,:)-Progress.Disturbed.X_BR(2,:));

cd("C:\Users\Angus\Documents\5th Year\Group Project\Final Control Code\UnModelled Torque Disturbance\Progress\Torque Disturbance PID")

load U.mat
load X_BR.mat

Progress.Disturbed.U_PID = sum_U;
Progress.Disturbed.X_BR_PID = X_BR;

cd("C:\Users\Angus\Documents\5th Year\Group Project\Final Control Code\UnModelled Torque Disturbance\Soyuz\No Torque Disturbance")
load U.mat
load X_BR.mat
load t.mat

Soyuz.Nominal.U = sum_U;
Soyuz.Nominal.X_BR = X_BR;
Soyuz.t = t;

cd("C:\Users\Angus\Documents\5th Year\Group Project\Final Control Code\UnModelled Torque Disturbance\Soyuz\Torque Disturbance")
load U.mat
load X_BR.mat

Soyuz.Disturbed.U = sum_U;
Soyuz.Disturbed.X_BR = X_BR;

% Soyuz.ErrorDiff = abs(Soyuz.Nominal.X_BR(2,:)-Soyuz.Disturbed.X_BR(2,:));

cd("C:\Users\Angus\Documents\5th Year\Group Project\Final Control Code\UnModelled Torque Disturbance\Soyuz\Torque Disturbance PID")

load U.mat
load X_BR.mat

Soyuz.Disturbed.U_PID = sum_U;
Soyuz.Disturbed.X_BR_PID = X_BR;

cd("C:\Users\Angus\Documents\5th Year\Group Project\Final Control Code\UnModelled Torque Disturbance\ATV\No Torque Disturbance")

load U.mat
load X_BR.mat
load t.mat

ATV.Nominal.U = sum_U;
ATV.Nominal.X_BR = X_BR;
ATV.t = t;

cd("C:\Users\Angus\Documents\5th Year\Group Project\Final Control Code\UnModelled Torque Disturbance\ATV\Torque Disturbance")
load U.mat
load X_BR.mat

ATV.Disturbed.U = sum_U;
ATV.Disturbed.X_BR = X_BR;

cd("C:\Users\Angus\Documents\5th Year\Group Project\Final Control Code\UnModelled Torque Disturbance\ATV\Torque Disturbance PID")

load U.mat
load X_BR.mat

ATV.Disturbed.U_PID = sum_U;
ATV.Disturbed.X_BR_PID = X_BR;

% ATV.ErrorDiff = abs(ATV.Nominal.X_BR(2,:)-ATV.Disturbed.X_BR(2,:));

%% Plot Torque Data
% 
% figure(1)
% subplot(3,1,1)
% plot(Progress.t(1,1:(end-1)),Progress.Nominal.U,"r")
% hold on
% plot(Progress.t(1,1:(end-1)),Progress.Disturbed.U,"r--")
% ylabel("Torque (Nm)","interpreter","latex")
% grid on
% xlim([Progress.t(1,1), Progress.t(1,(end-1))])
% title("Progress","interpreter","latex")
% 
% subplot(3,1,2)
% plot(Soyuz.t(1,1:(end-1)),Soyuz.Nominal.U,"g")
% hold on
% plot(Soyuz.t(1,1:(end-1)),Soyuz.Disturbed.U,"g--")
% ylabel("Torque (Nm)","interpreter","latex")
% grid on
% xlim([Soyuz.t(1,1), Soyuz.t(1,(end-1))])
% title("Soyuz","interpreter","latex")
% 
% subplot(3,1,3)
% plot(ATV.t(1,1:(end-1)),ATV.Nominal.U,"b")
% hold on
% plot(ATV.t(1,1:(end-1)),ATV.Disturbed.U,"b--")
% xlim([ATV.t(1,1), ATV.t(1,(end-1))])
% xlabel("Time (s)","interpreter","latex")
% ylabel("Torque (Nm)","interpreter","latex")
% grid on
% title("ATV","interpreter","latex")

%% Convert Error Matrices from MRPs to EAs
cd("C:\Users\Angus\Documents\5th Year\Group Project\Final Control Code")

for i=1:length(Progress.Nominal.X_BR)
    Progress.Disturbed.BR(:,:,i) = MRPtoDCM(Progress.Disturbed.X_BR(:,i));
    Progress.Disturbed.X_BR_EA(:,i) = DCMto321(Progress.Disturbed.BR(:,:,i));
    
    Progress.Nominal.BR(:,:,i) = MRPtoDCM(Progress.Nominal.X_BR(:,i));
    Progress.Nominal.X_BR_EA(:,i) = DCMto321(Progress.Nominal.BR(:,:,i));
    
    Progress.Disturbed.BR_PID(:,:,i) = MRPtoDCM(Progress.Disturbed.X_BR_PID(:,i));
    Progress.Disturbed.X_BR_EA_PID(:,i) = DCMto321(Progress.Disturbed.BR_PID(:,:,i));
        
    Soyuz.Disturbed.BR(:,:,i) = MRPtoDCM(Soyuz.Disturbed.X_BR(:,i));
    Soyuz.Disturbed.X_BR_EA(:,i) = DCMto321(Soyuz.Disturbed.BR(:,:,i));
    
    Soyuz.Nominal.BR(:,:,i) = MRPtoDCM(Soyuz.Nominal.X_BR(:,i));
    Soyuz.Nominal.X_BR_EA(:,i) = DCMto321(Soyuz.Nominal.BR(:,:,i));
        
    Soyuz.Disturbed.BR_PID(:,:,i) = MRPtoDCM(Soyuz.Disturbed.X_BR_PID(:,i));
    Soyuz.Disturbed.X_BR_EA_PID(:,i) = DCMto321(Soyuz.Disturbed.BR_PID(:,:,i));
    
    ATV.Disturbed.BR(:,:,i) = MRPtoDCM(ATV.Disturbed.X_BR(:,i));
    ATV.Disturbed.X_BR_EA(:,i) = DCMto321(ATV.Disturbed.BR(:,:,i));
    
    ATV.Nominal.BR(:,:,i) = MRPtoDCM(ATV.Nominal.X_BR(:,i));
    ATV.Nominal.X_BR_EA(:,i) = DCMto321(ATV.Nominal.BR(:,:,i));
        
    ATV.Disturbed.BR_PID(:,:,i) = MRPtoDCM(ATV.Disturbed.X_BR_PID(:,i));
    ATV.Disturbed.X_BR_EA_PID(:,i) = DCMto321(ATV.Disturbed.BR_PID(:,:,i));
    
end
    
%%

figure(2)

subplot(3,1,1)
plot(Progress.t(1,1:(end-1)),Progress.Nominal.X_BR_EA(2,:)*57.3,"r")
hold on
plot(Progress.t(1,1:(end-1)),Progress.Disturbed.X_BR_EA(2,:)*57.3,"r--")
hold on
plot(Progress.t(1,1:(end-1)),Progress.Disturbed.X_BR_EA_PID(2,:)*57.3,"r-.")
ylabel("$\theta$ (deg)","interpreter","latex")
grid on
xlim([Progress.t(1,1), Progress.t(1,(end-1))])
title("Progress","interpreter","latex")

subplot(3,1,2)
plot(Soyuz.t(1,1:(end-1)),Soyuz.Nominal.X_BR_EA(2,:)*57.3,"g")
hold on
plot(Soyuz.t(1,1:(end-1)),Soyuz.Disturbed.X_BR_EA(2,:)*57.3,"g--")
hold on
plot(Soyuz.t(1,1:(end-1)),Soyuz.Disturbed.X_BR_EA_PID(2,:)*57.3,"g-.")
ylabel("$\theta$ (deg)","interpreter","latex")
grid on
xlim([Soyuz.t(1,1), Soyuz.t(1,(end-1))])
title("Soyuz","interpreter","latex")

subplot(3,1,3)
plot(ATV.t(1,1:(end-1)),ATV.Nominal.X_BR_EA(2,:)*57.3,"b")
hold on
plot(ATV.t(1,1:(end-1)),ATV.Disturbed.X_BR_EA(2,:)*57.3,"b--")
hold on
plot(ATV.t(1,1:(end-1)),ATV.Disturbed.X_BR_EA_PID(2,:)*57.3,"b-.")
xlim([ATV.t(1,1), ATV.t(1,(end-1))])
xlabel("Time (s)","interpreter","latex")
ylabel("$\theta$ (deg)","interpreter","latex")
grid on
title("ATV","interpreter","latex")

%% Plot MRP Attitude Error Differences
% 
% figure(3)
% semilogy(Progress.t(1,1:(end-1)),Progress.ErrorDiff*57.3,"r")
% hold on
% semilogy(Soyuz.t(1,1:(end-1)),Soyuz.ErrorDiff*57.3,"g")
% hold on
% semilogy(ATV.t(1,1:(end-1)),ATV.ErrorDiff*57.3,"b")
% xlabel("Time (s)","interpreter","latex")
% ylabel("$\theta_{B/R}^{nom}$ - $\theta_{B/R}^{disturb}$ (degrees)","interpreter","latex")
% legend(["Progress","Soyuz","ATV"],"location","southeast","interpreter","latex")
% grid on

