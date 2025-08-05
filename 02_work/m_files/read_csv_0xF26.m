function T_CSV_F26 = read_csv_0xF26(filename, dataLines)
%IMPORTFILE Import data from a text file
%  T_CSV_F26 = read_csv_0xF26(FILENAME) reads data from text file FILENAME for
%  the default selection.  Returns the data as a table.
%
%  T_CSV_F26 = read_csv_0xF26(FILE, DATALINES) reads data for the specified row
%  interval(s) of text file FILENAME. Specify DATALINES as a positive
%  scalar integer or a N-by-2 array of positive scalar integers for
%  dis-contiguous row intervals.
%
%  Example:
%  T_CSV_F26 = read_csv_0x303("J:\SEE{0xF26}2025-02.csv", [1, Inf]);
%
%  See also READTABLE.
%
% 

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [1, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 13);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["Timestamp", "Datastamp", "VZMX", "VTZM", "Tmax", "Htmax", "VHZA", "VTZA", "Hsrms", "VZNW", "Nc", "VTZC", "Cov"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
T_CSV_F26 = readtable(filename, opts);
T_CSV_F26.Time = datetime(T_CSV_F26.Timestamp,'ConvertFrom','posixtime','TimeZone','UTC'); 
T_CSV_F26.Time.TimeZone = 'UTC';
T_CSV_F26.VH110 = -999*ones(height(T_CSV_F26),1);
T_CSV_F26.VT110 = -999*ones(height(T_CSV_F26),1);
T_CSV_F26.VAVH = -999*ones(height(T_CSV_F26),1);
T_CSV_F26.VAVT = -999*ones(height(T_CSV_F26),1);
T_CSV_F26 = removevars(T_CSV_F26, ["Timestamp","Datastamp","Tmax","Htmax","Hsrms", "Nc", "Cov"]);
T_CSV_F26 = movevars(T_CSV_F26, "Time", "Before", "VZMX");

end