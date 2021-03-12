function crashPos = posFilter(object, target, objectCovs, targetCovs, toleranceV, toleranceUW)
% object is the ISS for us and targets are the other things in orbit

objectStates = object(:, 2:7);
targetStates = target(:, 2:7);
times = object.t;
crashPos = [];
Rcomb = 0.2;
for i = 1:height(objectStates)
    objectState = table2array(objectStates(i, :));
    targetState = table2array(targetStates(i, :));
    
    if norm(objectState(1:3) - targetState(1:3)) < sqrt(toleranceV^2 + 2*toleranceUW^2)
        [Ut, Vt, Wt] = orc(objectState);
        
        R = [Ut; Vt; Wt];
        
        tcaUVW = R*targetState(1:3)' - R*objectState(1:3)';
        
        if abs(tcaUVW(1))<toleranceUW && abs(tcaUVW(3))<toleranceUW && abs(tcaUVW(2))<toleranceV
            TimeDays = times(i) / 60 / 60 / 24;
            TimeBin = round(TimeDays*2);
            if TimeBin == 0
                TimeBin = 1;
            end

            objectCov = objectCovs.(strcat('bin_', num2str(TimeBin)));
            targetCov = targetCovs.(strcat('bin_', num2str(TimeBin)));

            CovUVW = objectCov + targetCov;

            CovXYZ = R \ CovUVW / R';

            v = objectState(4:6) - targetState(4:6);
            r0 = objectState(1:3) - targetState(1:3);

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
            
            tolerance = 1E-7;
            
            if serraAlgorithm1(varX, varY, xm, ym, Rcomb, 10) > 0
                Probability = serraAlgorithm2(varX, varY, xm, ym, Rcomb, tolerance);
            else
                Probability = 0;
            end

            if Probability > 0
                crashPos = [crashPos; i targetState Probability];
            else
            end
        end
    end
end
end