function [bPositiveB, y] = getPositiveData(bData, x)
% select only the positive field sweep from the full low-B data
  numOfPoints = length(bData);
  numOfPositives = 0;
  
  for i = 1:numOfPoints
    if bData(i) > 0
      numOfPositives = numOfPositives + 1;
    end
  end
  
  bPositiveB = zeros(numOfPositives, 1);
  y = zeros(numOfPositives, 1);
  
  j = 1;  
  for i = 1:numOfPoints
    if bData(i) > 0
      bPositiveB(j) = bData(i);
      y(j) = x(i);
      j = j + 1;
    end
  end  
end