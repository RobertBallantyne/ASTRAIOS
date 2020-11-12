function results = Sieve(target_elements, object_elements) 

% 5-inclination, 6-eccentricity, 11-RAAN, 12-arg_of_percenter, 14-semi_major_axis

position_target3d = plot_kep3d(target_elements(3), target_elements(4), target_elements(9), target_elements(10), target_elements(12));
position_object3d = plot_kep3d(object_elements(3), object_elements(4), object_elements(9), object_elements(10), object_elements(12));
% Plots the orbits onto a 2d frame then rotates them appropriately
% depending on orbital elements

[~, dist1] = dsearchn(position_target3d', position_object3d');
[~, index1] = min(dist1);

object_close = position_object3d(:, index1);

[k2, dist2] = dsearchn(position_target3d', object_close');
target_close = position_target3d(:, k2);
closest = dist2;

target_close = target_close';
object_close = object_close';
results = [dist2 target_close object_close];

% figure
% 
% plot3(position_target3d(1, :), position_target3d(2, :), position_target3d(3, :))
% hold on
% plot3(position_object3d(1, :), position_object3d(2, :), position_object3d(3, :))
% scatter3(object_close(1), object_close(2), object_close(3))
% scatter3(target_close(1), target_close(2), target_close(3))
% hold off
end

