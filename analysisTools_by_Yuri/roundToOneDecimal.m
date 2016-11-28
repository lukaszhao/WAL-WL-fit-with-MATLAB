function y = roundToOneDecimal(x)
% found a number so that it has only one decimal
% like this xxx.yyyy -> xxx.y with proper rounding
y = sprintf('%.1f', x);
end