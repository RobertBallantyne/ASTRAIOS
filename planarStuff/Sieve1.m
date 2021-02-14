function check = Sieve1(object_elements, tolerance) 
%target is iss, object is debris
global ISS ISS_plane

% if ISS(9) > object_elements(7) || ISS(8) < object_elements(8)
    object_points = plot_kep3d(object_elements(3), object_elements(4), object_elements(9), object_elements(10), object_elements(12));
    syms y
    object_plane = planefit(object_points);
    intersection = solve(ISS_plane, object_plane);
    
end

