function bPositiveDGxx = getPositiveDGxx(bPositiveB, bPositiveRxx)
% Evaluate Delta Gxx for the positive values of B-field
  % 1. Estimate R(0)
  numOfPoints = length(bPositiveRxx);
  frac = 1/4; % fraction of all data-points to used for a fit near B = 0
  numOfFitPoints = int64(frac*numOfPoints); 
  
  if abs(bPositiveB(1)) < abs(bPositiveB(end)) 
      % low-field limit in the beginning of the vector
      rForFit = bPositiveRxx(1:numOfFitPoints);
      bForFit = bPositiveB(1:numOfFitPoints);
  else
      % low-field limit in the end of the vector. "-1" here to make the 
      % length of rForFit the same as rForFit above.
      rForFit = bPositiveRxx(end-numOfFitPoints-1:end);
      bForFit = bPositiveB(end-numOfFitPoints-1:end);
  end
  
  p = polyfit( bForFit, rForFit, 2);
  Rat0 = polyval(p, 0); % Ohm
  Gat0 = 1/Rat0; % Siemens  
  Gxx = 1./bPositiveRxx;   
  bPositiveDGxx = Gxx-Gat0;
  
  % IMPORTANT: need to check the HLN expression and units for proper 
  % scaling factor
  G0 = 7.74809173E-5; % Conductance Quantum 2e^2/h 
  bPositiveDGxx = bPositiveDGxx*2*pi/G0;
  
end