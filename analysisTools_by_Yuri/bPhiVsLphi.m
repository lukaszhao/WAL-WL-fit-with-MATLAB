function bPhiVsLphi
  Hp = 6.62607004E-34;% J*s, is the original Planck Constant
  Hbar =Hp/2/pi; % J*s, is the reduced Planck Constant
  Ec = 1.60217657E-19; % C, is the magnitude of the electron charge
  
  lPhiMin = 5.0; # coherence length in nanometers
  lPhiMax = 100.0;
  numOfPoints = 2000;
  
  lPhi = linspace( lPhiMin, lPhiMax, numOfPoints );
  f = @(x) 1e18*Hbar/4/Ec/x^2;
  bPhi = arrayfun(f, lPhi);
  
  f(1)
  f(4)
  f(20)
  
  bPhiFig = figure('Name','Bphi');
  bPhiAxes = axes();
  plot(bPhiAxes, lPhi, bPhi, 'linewidth', 2);
  
  set(bPhiAxes, 'FontSize', 24, 'LineWidth',2,'TickLength',[0.025 0.025]);
  title('Bphi Vs Coherence Length');
  xlabel(bPhiAxes, 'Lphi, nm');
  ylabel(bPhiAxes, 'Bphi, T');
  figure(bPhiFig);
  axes(bPhiAxes);  
  
  
end