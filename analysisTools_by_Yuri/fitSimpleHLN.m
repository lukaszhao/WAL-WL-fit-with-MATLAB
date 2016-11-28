function fitSimpleHLN(handles, side)
% Perform fit of the data on the 'side' (positive or negative) of the field
set(handles.tlStatus, 'String', 'Fitting Truncated HLN...');
set(handles.tlStatus, 'String', 'Estimating Parameters...');

[alpha, bPhi] = estimateAlphaBphi(handles, side);

set(handles.tlStatus, 'String', 'Thinking...');
F = @(params, xdata) params(1)*HLN(params(2)*1./xdata);

if strcmp(side, 'positive')
    [x,~,~,~,~] = lsqcurvefit(F, [alpha bPhi], handles.positiveB, handles.positiveDG);
    alpha = x(1);
    bPhi = abs(x(2));
    set(handles.teAlphaRight, 'String', num2str(alpha, handles.formatSpec));
    set(handles.teBphiRight, 'String', num2str(bPhi, handles.formatSpec));
    valueLphi = lPhiFromBphi(bPhi);
    set(handles.teLphiRight,'String', num2str(valueLphi, handles.formatSpec));
end
if strcmp(side, 'negative')
    [x,~,~,~,~] = lsqcurvefit(F, [alpha bPhi], handles.negativeB, handles.negativeDG);
    alpha = x(1);
    bPhi = abs(x(2));
    set(handles.teAlphaLeft, 'String', num2str(alpha, handles.formatSpec));
    set(handles.teBphiLeft, 'String', num2str(bPhi, handles.formatSpec));
    valueLphi = lPhiFromBphi(bPhi);
    set(handles.teLphiLeft,'String', num2str(valueLphi, handles.formatSpec));
end
set(handles.tlStatus, 'String', 'Fitting Step 1 DONE');
end