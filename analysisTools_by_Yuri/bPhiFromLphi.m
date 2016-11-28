function bPhi = bPhiFromLphi( lPhi )
% Calculate the field in Tesla (!) from the length in nanometers (!)
    k = 164.5530;
    bPhi = k/lPhi^2;
end