function table_hiw_radac_param = read_RADAC_HIW_VH110(s_VH110Files,s_InPath)

% import radac aggregated parameters to timetable, VH110
% Example:
%   Table_HIW_RADAC_VH110 = read_RADAC_HIW_VH110_data_timetable('H:\MATLAB\DATA\working_folder\NO1\Radac\height\VH110 ')
%     s_VH110Files = latest_VH110;
%     s_InPath = fullfile(s_InPathSystem,'height\VH110');

date_now = datetime('now','TimeZone','UTC');

%% import .txt
VariableNames =  {'Time','VH110'};
delimiter = {','};
formatSpec = '%s%s%[^\n\r]';
fileID = fopen(fullfile(s_InPath,s_VH110Files),'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false, 'headerLines', 5);
fclose(fileID);

year = s_VH110Files(1:4);
month = s_VH110Files(5:6);
day = s_VH110Files(7:end-4);
datum = datetime([year,'-',month,'-',day],'InputFormat','yyyy-MM-dd');

if ~isempty(dataArray{1,1})  
    table_hiw_radac_param = table(dataArray{1:2}, 'VariableNames', VariableNames);
    table_hiw_radac_param.Time = datum + seconds(str2double(table_hiw_radac_param.Time)/1000); % convert ms into s
    table_hiw_radac_param.VH110 = str2double(table_hiw_radac_param.VH110);
    table_hiw_radac_param.VH110 = table_hiw_radac_param.VH110 ./ 100; % convert cm in m
    table_hiw_radac_param.Properties.VariableUnits =  {'','m'};
    table_hiw_radac_param.Time.TimeZone = 'UTC';
    table_hiw_radac_param = table2timetable(table_hiw_radac_param);
else
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_VH110Files) ' is empty or corrupted.'])
    table_hiw_radac_param = [];
end