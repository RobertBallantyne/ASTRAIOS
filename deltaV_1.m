function [deltaV_1,m_fuel] = deltaV_1(orbit_velocity, orbit_radius, m_ISS, I_sp)
global mu_Earth exclusion_radius
T = (2*pi*orbit_radius+exclusion_radius)/orbit_velocity;
semi_major_axis = (mu_Earth*(T/(2*pi))^2)^(1/3);
r_a = 2*semi_major_axis-orbit_radius;
e = (r_a-orbit_radius)/(r_a+orbit_radius);
v_p = sqrt((mu_Earth/semi_major_axis)*(1-e)/(1+e));
deltaV_1 = abs(v_p - orbit_velocity);
m_fuel = m_ISS*(1-exp(-deltaV_1/(0.89*9.81*I_sp)));
end

