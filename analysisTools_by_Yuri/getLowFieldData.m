function [lowB, lowDGxx, lowDGxy] = getLowFieldData(handles)
% Extract the conductance tensor for the low magnetic field measurements
% Also return the low magnetic field values as a vector "lowB"
[lowB, lowRxx, lowRxy] = selectLowFieldData(handles);
[lowGxx, lowGxy] = calculateConductance(lowRxx, lowRxy);
[lowDGxx, lowDGxy] = calculateDG(lowB, lowGxx, lowGxy);
end