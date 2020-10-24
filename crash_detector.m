function crash = crash_detector(satellite_states, debris_states)

global exclusion_radius

sat_x = satellite_states(:, 1);
sat_y = satellite_states(:, 2);
sat_z = satellite_states(:, 3);

deb_x = debris_states(:, 1);
deb_y = debris_states(:, 2);
deb_z = debris_states(:, 3);

distance_between = zeros(length(sat_x), 1); % creates array of zeros, increased efficiency as the array doesnt need to change size each time
crash = ["Time step of incident" "Distance between objects"];

for i = 1:length(sat_x)
    distance_between(i) = sqrt((sat_x(i)-deb_x(i))^2 + (sat_y(i)-deb_y(i))^2 + (sat_z(i)-deb_z(i))^2); % calculates the distance between the centres of the satellite and the debris
    
    if distance_between(i) <= exclusion_radius % if that distance is less than a given tolerance...
        crash = [crash; i, distance_between(i)]; % save the time when this happened and the distance between the two
    else
    end
end
end
