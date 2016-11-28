function Rxx = correctVdP(R1, R2)
% Function calculates the corrected longitudinal resistance Rxx
% given the data from two channels in VdP measurements, R1 and R2.
    n = length(R1);
    m = length(R1);
    if m == n        
        Rxx = zeros(m, 1);
        for i = 1:m
            if R1(i)*R2(i) == 0
                display('ERROR: Zero Resistance Encountered. Check your data file!');
            end
            if R1(i) >= R2(i)
                k = R1(i)/R2(i);
            else
                k = R2(i)/R1(i);
            end
            f = 1+0.0323772171*k-0.0403767815*k*k+0.0085788146*(k^3)-0.0007769267*(k^4)+0.0000260362*(k^5);
            Rxx(i) = 3.141592654*(R1(i)+R2(i))*f/(log(2))/2;
        end        
    else
        Rxx = zeros(n, 1);
        display('ERROR: R1 and R2 must have the same length');
    end    
end