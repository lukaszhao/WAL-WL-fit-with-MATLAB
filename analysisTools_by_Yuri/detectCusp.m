function y = detectCusp( B, Rxx)
% The function analyzes the experimental data and guesses if there is a
% cusp in magneto-resistance
  y = 0;
  
  [positiveB, positiveRxx] = getPositiveData(B, Rxx);
  noise = estimateNoise(positiveB, positiveRxx);
  
  n = length(positiveB);
  f = 1/4; % fraction of data-points to use at the ends of the curves
  m = int64(n*f);
  
  pBeginning = polyfit(positiveB(1:m), positiveRxx(1:m), 4);
  pEnd = polyfit(positiveB(m:n), positiveRxx(m:n), 4);
  
  % demonstrating the difference in fitting using the end and the beginning of
  % the data
 figure;
 plot(positiveB(1:m), positiveRxx(1:m), 'o');
 hold on;
 dGBegin = polyval(pBeginning, positiveB);
 plot(positiveB(1:m), dGBegin(1:m), 'color', 'red', 'linewidth', 2);
 hold on;
 dGEnd = polyval(pEnd, positiveB);
 plot(positiveB(1:m), dGEnd(1:m), 'color', 'green', 'linewidth', 2);
 delta = dGBegin(1) - dGEnd;
  
  % if the difference due to the fits in the end and beginning of the data is 
  % greater than 3*sigma of the noise then we say that there is a cusp
  if abs(delta) > noise
    y = 1;
  end  
end