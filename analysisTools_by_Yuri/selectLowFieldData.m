function [lowBDataB, lowBDataRxx, lowBDataRxy] = selectLowFieldData(handles)  
  % maximum field to use for analysis. Allows focusing on low-field limit 
  % and disregard the background magnetoresistance, if necessary
  Bmax = handles.Bmax;
  hDataB = handles.bFieldData;
  rData = handles.rData;
  rHallData = handles.rHallData;
  
  % determine how many data points satisfy the criterion B < Bmax
  numOfLowBs = 0;
  numOfPoints = length(hDataB);
  for i = 1:numOfPoints
    if (abs(hDataB(i)) < Bmax) &&  (abs(hDataB(i)) ~= 0)
      numOfLowBs = numOfLowBs + 1;
    end
  end
  % pre-allocating
  lowBDataRxx = zeros(numOfLowBs, 1);
  lowBDataRxy = zeros(numOfLowBs, 1);
  lowBDataB = zeros(numOfLowBs, 1);
  j = 1;
  % select low-B values only, disregarding B = 0
  for i = 1:numOfPoints
    if (abs(hDataB(i)) < Bmax) &&  (abs(hDataB(i)) ~= 0)
      lowBDataRxx(j) = rData(i);
      lowBDataRxy(j) = rHallData(i);
      lowBDataB(j) = hDataB(i);
      j = j + 1;
    end
  end  
end