function n = locateColumn( name, headers )
% find the index of the column with specific data header
% remember that "headers" is a cell array
  n = 0;
  % checking occurences of "name" among the headers.
  idx = strfind(headers, name);
  
  m = length(idx); 
  
  for i = 1:m
    if cell2mat(idx(i)) == 1
      n = i;
      break;
    end
  end
  
end