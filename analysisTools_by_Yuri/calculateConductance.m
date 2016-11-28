function [Gxx, Gxy] = calculateConductance(Rxx, Rxy)
% Invert the resistance tensor to compute longitudinal
% and Hall conductances
    n = length(Rxx);
    m = length(Rxy);
    if m == n        
        Gxx = zeros(m, 1);
        Gxy = zeros(m, 1);
        for i = 1:m
            if ( abs(Rxx(i))+abs(Rxy(i)) ) == 0
                display('ERROR: Zero Resistance Encountered. Check your data file!');
            else
                x = Rxx(i)^2+Rxy(i)^2;
                Gxx(i) = Rxx(i)/x;
                Gxy(i) = Rxy(i)/x;
            end            
        end        
    else
        Gxx = zeros(n, 1);
        Gxy = zeros(n, 1);
        display('ERROR: R1 and R2 must have the same length');
    end
end