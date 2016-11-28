function [negativeB, y] = getNegativeData(bData, x)
% select only the Negative field sweep from the full low-B data
  numOfPoints = length(bData);
  numOfNegatives = 0;
  
  for i = 1:numOfPoints
    if bData(i) < 0
      numOfNegatives = numOfNegatives + 1;
    end
  end
  
  negativeB = zeros(numOfNegatives, 1);
  y = zeros(numOfNegatives, 1);
  
  j = 1;  
  for i = 1:numOfPoints
    if bData(i) < 0
      negativeB(j) = bData(i);
      y(j) = x(i);
      j = j + 1;
    end
  end  
end