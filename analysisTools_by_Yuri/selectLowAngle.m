function [b, t, r, rH, angle] = selectLowAngle(handles)
% This function analyzes the full raw data and selects only the data
% corresponding to the smallest rotator angle (if any)
    bFieldData = handles.bFieldData;
    tData = handles.tData;
    rData = handles.rData;
    rHallData = handles.rHallData;
    angleData = handles.angleData;
    
    lowestAngle = min(angleData);    
    % how many data points at this angle?
    numOfPoints = 0;
    n = length(angleData);
    tol = 1E-2;
    for i = 1:n            
            if abs(angleData(i) - lowestAngle) <= tol*lowestAngle
                numOfPoints = numOfPoints + 1;
            end
    end
    % pre-allocating
    b = zeros(numOfPoints, 1);
    t = zeros(numOfPoints, 1);
    r = zeros(numOfPoints, 1);
    rH = zeros(numOfPoints, 1);
    j = 1;
    for i = 1:n            
            if abs(angleData(i) - lowestAngle) <= tol*lowestAngle
                b(j) = bFieldData(i);
                t(j) = tData(i);
                r(j) = rData(i);
                rH(j) = rHallData(i);
                j = j + 1;
            end
    end
    angle = lowestAngle;
end