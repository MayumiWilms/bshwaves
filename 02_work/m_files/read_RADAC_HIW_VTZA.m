function table_hiw_radac_param = read_RADAC_HIW_VTZA(s_VTZAFiles,s_InPath)

% import radac aggregated parameters to timetable, VTZA
% Example:
%   Table_HIW_RADAC_VTZA = read_RADAC_HIW_VTZA_data_timetable('H:\MATLAB\DATA\working_folder\NO1\Radac\height\VTZA ')
%     s_VTZAFiles = latest_VTZA;
%     s_InPath = fullfile(s_InPathSystem,'height\VTZA');

date_now = datetime('now','TimeZone','UTC');

%% import .txt
VariableNames =  {'Time','VTZA'};
delimiter = {','};
formatSpec = '%s%s%[^\n\r]';
fileID = fopen(fullfile(s_InPath,s_VTZAFiles),'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false, 'headerLines', 5);
fclose(fileID);

year = s_VTZAFiles(1:4);
month = s_VTZAFiles(5:6);
day = s_VTZAFiles(7:end-4);
datum = datetime([year,'-',month,'-',day],'InputFormat','yyyy-MM-dd');

if ~isempty(dataArray{1,1})  
    table_hiw_radac_param = table(dataArray{1:2}, 'VariableNames', VariableNames);
    table_hiw_radac_param.Time = datum + seconds(str2double(table_hiw_radac_param.Time)/1000); % convert ms into s
    table_hiw_radac_param.VTZA = str2double(table_hiw_radac_param.VTZA);
    table_hiw_radac_param.Properties.VariableUnits =  {'','s'};
    table_hiw_radac_param.Time.TimeZone = 'UTC';
    table_hiw_radac_param = table2timetable(table_hiw_radac_param);
else
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_VTZAFiles) ' is empty or corrupted.'])
    table_hiw_radac_param = [];
end