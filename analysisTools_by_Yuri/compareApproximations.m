function compareApproximations
% this function demonstrates the accuracy of a polynomial approximation 
% of a function f(x) = Ln(x) - \Psi(1/2+x) which describes the quantum
% correction to the 2D conductance in Hikami-Larkin-Nagaoka theory
  ymin = 1e-6;
  ymax = 5.0;
  numOfPoints = 100;  
  y = linspace(ymin, ymax, numOfPoints);
  
  f = @(x) HLN(1/x);
  z = arrayfun(f, y);  
  plot(y, z, 'o');
  hold on;
  f = @(x) HLN6(1/x);
  zz = arrayfun(f, y);  
  plot(y, zz, 'color', 'red', 'linewidth', 4);
  hold on;
  set(gca(), 'FontSize', 24, 'LineWidth',2,'TickLength',[0.025 0.025]);
  title('Accuracy of Polynomial approximation');
  xlabel(gca(), 'B/Bphi');
  ylabel(gca(), 'f vs Polynomial');
end

function y = HLN6(x)
% 6th degree polynomial approximation of the HLN function at small fieds
  y = -1/24/x^2 + 7/960/x^4-31/8064/x^6;% + 127/30720/x^8-511/67584/x^10;
end