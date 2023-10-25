function table_hiw_radac_param = read_RADAC_HIW_VZNW(s_VZNWFiles,s_InPath)

% import radac aggregated parameters to timetable, VZNW

date_now = datetime('now','TimeZone','UTC');

%% import .txt
VariableNames =  {'Time','VZNW'};
delimiter = {','};
formatSpec = '%s%s%[^\n\r]';
fileID = fopen(fullfile(s_InPath,s_VZNWFiles),'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false, 'headerLines', 5);
fclose(fileID);

year = s_VZNWFiles(1:4);
month = s_VZNWFiles(5:6);
day = s_VZNWFiles(7:end-4);
datum = datetime([year,'-',month,'-',day],'InputFormat','yyyy-MM-dd');

if ~isempty(dataArray{1,1})  
    table_hiw_radac_param = table(dataArray{1:2}, 'VariableNames', VariableNames);
    table_hiw_radac_param.Time = datum + seconds(str2double(table_hiw_radac_param.Time)/1000); % convert ms into s
    table_hiw_radac_param.VZNW = str2double(table_hiw_radac_param.VZNW);
    table_hiw_radac_param.Properties.VariableUnits =  {'',''};
    table_hiw_radac_param.Time.TimeZone = 'UTC';
    table_hiw_radac_param = table2timetable(table_hiw_radac_param);
else
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_VZNWFiles) ' is empty or corrupted.'])
    table_hiw_radac_param = [];
end