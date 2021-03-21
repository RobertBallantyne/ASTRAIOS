function [X_BN, W_BN, U, sum_U, X_BR, W_BR, L_G, WD_BN] = simulation(dt, t_final, MRP_0, w_0, f, I, L_p, K, P, tracking, DeltaL, controltype, K_I, ref_MRP, ref_MRP_dot, soly)
global K P L DeltaL I

N_steps = round(t_final/dt);

t = 0:dt:t_final;

BR = zeros(3,3,N_steps);

X_RN = zeros(3,N_steps);
X_BN = zeros(3,N_steps);
X_BR = zeros(3,N_steps);

W_RN = zeros(3,N_steps);
W_BN = zeros(3,N_steps);
W_BR = zeros(3,N_steps);

W_RN_dot = zeros(3,N_steps);
W_BN_dot = zeros(3,N_steps);
X_BN_dot = zeros(3,N_steps);
L_G = zeros(3,N_steps);

dX_BN = zeros(3, N_steps);
DCM_dX_BN = zeros(3,3,N_steps);
dX_BN_EA = zeros(3, N_steps);
WD_BN = zeros(1, N_steps);

X_BN(:,1) = MRP_0;
W_BN(:,1) = w_0;

U = zeros(3,N_steps);
sum_U = zeros(1,N_steps);

Z = zeros(3,N_steps);

for N=1:N_steps
    
    if norm(X_BN(:,N))>=1
    X_BN(:,N) = -X_BN(:,N)/(norm(X_BN(:,N))^2);
    end
    
    X_RN(:,N) = MRP_tracking(t(1,N),f,tracking, ref_MRP(:,N));
    [X_BR(:,N), BR(:,:,N)] = MRP_BR(X_BN(:,N), X_RN(:,N), tracking);
    W_RN(:,N) = w_RN(t(1,N), BR(:,:,N), f, tracking, ref_MRP(:,N), ref_MRP_dot(:,N));
    W_RN_dot(:,N) = w_RN_dot(t(1,N), dt, BR(:,:,N), f, tracking, ref_MRP(:,N), ref_MRP_dot(:,N));
    W_BR(:,N) = W_BN(:,N) - W_RN(:,N);
    
    if controltype == 4
        if N == 1
            X_BR_integral = zeros(3,1);
        else
            X_BR_integral_1 = trapz(dt, X_BR(1,1:N));
            X_BR_integral_2 = trapz(dt, X_BR(2,1:N));
            X_BR_integral_3 = trapz(dt, X_BR(3,1:N));

            X_BR_integral = [X_BR_integral_1; X_BR_integral_2; X_BR_integral_3];
        end
    else
        X_BR_integral = zeros(3,1);
    end
   
    solrc = soly(1,N);
    Lg = gravgrad(X_BN(:,N) , solrc);
    L = Lg + L_p;
    Z(:,N) = K*X_BR_integral + I*(W_BR(:,N)-W_BR(:,1));    
    U(:,N) = control(X_BR(:,N),W_BR(:,N),W_BN(:,N),W_RN(:,N),W_RN_dot(:,N), L, controltype, K_I, Z(:,N));
    sum_U(1,N) = abs(U(1,N)) + abs(U(2,N)) + abs(U(3,N));
    
    W_BN_dot(:,N) = w_BN_dot(W_BN(:,N), U(:,N), L, DeltaL);
    X_BN_dot(:,N) = MRP_dot(X_BN(:,N),W_BN(:,N));
        
    W_BN(:,N+1) = W_BN(:,N) + W_BN_dot(:,N)*dt;
    X_BN(:,N+1) = X_BN(:,N) + X_BN_dot(:,N)*dt;
    
    dX_BN(:,N) = X_BN(:,N+1)- X_BN(:,N);
        
    DCM_dX_BN(:,:,N) = MRPtoDCM(dX_BN(:,N));
    dX_BN_EA(:,N) = DCMto321(DCM_dX_BN(:,:,N));
    WD_BN(1,N) = dot(U(:,N),dX_BN_EA(:,N));
    
    L_G(:,N) = Lg;
end
    
end
    
    