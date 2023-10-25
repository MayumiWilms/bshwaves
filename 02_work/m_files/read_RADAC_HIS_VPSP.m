function table_his_radac_param = read_RADAC_HIS_VPSP(s_VPSPFiles,s_InPath)

% import radac aggregated spectral parameters to timetable, S0bh_B4
% Example:
%   Table_HIS_RADAC_VPSP = read_RADAC_HIS_VPSP_data_timetable('H:\MATLAB\DATA\working_folder\NO1\Radac\direction\S0bh_B4 ')
%     s_VPSPFiles = latest_S0bh_B4;
%     s_InPath = fullfile(s_InPathSystem,'direction\S0bh_B4');

date_now = datetime('now','TimeZone','UTC');

%% import .txt
VariableNames =  {'Time','VPSP'};
delimiter = {','};
formatSpec = '%s%s%[^\n\r]';
fileID = fopen(fullfile(s_InPath,s_VPSPFiles),'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false, 'headerLines', 5);
fclose(fileID);

year = s_VPSPFiles(1:4);
month = s_VPSPFiles(5:6);
day = s_VPSPFiles(7:end-4);
datum = datetime([year,'-',month,'-',day],'InputFormat','yyyy-MM-dd');

if ~isempty(dataArray{1,1})  
    table_his_radac_param = table(dataArray{1:2}, 'VariableNames', VariableNames);
    table_his_radac_param.Time = datum + seconds(str2double(table_his_radac_param.Time)/1000); % convert ms into s
    table_his_radac_param.VPSP = str2double(table_his_radac_param.VPSP);
    table_his_radac_param.Properties.VariableUnits =  {'','deg'};
    table_his_radac_param.Time.TimeZone = 'UTC';
    table_his_radac_param = table2timetable(table_his_radac_param);
else
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_VPSPFiles) ' is empty or corrupted.'])
    table_his_radac_param = [];
end