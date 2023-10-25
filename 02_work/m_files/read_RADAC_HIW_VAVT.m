function table_hiw_radac_param = read_RADAC_HIW_VAVT(s_VAVTFiles,s_InPath)

% import radac aggregated parameters to timetable, VAVT
% Example:
%   Table_HIW_RADAC_VAVT = read_RADAC_HIW_VAVT_data_timetable('H:\MATLAB\DATA\working_folder\NO1\Radac\height\VAVT ')
%     s_VAVTFiles = latest_VAVT;
%     s_InPath = fullfile(s_InPathSystem,'height\VAVT');

date_now = datetime('now','TimeZone','UTC');

%% import .txt
VariableNames =  {'Time','VAVT'};
delimiter = {','};
formatSpec = '%s%s%[^\n\r]';
fileID = fopen(fullfile(s_InPath,s_VAVTFiles),'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false, 'headerLines', 5);
fclose(fileID);

year = s_VAVTFiles(1:4);
month = s_VAVTFiles(5:6);
day = s_VAVTFiles(7:end-4);
datum = datetime([year,'-',month,'-',day],'InputFormat','yyyy-MM-dd');

if ~isempty(dataArray{1,1})  
    table_hiw_radac_param = table(dataArray{1:2}, 'VariableNames', VariableNames);
    table_hiw_radac_param.Time = datum + seconds(str2double(table_hiw_radac_param.Time)/1000); % convert ms into s
    table_hiw_radac_param.VAVT = str2double(table_hiw_radac_param.VAVT);
    table_hiw_radac_param.Properties.VariableUnits =  {'','s'};
    table_hiw_radac_param.Time.TimeZone = 'UTC';
    table_hiw_radac_param = table2timetable(table_hiw_radac_param);
else
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_VAVTFiles) ' is empty or corrupted.'])
    table_hiw_radac_param = [];
end