function T_CSV_F25 = read_csv_0xF25(filename, dataLines)
%IMPORTFILE Import data from a text file
%  T_CSV_F25 = read_csv_0xF25(FILENAME) reads data from text file FILENAME for
%  the default selection.  Returns the data as a table.
%
%  T_CSV_F25 = read_csv_0xF25(FILE, DATALINES) reads data for the specified row
%  interval(s) of text file FILENAME. Specify DATALINES as a positive
%  scalar integer or a N-by-2 array of positive scalar integers for
%  dis-contiguous row intervals.
%
%  Example:
%  T_CSV_F25 = read_csv_0x303("J:\SEE{0xF25}2025-02.csv", [1, Inf]);
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
opts = delimitedTextImportOptions("NumVariables", 15);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["Timestamp", "Datastamp", "NumberOfSegments", "VHM0", "VTM20", "VTM10", "VTM01", "VTM02", "VTM13", "VTM24", "RP_VPQP", "VTPK", "Smax", "VPED", "VPSP"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
T_CSV_F25 = readtable(filename, opts);
T_CSV_F25.Time = datetime(T_CSV_F25.Timestamp,'ConvertFrom','posixtime','TimeZone','UTC'); 
T_CSV_F25.Time.TimeZone = 'UTC';
T_CSV_F25.VTPC = -999*ones(height(T_CSV_F25),1);
T_CSV_F25.VTNU = -999*ones(height(T_CSV_F25),1);
T_CSV_F25.VTES = -999*ones(height(T_CSV_F25),1);
T_CSV_F25.VSTS = -999*ones(height(T_CSV_F25),1);
T_CSV_F25.VPQP = 1./T_CSV_F25.RP_VPQP; % Get Godas Peakedness from reciprocal
T_CSV_F25.VPED = rad2deg(T_CSV_F25.VPED); % from radians to degrees
T_CSV_F25.VPSP = rad2deg(T_CSV_F25.VPSP); % from radians to degrees
T_CSV_F25 = removevars(T_CSV_F25, ["Timestamp","Datastamp","NumberOfSegments","RP_VPQP","Smax"]);
T_CSV_F25 = movevars(T_CSV_F25, "Time", "Before", "VHM0");

end