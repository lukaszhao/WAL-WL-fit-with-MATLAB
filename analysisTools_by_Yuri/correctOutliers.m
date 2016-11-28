function y = correctOutliers(x)
% The function scans the data in x and detects whether any 
% value jumps suddently far away from the expected value.
% That is, the spurious spikes in data is detected and removed
    n = length(x);
    dxs = zeros(1, n-1);
    y = x;
    % estimating average "increase" between two adjacent points
    for i = 2:n
        dxs(i-1) = abs( x(i) - x(i-1) );
    end
    dxAvg = mean(dxs);
    threshold = 2.0;
    
    for i = 2:(n-1)
        if (abs(x(i)-x(i-1)) > threshold*dxAvg) && (abs(x(i+1)-x(i)) > threshold*dxAvg)
            y(i) = ( x(i-1)+x(i+1) )/2;
        end
    end
end