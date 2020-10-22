function state_out = propagate(state_in, times, tolerance)

set = odeset('reltol',tolerance, 'abstol',tolerance);

[t, y] = ode113(@force_model, times, state_in, set); % integral, 113 is usually best for orbit propagations although doesnt make a huge amount of difference

state_out = y;
end