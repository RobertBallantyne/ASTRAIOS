function Pcmax = serraAlgorithm2(varX, varY, xm, ym, R, tolerance)

p = 1 / (2*varY);

phi = 1 - varY/varX;

omegaX = xm^2 / (4*varX^2);
omegaY = ym^2 / (4*varY^2);

a0 = 1 / (2*sqrt(varX*varY)) * exp(-(xm^2/varX + ym^2/varY)/2);

l0 = a0 * ((1 - exp(1 - p*R^2)) / p);
u0 = a0 *(exp(p*(phi/2 + (omegaX + omegaY)/p)*R^2)...
       - exp(-p*R^2))/(p*(1+phi/2 + (omegaX + omegaY) / p));
   
if u0 - l0 < tolerance
    Pcmin = l0;
    Pcmax = u0;
else
    N1 = 2 * (exp(1)*p*R^2*(1 + phi / 2 + (omegaX + omegaY) / p));
    N2 = log2((a0*exp(p*R^2*(phi/2+(omegaX + omegaY)/p))) ...
         / (tolerance * p * sqrt(2 * pi * N1)*(1 + phi/2 + (omegaX + omegaY)/p))); 

    n = ceil(max([N1, N2]) - 1);

    PcGuess = serraAlgorithm1(varX, varY, xm, ym, R, n);

    l = a0 * exp(-p*R^2)*(p*R^2)^(n+1) / (p*factorial((n+1)));
    u = a0 * exp(p*(phi/2 + (omegaX + omegaY)/p) * R^2)...
        * (p*(1 + phi/2 + (omegaX + omegaY) /p) * R^2)^(n+1) ...
        / (p*(1 + phi/2 + (omegaX + omegaY)/p)*factorial(n+1));
    Pcmin = PcGuess + l;
    Pcmax = PcGuess + u;
end
end