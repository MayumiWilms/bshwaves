function [bag] = DQC_Formatting(bag)

if isfield(bag,'Table_RAW')  

    % formatting *.mat
    bag.Table_RAW.Time.Format = 'yyyy-MM-dd''T''HH:mm:ss.SSS''Z';
    bag.Table_RAW_qc.Time.Format = 'yyyy-MM-dd''T''HH:mm:ss.SSS''Z';
    
    switch upper(bag.s_sensor)
        case 'DWR' 
            % sort
            bag.Table_RAW = bag.Table_RAW(:,{'heave' 'north' 'west' 'status' 'despiked'});

            % add dqf and fqf to Table_RAW to make a selection of good data easier
            for i3 = 1:1:height(bag.Table_RAW_qc)
                bag.Table_RAW.DQF(timerange(bag.Table_RAW_qc.Time(i3), bag.Table_RAW_qc.Time(i3)+ minutes(30) - seconds(1/1.28), 'closed')) = bag.Table_RAW_qc.dqf_heave(i3);
                bag.Table_RAW.FQF(timerange(bag.Table_RAW_qc.Time(i3), bag.Table_RAW_qc.Time(i3)+ minutes(30) - seconds(1/1.28), 'closed')) = bag.Table_RAW_qc.fqf_heave(i3); 
            end; clear i3;

            % add units
            bag.Table_RAW.Properties.VariableUnits =  {'m','m','m','-','m','-','-'};
                        
            % formatting *.csv
            % set precision for a clearer structure in *.csv
            bag.Table_RAW_csv = bag.Table_RAW;
            bag.Table_RAW_csv.heave = num2str(bag.Table_RAW_csv.heave,'%8.4f'); 
            bag.Table_RAW_csv.north = num2str(bag.Table_RAW_csv.north,'%8.4f'); 
            bag.Table_RAW_csv.west = num2str(bag.Table_RAW_csv.west,'%8.4f'); 
            bag.Table_RAW_csv.despiked = num2str(bag.Table_RAW_csv.despiked,'%8.4f');       
            
        case {'RADAC', 'RADAC_SINGLE'}
            % add dqf and fqf to Table_RAW to make a selection of good data easier
            for i3 = 1:1:height(bag.Table_RAW_qc)
                bag.Table_RAW.DQF(timerange(bag.Table_RAW_qc.Time(i3) - minutes(10), bag.Table_RAW_qc.Time(i3) + minutes(10), 'openright')) = bag.Table_RAW_qc.dqf_heave(i3);
                bag.Table_RAW.FQF(timerange(bag.Table_RAW_qc.Time(i3) - minutes(10), bag.Table_RAW_qc.Time(i3) + minutes(10), 'openright')) = bag.Table_RAW_qc.fqf_heave(i3); 
            end; clear i3;

            % add units
            bag.Table_RAW.Properties.VariableUnits =  {'m','-','-'};
                        
            % if heave is nan, dqf_04 to dqf_09 and fqf is 4
            indxn = find(isnan(bag.Table_RAW.heave));
            if ~isempty(indxn)    
                for i = 1:1:length(indxn)
                    bag.Table_RAW.DQF{indxn(i)}(4:9) = '444444';
                end; clear i;
                bag.Table_RAW.FQF(isnan(bag.Table_RAW.heave)) = 4; % fail
            end
            
            %
            bag.Table_RAW = bag.Table_RAW((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to

            % formatting *.csv
            % set precision for a clearer structure in *.csv
            bag.Table_RAW_csv = bag.Table_RAW;
            bag.Table_RAW_csv.heave = num2str(bag.Table_RAW_csv.heave,'%8.4f'); 

        case 'AWAC'       
                
        case 'FINODB'

        otherwise
            warning('Unexpected sensor type.')
    end
    
elseif isfield(bag,'Table_SPT')
    
    % formatting *.mat
    bag.Table_SPT.Time.Format = 'yyyy-MM-dd''T''HH:mm:ss.SSS''Z';
    bag.Table_SPT_qc.Time.Format = 'yyyy-MM-dd''T''HH:mm:ss.SSS''Z';
    bag.Table_SPEC.Time.Format = 'yyyy-MM-dd''T''HH:mm:ss.SSS''Z';
    %TIME = days(bag.Table_SPEC.Time - datetime(1950,01,01,00,00,00,'TimeZone','UTC'));  
    
    switch upper(bag.s_sensor)
        case 'DWR'   
            % sort
            bag.Table_SPEC = bag.Table_SPEC(:,{'f' 'df' 'Sf' 'Dirf' 'Sprf' 'SfSmax' 'Skewf' 'Kurtf'});

            % add dqf and fqf to Table_SPT to make a selection of good data easier
            for i3 = 1:1:height(bag.Table_SPT_qc)
                bag.Table_SPT.DQF(bag.Table_SPT_qc.Time(i3)) = bag.Table_SPT_qc.dqf_spectrum(bag.Table_SPT_qc.Time(i3));
                bag.Table_SPT.FQF(bag.Table_SPT_qc.Time(i3)) = bag.Table_SPT_qc.fqf_spectrum(bag.Table_SPT_qc.Time(i3));
            end; clear i3;
            
            % add dqf and fqf to Table_SPEC to make a selection of good data easier
            for i3 = 1:1:height(bag.Table_SPT_qc)
                bag.Table_SPEC.DQF(bag.Table_SPT_qc.Time(i3)) = bag.Table_SPT_qc.dqf_spectrum(bag.Table_SPT_qc.Time(i3));
                bag.Table_SPEC.FQF(bag.Table_SPT_qc.Time(i3)) = bag.Table_SPT_qc.fqf_spectrum(bag.Table_SPT_qc.Time(i3));
            end; clear i3;            
            
            % add units
            bag.Table_SPT.Properties.VariableUnits = {'-','m','s','m2 s','degrees_C','degrees_C','-','-','-','-','degree','degree','-','-'};
            bag.Table_SPEC.Properties.VariableUnits = {'Hz','Hz','m2 s','degree','degree','-','-','-','-','-'};

            % formatting *.csv
            % set precision for a clearer structure in *.csv
            bag.Table_SPT_csv = bag.Table_SPT;
            bag.Table_SPT_csv.tn = num2str(bag.Table_SPT_csv.tn,'%8.0f'); 
            bag.Table_SPT_csv.H_m0 = num2str(bag.Table_SPT_csv.H_m0,'%8.3f'); 
            bag.Table_SPT_csv.T_z = num2str(bag.Table_SPT_csv.T_z,'%8.3f'); 
            bag.Table_SPT_csv.Smax = num2str(bag.Table_SPT_csv.Smax,'%8.4E'); 
            bag.Table_SPT_csv.Tref = num2str(bag.Table_SPT_csv.Tref,'%8.2f'); 
            bag.Table_SPT_csv.Tsea = num2str(bag.Table_SPT_csv.Tsea,'%8.2f'); 
            bag.Table_SPT_csv.Bat = num2str(bag.Table_SPT_csv.Bat,'%8.0f'); 
            bag.Table_SPT_csv.Av = num2str(bag.Table_SPT_csv.Av,'%8.5f'); 
            bag.Table_SPT_csv.Ax = num2str(bag.Table_SPT_csv.Ax,'%8.5f'); 
            bag.Table_SPT_csv.Ay = num2str(bag.Table_SPT_csv.Ay,'%8.5f'); 
            bag.Table_SPT_csv.Ori = num2str(bag.Table_SPT_csv.Ori,'%8.3f'); 
            bag.Table_SPT_csv.Incli = num2str(bag.Table_SPT_csv.Incli,'%8.3f'); 
            
            bag.Table_SPEC_csv = bag.Table_SPEC;
            bag.Table_SPEC_csv.f = num2str(bag.Table_SPEC_csv.f,'%8.3f'); 
            bag.Table_SPEC_csv.SfSmax = num2str(bag.Table_SPEC_csv.SfSmax,'%8.4E'); 
            bag.Table_SPEC_csv.Dirf = num2str(bag.Table_SPEC_csv.Dirf,'%8.1f'); 
            bag.Table_SPEC_csv.Sprf = num2str(bag.Table_SPEC_csv.Sprf,'%8.1f'); 
            bag.Table_SPEC_csv.Skewf = num2str(bag.Table_SPEC_csv.Skewf,'%8.2f');
            bag.Table_SPEC_csv.Kurtf = num2str(bag.Table_SPEC_csv.Kurtf,'%8.2f'); 
            bag.Table_SPEC_csv.Sf = num2str(bag.Table_SPEC_csv.Sf,'%8.6f');
            bag.Table_SPEC_csv.df = num2str(bag.Table_SPEC_csv.df,'%8.4f');
            
            % change variablenames to CMEMS code            
            bag.Table_SPT.Properties.VariableNames{contains(bag.Table_SPT.Properties.VariableNames,'H_m0')} = 'VHM0';
            bag.Table_SPT.Properties.VariableNames{contains(bag.Table_SPT.Properties.VariableNames,'T_z')} = 'VTM02';         
            bag.Table_SPT.Properties.VariableNames{contains(bag.Table_SPT.Properties.VariableNames,'Smax')} = 'VEPK';
            bag.Table_SPT.Properties.VariableNames{contains(bag.Table_SPT.Properties.VariableNames,'Tsea')} = 'TEMP';
            
            bag.Table_SPEC.Properties.VariableNames = regexprep(string(bag.Table_SPEC.Properties.VariableNames), "\<f\>", "FREQUENCY");            
            bag.Table_SPEC.Properties.VariableNames{contains(bag.Table_SPEC.Properties.VariableNames,'SfSmax')} = 'VSPEC1D_VEPK';
            bag.Table_SPEC.Properties.VariableNames{contains(bag.Table_SPEC.Properties.VariableNames,'Dirf')} = 'THETA1';
            bag.Table_SPEC.Properties.VariableNames{contains(bag.Table_SPEC.Properties.VariableNames,'Sprf')} = 'STHETA1';
            bag.Table_SPEC.Properties.VariableNames{contains(bag.Table_SPEC.Properties.VariableNames,'Sf')} = 'VSPEC1D';            
            bag.Table_SPEC.Properties.VariableNames{contains(bag.Table_SPEC.Properties.VariableNames,'df')} = 'DELTA_FREQUENCY';            
    
            bag.Table_SPT_csv.Properties.VariableNames{contains(bag.Table_SPT_csv.Properties.VariableNames,'H_m0')} = 'VHM0';
            bag.Table_SPT_csv.Properties.VariableNames{contains(bag.Table_SPT_csv.Properties.VariableNames,'T_z')} = 'VTM02';           
            bag.Table_SPT_csv.Properties.VariableNames{contains(bag.Table_SPT_csv.Properties.VariableNames,'Smax')} = 'VEPK';            
            bag.Table_SPT_csv.Properties.VariableNames{contains(bag.Table_SPT_csv.Properties.VariableNames,'Tsea')} = 'TEMP';
            
            bag.Table_SPEC_csv.Properties.VariableNames = regexprep(string(bag.Table_SPEC_csv.Properties.VariableNames), "\<f\>", "FREQUENCY");            
            bag.Table_SPEC_csv.Properties.VariableNames{contains(bag.Table_SPEC_csv.Properties.VariableNames,'SfSmax')} = 'VSPEC1D_VEPK';
            bag.Table_SPEC_csv.Properties.VariableNames{contains(bag.Table_SPEC_csv.Properties.VariableNames,'Dirf')} = 'THETA1';
            bag.Table_SPEC_csv.Properties.VariableNames{contains(bag.Table_SPEC_csv.Properties.VariableNames,'Sprf')} = 'STHETA1';
            bag.Table_SPEC_csv.Properties.VariableNames{contains(bag.Table_SPEC_csv.Properties.VariableNames,'Sf')} = 'VSPEC1D';            
            bag.Table_SPEC_csv.Properties.VariableNames{contains(bag.Table_SPEC_csv.Properties.VariableNames,'df')} = 'DELTA_FREQUENCY';            
    
        case 'RADAC'    
            % sort
            bag.Table_SPEC = bag.Table_SPEC(:,{'f' 'df' 'Sf' 'Th010' 'S0bh10'});

            % add dqf and fqf to Table_SPEC to make a selection of good data easier
            tu = unique(bag.Table_SPEC.Time); % find unique time vector
            for i3 = 1:1:height(tu)
                bag.Table_SPEC.DQF(tu(i3)) = bag.Table_SPT_qc.dqf_spectrum(tu(i3));
                bag.Table_SPEC.FQF(tu(i3)) = bag.Table_SPT_qc.fqf_spectrum(tu(i3));
            end; clear i3 tu; 
            %
            bag.Table_SPEC = bag.Table_SPEC((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to
            
            % add units
            bag.Table_SPEC.Properties.VariableUnits =  {'Hz','Hz','m2 s','degree','degree','-','-'};

            % formatting *.csv
            % set precision for a clearer structure in *.csv
            bag.Table_SPEC_csv = bag.Table_SPEC;
            bag.Table_SPEC_csv.f = num2str(bag.Table_SPEC_csv.f,'%8.3f'); 
            bag.Table_SPEC_csv.Sf = num2str(bag.Table_SPEC_csv.Sf,'%8.6f'); 
            bag.Table_SPEC_csv.df = num2str(bag.Table_SPEC_csv.df,'%8.3f'); 
            bag.Table_SPEC_csv.Th010 = num2str(bag.Table_SPEC_csv.Th010,'%8.2f'); 
            bag.Table_SPEC_csv.S0bh10 = num2str(bag.Table_SPEC_csv.S0bh10,'%8.2f'); 
            
            % change variablenames to CMEMS code            
            bag.Table_SPEC.Properties.VariableNames = regexprep(string(bag.Table_SPEC.Properties.VariableNames), "\<f\>", "FREQUENCY");
            bag.Table_SPEC.Properties.VariableNames{contains(bag.Table_SPEC.Properties.VariableNames,'Sf')} = 'VSPEC1D';            
            bag.Table_SPEC.Properties.VariableNames{contains(bag.Table_SPEC.Properties.VariableNames,'df')} = 'DELTA_FREQUENCY';            
            
            bag.Table_SPEC_csv.Properties.VariableNames = regexprep(string(bag.Table_SPEC_csv.Properties.VariableNames), "\<f\>", "FREQUENCY");
            bag.Table_SPEC_csv.Properties.VariableNames{contains(bag.Table_SPEC_csv.Properties.VariableNames,'Sf')} = 'VSPEC1D';
            bag.Table_SPEC_csv.Properties.VariableNames{contains(bag.Table_SPEC_csv.Properties.VariableNames,'df')} = 'DELTA_FREQUENCY';
            
            bag.Table_SPEC.Properties.VariableNames{contains(bag.Table_SPEC.Properties.VariableNames,'Th010')} = 'THETA1';  
            bag.Table_SPEC.Properties.VariableNames{contains(bag.Table_SPEC.Properties.VariableNames,'S0bh10')} = 'STHETA1';  
            
            bag.Table_SPEC_csv.Properties.VariableNames{contains(bag.Table_SPEC_csv.Properties.VariableNames,'Th010')} = 'THETA1';  
            bag.Table_SPEC_csv.Properties.VariableNames{contains(bag.Table_SPEC_csv.Properties.VariableNames,'S0bh10')} = 'STHETA1';
            
        case 'RADAC_SINGLE'    
            % sort
            bag.Table_SPEC = bag.Table_SPEC(:,{'f' 'df' 'Sf'});

            % add dqf and fqf to Table_SPEC to make a selection of good data easier
            tu = unique(bag.Table_SPEC.Time); % find unique time vector
            for i3 = 1:1:height(tu)
                bag.Table_SPEC.DQF(tu(i3)) = bag.Table_SPT_qc.dqf_spectrum(tu(i3));
                bag.Table_SPEC.FQF(tu(i3)) = bag.Table_SPT_qc.fqf_spectrum(tu(i3));
            end; clear i3 tu;             
            %
            bag.Table_SPEC = bag.Table_SPEC((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to

            % add units
            bag.Table_SPEC.Properties.VariableUnits =  {'Hz','Hz','m2 s','-','-'};

            % formatting *.csv
            % set precision for a clearer structure in *.csv
            bag.Table_SPEC_csv = bag.Table_SPEC;
            bag.Table_SPEC_csv.f = num2str(bag.Table_SPEC_csv.f,'%8.3f'); 
            bag.Table_SPEC_csv.Sf = num2str(bag.Table_SPEC_csv.Sf,'%8.6f'); 
            bag.Table_SPEC_csv.df = num2str(bag.Table_SPEC_csv.df,'%8.3f'); 
            
            % change variablenames to CMEMS code            
            bag.Table_SPEC.Properties.VariableNames = regexprep(string(bag.Table_SPEC.Properties.VariableNames), "\<f\>", "FREQUENCY");
            bag.Table_SPEC.Properties.VariableNames{contains(bag.Table_SPEC.Properties.VariableNames,'Sf')} = 'VSPEC1D';            
            bag.Table_SPEC.Properties.VariableNames{contains(bag.Table_SPEC.Properties.VariableNames,'df')} = 'DELTA_FREQUENCY';            
            
            bag.Table_SPEC_csv.Properties.VariableNames = regexprep(string(bag.Table_SPEC_csv.Properties.VariableNames), "\<f\>", "FREQUENCY");
            bag.Table_SPEC_csv.Properties.VariableNames{contains(bag.Table_SPEC_csv.Properties.VariableNames,'Sf')} = 'VSPEC1D';            
            bag.Table_SPEC_csv.Properties.VariableNames{contains(bag.Table_SPEC_csv.Properties.VariableNames,'df')} = 'DELTA_FREQUENCY';            
    
        case 'AWAC'       
                
        case 'FINODB'

        otherwise
            warning('Unexpected sensor type.')
    end    
    
else    
    switch upper(bag.s_sensor)
        case 'DWR'  
            % sort
            bag.T_HIW_qc = bag.T_HIW_qc(:,{'Time' 'VZMX'  'dqf_VZMX' 'fqf_VZMX' 'VTZM' 'dqf_VTZM' 'fqf_VTZM' 'VH110' 'dqf_VH110' 'fqf_VH110' 'VT110' 'dqf_VT110' 'fqf_VT110'...
                'VAVH' 'dqf_VAVH' 'fqf_VAVH' 'VAVT' 'dqf_VAVT' 'fqf_VAVT' 'VHZA' 'dqf_VHZA' 'fqf_VHZA' 'VTZA' 'dqf_VTZA' 'fqf_VTZA' 'VZNW' 'dqf_VZNW' 'fqf_VZNW'...
                'VTZC' 'dqf_VTZC' 'fqf_VTZC'});

            bag.T_HIS_qc = bag.T_HIS_qc(:,{'Time' 'VHM0' 'dqf_VHM0' 'fqf_VHM0' 'VTPK' 'dqf_VTPK' 'fqf_VTPK' 'VTM02' 'dqf_VTM02' 'fqf_VTM02' 'VPED' 'dqf_VPED' 'fqf_VPED'...
                'VPSP' 'dqf_VPSP' 'fqf_VPSP' 'TEMP' 'dqf_TEMP' 'fqf_TEMP' 'k' 'dqf_k' 'fqf_k' 'VTM20' 'dqf_VTM20' 'fqf_VTM20'...
                'VTM01' 'dqf_VTM01' 'fqf_VTM01' 'VTM24' 'dqf_VTM24' 'fqf_VTM24' 'VTPC' 'dqf_VTPC' 'fqf_VTPC' 'VTNU' 'dqf_VTNU' 'fqf_VTNU'...
                'VTES' 'dqf_VTES' 'fqf_VTES' 'VPQP' 'dqf_VPQP' 'fqf_VPQP' 'VSTS' 'dqf_VSTS' 'fqf_VSTS'});

            bag.T_GPS_qc = bag.T_GPS_qc(:,{'Time' 'STATUS' 'LATITUDE' 'dqf_LATITUDE' 'fqf_LATITUDE' 'LONGITUDE' 'dqf_LONGITUDE' 'fqf_LONGITUDE'});

            % num2str for a clearer structure in *.dat
            for i = 1:1:size(bag.VarNam_HIW,2)
                eval(['bag.T_HIW_qc.' bag.VarNam_HIW{i} '(ismissing(bag.T_HIW_qc.' bag.VarNam_HIW{i} ',[NaN -9999.000])) = -999.000;'])
                eval(['bag.T_HIW_qc.dqf_' bag.VarNam_HIW{i} '(ismissing(bag.T_HIW_qc.dqf_' bag.VarNam_HIW{i} ')) = ''9999999999999999'';'])
                eval(['bag.T_HIW_qc.fqf_' bag.VarNam_HIW{i} '(or(isnan(bag.T_HIW_qc.fqf_' bag.VarNam_HIW{i} '),ismissing(bag.T_HIW_qc.dqf_' bag.VarNam_HIW{i} ',''9999999999999999''))) = 9;'])
                % num2str for a clearer structure in *.dat                
                if any(strcmpi(bag.VarNam_HIW{i},{'VTZM','VT110','VTZA','VTZC'}))
                    eval(['bag.T_HIW_qc.' bag.VarNam_HIW{i} ' = num2str(bag.T_HIW_qc.' bag.VarNam_HIW{i} ',''%8.3f'');'])
                elseif any(strcmpi(bag.VarNam_HIW{i},{'VHZA','VZMX','VH110','VAVH','VAVT'}))
                    eval(['bag.T_HIW_qc.' bag.VarNam_HIW{i} ' = num2str(bag.T_HIW_qc.' bag.VarNam_HIW{i} ',''%8.4f'');'])
                elseif any(strcmpi(bag.VarNam_HIW{i},{'VZNW'}))
                    eval(['bag.T_HIW_qc.' bag.VarNam_HIW{i} ' = num2str(bag.T_HIW_qc.' bag.VarNam_HIW{i} ',''%8.0f'');'])     
                end
            end        
            bag.T_HIW_qc.Time = dateshift(bag.T_HIW_qc.Time,'start','minute','current'); % dateshift seconds to current minute;
            bag.T_HIW_qc.Time.Format = 'yyyyMMddHHmm';

            for i = 1:1:size(bag.VarNam_HIS,2)
                eval(['bag.T_HIS_qc.' bag.VarNam_HIS{i} '(ismissing(bag.T_HIS_qc.' bag.VarNam_HIS{i} ',[NaN -9999.000])) = -999.000;'])
                eval(['bag.T_HIS_qc.dqf_' bag.VarNam_HIS{i} '(ismissing(bag.T_HIS_qc.dqf_' bag.VarNam_HIS{i} ')) = ''9999999999999999'';'])
                eval(['bag.T_HIS_qc.fqf_' bag.VarNam_HIS{i} '(or(isnan(bag.T_HIS_qc.fqf_' bag.VarNam_HIS{i} '),ismissing(bag.T_HIS_qc.dqf_' bag.VarNam_HIS{i} ',''9999999999999999''))) = 9;'])
                % num2str for a clearer structure in *.dat
                if any(strcmpi(bag.VarNam_HIS{i},{'VTPK','VTM02','VPED','VPSP','TEMP','VTM20','VTM01','VTM24','VTPC','VTNU','VTES','VPQP'}))
                    eval(['bag.T_HIS_qc.' bag.VarNam_HIS{i} ' = num2str(bag.T_HIS_qc.' bag.VarNam_HIS{i} ',''%8.3f'');'])
                elseif any(strcmpi(bag.VarNam_HIS{i},{'VHM0'}))                    
                    eval(['bag.T_HIS_qc.' bag.VarNam_HIS{i} ' = num2str(bag.T_HIS_qc.' bag.VarNam_HIS{i} ',''%8.4f'');'])
                elseif any(strcmpi(bag.VarNam_HIS{i},{'VSTS'})) && contains(bag.s_station,{'HHF','STO'}) % select LKN stations                    
                    eval(['bag.T_HIS_qc.' bag.VarNam_HIS{i} ' = num2str(bag.T_HIS_qc.' bag.VarNam_HIS{i} ',''%8.3f'');'])                    
                elseif any(strcmpi(bag.VarNam_HIS{i},{'VSTS'}))                    
                    eval(['bag.T_HIS_qc.' bag.VarNam_HIS{i} ' = num2str(bag.T_HIS_qc.' bag.VarNam_HIS{i} ',''%8.5f'');'])  
                end
            end        
            bag.T_HIS_qc.Time = dateshift(bag.T_HIS_qc.Time,'start','minute','nearest'); % dateshift seconds to nearest minute;
            bag.T_HIS_qc.Time.Format = 'yyyyMMddHHmm';     

            % k
            % -999 (missing value) to InSiDa error value 
            % '9999999999999999' (string), 9 (integer)
            bag.T_HIS_qc.dqf_k(bag.T_HIS_qc.k==-999) = '9999999999999999';
            bag.T_HIS_qc.fqf_k(bag.T_HIS_qc.k==-999) = 9;
            bag.T_HIS_qc.k = num2str(bag.T_HIS_qc.k,'%8.3f'); % num2str for a clearer structure in *.dat            

            % gps
            % NaN and <ismissing> to InSiDa error value -999.000 (float),
            % '9999999999999999' (string), 9 (integer)
            bag.T_GPS_qc.STATUS(isnan(bag.T_GPS_qc.STATUS)) = 9;
            bag.T_GPS_qc.LATITUDE(isnan(bag.T_GPS_qc.LATITUDE)) = -999.000;
            bag.T_GPS_qc.LONGITUDE(isnan(bag.T_GPS_qc.LONGITUDE)) = -999.000;

            bag.T_GPS_qc.STATUS = num2str(bag.T_GPS_qc.STATUS,'%8.0f'); % num2str for a clearer structure in *.dat
            bag.T_GPS_qc.LATITUDE = num2str(bag.T_GPS_qc.LATITUDE,'%8.5f'); 
            bag.T_GPS_qc.LONGITUDE = num2str(bag.T_GPS_qc.LONGITUDE,'%8.5f'); 

            bag.T_GPS_qc.Time = dateshift(bag.T_GPS_qc.Time,'start','minute','nearest'); % dateshift seconds to nearest minute;
            bag.T_GPS_qc.Time.Format = 'yyyyMMddHHmm';

        case 'RADAC'       
            % convert to timetable to sync
            temp_HIW_qc = table2timetable(bag.T_HIW_qc); 
            temp_HIS_qc = table2timetable(bag.T_HIS_qc); 
            temp_LEV_qc = table2timetable(bag.T_LEV_qc); 

            % sync 
            temp_qc0 = synchronize(temp_HIW_qc,temp_HIS_qc,'union','fillwithmissing'); % syncronize his and hiw
            bag.Table_qc = synchronize(temp_qc0,temp_LEV_qc,'union','fillwithmissing'); % syncronize his, hiw and lev

            % sort tables to specific radac format of insida
            bag.Table_qc = bag.Table_qc(:,{'VHM0' 'dqf_VHM0' 'fqf_VHM0' 'VTPK'  'dqf_VTPK' 'fqf_VTPK' 'VTM02'  'dqf_VTM02' 'fqf_VTM02' 'VPED'  'dqf_VPED' 'fqf_VPED'...
                 'VPSP'  'dqf_VPSP' 'fqf_VPSP' 'VZMX'  'dqf_VZMX' 'fqf_VZMX' 'VTZM'  'dqf_VTZM' 'fqf_VTZM' 'VH110'  'dqf_VH110' 'fqf_VH110' 'VAVH'  'dqf_VAVH' 'fqf_VAVH'...
                  'VAVT'  'dqf_VAVT' 'fqf_VAVT' 'VTZA'  'dqf_VTZA' 'fqf_VTZA' 'VMDR' 'dqf_VMDR' 'fqf_VMDR' 'VHZA' 'dqf_VHZA' 'fqf_VHZA' 'VZNW' 'dqf_VZNW' 'fqf_VZNW'...
                  'SLEV_H1' 'dqf_SLEV_H1' 'fqf_SLEV_H1' 'SLEV_H10' 'dqf_SLEV_H10' 'fqf_SLEV_H10'});

            % nan and <ismissing> to error value -999.000 (float), '9999999999999999' (string),
            % 9 (integer)
            for i = 1:1:size(bag.VarNam_HIW,2)
                eval(['bag.Table_qc.' bag.VarNam_HIW{i} '(ismissing(bag.Table_qc.' bag.VarNam_HIW{i} ',[NaN -9999.000])) = -999.000;'])
                eval(['bag.Table_qc.dqf_' bag.VarNam_HIW{i} '(ismissing(bag.Table_qc.dqf_' bag.VarNam_HIW{i} ')) = ''9999999999999999'';'])
                eval(['bag.Table_qc.fqf_' bag.VarNam_HIW{i} '(or(isnan(bag.Table_qc.fqf_' bag.VarNam_HIW{i} '),ismissing(bag.Table_qc.dqf_' bag.VarNam_HIW{i} ',''9999999999999999''))) = 9;'])
                % num2str for a clearer structure in *.dat
                if any(strcmpi(bag.VarNam_HIW{i},{'VTZM','VAVT','VTZA'}))
                    eval(['bag.Table_qc.' bag.VarNam_HIW{i} ' = num2str(bag.Table_qc.' bag.VarNam_HIW{i} ',''%8.3f'');'])
                elseif any(strcmpi(bag.VarNam_HIW{i},{'VZMX','VH110','VAVH','VHZA'}))
                    eval(['bag.Table_qc.' bag.VarNam_HIW{i} ' = num2str(bag.Table_qc.' bag.VarNam_HIW{i} ',''%8.4f'');'])
                    try
                        eval(['indnan = find(all(bag.Table_qc.' bag.VarNam_HIW{i} '==''-999.0000'',2));'])
                        for ii=1:1:numel(indnan)
                            eval(['bag.Table_qc.' bag.VarNam_HIW{i} '(indnan(ii),1:9) = ''-999.000 '';'])
                        end
                        clear indnan     
                    catch
                    end
                elseif any(strcmpi(bag.VarNam_HIW{i},{'VZNW'}))
%                     eval(['bag.Table_qc.' bag.VarNam_HIW{i} ' = num2str(bag.Table_qc.' bag.VarNam_HIW{i} ',''%8.0f'');'])  
                    eval(['bag.Table_qc.' bag.VarNam_HIW{i} ' = num2str(bag.Table_qc.' bag.VarNam_HIW{i} ',''%8.3f'');'])  
                end   

            end

            for i = 1:1:size(bag.VarNam_HIS,2)
                eval(['bag.Table_qc.' bag.VarNam_HIS{i} '(ismissing(bag.Table_qc.' bag.VarNam_HIS{i} ',[NaN -9999.000])) = -999.000;'])
                eval(['bag.Table_qc.dqf_' bag.VarNam_HIS{i} '(ismissing(bag.Table_qc.dqf_' bag.VarNam_HIS{i} ')) = ''9999999999999999'';'])
                eval(['bag.Table_qc.fqf_' bag.VarNam_HIS{i} '(or(isnan(bag.Table_qc.fqf_' bag.VarNam_HIS{i} '),ismissing(bag.Table_qc.dqf_' bag.VarNam_HIS{i} ',''9999999999999999''))) = 9;'])
                % num2str for a clearer structure in *.dat
                if any(strcmpi(bag.VarNam_HIS{i},{'VTPK','VTM02','VPED','VPSP','VMDR'}))
                    eval(['bag.Table_qc.' bag.VarNam_HIS{i} ' = num2str(bag.Table_qc.' bag.VarNam_HIS{i} ',''%8.3f'');'])
                elseif any(strcmpi(bag.VarNam_HIS{i},{'VHM0'}))
                    eval(['bag.Table_qc.' bag.VarNam_HIS{i} ' = num2str(bag.Table_qc.' bag.VarNam_HIS{i} ',''%8.4f'');'])
                    try
                        eval(['indnan = find(all(bag.Table_qc.' bag.VarNam_HIS{i} '==''-999.0000'',2));'])
                        for ii=1:1:numel(indnan)
                            eval(['bag.Table_qc.' bag.VarNam_HIS{i} '(indnan(ii),1:9) = ''-999.000 '';'])
                        end
                        clear indnan     
                    catch
                    end
                end
            end

            for i = 1:1:size(bag.VarNam_LEV,2)
                eval(['bag.Table_qc.' bag.VarNam_LEV{i} '(ismissing(bag.Table_qc.' bag.VarNam_LEV{i} ',[NaN -9999.000])) = -999.000;'])
                eval(['bag.Table_qc.dqf_' bag.VarNam_LEV{i} '(ismissing(bag.Table_qc.dqf_' bag.VarNam_LEV{i} ')) = ''9999999999999999'';'])
                eval(['bag.Table_qc.fqf_' bag.VarNam_LEV{i} '(or(isnan(bag.Table_qc.fqf_' bag.VarNam_LEV{i} '),ismissing(bag.Table_qc.dqf_' bag.VarNam_LEV{i} ',''9999999999999999''))) = 9;'])
                % num2str for a clearer structure in *.dat
                eval(['bag.Table_qc.' bag.VarNam_LEV{i} ' = num2str(bag.Table_qc.' bag.VarNam_LEV{i} ',''%8.3f''); '])
            end           

            % convert back to table
            bag.Table_qc = timetable2table(bag.Table_qc);
            bag.Table_qc.Time.Format = 'yyyyMMddHHmm';

        case 'RADAC_SINGLE'
            % convert to timetable to sync
            temp_HIW_qc = table2timetable(bag.T_HIW_qc); 
            temp_HIS_qc = table2timetable(bag.T_HIS_qc); 
            temp_LEV_qc = table2timetable(bag.T_LEV_qc); 

            % sync
            temp_qc0 = synchronize(temp_HIW_qc,temp_HIS_qc,'union','fillwithmissing'); % syncronize his and hiw
            bag.Table_qc = synchronize(temp_qc0,temp_LEV_qc,'union','fillwithmissing'); % syncronize his, hiw and lev

            % include VPED, VPSP, VMDR with missing values to adjust the
            % format to "RADAC" format
            bag.Table_qc.VPED = nan(height(bag.Table_qc),1);
            bag.Table_qc.dqf_VPED = string(nan(height(bag.Table_qc),1));
            bag.Table_qc.fqf_VPED = nan(height(bag.Table_qc),1);
            bag.Table_qc.VPSP = nan(height(bag.Table_qc),1);
            bag.Table_qc.dqf_VPSP = string(nan(height(bag.Table_qc),1));
            bag.Table_qc.fqf_VPSP = nan(height(bag.Table_qc),1);
            bag.Table_qc.VMDR = nan(height(bag.Table_qc),1);
            bag.Table_qc.dqf_VMDR = string(nan(height(bag.Table_qc),1));
            bag.Table_qc.fqf_VMDR = nan(height(bag.Table_qc),1);
            bag.VarNam_HIS = {'VHM0','VTPK','VTM02','VPED','VPSP','VMDR'};
            
            % sort tables to specific radac format of insida
%             bag.Table_qc = bag.Table_qc(:,{'VHM0' 'dqf_VHM0' 'fqf_VHM0' 'VTPK'  'dqf_VTPK' 'fqf_VTPK' 'VTM02'  'dqf_VTM02' 'fqf_VTM02' 'VZMX'  'dqf_VZMX' 'fqf_VZMX'...
%                 'VTZM'  'dqf_VTZM' 'fqf_VTZM' 'VH110'  'dqf_VH110' 'fqf_VH110' 'VAVH'  'dqf_VAVH' 'fqf_VAVH'...
%                   'VAVT'  'dqf_VAVT' 'fqf_VAVT' 'VTZA'  'dqf_VTZA' 'fqf_VTZA' 'VHZA' 'dqf_VHZA' 'fqf_VHZA' 'VZNW' 'dqf_VZNW' 'fqf_VZNW'...
%                   'SLEV_H1' 'dqf_SLEV_H1' 'fqf_SLEV_H1' 'SLEV_H10' 'dqf_SLEV_H10' 'fqf_SLEV_H10'});
            bag.Table_qc = bag.Table_qc(:,{'VHM0' 'dqf_VHM0' 'fqf_VHM0' 'VTPK'  'dqf_VTPK' 'fqf_VTPK' 'VTM02'  'dqf_VTM02' 'fqf_VTM02' 'VPED'  'dqf_VPED' 'fqf_VPED'...
                 'VPSP'  'dqf_VPSP' 'fqf_VPSP' 'VZMX'  'dqf_VZMX' 'fqf_VZMX' 'VTZM'  'dqf_VTZM' 'fqf_VTZM' 'VH110'  'dqf_VH110' 'fqf_VH110' 'VAVH'  'dqf_VAVH' 'fqf_VAVH'...
                  'VAVT'  'dqf_VAVT' 'fqf_VAVT' 'VTZA'  'dqf_VTZA' 'fqf_VTZA' 'VMDR' 'dqf_VMDR' 'fqf_VMDR' 'VHZA' 'dqf_VHZA' 'fqf_VHZA' 'VZNW' 'dqf_VZNW' 'fqf_VZNW'...
                  'SLEV_H1' 'dqf_SLEV_H1' 'fqf_SLEV_H1' 'SLEV_H10' 'dqf_SLEV_H10' 'fqf_SLEV_H10'});

            % nan and <ismissing> to error value -999.000 (float), '9999999999999999' (string),
            % 9 (integer)
            for i = 1:1:size(bag.VarNam_HIW,2)
                eval(['bag.Table_qc.' bag.VarNam_HIW{i} '(ismissing(bag.Table_qc.' bag.VarNam_HIW{i} ',[NaN -9999.000])) = -999.000;'])
                eval(['bag.Table_qc.dqf_' bag.VarNam_HIW{i} '(ismissing(bag.Table_qc.dqf_' bag.VarNam_HIW{i} ')) = ''9999999999999999'';'])
                eval(['bag.Table_qc.fqf_' bag.VarNam_HIW{i} '(or(isnan(bag.Table_qc.fqf_' bag.VarNam_HIW{i} '),ismissing(bag.Table_qc.dqf_' bag.VarNam_HIW{i} ',''9999999999999999''))) = 9;'])
                % num2str for a clearer structure in *.dat
                if any(strcmpi(bag.VarNam_HIW{i},{'VTZM','VAVT','VTZA'}))
                    eval(['bag.Table_qc.' bag.VarNam_HIW{i} ' = num2str(bag.Table_qc.' bag.VarNam_HIW{i} ',''%8.3f'');'])
                elseif any(strcmpi(bag.VarNam_HIW{i},{'VZMX','VH110','VAVH','VHZA'}))
                    eval(['bag.Table_qc.' bag.VarNam_HIW{i} ' = num2str(bag.Table_qc.' bag.VarNam_HIW{i} ',''%8.4f'');'])
                    try
                        eval(['indnan = find(all(bag.Table_qc.' bag.VarNam_HIW{i} '==''-999.0000'',2));'])
                        for ii=1:1:numel(indnan)
                            eval(['bag.Table_qc.' bag.VarNam_HIW{i} '(indnan(ii),1:9) = ''-999.000 '';'])
                        end
                        clear indnan     
                    catch
                    end
                elseif any(strcmpi(bag.VarNam_HIW{i},{'VZNW'}))
%                     eval(['bag.Table_qc.' bag.VarNam_HIW{i} ' = num2str(bag.Table_qc.' bag.VarNam_HIW{i} ',''%8.0f'');'])     
                    eval(['bag.Table_qc.' bag.VarNam_HIW{i} ' = num2str(bag.Table_qc.' bag.VarNam_HIW{i} ',''%8.3f'');'])     
                end
            end

            for i = 1:1:size(bag.VarNam_HIS,2)               
                eval(['bag.Table_qc.' bag.VarNam_HIS{i} '(ismissing(bag.Table_qc.' bag.VarNam_HIS{i} ',[NaN -9999.000])) = -999.000;'])
                eval(['bag.Table_qc.dqf_' bag.VarNam_HIS{i} '(ismissing(bag.Table_qc.dqf_' bag.VarNam_HIS{i} ')) = ''9999999999999999'';'])
                eval(['bag.Table_qc.fqf_' bag.VarNam_HIS{i} '(or(isnan(bag.Table_qc.fqf_' bag.VarNam_HIS{i} '),ismissing(bag.Table_qc.dqf_' bag.VarNam_HIS{i} ',''9999999999999999''))) = 9;'])
                % num2str for a clearer structure in *.dat
                if any(strcmpi(bag.VarNam_HIS{i},{'VTPK','VTM02','VPED','VPSP','VMDR'}))
                    eval(['bag.Table_qc.' bag.VarNam_HIS{i} ' = num2str(bag.Table_qc.' bag.VarNam_HIS{i} ',''%8.3f'');'])
                elseif any(strcmpi(bag.VarNam_HIS{i},{'VHM0'}))
                    eval(['bag.Table_qc.' bag.VarNam_HIS{i} ' = num2str(bag.Table_qc.' bag.VarNam_HIS{i} ',''%8.4f'');'])   
                    try
                        eval(['indnan = find(all(bag.Table_qc.' bag.VarNam_HIS{i} '==''-999.0000'',2));'])
                        for ii=1:1:numel(indnan)
                            eval(['bag.Table_qc.' bag.VarNam_HIS{i} '(indnan(ii),1:9) = ''-999.000 '';'])
                        end
                        clear indnan     
                    catch
                    end
                end 
            end

            for i = 1:1:size(bag.VarNam_LEV,2)                
                eval(['bag.Table_qc.' bag.VarNam_LEV{i} '(ismissing(bag.Table_qc.' bag.VarNam_LEV{i} ',[NaN -9999.000])) = -999.000;'])
                eval(['bag.Table_qc.dqf_' bag.VarNam_LEV{i} '(ismissing(bag.Table_qc.dqf_' bag.VarNam_LEV{i} ')) = ''9999999999999999'';'])
                eval(['bag.Table_qc.fqf_' bag.VarNam_LEV{i} '(or(isnan(bag.Table_qc.fqf_' bag.VarNam_LEV{i} '),ismissing(bag.Table_qc.dqf_' bag.VarNam_LEV{i} ',''9999999999999999''))) = 9;'])
                % num2str for a clearer structure in *.dat
                eval(['bag.Table_qc.' bag.VarNam_LEV{i} ' = num2str(bag.Table_qc.' bag.VarNam_LEV{i} ',''%8.3f''); '])
            end        

            % convert back to table
            bag.Table_qc = timetable2table(bag.Table_qc);
            bag.Table_qc.Time.Format = 'yyyyMMddHHmm';

        case 'AWAC'
            
        case 'FINODB'
            if isfield(bag,'T_LEV') 
                % convert to timetable to sync
                temp_HIW_qc = table2timetable(bag.T_HIW_qc); 
                temp_HIS_qc = table2timetable(bag.T_HIS_qc); 
                temp_LEV_qc = table2timetable(bag.T_LEV_qc); 
                
                % sync            
                temp_qc0 = synchronize(temp_HIW_qc,temp_HIS_qc,'union','fillwithmissing'); % syncronize his and hiw
                bag.Table_qc = synchronize(temp_qc0,temp_LEV_qc,'union','fillwithmissing'); % syncronize his, hiw and lev    

                % sort tables to specific format 
                bag.Table_qc = bag.Table_qc(:,{'VHM0' 'dqf_VHM0' 'fqf_VHM0' 'VTPK'  'dqf_VTPK' 'fqf_VTPK' 'VTM02'  'dqf_VTM02' 'fqf_VTM02' 'VPED'  'dqf_VPED' 'fqf_VPED'...
                      'VTM01' 'dqf_VTM01' 'fqf_VTM01' 'VZMX'  'dqf_VZMX' 'fqf_VZMX'...
                      'SLEV_H1' 'dqf_SLEV_H1' 'fqf_SLEV_H1' 'SLEV_H10' 'dqf_SLEV_H10' 'fqf_SLEV_H10'});

                % nan and <ismissing> to error value -999.000 (float), '9999999999999999' (string),
                % 9 (integer)
                for i = 1:1:size(bag.VarNam_HIW,2)
                    eval(['bag.Table_qc.' bag.VarNam_HIW{i} '(ismissing(bag.Table_qc.' bag.VarNam_HIW{i} ',[NaN -9999.000])) = -999.000;'])
                    eval(['bag.Table_qc.dqf_' bag.VarNam_HIW{i} '(ismissing(bag.Table_qc.dqf_' bag.VarNam_HIW{i} ')) = ''9999999999999999'';'])
                    eval(['bag.Table_qc.fqf_' bag.VarNam_HIW{i} '(or(isnan(bag.Table_qc.fqf_' bag.VarNam_HIW{i} '),ismissing(bag.Table_qc.dqf_' bag.VarNam_HIW{i} ',''9999999999999999''))) = 9;'])
                    % set precision to %8.3f, num2str for a clearer structure in *.dat
                    eval(['bag.Table_qc.' bag.VarNam_HIW{i} ' = num2str(bag.Table_qc.' bag.VarNam_HIW{i} ',''%8.3f''); '])
                end

                for i = 1:1:size(bag.VarNam_HIS,2)
                    eval(['bag.Table_qc.' bag.VarNam_HIS{i} '(ismissing(bag.Table_qc.' bag.VarNam_HIS{i} ',[NaN -9999.000])) = -999.000;'])
                    eval(['bag.Table_qc.dqf_' bag.VarNam_HIS{i} '(ismissing(bag.Table_qc.dqf_' bag.VarNam_HIS{i} ')) = ''9999999999999999'';'])
                    eval(['bag.Table_qc.fqf_' bag.VarNam_HIS{i} '(or(isnan(bag.Table_qc.fqf_' bag.VarNam_HIS{i} '),ismissing(bag.Table_qc.dqf_' bag.VarNam_HIS{i} ',''9999999999999999''))) = 9;'])
                    % set precision to %8.3f, num2str for a clearer structure in *.dat
                    eval(['bag.Table_qc.' bag.VarNam_HIS{i} ' = num2str(bag.Table_qc.' bag.VarNam_HIS{i} ',''%8.3f''); '])
                end    
                
                for i = 1:1:size(bag.VarNam_LEV,2)                
                    eval(['bag.Table_qc.' bag.VarNam_LEV{i} '(ismissing(bag.Table_qc.' bag.VarNam_LEV{i} ',[NaN -9999.000])) = -999.000;'])
                    eval(['bag.Table_qc.dqf_' bag.VarNam_LEV{i} '(ismissing(bag.Table_qc.dqf_' bag.VarNam_LEV{i} ')) = ''9999999999999999'';'])
                    eval(['bag.Table_qc.fqf_' bag.VarNam_LEV{i} '(or(isnan(bag.Table_qc.fqf_' bag.VarNam_LEV{i} '),ismissing(bag.Table_qc.dqf_' bag.VarNam_LEV{i} ',''9999999999999999''))) = 9;'])
                    % num2str for a clearer structure in *.dat
                    eval(['bag.Table_qc.' bag.VarNam_LEV{i} ' = num2str(bag.Table_qc.' bag.VarNam_LEV{i} ',''%8.3f''); '])
                end                   

                % convert back to table
                bag.Table_qc = timetable2table(bag.Table_qc);
                bag.Table_qc.Time.Format = 'yyyyMMddHHmm';                
                
            else
                % convert to timetable to sync
                temp_HIW_qc = table2timetable(bag.T_HIW_qc); 
                temp_HIS_qc = table2timetable(bag.T_HIS_qc); 

                % sync            
                bag.Table_qc = synchronize(temp_HIW_qc,temp_HIS_qc,'union','fillwithmissing'); % syncronize his and hiw 

                % sort tables to specific format 
                bag.Table_qc = bag.Table_qc(:,{'VHM0' 'dqf_VHM0' 'fqf_VHM0' 'VTPK'  'dqf_VTPK' 'fqf_VTPK' 'VTM02'  'dqf_VTM02' 'fqf_VTM02' 'VPED'  'dqf_VPED' 'fqf_VPED'...
                      'VTM01' 'dqf_VTM01' 'fqf_VTM01' 'VZMX'  'dqf_VZMX' 'fqf_VZMX'});

                % nan and <ismissing> to error value -999.000 (float), '9999999999999999' (string),
                % 9 (integer)
                for i = 1:1:size(bag.VarNam_HIW,2)
                    eval(['bag.Table_qc.' bag.VarNam_HIW{i} '(ismissing(bag.Table_qc.' bag.VarNam_HIW{i} ',[NaN -9999.000])) = -999.000;'])
                    eval(['bag.Table_qc.dqf_' bag.VarNam_HIW{i} '(ismissing(bag.Table_qc.dqf_' bag.VarNam_HIW{i} ')) = ''9999999999999999'';'])
                    eval(['bag.Table_qc.fqf_' bag.VarNam_HIW{i} '(or(isnan(bag.Table_qc.fqf_' bag.VarNam_HIW{i} '),ismissing(bag.Table_qc.dqf_' bag.VarNam_HIW{i} ',''9999999999999999''))) = 9;'])
                    % set precision to %8.3f, num2str for a clearer structure in *.dat
                    eval(['bag.Table_qc.' bag.VarNam_HIW{i} ' = num2str(bag.Table_qc.' bag.VarNam_HIW{i} ',''%8.3f''); '])
                end

                for i = 1:1:size(bag.VarNam_HIS,2)
                    eval(['bag.Table_qc.' bag.VarNam_HIS{i} '(ismissing(bag.Table_qc.' bag.VarNam_HIS{i} ',[NaN -9999.000])) = -999.000;'])
                    eval(['bag.Table_qc.dqf_' bag.VarNam_HIS{i} '(ismissing(bag.Table_qc.dqf_' bag.VarNam_HIS{i} ')) = ''9999999999999999'';'])
                    eval(['bag.Table_qc.fqf_' bag.VarNam_HIS{i} '(or(isnan(bag.Table_qc.fqf_' bag.VarNam_HIS{i} '),ismissing(bag.Table_qc.dqf_' bag.VarNam_HIS{i} ',''9999999999999999''))) = 9;'])
                    % set precision to %8.3f, num2str for a clearer structure in *.dat
                    eval(['bag.Table_qc.' bag.VarNam_HIS{i} ' = num2str(bag.Table_qc.' bag.VarNam_HIS{i} ',''%8.3f''); '])
                end    

                % convert back to table
                bag.Table_qc = timetable2table(bag.Table_qc);
                bag.Table_qc.Time.Format = 'yyyyMMddHHmm';
            end
            
        otherwise
            warning('Unexpected sensor type.')        
    end   
end

return