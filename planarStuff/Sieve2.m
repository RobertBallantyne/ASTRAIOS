function results = Sieve2(target_elements, object_elements)

position_target3d = plot_kep3d(target_elements(3), target_elements(4), target_elements(9), target_elements(10), target_elements(12));
position_object3d = plot_kep3d(object_elements(3), object_elements(4), object_elements(9), object_elements(10), object_elements(12));

[~, dist] = dsearchn(position_target3d', position_object3d');
[~, index1] = min(dist);
object_close = position_object3d(:, index1);

[k2, dist2] = dsearchn(position_target3d', object_close');
target_close = position_target3d(:, k2);

target_close = target_close';
object_close = object_close';
results = [dist2 target_close object_close];