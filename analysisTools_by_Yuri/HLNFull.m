function y = HLNFull(B1, B2, B3, B)
% Normalized value of the full Hikami-Larkin-Nagaoka function
% It describes the magnetoconductance in 2DEG due to three scattering
% mechanisms: 1) regular 2) spin-orbi 3) magnetic
    x = abs(B);
    B4 = B3*(B1/B2)^2;
    % plus sign for the second term and also log terms must be present to
    % insure y(0) = 0
    y = -( psi(1/2 + B1./x) - psi(1/2 + B2./x)+1/2*psi(1/2 + B3./x) - 1/2*psi(1/2 + B4./x) );
end
% QUESTION: Why is this function non-zero at zero field?
% ANSWER: The paper by HLN (1980) has wrong expression.
% Check more recent papers!