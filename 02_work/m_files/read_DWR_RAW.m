function [Table_RAW, dqf_03_compl_raw] = read_DWR_RAW(s_InDataFile,s_InPath) 

% import .raw to timetable
    % s_InDataFile = dirinfo_raw_yearX(I2).name;
    % s_InPath = dirinfo_raw_yearX(I2).folder;

date_now = datetime('now','TimeZone','UTC');

%% import .raw
s_RawFile = fullfile(s_InPath,s_InDataFile);
VariableNames =  {'status','heave','north','west'};
delimiter = ',';
formatSpec = '%f%f%f%f%[^\n\r]';
fileID = fopen(s_RawFile,'r');
try
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
    fclose(fileID);
    
    if abs(2304 - numel(dataArray{1})) > 1 
        disp([datestr(date_now) ' ' s_RawFile ' is incomplete.'])
        Table_RAW = [];
        dqf_03_compl_raw = 4;        
        return
    end
    
    Table_RAW0 = table(dataArray{1:end-1}, 'VariableNames', VariableNames);    
    Table_RAW0.heave = Table_RAW0.heave ./ 100; % convert cm in m
    Table_RAW0.north = Table_RAW0.north ./ 100; % convert cm in m
    Table_RAW0.west = Table_RAW0.west ./ 100; % convert cm in m
    Table_RAW0.Properties.VariableUnits =  {'-','m','m','m'};  
    % datetime
    if contains(s_RawFile,'Z')
        startTime = datetime(s_RawFile(end-20:end-4),'InputFormat','yyyy-MM-dd''T''HH''h''mm''Z'); 
    elseif contains(s_RawFile,'A')
        startTime = datetime(s_RawFile(end-20:end-4),'InputFormat','yyyy-MM-dd''T''HH''h''mm''A'); 
    else
        startTime = datetime(s_RawFile(end-19:end-4),'InputFormat','yyyy-MM-dd''T''HH''h''mm');       
        disp([datestr(date_now) ' ' s_RawFile ' is post-processed.'])
    end      
    endTime = startTime + seconds(1800) - seconds(1/1.28);
    Time_temp = (startTime:seconds((1800 - (1/1.28))/(size(Table_RAW0,1)-1)):endTime)';
    %    
    Table_RAW = table2timetable(Table_RAW0,'RowTimes',Time_temp);    
    Table_RAW.Time.TimeZone = 'UTC';
    dqf_03_compl_raw = 1;
catch
    disp([datestr(date_now) ' ' s_RawFile ' is empty  or corrupted.'])
    Table_RAW = [];
    dqf_03_compl_raw = 4;    
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     if contains(s_RawFile,'Z')
%         str_date_raw = s_RawFile(end-20:end-4); 
%         startTime = datetime(str_date_raw,'InputFormat','yyyy-MM-dd''T''HH''h''mm''Z'); 
%     else
%         str_date_raw = s_RawFile(end-19:end-4); 
%         startTime = datetime(str_date_raw,'InputFormat','yyyy-MM-dd''T''HH''h''mm');         
%     end    