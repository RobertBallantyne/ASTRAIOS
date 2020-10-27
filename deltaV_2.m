function [deltaV_2,m_fuel] = deltaV_2(orbit_velocity, orbit_radius, m_ISS, I_sp)
global mu_Earth exclusion_radius

r_a = orbit_radius + exclusion_radius;

a = 0.5*(r_a + orbit_radius);

e = exclusion_radius/(2*a);

v_p = sqrt((mu_Earth/a)*(1-e)/(1+e));

deltaV_2 = abs(v_p-orbit_velocity);

m_fuel = m_ISS*(1-exp(-deltaV_2/(0.89*9.81*I_sp)));
end