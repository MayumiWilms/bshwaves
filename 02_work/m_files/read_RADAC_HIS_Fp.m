function table_his_radac_param = read_RADAC_HIS_Fp(s_FpFiles,s_InPath)

% import radac aggregated spectral parameters to timetable, Fp
% Example:
%   Table_HIS_RADAC_Fp = read_RADAC_HIS_Fp_data_timetable('H:\MATLAB\DATA\working_folder\NO1\Radac\height\Fp ')
%     s_FpFiles = latest_Fp;
%     s_InPath = fullfile(s_InPathSystem,'height\Fp');

date_now = datetime('now','TimeZone','UTC');

%% import .txt
VariableNames =  {'Time','F_p'};
delimiter = {','};
formatSpec = '%s%s%[^\n\r]';
fileID = fopen(fullfile(s_InPath,s_FpFiles),'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false, 'headerLines', 5);
fclose(fileID);

year = s_FpFiles(1:4);
month = s_FpFiles(5:6);
day = s_FpFiles(7:end-4);
datum = datetime([year,'-',month,'-',day],'InputFormat','yyyy-MM-dd');

if ~isempty(dataArray{1,1})  
    table_his_radac_param = table(dataArray{1:2}, 'VariableNames', VariableNames);
    table_his_radac_param.Time = datum + seconds(str2double(table_his_radac_param.Time)/1000); % convert ms into s
    table_his_radac_param.F_p = str2double(table_his_radac_param.F_p);
    table_his_radac_param.F_p = table_his_radac_param.F_p ./ 1000; % convert mHz in Hz
    table_his_radac_param.VTPK = 1 ./ table_his_radac_param.F_p; % [s], peak period
	table_his_radac_param.VTPK(table_his_radac_param.VTPK == Inf) = 0; % if F_p=0, T_p=Inf
    table_his_radac_param.Properties.VariableUnits =  {'','Hz','s'};
    table_his_radac_param.Time.TimeZone = 'UTC';
    table_his_radac_param = table2timetable(table_his_radac_param);
else
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_FpFiles) ' is empty or corrupted.'])
    table_his_radac_param = [];
end