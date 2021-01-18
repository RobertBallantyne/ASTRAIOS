function dydt = force_model(t, state)

x = state(1);
y = state(2);
z = state(3);

u = state(4);
v = state(5);
w = state(6);

g = gravity(x, y, z);

p = perturbations(x, y, z, u, v, w);

ax = g(1);
ay = g(2);
az = g(3);

dydt = [u; v; w; ax; ay; az];
end