function [cleanX, cleanY] = purgeRepeats(x,y)
% this function removes the repeating data from y vector
% This is to process measurements that were done at the same 
% magnetic field, but different temperatures, for example.
% TODO: purge properly, taking into account the temperature at 
% which the measurements was done and removing the unnecessary points
% Idea: make triples (B, Rxx, T) and sort them, then remove repeating 
% keeping only the ones with the lowest T.
    n = length(x);
    cleanX = x;
    cleanY = y;
    for i = 2:n
        if cleanX(i) == cleanX(i-1)
            cleanY(i) = cleanY(i-1);
        end
    end    
end
