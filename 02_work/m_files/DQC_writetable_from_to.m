function [bag] = DQC_writetable_from_to(bag)

if exist(fullfile(bag.s_outgoing_folder,bag.s_station),'dir') == 0
    mkdir(fullfile(bag.s_outgoing_folder,bag.s_station));
end

if isfield(bag,'Table_RAW')  
    % heave
%     save(string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_HEAVE_v12_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.mat'))),'bag')
%     writetimetable(bag.Table_RAW_csv,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_hdr_HEAVE_v12_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.csv'))),'Delimiter','tab','WriteVariableNames',true)
    WriteTableWithUnits(bag.Table_RAW_csv,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_hdr_unit_HEAVE_v12_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.csv'))));
    
elseif isfield(bag,'Table_SPT')
    % spectrum
%     save(string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_SPECTRUM_v12_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.mat'))),'bag')
%     writetimetable(bag.Table_SPEC_csv,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_hdr_SPEC_v12_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.csv'))),'Delimiter','tab','WriteVariableNames',true)    
    WriteTableWithUnits(bag.Table_SPEC_csv,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_hdr_unit_SPEC_v12_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.csv'))));
    
	switch upper(bag.s_sensor)
        case 'DWR' 
%             writetimetable(bag.Table_SPT_csv,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_hdr_SPECTRUM_v12_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.csv'))),'Delimiter','tab','WriteVariableNames',true)
            WriteTableWithUnits(bag.Table_SPT_csv,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_hdr_unit_SPECTRUM_v12_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.csv'))));
    
        case {'RADAC', 'RADAC_SINGLE'}
            
        otherwise
            warning('Unexpected sensor type.')        
	end
    
else
    switch upper(bag.s_sensor)
        case 'DWR'
            % Time Correction GPS and HIS
            % gps
            bag.T_GPS_qc_tmcr = bag.T_GPS_qc;    
            bag.T_GPS_qc_tmcr.Time = dateshift(bag.T_GPS_qc_tmcr.Time,'start','minute','nearest'); % dateshift seconds to nearest minute
            bag.T_GPS_qc_tmcr.Time.Minute = 30 * floor(bag.T_GPS_qc_tmcr.Time.Minute/30); % dateshift time variable to the closest hour or half-hour
            bag.T_GPS_qc_tmcr.Time = bag.T_GPS_qc_tmcr.Time - duration([00 30 00]);           

            % his
            bag.T_HIS_qc_tmcr = bag.T_HIS_qc;
            bag.T_HIS_qc_tmcr.Time = dateshift(bag.T_HIS_qc_tmcr.Time,'start','minute','nearest'); % dateshift seconds to nearest minute
            bag.T_HIS_qc_tmcr.Time.Minute = 30 * floor(bag.T_HIS_qc_tmcr.Time.Minute/30); % dateshift time variable to the closest hour or half-hour
            bag.T_HIS_qc_tmcr.Time = bag.T_HIS_qc_tmcr.Time - duration([00 30 00]);

            % Header = NO && TimeCorrection = NO (InSiDa)
            if bag.d_C0hdr0tmc == 1 
                % gps
                writetable(bag.T_GPS_qc,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_Insida_GPS_v22_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.dat'))),'Delimiter','tab','WriteVariableNames',false)
                % his
                writetable(bag.T_HIS_qc,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_Insida_HIS_v22_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.dat'))),'Delimiter','tab','WriteVariableNames',false)
                % hiw
                writetable(bag.T_HIW_qc,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_Insida_HIW_v22_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.dat'))),'Delimiter','tab','WriteVariableNames',false)
            end

            % Header = YES && TimeCorrection = NO
            if bag.d_C1hdr0tmc == 1 
                % gps
                writetable(bag.T_GPS_qc,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_hdr_GPS_v22_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.dat'))),'Delimiter','tab','WriteVariableNames',true)
                % his
                writetable(bag.T_HIS_qc,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_hdr_HIS_v22_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.dat'))),'Delimiter','tab','WriteVariableNames',true)
                % hiw
                writetable(bag.T_HIW_qc,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_hdr_HIW_v22_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.dat'))),'Delimiter','tab','WriteVariableNames',true)    
            end        
            
            % Header = NO && TimeCorrection = YES (RAVE Forschungsarchiv)
            if bag.d_C0hdr1tmc == 1 
                % gps
                writetable(bag.T_GPS_qc_tmcr,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_tmc_GPS_v22_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.dat'))),'Delimiter','tab','WriteVariableNames',false)
                % his
                writetable(bag.T_HIS_qc_tmcr,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_tmc_HIS_v22_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.dat'))),'Delimiter','tab','WriteVariableNames',false)
                % hiw
                writetable(bag.T_HIW_qc,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_HIW_v22_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.dat'))),'Delimiter','tab','WriteVariableNames',false)    
            end

            % Header = YES && TimeCorrection = YES (Tableau)
            if bag.d_C1hdr1tmc == 1
                % gps
                writetable(bag.T_GPS_qc_tmcr,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_hdr_tmc_GPS_v22_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.dat'))),'Delimiter','tab','WriteVariableNames',true)
                % his
                writetable(bag.T_HIS_qc_tmcr,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_hdr_tmc_HIS_v22_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.dat'))),'Delimiter','tab','WriteVariableNames',true)
                % hiw
                writetable(bag.T_HIW_qc,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_hdr_HIW_v22_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.dat'))),'Delimiter','tab','WriteVariableNames',true)    
            end                

        case {'RADAC'}           
            bag.Table_qc_array = bag.Table_qc; 
            bag.Table_qc_array.Time = datestr(bag.Table_qc_array.Time,'yyyymmddHHMM');
            bag.Table_qc_array = table2array(bag.Table_qc_array);
            bag.s_filename = fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_Insida_v22_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.dat'));

            % Header = NO && TimeCorrection = NO (InSiDa)
            if bag.d_C0hdr0tmc == 1 
%                 fileID = fopen(bag.s_filename,'w');
%                 fprintf(fileID,'%s\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f \r\n',bag.Table_qc_array');
%                 fclose(fileID);   
                writetable(bag.Table_qc, bag.s_filename,'Delimiter','tab','WriteVariableNames',false)      
            end

            % Header = YES && TimeCorrection = NO (Tableau)
            if bag.d_C1hdr0tmc == 1 
                bag.s_filename_hdr = string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_hdr_v22_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.dat')));
                writetable(bag.Table_qc, bag.s_filename_hdr,'Delimiter','tab','WriteVariableNames',true)                               
            end         

        case 'RADAC_SINGLE'      
            bag.Table_qc_array = bag.Table_qc; 
            bag.Table_qc_array.Time = datestr(bag.Table_qc_array.Time,'yyyymmddHHMM');
            bag.Table_qc_array = table2array(bag.Table_qc_array);
            bag.s_filename = fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_Insida_v22_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.dat'));

            % Header = NO && TimeCorrection = NO (InSiDa)
            if bag.d_C0hdr0tmc == 1 
%                 fileID = fopen(bag.s_filename,'w');
% %                 fprintf(fileID,'%s\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f \r\n',bag.Table_qc_array');
% %                 fprintf(fileID,'%s\t%8.4f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.4f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.4f\t%s\t%.0f\t%8.4f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.4f\t%s\t%.0f\t%8.0f\t%s\t%.0f\t%8.4f\t%s\t%.0f\t%8.4f\t%s\t%.0f \r\n',bag.Table_qc_array');
%                 fprintf(fileID,'%s\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f\t%8.3f\t%s\t%.0f \r\n',bag.Table_qc_array');
%                 fclose(fileID);   
                writetable(bag.Table_qc, bag.s_filename,'Delimiter','tab','WriteVariableNames',false)   
            end

            % Header = YES && TimeCorrection = NO (Tableau)
            if bag.d_C1hdr0tmc == 1 
                bag.s_filename_hdr = string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_hdr_v22_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.dat')));
                writetable(bag.Table_qc, bag.s_filename_hdr,'Delimiter','tab','WriteVariableNames',true)                            
            end

        case 'AWAC'
            
        case 'FINODB'
            % Header = NO && TimeCorrection = NO (InSiDa)
            if bag.d_C0hdr0tmc == 1 
                % Table_qc
                writetable(bag.Table_qc,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_Insida_v22_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.dat'))),'Delimiter','tab','WriteVariableNames',false)                
            end                  

            % Header = YES && TimeCorrection = NO
            if bag.d_C1hdr0tmc == 1 
                % Table_qc
                writetable(bag.Table_qc,string(fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_hdr_v22_',datestr(bag.date_from,'yyyy-mm-dd'),'_',datestr(bag.date_to,'yyyy-mm-dd'),'.dat'))),'Delimiter','tab','WriteVariableNames',true)                
            end        

        otherwise
            warning('Unexpected sensor type.')        
    end   
end

return