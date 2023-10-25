function table_hiw_radac_param = read_RADAC_HIW_VTZM(s_VTZMFiles,s_InPath)

% import radac aggregated parameters to timetable, VTZM
% Example:
%   Table_HIW_RADAC_VTZM = read_RADAC_HIW_VTZM_data_timetable('H:\MATLAB\DATA\working_folder\NO1\Radac\height\VTZM ')
%     s_VTZMFiles = latest_VTZM;
%     s_InPath = fullfile(s_InPathSystem,'height\VTZM');

date_now = datetime('now','TimeZone','UTC');

%% import .txt
VariableNames =  {'Time','VTZM'};
delimiter = {','};
formatSpec = '%s%s%[^\n\r]';
fileID = fopen(fullfile(s_InPath,s_VTZMFiles),'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false, 'headerLines', 5);
fclose(fileID);

year = s_VTZMFiles(1:4);
month = s_VTZMFiles(5:6);
day = s_VTZMFiles(7:end-4);
datum = datetime([year,'-',month,'-',day],'InputFormat','yyyy-MM-dd');

if ~isempty(dataArray{1,1})  
    table_hiw_radac_param = table(dataArray{1:2}, 'VariableNames', VariableNames);
    table_hiw_radac_param.Time = datum + seconds(str2double(table_hiw_radac_param.Time)/1000); % convert ms into s
    table_hiw_radac_param.VTZM = str2double(table_hiw_radac_param.VTZM);
    table_hiw_radac_param.Properties.VariableUnits =  {'','s'};
    table_hiw_radac_param.Time.TimeZone = 'UTC';
    table_hiw_radac_param = table2timetable(table_hiw_radac_param);
else
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_VTZMFiles) ' is empty or corrupted.'])
    table_hiw_radac_param = [];
end