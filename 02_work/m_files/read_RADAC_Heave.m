function [Table_RAW, dqf_03_compl_raw] = read_RADAC_Heave(s_HeaveFiles,s_InPath) 

% import radac heave .txt to timetable
    % s_HeaveFiles = dirinfo_raw_yearX(I2).name;
    % s_InPath = dirinfo_raw_yearX(I2).folder;

date_now = datetime('now','TimeZone','UTC');

%% import .txt
VariableNames =  {'Time','heave'};
delimiter = {','};
formatSpec = '%s%s%[^\n\r]';
fileID = fopen(fullfile(s_InPath,s_HeaveFiles),'r');
try
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false, 'headerLines', 5);
    fclose(fileID);   

    year = s_HeaveFiles(1:4);
    month = s_HeaveFiles(5:6);
    day = s_HeaveFiles(7:end-4);
    datum = datetime([year,'-',month,'-',day],'InputFormat','yyyy-MM-dd');

    if ~isempty(dataArray{1,1})  
        Table_RAW = table(dataArray{1:2}, 'VariableNames', VariableNames);
        Table_RAW.Time = datum + seconds(str2double(Table_RAW.Time)/1000); % convert ms into s
        Table_RAW.heave = str2double(Table_RAW.heave);
        Table_RAW.heave = Table_RAW.heave ./ 100; % convert cm in m
        Table_RAW.Properties.VariableUnits =  {'-','m'};
        Table_RAW = table2timetable(Table_RAW);
        Table_RAW.Time.TimeZone = 'UTC';
        dqf_03_compl_raw = 1;
    else
        disp([datestr(date_now) ' ' fullfile(s_InPath,s_HeaveFiles) ' is empty or corrupted.'])
        Table_RAW = [];
        dqf_03_compl_raw = 4;   
    end
    
catch
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_HeaveFiles) ' is empty or corrupted.'])
	Table_RAW = [];
    dqf_03_compl_raw = 4;    
end

return