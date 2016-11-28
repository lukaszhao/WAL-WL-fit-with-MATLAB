function [headers, data] = loadRawData(fullPathName)
% This function loads a file with raw data on magneto-transport 
% measurements and returs two cell arrays:
% headers: names of the columns
% data: the matrix of numeric data  
  
  % processing the raw data, extracting column headers and 
  % the actual data. Removing empty strings along the way
  dataStrings = strsplit(fileread(fullPathName), '\n');  
  numOfLines = length(dataStrings);
  numOfEmptyLines = 0;
  
  % counting empty lines
  for i = 1:numOfLines
    if isempty( cell2mat(dataStrings(i)) )
      numOfEmptyLines = numOfEmptyLines + 1;
    end    
  end
  
  % we expect the first line to be header in text format
  headers = cell2mat( dataStrings(1) );
  headers = strsplit(headers, '\t');
  
  % processing the actual data
  data = cell(numOfLines - numOfEmptyLines - 1, 1); % -1 for header!
  
  % progress bar
  frac = 0.0;
  %pBar = waitbar(frac, 'Loading Data');
  
  j = 1;
  for i = 2:numOfLines % row 1 is header!
    iString = cell2mat(dataStrings(i));
    if ~(isempty( iString ))
      % splitting tab-separated data and converting into numbers
      %data(j) = arrayfun(@str2double, strsplit(iString, '\t'));
      x = str2double( strsplit(iString, '\t') );
      y = size(x);
      data(j) = mat2cell( x, [y(1)], [y(2)] );
      j = j + 1;
      frac = i/numOfLines;
   %   waitbar(frac, pBar);
    end    
  end
  %close(pBar);
end