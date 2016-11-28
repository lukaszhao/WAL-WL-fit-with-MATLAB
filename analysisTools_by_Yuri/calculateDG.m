function [dataDGxx, dataDGxy] = calculateDG(dataB, dataGxx, dataGxy)
% Evaluate the correction to conductance due to the magnetic field
% We first evaluate the zero-field conductance and then subtract it from 
% the data

% attempting to find where the minimum of the field is
bMin = min(abs(dataB));
idxMin = find(abs(dataB) == bMin);
% how many points around the "zero field" to consider
fraction = 1/8;
numOfPoints = ceil( fraction*length(dataB) );
if numOfPoints > 10
    numOfPoints = 10;
end
range = (idxMin-numOfPoints):(idxMin+numOfPoints);
x = dataB(range);
y = dataGxx(range);
z = dataGxy(range);

% approximating the data with polynomial and finding the interpolated
% zero-field value of conductances
pDegree = 2;
p = polyfit(x, y, pDegree);
GxxAt0 = polyval(p, 0);
dataDGxx = dataGxx - GxxAt0;

p = polyfit(x, z, pDegree);
GxyAt0 = polyval(p, 0);
dataDGxy = dataGxy - GxyAt0;

% Finally, normalizing to G0/2/pi -- reduced conductace quantum
% IMPORTANT: need to check the HLN expression and units for proper 
% scaling factor. Feb 18: Last time I checked it looks OK
G0 = 7.74809173E-5; % Conductance Quantum 2e^2/h
dataDGxx = dataDGxx*2*pi/G0;
dataDGxy = dataDGxy*2*pi/G0;

end