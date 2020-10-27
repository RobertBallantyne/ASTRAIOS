function dydt = force_model(t, state)

x = state(1);
y = state(2);
z = state(3);

vx = state(4);
vy = state(5);
vz = state(6);

g = gravity(x, y, z);

ax = g(1);
ay = g(2);
az = g(3);

dydt = [vx; vy; vz; ax; ay; az];
end