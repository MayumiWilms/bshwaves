function [bag] = parser_dwr_spectrum(bag)

% select data
% data needs to be selected by dir*.name because dir*.datenum is the last
% modified date of the file
dirinfo_spt_year = dir(fullfile(bag.s_incoming_folder,bag.s_station,num2str(year(bag.date_from_x)),'\**\*.spt'));
str_date = {dirinfo_spt_year.name}';
for I2=1:1:numel(str_date)     
    str_date_spt = regexp(str_date{I2,:},'\d\d\d\d-\d\d-\d\dT\d\dh\d\d','match','once');
    startTime = datetime(str_date_spt,'InputFormat','yyyy-MM-dd''T''HH''h''mm'); 
    dirinfo_spt_year(I2).name_datenum = datenum(startTime); 
    clear str_date_spt startTime
end; clear I2 str_date
dirinfo_spt_yearX = dirinfo_spt_year(and([dirinfo_spt_year.name_datenum] >= datenum(bag.date_from_x),[dirinfo_spt_year.name_datenum] <= datenum(bag.date_to_x))); 
[~,index] = sortrows({dirinfo_spt_yearX.name_datenum}.'); dirinfo_spt_yearX = dirinfo_spt_yearX(index); clear index 

% check if spt exist
if isempty(dirinfo_spt_yearX)
    error([datestr(bag.date_now) ' No *.spt data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
end        

% load data into workspace     
bag.Table_SPT = timetable;
bag.Table_SPEC = timetable;
bag.Table_SPT_dqf_03 = table;
for I2 = 1:1:numel(dirinfo_spt_yearX)
    % read .spt
    [Table_SPT_temp, Table_SPEC_temp, dqf_03_compl_spt_temp] = read_DWR_SPT(dirinfo_spt_yearX(I2).name,dirinfo_spt_yearX(I2).folder) ;   
    [Table_SPT_temp, indexSPT] = sortrows(Table_SPT_temp); %#ok<ASGLU>
    bag.Table_SPT = [bag.Table_SPT; Table_SPT_temp];    
    [Table_SPEC_temp, indexSPEC] = sortrows(Table_SPEC_temp); %#ok<ASGLU>
    bag.Table_SPEC = [bag.Table_SPEC; Table_SPEC_temp];        
    % creating quality control (qc) tables
    str_date_spt = regexp(dirinfo_spt_yearX(I2).name,'\d\d\d\d-\d\d-\d\dT\d\dh\d\d','match','once');
    startTime = datetime(str_date_spt,'InputFormat','yyyy-MM-dd''T''HH''h''mm','TimeZone','UTC');      
    Table_SPT_dqf_03_temp = table(startTime, dqf_03_compl_spt_temp,'VariableNames',{'Time', 'dqf_03_compl_spt'}); % collect timestamp of each file in table   
    bag.Table_SPT_dqf_03 = [bag.Table_SPT_dqf_03; Table_SPT_dqf_03_temp]; 
    clear *_temp str_date_spt startTime 
end; clear I2    
bag.Table_SPT_dqf_03 = table2timetable(bag.Table_SPT_dqf_03);
bag.Table_SPT_qc = timetable('RowTimes',bag.Table_SPT_dqf_03.Time); % 
bag.Table_SPT_qc0 = bag.Table_SPT_qc; % interim variable  
    
% check if spt exist for selected timerange
if isempty(bag.Table_SPT) || isempty(bag.Table_SPEC)
    error([datestr(bag.date_now) ' No *.spt data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
end

return