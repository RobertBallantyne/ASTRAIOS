%%  Serra method
v = vs - vp;
r0 = rs - rp;

ez = v / norm(v);
ey = cross(v, r0) / norm(cross(v, r0));
ex = cross(ey, ez);

rmBar = [ex;ey;ez] * r0;

Ce = [ex;ey] * C * [ex;ey]';

rho = corrcoeff(Ce);

varXbar = Ce(1, 1);
varYbar = Ce(2, 2);

if rho ~= 0
    theta = atan((varXbar - varYbar) / 2*rho*sqrt(varXbar*varYbar) + ...
            rho/norm(rho) * sqrt(1 + ...
            ((varYbar - varXbar)/(2*rho*sqrt(varXbar*varYbar)))));
elseif varXbar >= varYbar
    theta = 0;

elseif varXbar < varYbar
    theta = pi/2;
end

xm = rmBar(1) * cos(theta);
ym = -rmBar(1) * sin(theta);

eigenValues = eig(Ce);

varX = eigenValues(1);
varY = eigenValues(2);

%% Algorithm 1

varX = 50^2;
varY = 25^2;
xm = 10;
ym = 0;

Rp = 2.5;
Rs = 2.5;

R = Rp + Rs;

p = 1 / (2*varY);

phi = 1 - varY/varX;

omegaX = xm^2 / (4*varX^2);
omegaY = ym^2 / (4*varY^2);

a0 = 1 / (2*sqrt(varX*varY)) * exp(-(xm^2/varX + ym^2/varY)/2);

N = 10;
c(1) = a0 * R^2;
c(2) = a0 * R^4 * (p*(phi/2 + 1) + omegaX + omegaY)/2;
c(3) = a0 * R^6 * ((p*(phi/2 + 1) + omegaX + omegaY)^2 ...
       + p^2 * (phi^2/2 + 1) + 2*p*phi*omegaX) / 6;
c(4) = a0 * R^8 * ((p*(phi/2 + 1) + omegaX + omegaY)^3 ...
       + 3 * (p*(phi/2+1) + omegaX + omegaY)*(p^2*(phi^2/2+1) + 2*p*phi*omegaX) ...
       + 2 * (p^3*(phi^3/2 + 1) + 3*p^2*phi^2*omegaX)) / 144;

for k = 1:N-4
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

%% Algorithm 2
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
