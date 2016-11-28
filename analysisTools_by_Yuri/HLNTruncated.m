function y = HLNTruncated(alpha, Bphi, B)
    x = abs(B);
    y = alpha*( log(abs(Bphi./x)) - psi(abs(Bphi./x)+1/2) );
end