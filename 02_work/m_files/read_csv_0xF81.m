function T_CSV_F81 = read_csv_0xF81(filename, dataLines)
%IMPORTFILE Import data from a text file
%  T_CSV_F81 = IMPORTFILE(FILENAME) reads data from text file FILENAME
%  for the default selection.  Returns the data as a table.
%
%  T_CSV_F81 = IMPORTFILE(FILE, DATALINES) reads data for the specified
%  row interval(s) of text file FILENAME. Specify DATALINES as a
%  positive scalar integer or a N-by-2 array of positive scalar integers
%  for dis-contiguous row intervals.
%
%  Example:
%  T_CSV_F81 = importfile("J:\SEE{0xF81}2025-02.csv", [1, Inf]);
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
opts.VariableNames = ["Timestamp", "Datastamp", "TEMPK"];
opts.VariableTypes = ["double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";


% Import the data
T_CSV_F81 = readtable(filename, opts);
T_CSV_F81.Time = datetime(T_CSV_F81.Timestamp,'ConvertFrom','posixtime','TimeZone','UTC'); 
T_CSV_F81.Time.TimeZone = 'UTC';
T_CSV_F81.TEMP = T_CSV_F81.TEMPK - 273.15; % Kelvin to Celsius
T_CSV_F81 = removevars(T_CSV_F81, ["Timestamp","Datastamp","TEMPK"]);

end