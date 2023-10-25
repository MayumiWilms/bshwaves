function [bag] = parser_dwr_heave(bag)

% select data
% data needs to be selected by dir*.name because dir*.datenum is the last
% modified date of the file
dirinfo_raw_year = dir(fullfile(bag.s_incoming_folder,bag.s_station,num2str(year(bag.date_from_x)),'\**\*.raw'));
str_date = {dirinfo_raw_year.name}';
for I2=1:1:numel(str_date)     
    str_date_raw = regexp(str_date{I2,:},'\d\d\d\d-\d\d-\d\dT\d\dh\d\d','match','once');
    startTime = datetime(str_date_raw,'InputFormat','yyyy-MM-dd''T''HH''h''mm'); 
    dirinfo_raw_year(I2).name_datenum = datenum(startTime); 
    clear str_date_raw startTime
end; clear I2 str_date
dirinfo_raw_yearX = dirinfo_raw_year(and([dirinfo_raw_year.name_datenum] >= datenum(bag.date_from_x),[dirinfo_raw_year.name_datenum] <= datenum(bag.date_to_x))); 
[~,index] = sortrows({dirinfo_raw_yearX.name_datenum}.'); dirinfo_raw_yearX = dirinfo_raw_yearX(index); clear index 

% check if raw exist
if isempty(dirinfo_raw_yearX)
    error([datestr(bag.date_now) ' No *.raw data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
end        

% load data into workspace     
bag.Table_RAW = timetable;
bag.Table_RAW_dqf_03 = table;
for I2 = 1:1:numel(dirinfo_raw_yearX)
    % read .raw
    [Table_RAW_temp, dqf_03_compl_raw_temp] = read_DWR_RAW(dirinfo_raw_yearX(I2).name,dirinfo_raw_yearX(I2).folder) ;   
    [Table_RAW_temp, indexRAW] = sortrows(Table_RAW_temp); %#ok<ASGLU>
    bag.Table_RAW = [bag.Table_RAW; Table_RAW_temp];
    % creating quality control (qc) tables
    str_date_raw = regexp(dirinfo_raw_yearX(I2).name,'\d\d\d\d-\d\d-\d\dT\d\dh\d\d','match','once');
    startTime = datetime(str_date_raw,'InputFormat','yyyy-MM-dd''T''HH''h''mm','TimeZone','UTC');      
    Table_RAW_dqf_03_temp = table(startTime, dqf_03_compl_raw_temp,'VariableNames',{'Time', 'dqf_03_compl_raw'}); % collect timestamp of each file in table   
    bag.Table_RAW_dqf_03 = [bag.Table_RAW_dqf_03; Table_RAW_dqf_03_temp]; 
    clear *_temp str_date_raw startTime 
end; clear I2    
bag.Table_RAW_dqf_03 = table2timetable(bag.Table_RAW_dqf_03);
bag.Table_RAW_qc = timetable('RowTimes',bag.Table_RAW_dqf_03.Time); % 
bag.Table_RAW_qc0 = bag.Table_RAW_qc; % interim variable  
    
% check if raw exist for selected timerange
if isempty(bag.Table_RAW)
    error([datestr(bag.date_now) ' No *.raw data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
end

return