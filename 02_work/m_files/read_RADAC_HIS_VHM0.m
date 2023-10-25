function table_his_radac_param = read_RADAC_HIS_VHM0(s_VHM0Files,s_InPath)

% import radac aggregated spectral parameters to timetable, VHM0
% Example:
%   Table_HIS_RADAC_VHM0 = read_RADAC_HIS_VHM0_data_timetable('H:\MATLAB\DATA\working_folder\NO1\Radac\height\VHM0 ')
%     s_VHM0Files = latest_VHM0;
%     s_InPath = fullfile(s_InPathSystem,'height\VHM0');
% s_VHM0Files = dirinfo_VHM0X(I2).name;
% s_InPath = dirinfo_VHM0X(I2).folder;

date_now = datetime('now','TimeZone','UTC');

%% import .txt
VariableNames =  {'Time','VHM0'};
delimiter = {','};
formatSpec = '%s%s%[^\n\r]';
fileID = fopen(fullfile(s_InPath,s_VHM0Files),'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false, 'headerLines', 5);
fclose(fileID);

year = s_VHM0Files(1:4);
month = s_VHM0Files(5:6);
day = s_VHM0Files(7:end-4);
datum = datetime([year,'-',month,'-',day],'InputFormat','yyyy-MM-dd');

if ~isempty(dataArray{1,1})  
    table_his_radac_param = table(dataArray{1:2}, 'VariableNames', VariableNames);
    table_his_radac_param.Time = datum + seconds(str2double(table_his_radac_param.Time)/1000); % convert ms into s
    table_his_radac_param.VHM0 = str2double(table_his_radac_param.VHM0);
    table_his_radac_param.VHM0 = table_his_radac_param.VHM0 ./ 100; % convert cm in m
    table_his_radac_param.Properties.VariableUnits =  {'','m'};
    table_his_radac_param.Time.TimeZone = 'UTC';
    table_his_radac_param = table2timetable(table_his_radac_param);
else
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_VHM0Files) ' is empty or corrupted.'])
    table_his_radac_param = [];
end