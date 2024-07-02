function [bag] = parser_radac_bo1(bag)

% select data for the last X+1 days 
% data needs to be selected by dir*.name because dir*.datenum is the last
% modified date of the file

% txt
dirinfo_txt_year = dir(fullfile(bag.s_incoming_folder,bag.s_station,'\**\*.txt'));
str_date = {dirinfo_txt_year.name}';
for I2=1:1:numel(str_date)   
    str_date_temp0 = regexp(str_date{I2,:},'(?<year>\d+)-(?<month>\d+)','match','once');
    str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyy-MM');  
    [Y,M,~] = ymd(str_date_temp1);
    str_date_temp2 = datetime(Y,M,31);
    dirinfo_txt_year(I2).name_datenum = datenum(str_date_temp2);
    clear str_date_temp* Y M D 
end; clear I2 str_date
dirinfo_txt_yearX = dirinfo_txt_year(([dirinfo_txt_year.name_datenum] >= datenum(bag.date_from_x))); 
[~,index] = sortrows({dirinfo_txt_yearX.name_datenum}.'); dirinfo_txt_yearX = dirinfo_txt_yearX(index); clear index 

% check if txt exist
if isempty(dirinfo_txt_yearX)
    disp([datestr(bag.date_now) ' No *.txt data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
    return
end

% load data into workspace  
% read txt
T_TXT = table;
for I2 = 1:1:numel(dirinfo_txt_yearX)
    T_TXT_tmp = read_txt_BO1(fullfile(dirinfo_txt_yearX(I2).folder,dirinfo_txt_yearX(I2).name));     
    T_TXT = [T_TXT; T_TXT_tmp]; %#ok<AGROW>
end
clear I2 T_TXT_tmp
T_TXT = sortrows(T_TXT, "Time");
T_TXT = unique(T_TXT); % remove duplicate rows with same time and data
T_TXT = table2timetable(T_TXT);
T_TXT = T_TXT((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days

% load data into workspace   
% his
T_HIS = T_TXT(:,{'VPED' 'VTPK'}); 

% hiw
T_HIW = T_TXT(:,{'VAVH' 'VEMH' 'VHZA'});

% lev
T_LEV = T_TXT(:,'SLEV_H1');

% sensor does not provide GPS information
T_GPS = timetable(T_HIS.Time,nan(height(T_HIS),1), nan(height(T_HIS),1), nan(height(T_HIS),1),'VariableNames',{'STATUS' 'LATITUDE' 'LONGITUDE'});

% data availability
if isempty(T_HIS)
    error([datestr(bag.date_now) ' No spectral data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
end

if isempty(T_HIW)
    error([datestr(bag.date_now) ' No zero-crossing data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
end

if isempty(T_LEV)
    error([datestr(bag.date_now) ' No waterlevel data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
end

% fill in the blanks
T_HIS.VHM0 = nan(height(T_HIS),1);
T_HIS.VTM02 = nan(height(T_HIS),1);
T_HIS.VPSP = nan(height(T_HIS),1);
T_HIS.VMDR = nan(height(T_HIS),1);

T_HIW.VZMX = nan(height(T_HIW),1);
T_HIW.VTZM = nan(height(T_HIW),1);
T_HIW.VH110 = nan(height(T_HIW),1);
T_HIW.VAVT = nan(height(T_HIW),1);
T_HIW.VTZA = nan(height(T_HIW),1);
T_HIW.VZNW = nan(height(T_HIW),1);

T_LEV.SLEV_H10 = nan(height(T_LEV),1);

% pack your bag
bag.T_TXT = T_TXT;
bag.T_HIW = T_HIW;
bag.T_HIS = T_HIS;
bag.T_GPS = T_GPS;  
bag.T_LEV = T_LEV;  

return