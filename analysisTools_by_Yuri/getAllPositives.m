function y = getAllPositives(x)
  n = length(x);
  m = 0;
  for i = 1:n
    if x(i) > 0
      m = m +1;
    end
  end
  y = zeros(m,1);
  k = 1;
  for i = 1:n
    if x(i) > 0
      y(k) = x(i);
      k = k +1;
    end
  end
end