function cuspFromRawData()
  
  clear;
  % asking user to point to the data file
  dialogString = 'Select a data file:';
  [dataFileName, pathToFile, ~] = uigetfile('*', dialogString);
  fullPathName = [pathToFile dataFileName];
  [columnHeaders, rawData] = loadRawData(fullPathName);
  
  hFieldHeader =  'H(Oe)';
  rHeader = 'R(Ohm)';
 
  hFieldColumnNumber = locateColumn(hFieldHeader, columnHeaders);
  rColumnNumber = locateColumn(rHeader, columnHeaders);
  
  % 1E-4 factor to convert into Tesla, SI units
  hFieldData = 1E-4*getNthColumn( hFieldColumnNumber, rawData );
  rData = getNthColumn( rColumnNumber, rawData );
  % Plotting the full data
  %detectRepeats(hFieldData)
  [hFieldData, rData] = purgeRepeats(hFieldData, rData);
  rData = correctOutliers(rData);
  
  [positiveB, positiveRxx] = getPositiveData(hFieldData, rData);
  [negativeB, negativeRxx] = getNegativeData(hFieldData, rData);  
  figure;
  plot(positiveB, positiveRxx, 'ro');
  hold on;
  plot(negativeB, negativeRxx, 'bo');
  
  
  if 1%detectCusp(hFieldData, rData)
    waitbar(1.0, 'Found Cusp in Raw Data!');
    Bmax = max(abs(hFieldData))/5;
  
    [lowBDataB, lowBDataRxx ] = selectLowFieldData(hFieldData, rData, Bmax);
    
    [bPositiveB, bPositiveRxx] = getPositiveData(lowBDataB, lowBDataRxx);
    bPositiveDGxx = getPositiveDGxx(bPositiveB, bPositiveRxx);
    [alphaPositive, bPhiPositive] = estimateAlphaBphi(bPositiveB, bPositiveDGxx);
    
    %[bNegativeB, bNegativeRxx] = getNegativeData(lowBDataB, lowBDataRxx);  
%    figure;
%    % Smoothing the data with polynomial fit
%     p = polyfit(bPositiveB, bPositiveRxx, 4);
%     plot(bPositiveB, bPositiveRxx, 'o');
%     hold on;
%     plot(bPositiveB, polyval(p, bPositiveB));
%     bPositiveRxx = polyval(p, bPositiveB);
      
    % dimensionless conductance 2*pi*G/G0
       
    %plot(bPositiveB, bPositiveDGxx, 'o');
    
    % estimate initial values of alpha and Bphi from low-field 
    % using polynomial approximation
    
    
    % trying non-linear least square. WARNING: Octave is not good for this,
    % Use Matlab
  %  tolerance = 0.001;
  %  niterations = 20;
  %  weights = ones (size (bPositiveDGxx'));%1./sqrt(abs(bPositiveDGxx));
  %  [f, p, cvg, iter, corp, covp, covr, stdresid, Z, r2] = leasqr(bPositiveB', bPositiveDGxx', [alphaPositive; bPhiPositive], @HLNFit, tolerance, niterations, weights);
    F = @(params, xdata) params(1)*HLN(params(2)*1./xdata);
    [x,resnorm,~,exitflag,output] = lsqcurvefit(F, [alphaPositive bPhiPositive], bPositiveB, bPositiveDGxx);
    
    alpha = x(1)
    bPhi = x(2)
    DGxx = F([alpha bPhi], bPositiveB);
    
    figure;
    plot(bPositiveB, bPositiveDGxx, 'bo');
    hold on;
    plot(bPositiveB, DGxx, 'r-');
    % my work-around.  
    %fitPhi(bPositiveB, bPositiveDGxx, bPhiPositive)
    %hist(bPhis);
  else
    waitbar(1.0, 'No cusp found! Sorry...');
  end  
end

function y = HLNFit(x, p)
 alpha = p(1);
 Bphi = p(2);
 %f = @(z) alpha*HLN(Bphi/z);
 %y = arrayfun(f, x);  
 %y = alpha*HLN(Bphi/x);
 y = alpha*HLN(Bphi*1./x);
end

