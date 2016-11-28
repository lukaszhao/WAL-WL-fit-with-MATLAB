function repeatValues = detectRepeats( x )
% detectRepeats analyzes a vector x and creates a vector of 
% values that repeat in x.    
    unq = unique(x);
    
    n = length(x);
    m = length(unq);
    
    haveRepeats = n > m;
    
    if haveRepeats
        repeatCounts = zeros( m, 1 );        
        for i = 1:m
            for j = 1:n
                if unq(i) == x(j)
                    repeatCounts(i) = repeatCounts(i) + 1;
                end
            end
        end        
        repeatIdx = find(repeatCounts-1);
        k = length(repeatIdx);
        repeatValues = zeros(k, 1);
        for i = 1:k
            repeatValues(i) = unq(repeatIdx(i));
        end
    else
        repeatValues = zeros(0,0);
    end
    
    
    
end
