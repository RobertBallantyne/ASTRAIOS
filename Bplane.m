function [X_B Y_B] = Bplane(dr_tca, dv_tca)
%B-plane conversion
x = dr_tca(1);
y = dr_tca(2);
z = dr_tca(3);
vx = dv_tca(1);
vy = dv_tca(2);
vz = dv_tca(3);

drtca = [ x y z ];
dvtca = [ vx vy vz ];

X_B = drtca/norm(drtca);
Y_B = cross(drtca,dvtca)/norm(cross(drtca, dvtca));

