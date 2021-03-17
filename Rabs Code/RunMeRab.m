%% ISS Orbital Manoeuvre Script - Written by Angus McAllister 20/02/2021
% Map Generator For Rab to run 

clear all
close all
warning off

% t_f_init = 3.8;
% t_f_fin = 10;
% N_steps = 20;
% 
% t_f_array = linspace(t_f_init,t_f_fin,N_steps);

global mu m0 m1 T r_0

mu_E = 3.986e14; %Gravitational Parameter of Earth (m^3/s^2)
I_sp = 300; % Specific Impulse (N/s)
DU = 6371000; %Distance Unit (Earth's Radius) (m)
TU = sqrt(DU^3/mu_E); %Time Unit (s)
MU = 300400; %Mass Unit (kg)

ISS_alt = 420000;
U_res = 1;
it = 1;
t_f_min = 6;
t_f_max = 8;
t_f_step = 0.02;
n_t_f = (t_f_max-t_f_min)/t_f_step + 1;
t_f_array = linspace(t_f_min,t_f_max,n_t_f);
%%
for J=1:n_t_f
    F = 20;
    U_res = 1;
    it = 1;
    while U_res>0
        
        t_f = t_f_array(1,J);
        
        m_dot = F/(I_sp*9.81);

        mu = 1; % = DU^3/TU^2
        m0 = 1; % = MU
        m1 = m_dot*TU/MU;
        T = F*TU^2/(MU*DU);
        r_0 = (DU+ISS_alt)/DU;


        n = 10000;

        % for i=1:N_steps

        y = [1
        0
        1
        0
        0
        -1
        0];

        % t_f = t_f_array(1,i);

        x = linspace(0,t_f,n);%time vector

        solinit = bvpinit(x,y);

        tol = 1e-10;
        options = bvpset("RelTol",tol,"AbsTol",[tol tol tol tol tol tol tol],"Nmax", n);

        sol = bvp5c(@orbit_ivp,@orbit_bound,solinit,options);

        ang2= pi + atan2(sol.y(6,:),sol.y(7,:));
            %
%             figure(1)
%             subplot(3,1,1)
%             plot(sol.x*TU,sol.y(1,:)*DU/1000,'r')
%             ylabel("r (km)", "interpreter","latex")
%             grid on
%             subplot(3,1,2)
%             plot(sol.x*TU,sol.y(2,:)*DU/TU,'g')
%             ylabel("$V_r$(km/s)", "interpreter","latex")
%             grid on
%             subplot(3,1,3)
%             plot(sol.x*TU,sol.y(3,:)*DU/TU,'b')
%             ylabel("$V_t$ (km/s)", "interpreter","latex")
%             grid on
%             xlabel("Time (s)","interpreter","latex")
%             sgtitle("States","interpreter","latex")
%             %%
%             dt = diff(sol.x);
%             dth=(sol.y(3,1:end-1)./sol.y(1,1:end-1)).*dt; % \dot \theta = v_t/r
%             th = cumsum(dth');
%             pathloc=[sol.y(1,1:end-1)'.*cos(th) sol.y(1,1:end-1)'.*sin(th)];
%             % 
%     
%             figure(2)
%             plot(pathloc(:,1),pathloc(:,2),'k-',"LineWidth",2)
%             hold on
%             zz = exp(sqrt(-1)*[0:0.01:pi]');
%             r0 = sol.y(1,1);
%             rf = sol.y(1,end);
%             plot(r0*real(zz),r0*imag(zz),"r--","LineWidth",2)
%             plot(rf*real(zz),rf*imag(zz),"b--","LineWidth",2)
%             plot(r0,0,"ro","MarkerFace","r")
%             plot(rf*cos(th(end)),rf*sin(th(end)),"bo","MarkerFace","b")
%             fact = 0.2;
%             ep = ones(size(th,1),1)*pi/2+th-ang2(1,end-1)';
%             xt = fact*cos(ang2);
%             yt = fact*sin(ang2);
%             step = floor(size(th,1)/50);
%             for i = 1:step:size(th,1)
%                 quiver(pathloc(i,1),pathloc(i,2), xt(i), yt(i),"m");
%             end
%             grid on
%             title("Orbital Maneuver","interpreter","latex")

        DCM = zeros(3,3,length(ang2));
        eulerAngles = zeros(length(ang2),3);
        MRP = zeros(length(ang2),3);

        t_f = t_f*TU;
        dt = t_f/length(sol.x);

        for i=1:length(ang2)
            if ang2(1,i) > pi
                ang2(1,i) = ang2(1,i) - 2*pi;
            end
            eulerAngles(i, 2) = ang2(i);
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

        %Initial Conditions
        MRP_0 = MRP(:,1);
        w_0 = [0; 0; 0];
        f = 0;

        %Setup Parameters
        % I = [75763427 0 0;0 63229877 0 ;0 0 133090463];
%         I = [72170517 5612326 3106490; 5612326 67072203 -2727715; 3106490 -2727715 132841047]; 
        I = [72170517 5612326 3106490; 
                5612326 67072203 -2727715; 
                3106490 -2727715 132841047]; 
        % Model vector thrust acting on craft

%         r_PN = [-23.701; -6e-3; 16.335];
        r_PN = [-23.701; -6e-3; -16.335];
        r_CN = [-6.06 ; -2.69 ; -3.37];
        r_PC = r_PN - r_CN;
        F_PS = [0; 0; F];
        L_p = cross(r_PC, F_PS);
        
        T_F = 0.025*t_f*eye(3);
        P = 2* I / T_F;
        K = P.^2 / (0.9^2 * I);
        tracking = true;
        DeltaL = 0;
        controltype = 1;
        K_I = 0;

        soly = sol.y(1,:)*DU;
        [X_BN, W_BN, U, sum_U, X_BR, W_BR, L_G] = simulation(dt, t_f, MRP_0, w_0, f, I, L_p, K, P, tracking, DeltaL, controltype, K_I, MRP, MRP_dot, soly);

        U_res = 1032 - max(sum_U);
        it = it+1;
        F = F + 2;
        
        DEL_R(J,it) = sol.y(1,end)*DU - (DU + ISS_alt);
        RES_BVP(J,it) =  sol.stats.maxerr;
        THRUST(J,it) = F;
    end
    
    delta_R(J,1) = sol.y(1,end)*DU - (DU + ISS_alt);
    res_bvp(J,1) = sol.stats.maxerr;
    Thrust(J,1) = F;
    num_iterations(J,1) = it;
    fprintf("---------------------------------------------- \n")
    fprintf("J = %d \n",J)
    fprintf("t_f = %.2f \n", t_f/TU)
    fprintf("delta R = %.2f \n", delta_R(J,end))
    fprintf("F = %.1f \n", F)
    fprintf("Number of Iterations = %d \n", num_iterations(J,1))
    fprintf("BVP Residuals = %d \n", res_bvp(J,1))
end

% t = 0:dt:t_f;
% Nsteps = round(t_f/dt);
% 
% figure(3)
% 
% plot(t(1,1:Nsteps),MRP(1,:),'r--')
% hold on
% plot(t,X_BN(1,:),'r')
% hold on
% plot(t(1,1:Nsteps),X_BR(2,:),'g')
% hold on
% plot(t(1,1:Nsteps),X_BR(3,:),'b')
% legend(["Reference","1","2","3"],"orientation","horizontal","location","northeast","interpreter","latex")
% grid on
% ylabel("$\sigma_{B/N}$","interpreter","latex")
% 
% figure(4)
% plot(t,W_BN(1,:),'r')
% hold on
% plot(t,W_BN(2,:),'g')
% hold on
% plot(t,W_BN(3,:),'b')
% grid on
% legend(["$\omega_1$","$\omega_2$","$\omega_3$"],"interpreter","latex")
% ylabel("$\omega_{B/N}$ (rad/s)","interpreter","latex")
% 
% 
% figure(5)
% plot(t(1,1:Nsteps),U(1,:),'r')
% hold on
% plot(t(1,1:Nsteps),U(2,:),'g')
% hold on
% plot(t(1,1:Nsteps),U(3,:),'b')
% grid on
% legend(["$u_1$","$u_2$","$u_3$"],"interpreter","latex")
% xlabel("Time (s)","interpreter","latex")
% ylabel("U (Nm)","interpreter","latex")
% 
% % figure(6)
% % plot(t(1,1:Nsteps),L_G(1,:),'r')
% % hold on
% % plot(t(1,1:Nsteps),L_G(2,:),'g')
% % hold on
% % plot(t(1,1:Nsteps),L_G(3,:),'b')
% % grid on
% % legend(["$lg_1$","$lg_2$","$lg_3$"],"interpreter","latex")
% % xlabel("Time (s)","interpreter","latex")
% % ylabel("Grav Grad (Nm)","interpreter","latex")

%%
% load DEL_R.mat
% load THRUST.mat
% load RES_BVP.mat
% %%
% t_f_min = 6.0;
% t_f_max = 7;
% t_f_step = 0.02;
% n_t_f = (t_f_max-t_f_min)/t_f_step + 1;
% t_f_array = linspace(t_f_min,t_f_max,n_t_f);
% 
% F_arr = THRUST(49,:);
% [t_f_arr, F_array] = meshgrid(t_f_array, F_arr);
% %%
% figure(1)
% surf(F_arr,t_f_array*TU, DEL_R)
% xlabel("Force (N)","interpreter","latex")
% ylabel("Time (s)","interpreter","latex")
% zlabel("Change in Orbit Radius (m)","interpreter","latex")
% %%
% figure(2)
% 
% surf(F_arr,t_f_array*TU, RES_BVP)
% xlabel("Force (N)","interpreter","latex")
% ylabel("Time (s)","interpreter","latex")
% zlabel("BVP Residuals","interpreter","latex")
% % figure
% % surf(F_arr,t_f_array, RES_BVP)
% 
% %%
% figure(1)
% yyaxis left
% plot(t_f_array*TU, delta_R)
% ylabel("$\Delta R$ (km)","interpreter","latex")
% yyaxis right
% plot(t_f_array*TU, Thrust)
% xlabel("Burn Time (s)","interpreter","latex")
% ylabel("Thrust (N)","interpreter","latex")
% grid on
