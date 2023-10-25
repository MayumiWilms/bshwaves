function [bag] = dqc_seastate_realtime_v2_5_tmc_from_to(incoming_folder, work_folder, outgoing_folder, log_folder, sensor, station, date_from, date_to, config_output) 

%% author: Mayumi Wilms, mayumi.wilms@bsh.com, BSH
%% date: 23.10.2023
%% version: 2.5

%{
% Real-time quality control tests for sea state (DWR, Radac, Radac Single)
% Looks for the timerange date_from to date_to (editable)

% detailed_qc_flag (dqf) contains each test result for every evaluated parameter
% final_qc_flag (fqf) contains the worst (= max) flag from detailed_qc_flag

% flags for real-time data (CMEMS 2017)
% 0 = Not evaluated: Data have not been QC-tested, or the information on quality is not available.
% 1 = Pass: Data have passed critical real-time QC tests and are deemed adequate for use as preliminary data.
% 2 = Probably good data
% 3 = Probably bad data, potentially correctable
% 4 = Fail: Data are considered to have failed one or more critical real-time QC checks. If they are disseminated at all, it should be readily apparent that they are not of acceptable quality.
% 9 = Missing data: Data are missing; used as a placeholder.
%}

%% input information for script 
bag.s_incoming_folder = incoming_folder; % data folder
bag.s_work_folder = work_folder; % meta files folder
bag.s_outgoing_folder = outgoing_folder; % output files folder
bag.s_log_folder = log_folder; % log files folder
bag.s_sensor = upper(sensor); % sensor = 'DWR';
bag.s_station = station; % station = 'BUD';
bag.d_C0hdr0tmc = str2double(config_output(1)); % output files with header = 0 & time correction  = 0
bag.d_C0hdr1tmc = str2double(config_output(2)); % output files with header = 0 & time correction  = 1
bag.d_C1hdr1tmc = str2double(config_output(3)); % output files with header = 1 & time correction  = 1
bag.d_C1hdr0tmc = str2double(config_output(4)); % output files with header = 1 & time correction  = 0

bag.date_now = datetime('now','TimeZone','UTC');        
bag.date_from = datetime(date_from,'TimeZone','UTC');
bag.date_to = datetime(date_to,'TimeZone','UTC');
bag.date_from_x = datetime(floor(datenum(bag.date_from - hours(24))),'ConvertFrom','datenum','TimeZone','UTC'); % floor date to date at midnight
bag.date_to_x = datetime(bag.date_to) + hours(2);
% in order to control the timerange date_from to date_to, one day before
% and 2 hours after have to be imported due to Test 14 Flat Line which
% needs 24 hours data before tested timerange and due to Test 13 Spike
% which needs succedding measurements; Note: timerange days are written in
% writetable at the end of the script. 

%% check if folder exist
if ~isfolder(bag.s_incoming_folder)
    disp([datestr(bag.date_now) ' Incoming folder ' bag.s_incoming_folder ' does not exist.'])
    return
end

if ~isfolder(bag.s_work_folder)
    disp([datestr(bag.date_now) ' Work folder ' bag.s_work_folder ' does not exist.'])
    return
end

if ~isfolder(bag.s_outgoing_folder)
    disp([datestr(bag.date_now) ' Outgoing folder ' bag.s_outgoing_folder ' does not exist.'])
    return
end

if ~isfolder(fullfile(bag.s_incoming_folder,bag.s_station))
    disp([datestr(bag.date_now) ' Station folder ' fullfile(bag.s_incoming_folder,bag.s_station) ' does not exist.'])
    return
end

%% read metadatabase
s_MetaDatabase = fullfile(bag.s_work_folder,'Metadatenbank.xlsx');
bag.metadatabase = read_metadatabase(s_MetaDatabase,bag.s_sensor);      
   
if isempty(bag.metadatabase)
    disp([datestr(bag.date_now) ' Metadatabase ' s_MetaDatabase ' does not exist.'])
    return    
end

%% parser
switch upper(bag.s_sensor)
    case 'DWR' 
        % var
        bag.VarNam_HIW =  {'VZMX','VTZM','VH110','VT110','VAVH','VAVT','VHZA',...
            'VTZA','VTZC','VZNW'};
        bag.VarNam_HIS =  {'VTPK','VPED','VPSP','VTM02','VHM0','VTM20','VTM01',...
            'VTM24','VTPC','VTNU','VTES','VPQP','VSTS','TEMP'};     
        
        % parser
        if contains(bag.s_station,{'HHF','STO'}) % select LKN stations
            [bag] = parser_dwr_lkn(bag);
        else
            [bag] = parser_dwr(bag);     
        end
      
    case 'RADAC'
        % var
        bag.VarNam =  {'Time','VHM0','dqf_VHM0','fqf_VHM0','VTPK','dqf_VTPK','fqf_VTPK','VTM02','dqf_VTM02','fqf_VTM02','VPED','dqf_VPED','fqf_VPED',...
            'VPSP','dqf_VPSP','fqf_VPSP','VZMX','dqf_VZMX','fqf_VZMX','VTZM','dqf_VTZM','fqf_VTZM','VH110','dqf_VH110','fqf_VH110','VAVH','dqf_VAVH','fqf_VAVH',...
            'VAVT','dqf_VAVT','fqf_VAVT','VTZA','dqf_VTZA','fqf_VTZA','VMDR','dqf_VMDR','fqf_VMDR','VHZA','dqf_VHZA','fqf_VHZA','VZNW','dqf_VZNW','fqf_VZNW',...
            'SLEV_H1','dqf_SLEV_H1','fqf_SLEV_H1','SLEV_H10','dqf_SLEV_H10','fqf_SLEV_H10'};      
        
        bag.VarNam_HIW =  {'VZMX','VTZM','VH110','VAVH','VAVT','VTZA','VHZA','VZNW'};
        bag.VarNam_HIS =  {'VHM0','VTPK','VTM02','VPED','VPSP','VMDR'};
        bag.VarNam_LEV =  {'SLEV_H1','SLEV_H10'};       
        
        % parser
        [bag] =  parser_radac(bag);  
        
    case 'RADAC_SINGLE'
        % var 
        bag.VarNam =  {'Time','VHM0','dqf_VHM0','fqf_VHM0','VTPK','dqf_VTPK','fqf_VTPK','VTM02','dqf_VTM02','fqf_VTM02','VZMX','dqf_VZMX','fqf_VZMX',...
            'VTZM','dqf_VTZM','fqf_VTZM','VH110','dqf_VH110','fqf_VH110','VAVH','dqf_VAVH','fqf_VAVH','VAVT','dqf_VAVT','fqf_VAVT','VTZA','dqf_VTZA','fqf_VTZA',...
            'VHZA','dqf_VHZA','fqf_VHZA','VZNW','dqf_VZNW','fqf_VZNW','SLEV_H1','dqf_SLEV_H1','fqf_SLEV_H1','SLEV_H10','dqf_SLEV_H10','fqf_SLEV_H10'};
        
        bag.VarNam_HIW =  {'VZMX','VTZM','VH110','VAVH','VAVT','VTZA','VHZA','VZNW'};
        bag.VarNam_HIS =  {'VHM0','VTPK','VTM02'};
        bag.VarNam_LEV =  {'SLEV_H1','SLEV_H10'};
        
        % parser
        [bag] =  parser_radac(bag);          
        
    case 'AWAC'        
        
    otherwise
        warning('Unexpected sensor type.')
end

%% remove problematic timestamps in HIS and GPS
[bag] = DQC_rmdate(bag); 

%% Date Test, Test 1
% checks if timestamps in datasets are logical
[bag] = DQC_Test01(bag);

%% Location Test, Test 2
% checks if lat and lon in gps.txt are correct; gps flag is handed over to
% the right timestamp of his, hiw, raw, spt; if a gps flag does not exist
% for a timestamp in his, hiw, raw, spt, the flag is 9 = missing value (for
% this timestamp)
[bag] = DQC_Test02(bag);

%% Completeness Test, Test 3
% checks for missing values in datasets, for raw and spt flags are computed
% when raw and spt are imported
[bag] = DQC_Test03(bag);

%% Range Test, Test 12
% checks if physical and sensor ranges are kept 
[bag] = DQC_Test12(bag); 

%% Spike Test, Test 13 
% Test checks for spikes / outliers, i.e. the difference between sequential
% measurements, where one measurement is quite different than adjacent
% ones. Test_value = |Vi-(Vi+1 + Vi-1)/2| - |(Vi+1 - Vi-1)/2|. Vi is the
% measurement being tested, see Copernicus Marine In Situ Team (2017, Test
% 5). First and last measurement are not considered (= 0, not evaluated),
% because adjacent values are needed for testing.
[bag] = DQC_Test13(bag);

%% Stuck Value Test, Test 14    
% Test checks for flat lines / stuck values in the aggregated parameters,
% within a tolerance value EPS to allow for numerical round-off error, see
% Copernicus Marine In Situ Team (2017, Test 6). Test compares a value with
% the last X hours, i.e. 24 hours; if there aren't enough measurements the
% test cannot be evaluated
[bag] = DQC_Test14(bag);

%% Rate of Change in Time Test, Test 15
% Test checks the rate of the change in time. It is based on the difference
% between the current value with the previous and next ones, see Copernicus
% Marine In Situ Team (2017, Test 7).
[bag] = DQC_Test15(bag);

%% Wave Period Test, Test 16
% Test checks if wave periods TZ (zero-upcrossing period), TP (peak
% period), and TC (crest period) have the right relations to each other,
% see SeaDataNet (2010, section 5.3).
[bag] = DQC_Test16(bag); 

%% final qc
% the order in detailed_qc_flag is essential because the position of the
% flags indicates the test number for which the flag is the result.
% therefore the timetable variables have to be sorted to make sure the
% order is right. Note: First 24 hours of Table_* are deleted because Test
% 13 Spike and Test 14 Flat Line are not evaluated.
[bag] = DQC_FinalQC_from_to(bag) ;

%% Copernicus Rule: If one main parameter fails, all parameters fail
% [bag] = DQC_CopernicusRule(bag);

%% sort and format tables to specific format of insida
[bag] = DQC_Formatting(bag);

%% writetable
% writes the qc results (timestamp, detailed_qc_flag, final_qc_flag) in a
% text file.
[bag] = DQC_writetable_from_to(bag);

disp([datestr(bag.date_now) ' Data quality control for station ' bag.s_station ' (' bag.s_sensor ') was successful.'])

return