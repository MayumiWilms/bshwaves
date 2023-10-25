function table_his_radac_param = read_RADAC_HIS_VPED(s_VPEDFiles,s_InPath)

% import radac aggregated spectral parameters to timetable, T0bh_B4
% Example:
%   Table_HIS_RADAC_S0bh_B4 = read_RADAC_HIS_S0bh_B4_data_timetable('H:\MATLAB\DATA\working_folder\NO1\Radac\direction\T0bh_B4 ')
%     s_VPEDFiles = latest_T0bh_B4;
%     s_InPath = fullfile(s_InPathSystem,'direction\T0bh_B4');

date_now = datetime('now','TimeZone','UTC');

%% import .txt
VariableNames =  {'Time','VPED'};
delimiter = {','};
formatSpec = '%s%s%[^\n\r]';
fileID = fopen(fullfile(s_InPath,s_VPEDFiles),'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false, 'headerLines', 5);
fclose(fileID);

year = s_VPEDFiles(1:4);
month = s_VPEDFiles(5:6);
day = s_VPEDFiles(7:end-4);
datum = datetime([year,'-',month,'-',day],'InputFormat','yyyy-MM-dd');

if ~isempty(dataArray{1,1})  
    table_his_radac_param = table(dataArray{1:2}, 'VariableNames', VariableNames);
    table_his_radac_param.Time = datum + seconds(str2double(table_his_radac_param.Time)/1000); % convert ms into s
    table_his_radac_param.VPED = str2double(table_his_radac_param.VPED);
    table_his_radac_param.Properties.VariableUnits =  {'','deg'};
    table_his_radac_param.Time.TimeZone = 'UTC';
    table_his_radac_param = table2timetable(table_his_radac_param);
else
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_VPEDFiles) ' is empty or corrupted.'])
    table_his_radac_param = [];
end