function table_lev_radac_param = read_RADAC_LEV_SLEV_H1(s_SLEV_H1Files,s_InPath)

% import radac tide parameters to timetable, SLEV_H1

date_now = datetime('now','TimeZone','UTC');

%% import .txt
VariableNames =  {'Time','SLEV_H1'};
delimiter = {','};
formatSpec = '%s%s%[^\n\r]';
fileID = fopen(fullfile(s_InPath,s_SLEV_H1Files),'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false, 'headerLines', 5);
fclose(fileID);

year = s_SLEV_H1Files(1:4);
month = s_SLEV_H1Files(5:6);
day = s_SLEV_H1Files(7:end-4);
datum = datetime([year,'-',month,'-',day],'InputFormat','yyyy-MM-dd');

if ~isempty(dataArray{1,1})  
    table_lev_radac_param = table(dataArray{1:2}, 'VariableNames', VariableNames);
    table_lev_radac_param.Time = datum + seconds(str2double(table_lev_radac_param.Time)/1000); % convert ms into s
    table_lev_radac_param.SLEV_H1 = str2double(table_lev_radac_param.SLEV_H1);
    table_lev_radac_param.SLEV_H1 = table_lev_radac_param.SLEV_H1 ./ 100; % convert cm in m
    table_lev_radac_param.Properties.VariableUnits =  {'','m'};
    table_lev_radac_param.Time.TimeZone = 'UTC';
    table_lev_radac_param = table2timetable(table_lev_radac_param);
else
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_SLEV_H1Files) ' is empty or corrupted.'])
    table_lev_radac_param = [];
end