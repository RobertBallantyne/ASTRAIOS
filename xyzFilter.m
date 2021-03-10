function crashes = xyzFilter(object, targets, xTolerance, yTolerance, zTolerance)
% object is the ISS for us and targets are the other things in orbit
crashes = struct;
crashes.xFilter = struct;
crashes.yFilter = struct;
crashes.zFilter = struct;
targetNames = fieldnames(targets);
for i = 1:length(targetNames)
    targetX = targets.(targetNames{i}).x;
    objectX = object.x;
    crashPosX = [];
    
    for j = 1:length(targetX)
        if abs(targetX(j) - objectX(j)) < xTolerance
            crashPosX = [crashPosX; j];
        else
        end
    end
    if isempty(crashPosX)
    else
        crashes.xFilter.(targetNames{i}) = targets.(targetNames{i})(crashPosX, :);
    end
end
%%
fieldsX = fieldnames(crashes.xFilter);
for i = 1:length(fieldsX)
    targetY = crashes.xFilter.(fieldsX{i}).y;
    timeFind = logical(-ismember(object.t,crashes.xFilter.(fieldsX{i}).t) + 1);
    objectY = object;
    objectY(timeFind, :) = [];
    crashPosY = [];
    
    for j = 1:length(targetY)
        if abs(targetY(j) - objectY.y(j)) < yTolerance
            crashPosY = [crashPosY; j];
        else
        end
    end
    if isempty(crashPosY)
    else
        crashes.yFilter.(fieldsX{i}) = crashes.xFilter.(fieldsX{i})(crashPosY, :);
    end
end  
%%
fieldsY = fieldnames(crashes.yFilter);
for i = 1:length(fieldsY)
    targetZ = crashes.yFilter.(fieldsY{i}).z;
    timeFind2 = logical(-ismember(object.t,crashes.yFilter.(fieldsY{i}).t) + 1);
    objectZ = object;
    objectZ(timeFind2, :) = [];
    crashPosZ = [];
    
    for j = 1:length(targetZ)
        if abs(targetZ(j) - objectZ.z(j)) < zTolerance
            crashPosZ = [crashPosZ; j];
        else
        end
    end
    if isempty(crashPosZ)
    else
        crashes.zFilter.(fieldsY{i}) = crashes.yFilter.(fieldsY{i})(crashPosZ, :);
    end
end  