function [P_C, P_C_bar] = sennas_method_2(SD_x, SD_y, x_m, y_m, R, del)
p = 1/(2*SD_y^2);
Phi = 1 - SD_y^2/SD_x^2;
w_x = x_m^2/(4*SD_x^4);
w_y = y_m^2/(4*SD_y^4);
a_0 = 1/(2*SD_x*SD_y)*exp(-(x_m^2/SD_x^2 + y_m^2/SD_y^2)/2);
l_0 = a_0*((1-exp(-p*R^2))/p);
u_0 = a_0*(exp(p*(Phi/2 + (w_x + w_y)/p)*R^2) - exp(-p*R^2))/(p*(1+ Phi/2 + (w_x + w_y)/p));

if u_0 - l_0 <= del
    P_C = l_0;
    P_C_bar = u_0;
    return
else
    N(1,1) = 2*ceil(e*p*R^2*(1 + Phi/2 + (w_x + w_y)/p));
    N(1,2) = ceil(log2(a_0 * exp(p * R^2 * (Phi/2 + (w_x + w_y)/p))/(del*p*sqrt(2*pi*N(1,1))*(1 + Phi/2 + (w_x + w_y)/p))));
    n = max(N) - 1;
    P_C_1 = sennas_method_1(SD_x, SD_y, x_m, y_m, R, n);
    
    l_n = a_0 * exp(-p*R^2)*(p*R^2)^(n+1) / (p*fact(n+1));
    u_n = a_0*exp(p*(Phi/2 + (w_x + w_y)/p)*R^2)*(p*(1 + Phi/2 + (w_x + w_y)/p)*R^2)^(n+1) / (p*(1 + Phi/2 + w_x + w_y)/p)*fact(n + 1);
    P_C = P_C_1 + l_n;
    P_C_bar = P_c_1 + u_n;
    return
    
end