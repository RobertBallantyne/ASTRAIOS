%% Root Locus Plots

close all
clear all

warning off

I_P = [72170517 5612326 3106490; 
    5612326 67072203 -2727715; 
    3106490 -2727715 132841047]; 

I_S = [104643956 2655014 2702459; 
    2655014 60362756 -707488; 
    2702459 -707468 158216940];

I_ATV = [112719909 3349035 26311761; 
    3349035 74123914 757450;
    2631761 77450 178976655];

I_arr = [I_P I_S I_ATV];

DU = 6371000; %Distance Unit (Earth's Radius) (m)
mu_E = 3.986e14; %Gravitational Parameter of Earth (m^3/s^2)

TU = sqrt(DU^3/mu_E); %Time Unit (s)

% t_f = 6.92*TU;
t_f = [6.92*TU 6.92*TU 7.46*TU];
T_F = 0.025*t_f;

I_factor = linspace(0.75,1.25,100);
s = zeros(2,100);
%%
for j=1:3
    for i =1:100

        Iyy = I_factor(1,i)*I_arr(1,j);
        P(i,j) = 2* Iyy / T_F(1,j);
        K(i,j) = P(i,j)^2 / (0.9^2 * Iyy);

    end
end

figure(1)

semilogy(I_factor,P(:,1),"r")
hold on
semilogy(I_factor,P(:,2),"g")
hold on
semilogy(I_factor,P(:,3),"b")
xlabel("Mass Moment of Inertia Factor","interpreter","latex")
ylabel("Derivative Gain ($kg m^{2}/s$)","interpreter","latex")
grid on
legend(["Progress","Soyuz","ATV"],"location","northeast","interpreter","latex")

figure(2)
semilogy(I_factor,K(:,1),"r")
hold on
semilogy(I_factor,K(:,2),"g")
hold on
semilogy(I_factor,K(:,3),"b")
xlabel("Mass Moment of Inertia Factor","interpreter","latex")
ylabel("Proportional Gain ($kg m^{2}/s$)","interpreter","latex")
grid on
legend(["Progress","Soyuz","ATV"],"location","northeast","interpreter","latex")
