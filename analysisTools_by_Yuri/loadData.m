function [B, T, Rxx, Rxy, Angle] = loadData(handles)

dialogString = 'Select a data file:';
fileName = get(handles.tlDataFile,'String');
[dataFileName, pathToFile, ~] = uigetfile('*', dialogString, fileName);
fullPathName = [pathToFile dataFileName];
set(handles.tlDataFile, 'String', fullPathName);
set(handles.tlStatus, 'String', 'Loading Data...');
% reading the data from the file
[columnHeaders, rawData] = loadRawData(fullPathName);

% Column Headers with relevant data
hFieldHeader =  'H(Oe)';
tHeader = 'T(K)';
r1Header = 'R1+(Ohm)';
r2Header = 'R2(Ohm)';
rHallHeader = 'Hall R(Ohm)';
angleHeader = 'Rotator Angle(deg)'; % for rotation measurements

% Locating the respective columns of the data
hFieldColumnNumber = locateColumn(hFieldHeader, columnHeaders);
tColumnNumber = locateColumn(tHeader, columnHeaders);
r1ColumnNumber = locateColumn(r1Header, columnHeaders);
r2ColumnNumber = locateColumn(r2Header, columnHeaders);
rHallColumnNumber = locateColumn(rHallHeader, columnHeaders);
angleColumnNumber = locateColumn(angleHeader, columnHeaders);

% 1E-4 factor to convert into Tesla, SI units
B = 1E-4*getNthColumn( hFieldColumnNumber, rawData );
% Reading two-channel measurements data and performing correction for 
% Van der Pauw configuration
R1 = getNthColumn( r1ColumnNumber, rawData );
R2 = getNthColumn( r2ColumnNumber, rawData );
Rxx = correctVdP(R1, R2);

% need to purge repeats smartly!!! Now its dumb :(
[B, Rxx] = purgeRepeats(B, Rxx);
Rxx = correctOutliers(Rxx);

% Extracting the temperature, Hall resistance, and the rotator angle
T = getNthColumn( tColumnNumber, rawData );
Rxy = getNthColumn( rHallColumnNumber, rawData );
Angle = getNthColumn( angleColumnNumber, rawData );
end