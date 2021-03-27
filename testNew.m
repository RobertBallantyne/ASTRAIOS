state1 = [174.104265848202,-5076.37797938112,-4524.93532529571,6.25904000194725,3.04267565150098,-3.17875781100347];
state2 = [173.104265848202,-5076.37797938112,-4524.93532529571,7.534218805354479,-0.732793539852374,1.111988627739440];{26015.3843716567} 
state2EndPos = [259.838747565009,2478.68646725670,-6313.89485387367,0.898443220917406,-7.08789479623382,-2.75564229706531];
CUVW = [0.026034722771238,0.919757052661740,0.103178001119845;0.919757052661740,8.460791658758010e+02,1.349542213083240;0.103178001119845,1.349542213083240,0.748577205721093];

state1Pos = state1(1:3);
state2Pos = state2(1:3);

r0 = state2Pos - state1Pos;

state1Vel = state1(4:6);
state2Vel = state2(4:6);


[Ut, Vt, Wt] = orc(state1);
        
R = [Ut; Vt; Wt];
CovXYZ = R \ CUVW / R';

state2Vel2 = R \ [norm(state1Vel)/sqrt(2); 0; norm(state1Vel)/sqrt(2)];

endEpoch = 2.247436276436690e+09;
startEpoch = 2.247298584160032e+09;

steps2 = (endEpoch - startEpoch) / 10;

t = linspace(startEpoch, endEpoch, steps2);

%debrisTest2 = propagateState(state2EndPos, t, 1E-8);
v = state2Vel - state1Vel;

ez = v / norm(v);
ey = cross(v, r0) / norm(cross(v, r0));
ex = cross(ey, ez);

rmBar = [ex;ey;ez] * r0';

Ce = [ex;ey] * CovXYZ * [ex;ey]';

[vect, ~] = eig(Ce);

varX = max(eig(Ce));
varY = min(eig(Ce));

theta = acos(dot(vect(:, 1), [1; 0]));

xm = rmBar(1) * cos(theta);
ym = -rmBar(1) * sin(theta);
tolerance = 1E-8;
Rcomb = 0.2;
ihope = serraAlgorithm2(varX, varY, xm, ym, Rcomb, 1E-5);