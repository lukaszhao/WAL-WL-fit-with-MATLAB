function y = HLN(x)  
  y = log(abs(x)) - psi(abs(x)+1/2);
end