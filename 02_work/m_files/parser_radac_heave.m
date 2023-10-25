function [bag] = parser_radac_heave(bag)

% select data 
% data needs to be selected by dir*.name because dir*.datenum is
% the last modified date of the file

% heave
switch upper(bag.s_sensor)
    case 'RADAC'
        dirinfo_raw_year = dir(fullfile(bag.s_incoming_folder,bag.s_station,'height\heave','*.txt')); 
        
    case 'RADAC_SINGLE'
        dirinfo_raw_year = dir(fullfile(bag.s_incoming_folder,bag.s_station,'heave','*.txt'));        
        
    otherwise
        warning('Unexpected sensor type.')
end

if isempty(dirinfo_raw_year)
    error([datestr(bag.date_now) ' No heave data at station ' bag.s_station '.'])
end

str_date = {dirinfo_raw_year.name}';
for I2=1:1:numel(str_date)    
    str_date_temp0 = str_date{I2,:}(1:end-4);
    str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
    dirinfo_raw_year(I2).name_datenum = datenum(str_date_temp1);
    clear str_date_temp* 
end; clear I2 str_date
date_from_x = datetime(floor(datenum(bag.date_from_x)),'ConvertFrom','datenum','TimeZone','UTC'); % floor date to date at midnight
date_to_x = datetime(ceil(datenum(bag.date_to_x)),'ConvertFrom','datenum','TimeZone','UTC'); % floor date to date at midnight
dirinfo_raw_yearX = dirinfo_raw_year(and([dirinfo_raw_year.name_datenum] >= datenum(date_from_x),[dirinfo_raw_year.name_datenum] <= datenum(date_to_x))); 
[~,index] = sortrows({dirinfo_raw_yearX.name_datenum}.'); dirinfo_raw_yearX = dirinfo_raw_yearX(index); clear index % sort by name; datenum could be date_modified   

% check if raw exist
if isempty(dirinfo_raw_yearX)
    error([datestr(bag.date_now) ' No heave data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
end  

% load data into workspace     
bag.Table_RAW = timetable;
bag.Table_RAW_dqf_03 = table;
for I2 = 1:1:numel(dirinfo_raw_yearX)
    % read heave
    [Table_RAW_temp, dqf_03_compl_raw_temp] = read_RADAC_Heave(dirinfo_raw_yearX(I2).name,dirinfo_raw_yearX(I2).folder);   
    [Table_RAW_temp, indexRAW] = sortrows(Table_RAW_temp); %#ok<ASGLU>
    bag.Table_RAW = [bag.Table_RAW; Table_RAW_temp];
    % creating quality control (qc) tables
    str_date_raw = regexp(dirinfo_raw_yearX(I2).name,'\d\d\d\d\d\d\d\d','match','once');
    startTime = datetime(str_date_raw,'InputFormat','yyyyMMdd','TimeZone','UTC');      
    Table_RAW_dqf_03_temp = table(startTime, dqf_03_compl_raw_temp,'VariableNames',{'Time', 'dqf_03_compl_raw'}); % collect timestamp of each file in table   
    bag.Table_RAW_dqf_03 = [bag.Table_RAW_dqf_03; Table_RAW_dqf_03_temp]; 
    clear *_temp str_date_raw startTime 
end; clear I2    
bag.Table_RAW_dqf_03 = table2timetable(bag.Table_RAW_dqf_03);
%%% RADAC / RADAC_SINGLE addition to create the right Time vector
    if height(bag.Table_RAW_dqf_03) == 1
        bag.Table_RAW_dqf_03 = [bag.Table_RAW_dqf_03; bag.Table_RAW_dqf_03];    
        bag.Table_RAW_dqf_03.Time(2) = bag.Table_RAW_dqf_03.Time(1) + days(1); 
        bag.Table_RAW_dqf_03 = retime(bag.Table_RAW_dqf_03,'minutely','linear');
    else
        bag.Table_RAW_dqf_03 = retime(bag.Table_RAW_dqf_03,'minutely','linear');
    end
    bag.Table_RAW_dqf_03 = bag.Table_RAW_dqf_03((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to
    bag.Table_RAW = bag.Table_RAW((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the timerange date_from to date_to
    bag.Table_RAW.Time.Format = 'yyyy-MM-dd HH:mm:ss.SSS';
    bag.Table_RAW_dqf_03.Time.Format = 'yyyy-MM-dd HH:mm:ss.SSS';
    
    % in operational mode, bag.Table_RAW.Time(end) and bag.date_to_x might
    % differ > 20 min, which causes an error in for-loop (Test04-Test10) =
    % no Table_RAW_temp. date_to and date_to_x needs to be adapted.
    % check if raw exist for selected timerange
    if isempty(bag.Table_RAW)
        error([datestr(bag.date_now) ' No heave data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
    end
    if abs(bag.Table_RAW.Time(end) - bag.date_to_x) > seconds(1)
        bag.date_to_x = bag.Table_RAW.Time(end);
        bag.date_to = bag.date_to_x - minutes(10);
        bag.Table_RAW_dqf_03 = bag.Table_RAW_dqf_03((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to
        bag.Table_RAW = bag.Table_RAW((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the timerange date_from to date_to
    end    
%%%
bag.Table_RAW_qc = timetable('RowTimes',bag.Table_RAW_dqf_03.Time); % 
bag.Table_RAW_qc0 = bag.Table_RAW_qc; % interim variable 
          
% check if raw exist for selected timerange
if isempty(bag.Table_RAW)
    error([datestr(bag.date_now) ' No heave data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
end

return