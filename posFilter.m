function crashPos = posFilter(object, target, objectCovs, targetCovs, toleranceV, toleranceUW)
% object is the ISS for us and targets are the other things in orbit

objectStates = object(:, 2:7);
targetStates = target(:, 2:7);
times = object.t;
crashPos = [];
for i = 1:height(objectStates)
    objectState = table2array(objectStates(i, :));
    targetState = table2array(targetStates(i, :));
    
    if norm(objectState(1:3) - targetState(1:3)) < toleranceV + toleranceUW
        [Ut, Vt, Wt] = orc(objectState);
        
        R = [Ut; Vt; Wt];
        
        objectStateUVW = R * objectState(1:3)';
        targetStateUVW = R * targetState(1:3)';
        
        tcaUVW = targetStateUVW - objectStateUVW;
        
        if abs(tcaUVW(1)) < toleranceUW && abs(tcaUVW(2)) < toleranceV && abs(tcaUVW(3)) < toleranceUW
            TimeDays = times(i) / 60 / 60 / 24;
            TimeDaysRounded = round(TimeDays*2);
            if TimeDaysRounded == 0
                TimeDaysRounded = 1;
            end
            objectCov = objectCovs.(strcat('bin_', num2str(TimeDaysRounded)));
            targetCov = targetCovs.(strcat('bin_', num2str(TimeDaysRounded)));
            CovUVW = objectCov + targetCov;

            Probability = SinglePos(tcaUVW, CovUVW);

            if Probability > 0
                crashPos = [crashPos; i targetState Probability];
            else
            end
        end
    end
end
end