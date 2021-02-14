function [position_r]=plot_kep3d(inclination, eccentricity, RAAN, arg_of_perigee, semi_major_axis)

Evals = 0:0.1:360;

pvals2 = semi_major_axis*(cosd(Evals)-eccentricity); % [m] orbit positions
qvals2 = semi_major_axis*sqrt(1 - eccentricity^2)*sind(Evals); % [m] orbit positions

position = zeros(3, length(pvals2));
position(1, :) = pvals2;
position(2, :) = qvals2;

%alpha is rotation around z raan
%beta is rotation around y arg of periapsis
%gamma is rotation around x inclination
alpha = RAAN;
beta = arg_of_perigee;
gamma = inclination;

rotation_matrix = [
    [cosd(alpha)*cosd(beta) cosd(alpha)*sind(beta)*sind(gamma)-sind(alpha)*cosd(gamma) cosd(alpha)*sind(beta)*cosd(gamma)+sind(alpha)*sind(gamma)],
    [sind(alpha)*cosd(beta) sind(alpha)*sind(beta)*sind(gamma)+cosd(alpha)*cosd(gamma) sind(alpha)*sind(beta)*cosd(gamma)-cosd(beta)*sind(gamma)],
    [-sind(beta)            cosd(beta)*sind(gamma)                                     cosd(beta)*cosd(gamma)]
    ];

position_r = rotation_matrix * position;
end