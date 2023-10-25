function [bag] = DQC_radac_file_check(bag)

% open <STATION>_<SENSOR>_Insida.dat to remove last lines and read last timestamp
bag.s_filename = fullfile(bag.s_outgoing_folder,bag.s_station,strcat(bag.s_station,'_',bag.s_sensor,'_Insida.dat'));

switch upper(bag.s_sensor)
    case 'RADAC'
        if exist(bag.s_filename,'file') == 0 % if *.dat does not exist, then evaluate the last X days
            disp([datestr(bag.date_now) ' ' bag.s_filename ' is newly created.'])   
            bag.date_from = datetime('today','TimeZone','UTC') - days(bag.d_X);
            bag.date_to = bag.date_now;
            bag.date_from_x = bag.date_from - hours(24); 
            bag.date_to_x = bag.date_to;  
            % at least 24 hours have to be imported due to Test 14 Flat Line which
            % needs 24 hours data before tested timerange;
        else
            delimiter = '\t';
%             formatSpec = '%s %8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s %[^\n\r]';
%             formatSpec = '%s %8.4f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.4f%s%s%8.3f%s%s%8.4f%s%s%8.4f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.4f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s %[^\n\r]';
            formatSpec = '%s %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s %[^\n\r]';
            fileID = fopen(bag.s_filename,'r');
            dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
            fclose(fileID);
            % check if file is empty
            if ~isempty(dataArray{1,1})   
                T_RADAC_0 = table(dataArray{1:end-1}, 'VariableNames', bag.VarNam(1,:));   
                T_RADAC_0.Time = datetime(T_RADAC_0.Time,'InputFormat','yyyyMMddHHmm','TimeZone','UTC');
                T_RADAC_0 = table2timetable(T_RADAC_0);    
                % remove last X hours to overwrite eventual dummy values and
                % because of Test 13 Spike Test which has not been evaluated for
                % the last timestamp yet; remove timetamps older than X days
                T_RADAC_0 = T_RADAC_0(timerange(datetime('today','TimeZone','UTC') - days(bag.d_X), T_RADAC_0.Time(end) - hours(2),'openright'),:);   
                % determine date_then  
                if isempty(T_RADAC_0) % letztes kontrolliertes Datum ist älter als date_from = Datenlücke
                    disp([datestr(bag.date_now) ' ' bag.s_filename ' is too old. It will be newly created. Please check if there is a data gap.'])   
                    delete(bag.s_filename)
                    bag.date_from = datetime('today','TimeZone','UTC') - days(bag.d_X);
                    bag.date_to = bag.date_now;
                    bag.date_from_x = bag.date_from - hours(24); 
                    bag.date_to_x = bag.date_to;  
                    % at least 24 hours have to be imported due to Test 14 Flat Line which
                    % needs 24 hours data before tested timerange; 
                else
                    bag.date_from = datetime(T_RADAC_0.Time(end));
                    bag.date_to = bag.date_now;
                    bag.date_from_x = datetime(floor(datenum(bag.date_from - hours(24))),'ConvertFrom','datenum','TimeZone','UTC'); % floor date to date at midnight
                    bag.date_to_x = bag.date_to;  
                    % at least 24 hours have to be imported due to Test 14 Flat Line
                    % which needs 24 hours data before tested timerange; Note: only new
                    % measurements are written in writetable at the end of the script.

                    % set precision to %8.3f, num2str for a clearer structure in *.dat
%                     T_RADAC_0.VHM0 = num2str(T_RADAC_0.VHM0,'%8.4f'); 
%                     T_RADAC_0.VTPK = num2str(T_RADAC_0.VTPK,'%8.3f'); 
%                     T_RADAC_0.VTM02 = num2str(T_RADAC_0.VTM02,'%8.3f'); 
%                     T_RADAC_0.VPED = num2str(T_RADAC_0.VPED,'%8.3f'); 
%                     T_RADAC_0.VPSP = num2str(T_RADAC_0.VPSP,'%8.3f'); 
%                     T_RADAC_0.VZMX = num2str(T_RADAC_0.VZMX,'%8.4f'); 
%                     T_RADAC_0.VTZM = num2str(T_RADAC_0.VTZM,'%8.3f'); 
%                     T_RADAC_0.VH110 = num2str(T_RADAC_0.VH110,'%8.4f'); 
%                     T_RADAC_0.VAVH = num2str(T_RADAC_0.VAVH,'%8.4f'); 
%                     T_RADAC_0.VAVT = num2str(T_RADAC_0.VAVT,'%8.3f'); 
%                     T_RADAC_0.VTZA = num2str(T_RADAC_0.VTZA,'%8.3f');
%                     T_RADAC_0.VMDR = num2str(T_RADAC_0.VMDR,'%8.3f'); 
%                     T_RADAC_0.VHZA = num2str(T_RADAC_0.VHZA,'%8.4f'); 
%                     T_RADAC_0.VZNW = num2str(T_RADAC_0.VZNW,'%8.3f'); 
%                     T_RADAC_0.SLEV_H1 = num2str(T_RADAC_0.SLEV_H1,'%8.3f'); 
%                     T_RADAC_0.SLEV_H10 = num2str(T_RADAC_0.SLEV_H10,'%8.3f');                      
                    % write back into file
                    T_RADAC_0 = timetable2table(T_RADAC_0);
                    T_RADAC_0.Time.Format = 'yyyyMMddHHmm';
                    T_RADAC_0.Time = datestr(T_RADAC_0.Time,'yyyymmddHHMM');
                    T_RADAC_0 = table2array(T_RADAC_0);
                    fileID = fopen(bag.s_filename,'w');
%                     fprintf(fileID,'%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s \r\n',T_RADAC_0');
%                     fprintf(fileID,'%s\t%8.4f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.4f\t%s\t%s\t%8.3f\t%s\t%s\t%8.4f\t%s\t%s\t%8.4f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.4f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s \r\n',T_RADAC_0');
                    fprintf(fileID,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s \r\n',T_RADAC_0');
                    fclose(fileID);  
                end
            else % if *.dat is empty, then evaluate the last X days
                disp([datestr(bag.date_now) ' ' bag.s_filename ' is empty  or corrupted.'])
                bag.date_from = datetime('today','TimeZone','UTC') - days(bag.d_X);
                bag.date_to = bag.date_now;
                bag.date_from_x = bag.date_from - hours(24); 
                bag.date_to_x = bag.date_to;  
                % at least 24 hours VHZAe to be imported due to Test 14 Flat Line
                % which needs 24 hours data before tested timerange;
            end   
        end
        
    case 'RADAC_SINGLE'
        if exist(bag.s_filename,'file') == 0 % if *.dat does not exist, then evaluate the last X days
            disp([datestr(bag.date_now) ' ' bag.s_filename ' is newly created.'])   
            bag.date_from = datetime('today','TimeZone','UTC') - days(bag.d_X);
            bag.date_to = bag.date_now;
            bag.date_from_x = bag.date_from - hours(24); 
            bag.date_to_x = bag.date_to;  
            % at least 24 hours have to be imported due to Test 14 Flat Line which
            % needs 24 hours data before tested timerange;
        else
            bag.VarNam =  {'Time','VHM0','dqf_VHM0','fqf_VHM0','VTPK','dqf_VTPK','fqf_VTPK','VTM02','dqf_VTM02','fqf_VTM02','VPED','dqf_VPED','fqf_VPED',...
            'VPSP','dqf_VPSP','fqf_VPSP','VZMX','dqf_VZMX','fqf_VZMX','VTZM','dqf_VTZM','fqf_VTZM','VH110','dqf_VH110','fqf_VH110','VAVH','dqf_VAVH','fqf_VAVH',...
            'VAVT','dqf_VAVT','fqf_VAVT','VTZA','dqf_VTZA','fqf_VTZA','VMDR','dqf_VMDR','fqf_VMDR','VHZA','dqf_VHZA','fqf_VHZA','VZNW','dqf_VZNW','fqf_VZNW',...
            'SLEV_H1','dqf_SLEV_H1','fqf_SLEV_H1','SLEV_H10','dqf_SLEV_H10','fqf_SLEV_H10'};  
        
            delimiter = '\t';                         
%             formatSpec = '%s %8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s %[^\n\r]';
%             formatSpec = '%s %8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s%8.3f%s%s %[^\n\r]';
            formatSpec = '%s %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s %[^\n\r]';
            fileID = fopen(bag.s_filename,'r');
            dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
            fclose(fileID);
            % check if file is empty
            if ~isempty(dataArray{1,1})   
                T_RADAC_0 = table(dataArray{1:end-1}, 'VariableNames', bag.VarNam(1,:));   
                T_RADAC_0.Time = datetime(T_RADAC_0.Time,'InputFormat','yyyyMMddHHmm','TimeZone','UTC');
                T_RADAC_0 = table2timetable(T_RADAC_0);    
                % remove last X hours to overwrite eventual dummy values and
                % because of Test 13 Spike Test which has not been evaluated for
                % the last timestamp yet; remove timetamps older than X days
                T_RADAC_0 = T_RADAC_0(timerange(datetime('today','TimeZone','UTC') - days(bag.d_X), T_RADAC_0.Time(end) - hours(2),'openright'),:);   
                % determine date_then     
                if isempty(T_RADAC_0) % letztes kontrolliertes Datum ist älter als date_from = Datenlücke
                    disp([datestr(bag.date_now) ' ' bag.s_filename ' is too old. It will be newly created. Please check if there is a data gap.'])   
                    delete(bag.s_filename)
                    bag.date_from = datetime('today','TimeZone','UTC') - days(bag.d_X);
                    bag.date_to = bag.date_now;
                    bag.date_from_x = bag.date_from - hours(24); 
                    bag.date_to_x = bag.date_to;  
                    % at least 24 hours have to be imported due to Test 14 Flat Line which
                    % needs 24 hours data before tested timerange; 
                else
                    bag.date_from = datetime(T_RADAC_0.Time(end));
                    bag.date_to = bag.date_now;
                    bag.date_from_x = datetime(floor(datenum(bag.date_from - hours(24))),'ConvertFrom','datenum','TimeZone','UTC'); % floor date to date at midnight
                    bag.date_to_x = bag.date_to;  
                    % at least 24 hours VHZAe to be imported due to Test 14 Flat Line
                    % which needs 24 hours data before tested timerange; Note: only new
                    % measurements are written in writetable at the end of the script.

                    % set precision to %8.3f, num2str for a clearer structure in *.dat
%                     T_RADAC_0.VHM0 = num2str(T_RADAC_0.VHM0,'%8.3f'); 
%                     T_RADAC_0.VTPK = num2str(T_RADAC_0.VTPK,'%8.3f'); 
%                     T_RADAC_0.VTM02 = num2str(T_RADAC_0.VTM02,'%8.3f'); 
%                     T_RADAC_0.VZMX = num2str(T_RADAC_0.VZMX,'%8.3f'); 
%                     T_RADAC_0.VTZM = num2str(T_RADAC_0.VTZM,'%8.3f'); 
%                     T_RADAC_0.VH110 = num2str(T_RADAC_0.VH110,'%8.3f'); 
%                     T_RADAC_0.VAVH = num2str(T_RADAC_0.VAVH,'%8.3f'); 
%                     T_RADAC_0.VAVT = num2str(T_RADAC_0.VAVT,'%8.3f'); 
%                     T_RADAC_0.VTZA = num2str(T_RADAC_0.VTZA,'%8.3f');
%                     T_RADAC_0.VHZA = num2str(T_RADAC_0.VHZA,'%8.3f'); 
%                     T_RADAC_0.VZNW = num2str(T_RADAC_0.VZNW,'%8.3f'); 
%                     T_RADAC_0.SLEV_H1 = num2str(T_RADAC_0.SLEV_H1,'%8.3f'); 
%                     T_RADAC_0.SLEV_H10 = num2str(T_RADAC_0.SLEV_H10,'%8.3f');                      
%                     T_RADAC_0.VHM0 = num2str(T_RADAC_0.VHM0,'%8.3f'); 
%                     T_RADAC_0.VTPK = num2str(T_RADAC_0.VTPK,'%8.3f'); 
%                     T_RADAC_0.VTM02 = num2str(T_RADAC_0.VTM02,'%8.3f'); 
%                     T_RADAC_0.VPED = num2str(T_RADAC_0.VPED,'%8.3f'); 
%                     T_RADAC_0.VPSP = num2str(T_RADAC_0.VPSP,'%8.3f'); 
%                     T_RADAC_0.VZMX = num2str(T_RADAC_0.VZMX,'%8.3f'); 
%                     T_RADAC_0.VTZM = num2str(T_RADAC_0.VTZM,'%8.3f'); 
%                     T_RADAC_0.VH110 = num2str(T_RADAC_0.VH110,'%8.3f'); 
%                     T_RADAC_0.VAVH = num2str(T_RADAC_0.VAVH,'%8.3f'); 
%                     T_RADAC_0.VAVT = num2str(T_RADAC_0.VAVT,'%8.3f'); 
%                     T_RADAC_0.VTZA = num2str(T_RADAC_0.VTZA,'%8.3f');
%                     T_RADAC_0.VMDR = num2str(T_RADAC_0.VMDR,'%8.3f'); 
%                     T_RADAC_0.VHZA = num2str(T_RADAC_0.VHZA,'%8.3f'); 
%                     T_RADAC_0.VZNW = num2str(T_RADAC_0.VZNW,'%8.3f'); 
%                     T_RADAC_0.SLEV_H1 = num2str(T_RADAC_0.SLEV_H1,'%8.3f'); 
%                     T_RADAC_0.SLEV_H10 = num2str(T_RADAC_0.SLEV_H10,'%8.3f');                     
                    % write back into file
                    T_RADAC_0 = timetable2table(T_RADAC_0);
                    T_RADAC_0.Time.Format = 'yyyyMMddHHmm';
                    T_RADAC_0.Time = datestr(T_RADAC_0.Time,'yyyymmddHHMM');
                    T_RADAC_0 = table2array(T_RADAC_0);
                    fileID = fopen(bag.s_filename,'w');
%                     fprintf(fileID,'%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s \r\n',T_RADAC_0');
%                     fprintf(fileID,'%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s\t%8.3f\t%s\t%s \r\n',T_RADAC_0');
                    fprintf(fileID,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s \r\n',T_RADAC_0');
                    fclose(fileID);                        
                end        
            else % if *.dat is empty, then evaluate the last X days
                disp([datestr(bag.date_now) ' ' bag.s_filename ' is empty  or corrupted.'])
                bag.date_from = datetime('today','TimeZone','UTC') - days(bag.d_X);
                bag.date_to = bag.date_now;
                bag.date_from_x = bag.date_from - hours(24); 
                bag.date_to_x = bag.date_to;  
                % at least 24 hours VHZAe to be imported due to Test 14 Flat Line
                % which needs 24 hours data before tested timerange;
            end
            bag.VarNam =  {'Time','VHM0','dqf_VHM0','fqf_VHM0','VTPK','dqf_VTPK','fqf_VTPK','VTM02','dqf_VTM02','fqf_VTM02','VZMX','dqf_VZMX','fqf_VZMX',...
            'VTZM','dqf_VTZM','fqf_VTZM','VH110','dqf_VH110','fqf_VH110','VAVH','dqf_VAVH','fqf_VAVH','VAVT','dqf_VAVT','fqf_VAVT','VTZA','dqf_VTZA','fqf_VTZA',...
            'VHZA','dqf_VHZA','fqf_VHZA','VZNW','dqf_VZNW','fqf_VZNW','SLEV_H1','dqf_SLEV_H1','fqf_SLEV_H1','SLEV_H10','dqf_SLEV_H10','fqf_SLEV_H10'};
        end        
        
    otherwise
        warning('Unexpected sensor type.')     
        
end

return