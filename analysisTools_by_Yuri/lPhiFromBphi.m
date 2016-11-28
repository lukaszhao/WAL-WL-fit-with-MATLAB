function lPhi = lPhiFromBphi( bPhi )
% Calculate the length in nanometers (!) from the field in Tesla (!)
    k = 164.5530;
    lPhi = sqrt( k/bPhi );
end