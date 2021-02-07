function crashes = posFilter(object, targets, xTolerance, yTolerance, zTolerance)
% object is the ISS for us and targets are the other things in orbit
crashes = struct;

targetNames = fieldnames(targets);

for i = 1:length(targetNames)
    targetX = targets.(targetNames{i}).x;
    targetY = targets.(targetNames{i}).y;
    targetZ = targets.(targetNames{i}).z;
    objectX = object.x;
    objectY = object.y;
    objectZ = object.z;
    crashPos = [];
    
    for j = 1:length(targetX)
        if abs(targetX(j) - objectX(j)) < xTolerance && abs(targetY(j) - objectY(j)) < yTolerance && abs(targetZ(j) - objectZ(j)) < zTolerance
            crashPos = [crashPos; j];
        else
        end
    end
    if isempty(crashPos)
        break;
    else
        crashes.(targetNames{i}) = targets.(targetNames{i})(crashPos, :);
    end
end