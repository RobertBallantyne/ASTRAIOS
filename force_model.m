function dydt = force_model(t, state)

x = state(1);
y = state(2);
z = state(3);

u = state(4);
v = state(5);
w = state(6);

g = gravity(x, y, z);

p = perturbation_code(x, y, z, u, v, w, t);

ax = g(1) + p(1);
ay = g(2) + p(2);
az = g(3) + p(3);

dydt = [u; v; w; ax; ay; az];
end