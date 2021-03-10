function Pc = MonteCarlo(state1, state2, cov1, cov2)
  
Cov = cov1 + cov2;

[Umat, Vmat, Wmat] = orc(state1);

R = [Umat; Vmat; Wmat];

state1UVW = R * state1(1:3)';
state2UVW = R * state2(1:3)';

% ISSUVW(3) = ISSUVW(3) + 40;
% ISSUVW(1) = ISSUVW(1) + 27;
rTCA = state1UVW - state2UVW;

samples = 100000000;

mu = state1UVW;

r = mvnrnd(rTCA, Cov, samples);

collision = zeros(1, samples);
for i = 1:length(r)
    if abs(r(i, 1)) < 10 && abs(r(i, 2)) < 10 && abs(r(i, 3)) < 10
        collision(i) = 1;
    end
end

total = sum(collision);

Pc = total / samples;