function [alpha, bPhi] = estimateAlphaBphi(handles, side)
% Find the initial values for the parameters in Hikami-Larkin-Nagaoka model
% alpha is the 1/2 of the number of conductance channels
% Bphi is the coherenece field
  
  % Here we use a polynomial approximation for the quantum correction
  % The approximation is valid for very low fields and looks like
  % 2pi G/G0 = -alpha B^2/(24 Bphi^2)+ 7alpha B^4/(960 Bphi^4)
  if strcmp(side, 'positive')
      B = handles.positiveB;
      DG = handles.positiveDG;
  end
  if strcmp(side, 'negative')
      B = handles.negativeB;
      DG = handles.negativeDG;
  end
  
  b2 = arrayfun(@(x) x^2, B);
  
  % G vs B^2 is a second degree polynomial near B = 0
  p = polyfit( b2, DG, 2);
  
  C1 = p(2);
  C2 = p(1);  
  
  alpha = 21*C1^2/C2;
  if alpha > 10 % capping alpha to "reasonable" value
    alpha = 10;
  end
  bPhi = sqrt(-7*C1/40/C2);
  
  % comparing fit and experimental data  
  %g2 = arrayfun( @(x) C1*x^2 + C2*x^4, bPositiveB);
  %plot(bPositiveB, bPositiveDGxx, 'o');
  %hold on;
  %plot(bPositiveB, g2, 'color', 'red');
  
end