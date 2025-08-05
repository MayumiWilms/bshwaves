function T_CSV_F80 = read_csv_0xF80(filename, dataLines)
%IMPORTFILE Import data from a text file
%  T_CSV_F80 = read_csv_0xF80(FILENAME) reads data from text file FILENAME
%  for the default selection.  Returns the data as a table.
%
%  T_CSV_F80 = read_csv_0xF80(FILE, DATALINES) reads data for the specified
%  row interval(s) of text file FILENAME. Specify DATALINES as a
%  positive scalar integer or a N-by-2 array of positive scalar integers
%  for dis-contiguous row intervals.
%
%  Example:
%  T_CSV_F80 = read_csv_0x380("J:\SEE{0xF80}2025-02.csv", [1, Inf]);
%
%  See also READTABLE.
%

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [1, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 4);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["Timestamp", "Datastamp", "LatitudeRad", "LongitudeRad"];
opts.VariableTypes = ["double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";


% Import the data
T_CSV_F80 = readtable(filename, opts);
T_CSV_F80.Time = datetime(T_CSV_F80.Timestamp,'ConvertFrom','posixtime','TimeZone','UTC'); 
T_CSV_F80.Time.TimeZone = 'UTC';
T_CSV_F80.LATITUDE = T_CSV_F80.LatitudeRad * 180/pi();
T_CSV_F80.LONGITUDE = T_CSV_F80.LongitudeRad * 180/pi();
T_CSV_F80.STATUS = 9*ones(height(T_CSV_F80),1);
T_CSV_F80 = removevars(T_CSV_F80, ["Timestamp","Datastamp","LatitudeRad","LongitudeRad"]);
T_CSV_F80 = movevars(T_CSV_F80, "STATUS", "Before", "LATITUDE");

end