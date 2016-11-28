function [b, temp, r, rH] = selectLowTemperature(handles)
% This function analyzes the input data and selects only the data
% corresponding to the lowest temperature of the sample
    bFieldData = handles.bFieldData;
    tData = handles.tData;
    rData = handles.rData;
    rHallData = handles.rHallData;    
    
    lowestT = 2.0;
    % sometimes the data is corrupt and the lowest temperatures is ZERO
    % working around: Finding the first minimum non-zero temperature
    tSorted = sort(tData);
    for i = reshape(tSorted, [1, numel(tSorted)])
        if i > 0
            lowestT = i;
            break;
        end
    end
    % how many data points at this temperature?
    numOfPoints = 0;
    n = length(tData);
    tol = 1E-2;
    for i = 1:n            
            if abs(tData(i) - lowestT) <= tol*lowestT
                numOfPoints = numOfPoints + 1;
            end
    end
    % pre-allocating
    b = zeros(numOfPoints, 1);    
    r = zeros(numOfPoints, 1);
    rH = zeros(numOfPoints, 1);
    j = 1;
    for i = 1:n            
            if abs(tData(i) - lowestT) <= tol*lowestT
                b(j) = bFieldData(i);                
                r(j) = rData(i);
                rH(j) = rHallData(i);
                j = j + 1;
            end
    end
    temp = lowestT;
end