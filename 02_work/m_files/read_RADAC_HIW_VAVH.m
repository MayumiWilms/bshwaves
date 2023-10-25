function table_hiw_radac_param = read_RADAC_HIW_VAVH(s_VAVHFiles,s_InPath)

% import radac aggregated parameters to timetable, VAVH
% Example:
%   Table_HIW_RADAC_VAVH = read_RADAC_HIW_VAVH_data_timetable('H:\MATLAB\DATA\working_folder\NO1\Radac\height\VAVH ')
%     s_VAVHFiles = latest_VAVH;
%     s_InPath = fullfile(s_InPathSystem,'height\VAVH');

date_now = datetime('now','TimeZone','UTC');

%% import .txt
VariableNames =  {'Time','VAVH'};
delimiter = {','};
formatSpec = '%s%s%[^\n\r]';
fileID = fopen(fullfile(s_InPath,s_VAVHFiles),'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false, 'headerLines', 5);
fclose(fileID);

year = s_VAVHFiles(1:4);
month = s_VAVHFiles(5:6);
day = s_VAVHFiles(7:end-4);
datum = datetime([year,'-',month,'-',day],'InputFormat','yyyy-MM-dd');

if ~isempty(dataArray{1,1})  
    table_hiw_radac_param = table(dataArray{1:2}, 'VariableNames', VariableNames);
    table_hiw_radac_param.Time = datum + seconds(str2double(table_hiw_radac_param.Time)/1000); % convert ms into s
    table_hiw_radac_param.VAVH = str2double(table_hiw_radac_param.VAVH);
    table_hiw_radac_param.VAVH = table_hiw_radac_param.VAVH ./ 100; % convert cm in m
    table_hiw_radac_param.Properties.VariableUnits =  {'','m'};
    table_hiw_radac_param.Time.TimeZone = 'UTC';
    table_hiw_radac_param = table2timetable(table_hiw_radac_param);
else
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_VAVHFiles) ' is empty or corrupted.'])
    table_hiw_radac_param = [];
end