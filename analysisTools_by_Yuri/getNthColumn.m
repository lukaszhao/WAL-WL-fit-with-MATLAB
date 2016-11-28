function dataColumn = getNthColumn( columnNumber, rawData )
% Extract the numbers from the cell 2D array of raw data
% The data column "columnNumber" is extracted

% Need to handle invalid columnNumber (like 0 for missing columns?)

numOfMeasurements = length(rawData);
dataColumn = zeros(numOfMeasurements, 1);

if columnNumber ~= 0
    matrixData = cell2mat(rawData);    
    for i = 1:numOfMeasurements
        dataColumn(i) = matrixData(i, columnNumber);
    end
end

end