C_B = [30.5819 -30.829;
        -30.829 31.2692];
dX_min = -50;
dX_max = 50;
dY_min = -50;
dY_max = 50;

Nsteps = 500;

dX = linspace(dX_min, dX_max, Nsteps);
dY = linspace(dY_min, dY_max, Nsteps);
P = zeros(Nsteps, Nsteps);

for i = 1:Nsteps
    for j = 1:Nsteps
        P(i,j) = (1/(2*pi*sqrt(det(C_B))))*exp(-0.5*[dX(1,i) dY(1,j)]*inv(C_B)*[dX(1,i);dY(1,j)]);
    end
end

[dX, dY] = meshgrid(dX, dY);
surf(dX, dY, P)

dr_tca = [49.65; 0];
Rc = 0.11;
x = linspace(dr_tca(1,1)-Rc,dr_tca(1,1) + Rc,500);
y = linspace(dr_tca(2,1)-Rc,dr_tca(2,1) + Rc,500);
P_c = trapz(y, trapz(x, P, 2))