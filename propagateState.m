function tableOut = propagateState(state_in, times, tolerance)

set = odeset('reltol',tolerance, 'abstol',tolerance);

[t, y] = ode113(@force_model, times, state_in); % integral, 113 is usually best for orbit propagations although doesnt make a huge amount of difference

tableOut = array2table([t y], 'VariableNames', {'t', 'x', 'y', 'z', 'u', 'v', 'w'});

end