function Pc = serraAlgorithm1(varX, varY, xm, ym, R, n)
    p = 1 / (2*varY);

    phi = 1 - varY/varX;

    omegaX = xm^2 / (4*varX^2);
    omegaY = ym^2 / (4*varY^2);

    a0 = 1 / (2*sqrt(varX*varY)) * exp(-(xm^2/varX + ym^2/varY)/2);

    c(1) = a0 * R^2;
    c(2) = a0 * R^4 * (p*(phi/2 + 1) + omegaX + omegaY)/2;
    c(3) = a0 * R^6 * ((p*(phi/2 + 1) + omegaX + omegaY)^2 ...
           + p^2 * (phi^2/2 + 1) + 2*p*phi*omegaX) / 6;
    c(4) = a0 * R^8 * ((p*(phi/2 + 1) + omegaX + omegaY)^3 ...
           + 3 * (p*(phi/2+1) + omegaX + omegaY)*(p^2*(phi^2/2+1) + 2*p*phi*omegaX) ...
           + 2 * (p^3*(phi^3/2 + 1) + 3*p^2*phi^2*omegaX)) / 144;

    for k = 1:n-4
        c(k+4) = -(R^8*p^3*phi^2*omegaY / ((k+2)*(k+3)*(k+4)^2*(k+5)))*c(k) ...
                 + R^6*p^2*phi*(p*phi*(k + 5/2) + 2*omegaY *(phi/2 + 1)) ...
                 / ((k + 3)*(k + 4)^2*(k + 5))*c(k+1) ...
                 - R^4*p*(p*phi*(phi/2+1)*(2*k+5)+ ...
                 phi*(2*omegaY + 3*p/2) + omegaX + omegaY) ...
                 / ((k + 4)^2*(k + 5)) * c(k+2) ...
                 + R^2*(p*(2*phi + 1) * (k+3) + p*(phi/2 + 1) + omegaX + omegaY)...
                 / ((k + 4)*(k + 5)) * c(k+3);
    end

    s = sum(c);

    Pc = exp(-p*R^2)*s;
end
