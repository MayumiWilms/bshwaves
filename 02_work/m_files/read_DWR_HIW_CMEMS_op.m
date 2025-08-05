function Table_HIW = read_DWR_HIW_CMEMS_op(s_HiwFiles,s_InPath)

% import .hiw to timetable
    % s_HiwFiles = dirinfo_hiw_yearX(I2).name;
    % s_InPath = dirinfo_hiw_yearX(I2).folder;

date_now = datetime('now','TimeZone','UTC');

%% import .hiw
% VariableNames =  {'Time','Coverage','H_max','T_Hmax','H_110',...
%     'T_H110','H_13','T_H13','Hav','Tav','eps','NumWaves'};
VariableNames =  {'Time','Coverage','VZMX','VTZM','VH110',...
    'VT110','VAVH','VAVT','VHZA','VTZA','VTZC','VZNW'};
delimiter = ',';
formatSpec = '%s%s%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(fullfile(s_InPath,s_HiwFiles),'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
dataArray{1,2} = erase(dataArray{1,2},'%');
dataArray{1,2} = str2double(dataArray{1,2});
fclose(fileID);
if ~isempty(dataArray{1,1})
    Table_HIW = table(dataArray{1:end-1}, 'VariableNames', VariableNames);
    toDelete = Table_HIW.Time == "";
    Table_HIW(toDelete,:) = [];
    try
        Table_HIW.Time = datetime(Table_HIW.Time,'InputFormat','yyyy-MM-dd''T''HH:mm:ss.SSS''Z'); 
    catch
        Table_HIW.Time = datetime(Table_HIW.Time,'InputFormat','yyyy-MM-dd''T''HH:mm:ss.SSS'); 
        disp([datestr(date_now) ' ' fullfile(s_InPath,s_HiwFiles) ' is post-processed or Waves5.'])
    end
    Table_HIW.VZMX = Table_HIW.VZMX ./ 100; % convert cm in m
    Table_HIW.VH110 = Table_HIW.VH110 ./ 100; % convert cm in m
    Table_HIW.VAVH = Table_HIW.VAVH ./ 100; % convert cm in m
    Table_HIW.VHZA = Table_HIW.VHZA ./ 100; % convert cm in m
    Table_HIW.Properties.VariableUnits =  {'','%','m','s','m',...
        's','m','s','m','s','',''};
    Table_HIW.Time.TimeZone = 'UTC';
    Table_HIW = table2timetable(Table_HIW); 
else
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_HiwFiles) ' is empty  or corrupted.'])  
    Table_HIW = [];
end

return