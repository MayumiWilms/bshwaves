function T_CSV_FC3 = read_csv_0xFC3(filename, dataLines)
%IMPORTFILE Import data from a text file
%  T_CSV_FC3 = read_csv_0xFC3(FILENAME) reads data from text file FILENAME
%  for the default selection.  Returns the data as a table.
%
%  T_CSV_FC3 = read_csv_0xFC3(FILE, DATALINES) reads data for the specified
%  row interval(s) of text file FILENAME. Specify DATALINES as a
%  positive scalar integer or a N-by-2 array of positive scalar integers
%  for dis-contiguous row intervals.
%
%  Example:
%  T_CSV_FC3 = read_csv_0xFC3("J:\SEE{0xFC3}2025-02.csv", [1, Inf]);
%
%  See also READTABLE.
%

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [1, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["Timestamp", "Datastamp", "BatteryLifeSeconds"];
opts.VariableTypes = ["double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties

% Import the data
T_CSV_FC3 = readtable(filename, opts);
T_CSV_FC3.Time = datetime(T_CSV_FC3.Timestamp,'ConvertFrom','posixtime','TimeZone','UTC'); 
T_CSV_FC3.Time.TimeZone = 'UTC';
T_CSV_FC3.Bat = bat_status_from_expectancy(T_CSV_FC3.BatteryLifeSeconds);
T_CSV_FC3 = rmmissing(T_CSV_FC3);
T_CSV_FC3 = removevars(T_CSV_FC3, ["Timestamp","Datastamp","BatteryLifeSeconds"]);
T_CSV_FC3 = movevars(T_CSV_FC3, "Time", "Before", "Bat");

end

function bat_status = bat_status_from_expectancy(expectancy)
% extimates Battery status from Life Expectancy
% Table 5.10.2 in Datawell DWR-MK3 Manual
bat_status = nan(size(expectancy));
week_expectancy = expectancy./60./60./24./7; % seconds to weeks
%%
   bat_status(week_expectancy >= 0 & week_expectancy <= 6) = 0;
   bat_status(week_expectancy >= 7 & week_expectancy <= 15) = 1;
   bat_status(week_expectancy >= 16 & week_expectancy <= 22) = 2;
   bat_status(week_expectancy >= 23 & week_expectancy <= 27) = 3;
   bat_status(week_expectancy >= 28 & week_expectancy <= 41) = 4;
   bat_status(week_expectancy >= 42 & week_expectancy <= 49) = 5;
   bat_status(week_expectancy >= 50 & week_expectancy <= 60) = 6;
   bat_status(week_expectancy >= 61) = 7;
 

end
