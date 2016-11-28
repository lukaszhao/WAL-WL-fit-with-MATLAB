function y = estimateNoise( B, Rxx)
  % Smoothing the data with polynomial fit
  p = polyfit(B, Rxx, 4);
  smoothRxx = polyval(p, B);
  y = std( Rxx - smoothRxx );
  % comparing the fit to the data
%  figure;
%  plot(B, Rxx, 'o');
%  hold on;
%  plot(B, smoothRxx, 'color', 'red', 'linewidth', 2);  
end