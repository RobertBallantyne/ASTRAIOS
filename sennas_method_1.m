function P_C = sennas_method_1(SD_x, SD_y, x_m, y_m, R, N)
p = 1/(2*SD_y^2);
Phi = 1 - SD_y^2/SD_x^2;
w_x = x_m^2/(4*SD_x^4);
w_y = y_m^2/(4*SD_y^4);
a_0 = 1/(2*SD_x*SD_y)*exp(-(x_m^2/SD_x^2 + y_m^2/SD_y^2)/2);
c(1,1) = a_0 * R^2;
c(1,2) = a_0*R^4*(p*(Phi/2 + 1) + w_x + w_y)/2;
c(1,3) = a_0*R^6*((p*(Phi/2 + 1) + w_x + w_x)^2 + p^2*(Phi^2/2 + 1) + 2*p*Phi*w_x)/6;
c(1,4) = a_0*R^8*((p*(Phi/2 + 1) + w_x + w_y)^3 + 3*(p*(Phi/2 + 1) + w_x + w+y)*(p^2*(Phi^2/1 + 1) + 2*p*Phi*w_x)...
    + 2*(p^3*(Phi^3/2 + 1) + 3*p^2*Phi^2*w_x))/144;

for k = 1:N-5
    c(1,k+4) = -(R^8*p^3*Phi^2*w_y/(k+2)*(k+3)*((k+4)^2)*(k + 5))*c(1,k) + R^6*p^2*Phi*(p*Phi*(k+ 2.5) + ...
        2*w_y*(Phi/2 + 1))/((k+3)*((k+4)^2)*(k+5)*c(1,k+1) - R^4*p*(p*Phi*(Phi/2 + 1)*(2*k + 5) + Phi*(2*w_y ...
        + 1.5*p) + w_x + w_y)/(((k+4)^2)*(k+5))*c(1,k+2) + R^2*(p*(2*Phi+1)*(k+3) + p*(Phi/2 + 1) + w_x + w_y)...
        /((k+4)*(k+5)*c(1,k+3)));
end

P_C = exp(-p*R^2)*sum(c(1,:));
end