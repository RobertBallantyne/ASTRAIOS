%% Sensitivity to Moment of Inertia Numerical Analysis
close all
clear all

cd("C:\Users\Angus\Documents\5th Year\Group Project\Final Control Code\Progress Sensitivity Analysis\Torque")
load U_75.mat
U_75 = sum_U;
load U_nom.mat
U_nom = sum_U;
load U_125.mat;
U_125 = sum_U;

load t;

%%
cd("C:\Users\Angus\Documents\5th Year\Group Project\Final Control Code\Progress Sensitivity Analysis\Rates")
load W_BN_75.mat
W_75 = W_BN(2,:);
load W_BN_nom.mat
W_nom = W_BN(2,:);
load W_BN_125.mat
W_125 = W_BN(2,:);

%%
cd("C:\Users\Angus\Documents\5th Year\Group Project\Final Control Code\Progress Sensitivity Analysis\States")
load X_BN_75.mat
X_75 = X_BN(2,:);
load X_BN_nom.mat
X_nom = X_BN(2,:);
load X_BN_125.mat
X_125 = X_BN(2,:);
%%
figure(1)
plot(t(1,1:end-1),U_75,"r")
hold on
plot(t(1,1:end-1),U_nom,"g")
hold on
plot(t(1,1:end-1),U_125,"b")
xlim([0, t(1,end)])
xlabel("Time (s)","interpreter","latex")
ylabel("Control Torque (Nm)","interpreter","latex")
legend(["75 \%","Nominal","125 \%"],"interpreter","latex")
grid on
