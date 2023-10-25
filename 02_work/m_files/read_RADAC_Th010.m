function Table_RADAC_Th010 = read_RADAC_Th010(s_Th010Files,s_InPath)

% import radac spectrum Th010 .txt to timetable
% Example:
%   Table_RADAC_Th010 = importfile('20180909.txt','I:\RADAC\NOR\direction\Th010');
%
% s_Th010Files = dirinfo_Th010X(I2).name;
% s_InPath = dirinfo_Th010X(I2).folder;

date_now = datetime('now','TimeZone','UTC');

%% import .txt
delimiter = ',';
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(fullfile(s_InPath,s_Th010Files),'r');
try
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines', 5, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);

    VariableNames = compose('Th010_%d',1:1:numel(dataArray)-2); % first and last column do not belong to Th010
    VariableNames = ['Time',VariableNames];
    UnitsNames = cellstr(repmat('degree',numel(dataArray)-2,1)); 
    UnitsNames = ['Time';UnitsNames]';

    year = s_Th010Files(1:4);
    month = s_Th010Files(5:6);
    day = s_Th010Files(7:end-4);
    datum = datetime([year,'-',month,'-',day],'InputFormat','yyyy-MM-dd');

    if ~isempty(dataArray{1,1})  
        dataArray2 = cell2mat(dataArray(1:numel(dataArray)-1));
        Table_RADAC_Th010 = array2table(dataArray2, 'VariableNames', VariableNames);
        Table_RADAC_Th010.Time = datum + seconds(Table_RADAC_Th010.Time/1000); % convert ms into s    
        Table_RADAC_Th010.Properties.VariableUnits =  UnitsNames;
        Table_RADAC_Th010 = table2timetable(Table_RADAC_Th010);     
        Table_RADAC_Th010.Time.TimeZone = 'UTC';
    else
        disp([datestr(date_now) ' ' fullfile(s_InPath,s_Th010Files) ' is empty or corrupted.'])
        Table_RADAC_Th010 = [];
    end
catch
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_Th010Files) ' is empty or corrupted.'])
    Table_RADAC_Th010 = [];
end