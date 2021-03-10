function [position]=plot_kep2d(eccentricity, semi_major_axis)

Evals = 0:0.1:360;
pvals = semi_major_axis*(cosd(Evals)-eccentricity); % [m] orbit positions
qvals = semi_major_axis*sqrt(1 - eccentricity^2)*sind(Evals); % [m] orbit positions
position = [pvals; qvals];
end

