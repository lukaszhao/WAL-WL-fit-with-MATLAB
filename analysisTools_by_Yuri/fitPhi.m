function bPhi = fitPhi(bPositiveB, bPositiveDGxx, bPhiPositive)
  n = length(bPositiveB);  
  bPhis = -ones(n*(n-1)/2, 1);
  k = 1;
  for i = 1:(n-1)
    x1 = bPositiveB(i);
    y1 = bPositiveDGxx(i);
    for j = (i+1):n
      x2 = bPositiveB(j);
      y2 = bPositiveDGxx(j);  
      f = @(x) forB(x1, y1, x2, y2, x);
      try
        [x, fval, info, output] = fzero(f, [1e-3*bPhiPositive; 10*bPhiPositive]);        
        bPhis(k) = x;
        k = k + 1;
      end      
    end    
  end
  bPhis = getAllPositives(bPhis);
  bPhi = mean(bPhis);
end

function y = forB(x1, y1, x2, y2, B)
  y = HLN(B/x1)/HLN(B/x2) - y1/y2;
end