function [bag] = parser_dwr(bag)

%% select data for the last X+1 days 
% data needs to be selected by dir*.name because dir*.datenum is the last
% modified date of the file
% his
dirinfo_his_year = dir(fullfile(bag.s_incoming_folder,bag.s_station,'\**\*.his'));
dirinfo_his_year = dirinfo_his_year(~contains({dirinfo_his_year.name}','$'),:);
str_date = {dirinfo_his_year.name}';
for I2=1:1:numel(str_date)   
    str_date_temp0 = regexp(str_date{I2,:},'(?<year>\d+)-(?<month>\d+)','match','once');
    str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyy-MM');  
    [Y,M,~] = ymd(str_date_temp1);
    str_date_temp2 = datetime(Y,M,31);
    dirinfo_his_year(I2).name_datenum = datenum(str_date_temp2);
    clear str_date_temp* Y M D 
end; clear I2 str_date
dirinfo_his_yearX = dirinfo_his_year(([dirinfo_his_year.name_datenum] >= datenum(bag.date_from_x))); 
[~,index] = sortrows({dirinfo_his_yearX.name_datenum}.'); dirinfo_his_yearX = dirinfo_his_yearX(index); clear index 

% hiw
dirinfo_hiw_year = dir(fullfile(bag.s_incoming_folder,bag.s_station,'\**\*.hiw'));
str_date = {dirinfo_hiw_year.name}';
for I2=1:1:numel(str_date)    
    str_date_temp0 = regexp(str_date{I2,:},'(?<year>\d+)-(?<month>\d+)','match','once');
    str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyy-MM');  
    [Y,M,~] = ymd(str_date_temp1);
    str_date_temp2 = datetime(Y,M,31);
    dirinfo_hiw_year(I2).name_datenum = datenum(str_date_temp2);
    clear str_date_temp* Y M D 
end; clear I2 str_date
dirinfo_hiw_yearX = dirinfo_hiw_year(([dirinfo_hiw_year.name_datenum] >= datenum(bag.date_from_x))); 
[~,index] = sortrows({dirinfo_hiw_yearX.name_datenum}.'); dirinfo_hiw_yearX = dirinfo_hiw_yearX(index); clear index 

% gps
dirinfo_gps_year = dir(fullfile(bag.s_incoming_folder,bag.s_station,'\**\*GPS.txt'));
str_date = {dirinfo_gps_year.name}';
for I2=1:1:numel(str_date)    
    str_date_temp0 = regexp(str_date{I2,:},'(?<year>\d+)-(?<month>\d+)','match','once');
    str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyy-MM');  
    [Y,M,~] = ymd(str_date_temp1);
    str_date_temp2 = datetime(Y,M,31);
    dirinfo_gps_year(I2).name_datenum = datenum(str_date_temp2);
    clear str_date_temp* Y M D 
end; clear I2 str_date
dirinfo_gps_yearX = dirinfo_gps_year(([dirinfo_gps_year.name_datenum] >= datenum(bag.date_from_x))); 
[~,index] = sortrows({dirinfo_gps_yearX.name_datenum}.'); dirinfo_gps_yearX = dirinfo_gps_yearX(index); clear index 

%% check if his, hiw and gps exist
if isempty(dirinfo_his_yearX)
    disp([datestr(bag.date_now) ' No *.his data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
    return
end

if isempty(dirinfo_hiw_yearX)
    disp([datestr(bag.date_now) ' No *.hiw data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
    return
end

if isempty(dirinfo_gps_yearX)
    disp([datestr(bag.date_now) ' No *GPS.txt data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
end

%% load data into workspace     
% his    
T_HIS = timetable;
for I2 = 1:1:numel(dirinfo_his_yearX)
    T_HIS_tmp = read_DWR_HIS_CMEMS_op(dirinfo_his_yearX(I2).name,dirinfo_his_yearX(I2).folder);     
    T_HIS = [T_HIS; T_HIS_tmp]; %#ok<AGROW>
end
clear I2 T_HIS_tmp
T_HIS = sortrows(T_HIS);
T_HIS = unique(T_HIS); % remove duplicate rows with same time and data
T_HIS = T_HIS(logical([diff(T_HIS.Time) > seconds(60);1]),:); % remove duplicate rows with same time
T_HIS = T_HIS((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
T_HIS_orgtme = T_HIS.Time; % save the original timestamp before rounding for the last X+1 days
T_HIS.Time = dateshift(T_HIS.Time,'start','minute','nearest'); % dateshift seconds to nearest minute; the original timestamp will be given back before writetable

% hiw   
T_HIW = timetable;
for I2 = 1:1:numel(dirinfo_hiw_yearX)
    T_HIW_tmp = read_DWR_HIW_CMEMS_op(dirinfo_hiw_yearX(I2).name,dirinfo_hiw_yearX(I2).folder);     
    T_HIW = [T_HIW; T_HIW_tmp]; %#ok<AGROW>
end
clear I2 T_HIW_tmp   
T_HIW = sortrows(T_HIW);
T_HIW = unique(T_HIW); % remove duplicate rows with same time and data
T_HIW = T_HIW(or(T_HIW.Time.Minute == 0 , T_HIW.Time.Minute == 30),:); % select timestamps with xx:00 and xx:30   
T_HIW = T_HIW(logical([diff(T_HIW.Time) > seconds(60);1]),:); % remove duplicate rows with same time
T_HIW = T_HIW((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
T_HIW_orgtme = T_HIW.Time; % save the original timestamp before rounding for the last X+1 days
T_HIW.Time = dateshift(T_HIW.Time,'start','minute','current'); % dateshift seconds to nearest minute; the original timestamp will be given back before writetable

% gps   
if isempty(dirinfo_gps_yearX)
    % create Table_GPS with NaNs
    T_GPS = timetable(T_HIS.Time,nan(height(T_HIS),1), nan(height(T_HIS),1), nan(height(T_HIS),1),'VariableNames',{'STATUS' 'LATITUDE' 'LONGITUDE'});
    T_GPS_orgtme = T_HIS_orgtme; % T_HIS is already rounded to nearest minute
else
    T_GPS = timetable;
    for I2 = 1:1:numel(dirinfo_gps_yearX)
        T_GPS_tmp = read_DWR_GPS_CMEMS_op(dirinfo_gps_yearX(I2).name,dirinfo_gps_yearX(I2).folder);     
        T_GPS = [T_GPS; T_GPS_tmp]; %#ok<AGROW>
    end
    clear I2 T_GPS_tmp      
    T_GPS = sortrows(T_GPS);
    T_GPS = unique(T_GPS); % remove duplicate rows with same time and data
    T_GPS = T_GPS(logical([diff(T_GPS.Time) > seconds(60);1]),:); % remove duplicate rows with same time
    T_GPS = T_GPS((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
    T_GPS_orgtme = T_GPS.Time; % save the original timestamp before rounding for the last X+1 days
    T_GPS.Time = dateshift(T_GPS.Time,'start','minute','nearest'); % dateshift seconds to nearest minute; the original timestamp will be given back before writetable
end
    
%% data availability
if isempty(T_HIS)
    error([datestr(bag.date_now) ' No HIS data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
end

if isempty(T_HIW)
    error([datestr(bag.date_now) ' No HIW data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
end

if isempty(T_GPS)
    disp([datestr(bag.date_now) ' No GPS data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
    % create T_GPS with NaNs
    T_GPS = timetable(T_HIS.Time,nan(height(T_HIS),1), nan(height(T_HIS),1), nan(height(T_HIS),1),'VariableNames',{'STATUS' 'LATITUDE' 'LONGITUDE'});
    T_GPS_orgtme = T_HIS_orgtme; % T_HIS is already rounded to nearest minute
end

%% pack your bag
bag.T_HIW = T_HIW;
bag.T_HIS = T_HIS;
bag.T_GPS = T_GPS;
bag.T_HIW_orgtme = T_HIW_orgtme;
bag.T_HIS_orgtme = T_HIS_orgtme;
bag.T_GPS_orgtme = T_GPS_orgtme;

return