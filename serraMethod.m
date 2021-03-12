%%  Serra method
stateP = [5.411976700798020e+03,3.773578054795260e+03,1.636651387824370e+03,-1.636943096298460,4.827290046272320,-5.714721893939820];
stateS = [5.413976700798020e+03,3.775578054795260e+03,1.639651387824370e+03,1.336943096298460,2.727290046272320,4.214721893939820];
CUVW = [0.026034722771238,0.919757052661740,0.103178001119845;0.919757052661740,8.460791658758010e+02,1.349542213083240;0.103178001119845,1.349542213083240,0.748577205721093];
tolerance = 1E-5;

[Ut, Vt, Wt] = orc(stateP);
        
R = [Ut; Vt; Wt];

C = R \ CUVW / R';

rp = stateP(1:3);
vp = stateP(4:6);

rs = stateS(1:3);
vs = stateS(4:6);

v = vs - vp;
r0 = rs - rp;

ez = v / norm(v);
ey = cross(v, r0) / norm(cross(v, r0));
ex = cross(ey, ez);


%% PLotting

figure 
hold on
view(3)

scatter3(stateP(1), stateP(2), stateP(3));
scatter3(stateS(1), stateS(2), stateS(3));

plot3([stateP(1), stateP(1) + 3*ex(1)], [stateP(2), stateP(2) + 3*ex(2)], [stateP(3), stateP(3) + 3*ex(3)])
plot3([stateP(1), stateP(1) + 3*ey(1)], [stateP(2), stateP(2) + 3*ey(2)], [stateP(3), stateP(3) + 3*ey(3)])
plot3([stateP(1), stateP(1) + 3*ez(1)], [stateP(2), stateP(2) + 3*ez(2)], [stateP(3), stateP(3) + 3*ez(3)])

%% Projecting onto the axes
projX = dot(r0, ex) * ex + rp;
projZ = dot(r0, ez) * ez + rp;

scatter3(projX(1), projX(2), projX(3));
scatter3(projZ(1), projZ(2), projZ(3));


%%

rmBar = [ex;ey;ez] * r0';

Ce = [ex;ey] * C * [ex;ey]';

varXbar = Ce(1, 1);
varYbar = Ce(2, 2);

[vect, ~] = eig(Ce);

varX = max(eig(Ce));
varY = min(eig(Ce));

theta = acos(dot(vect(:, 1), [1; 0]));

xm = rmBar(1) * cos(theta);
ym = -rmBar(1) * sin(theta);

Rad = 1;

Pc = serraAlgorithm2(varX, varY, xm, ym, Rad, tolerance);


%% Algorithms
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
