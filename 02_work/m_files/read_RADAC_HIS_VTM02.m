function table_his_radac_param = read_RADAC_HIS_VTM02(s_VTM02Files,s_InPath)

% import radac aggregated spectral parameters to timetable, VTM02
% Example:
%   Table_HIS_RADAC_VTM02 = read_RADAC_HIS_VTM02_data_timetable('H:\MATLAB\DATA\working_folder\NO1\Radac\height\VTM02 ')
%     s_VTM02Files = latest_VTM02;
%     s_InPath = fullfile(s_InPathSystem,'height\VTM02');

date_now = datetime('now','TimeZone','UTC');

%% import .txt
VariableNames =  {'Time','VTM02'};
delimiter = {','};
formatSpec = '%s%s%[^\n\r]';
fileID = fopen(fullfile(s_InPath,s_VTM02Files),'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false, 'headerLines', 5);
fclose(fileID);

year = s_VTM02Files(1:4);
month = s_VTM02Files(5:6);
day = s_VTM02Files(7:end-4);
datum = datetime([year,'-',month,'-',day],'InputFormat','yyyy-MM-dd');

if ~isempty(dataArray{1,1})  
    table_his_radac_param = table(dataArray{1:2}, 'VariableNames', VariableNames);
    table_his_radac_param.Time = datum + seconds(str2double(table_his_radac_param.Time)/1000); % convert ms into s
    table_his_radac_param.VTM02 = str2double(table_his_radac_param.VTM02);
    table_his_radac_param.Properties.VariableUnits =  {'','s'};
    table_his_radac_param.Time.TimeZone = 'UTC';
    table_his_radac_param = table2timetable(table_his_radac_param);
else
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_VTM02Files) ' is empty or corrupted.'])
    table_his_radac_param = [];
end