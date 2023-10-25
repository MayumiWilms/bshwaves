function table_his_radac_param = read_RADAC_HIS_VMDR(s_VMDRFiles,s_InPath)

% import radac aggregated spectral parameters to timetable, VMDR
% Example:
%   Table_HIS_RADAC_VMDR = read_RADAC_HIS_VMDR_data_timetable('H:\MATLAB\DATA\working_folder\NO1\Radac\direction\VMDR ')
%     s_VMDRFiles = dirinfo_VMDRX(I2).name;
%     s_InPath = dirinfo_VMDRX(I2).folder;

date_now = datetime('now','TimeZone','UTC');

%% import .txt
VariableNames =  {'Time','VMDR'};
delimiter = {','};
formatSpec = '%s%s%[^\n\r]';
fileID = fopen(fullfile(s_InPath,s_VMDRFiles),'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false, 'headerLines', 5);
fclose(fileID);

year = s_VMDRFiles(1:4);
month = s_VMDRFiles(5:6);
day = s_VMDRFiles(7:end-4);
datum = datetime([year,'-',month,'-',day],'InputFormat','yyyy-MM-dd');

if ~isempty(dataArray{1,1})  
    table_his_radac_param = table(dataArray{1:2}, 'VariableNames', VariableNames);
    table_his_radac_param.Time = datum + seconds(str2double(table_his_radac_param.Time)/1000); % convert ms into s
    table_his_radac_param.VMDR = str2double(table_his_radac_param.VMDR);
    table_his_radac_param.Properties.VariableUnits =  {'','deg'};
    table_his_radac_param.Time.TimeZone = 'UTC';
    table_his_radac_param = table2timetable(table_his_radac_param);
else
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_VMDRFiles) ' is empty or corrupted.'])
    table_his_radac_param = [];
end