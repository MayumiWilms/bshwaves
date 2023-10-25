function [bag] = parser_radac(bag)

switch upper(bag.s_sensor)
    case 'RADAC'
        % select data 
        % data needs to be selected by dir*.name because dir*.datenum is
        % the last modified date of the file

        % History of spectral parameter (his), Table_HIS_RADAC
        % VHM0
        dirinfo_VHM0 = dir(fullfile(bag.s_incoming_folder,bag.s_station,'height\Hm0','*.txt'));
        str_date = {dirinfo_VHM0.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VHM0(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VHM0X = dirinfo_VHM0(and([dirinfo_VHM0.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VHM0.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VHM0X.name_datenum}.'); dirinfo_VHM0X = dirinfo_VHM0X(index); clear index % sort by name; datenum could be date_modified   

        % Fp
        dirinfo_Fp = dir(fullfile(bag.s_incoming_folder,bag.s_station,'height\Fp','*.txt'));
        str_date = {dirinfo_Fp.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_Fp(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_FpX = dirinfo_Fp(and([dirinfo_Fp.name_datenum] >= datenum(bag.date_from_x),[dirinfo_Fp.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_FpX.name_datenum}.'); dirinfo_FpX = dirinfo_FpX(index); clear index % sort by name; datenum could be date_modified     

        % VTM02
        dirinfo_VTM02 = dir(fullfile(bag.s_incoming_folder,bag.s_station,'height\Tm02','*.txt'));
        str_date = {dirinfo_VTM02.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VTM02(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VTM02X = dirinfo_VTM02(and([dirinfo_VTM02.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VTM02.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VTM02X.name_datenum}.'); dirinfo_VTM02X = dirinfo_VTM02X(index); clear index % sort by name; datenum could be date_modified 

        % VPED (Dir_p)
        dirinfo_VPED = dir(fullfile(bag.s_incoming_folder,bag.s_station,'direction\Th0_B4','*.txt'));
        str_date = {dirinfo_VPED.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VPED(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VPEDX = dirinfo_VPED(and([dirinfo_VPED.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VPED.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VPEDX.name_datenum}.'); dirinfo_VPEDX = dirinfo_VPEDX(index); clear index % sort by name; datenum could be date_modified   

        % VPSP (Spr_p)
        dirinfo_VPSP = dir(fullfile(bag.s_incoming_folder,bag.s_station,'direction\S0bh_B4','*.txt'));
        str_date = {dirinfo_VPSP.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VPSP(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VPSPX = dirinfo_VPSP(and([dirinfo_VPSP.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VPSP.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VPSPX.name_datenum}.'); dirinfo_VPSPX = dirinfo_VPSPX(index); clear index % sort by name; datenum could be date_modified     

        % VMDR (VMDR)
        dirinfo_VMDR = dir(fullfile(bag.s_incoming_folder,bag.s_station,'direction\Th0','*.txt'));
        str_date = {dirinfo_VMDR.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VMDR(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VMDRX = dirinfo_VMDR(and([dirinfo_VMDR.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VMDR.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VMDRX.name_datenum}.'); dirinfo_VMDRX = dirinfo_VMDRX(index); clear index % sort by name; datenum could be date_modified  

        % History of upcross waves parameters (hiw), T_HIW
        % VZMX
        dirinfo_VZMX = dir(fullfile(bag.s_incoming_folder,bag.s_station,'height\Hmax','*.txt'));
        str_date = {dirinfo_VZMX.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VZMX(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VZMXX = dirinfo_VZMX(and([dirinfo_VZMX.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VZMX.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VZMXX.name_datenum}.'); dirinfo_VZMXX = dirinfo_VZMXX(index); clear index % sort by name; datenum could be date_modified  

        % VTZM 
        dirinfo_VTZM = dir(fullfile(bag.s_incoming_folder,bag.s_station,'height\THmax','*.txt'));
        str_date = {dirinfo_VTZM.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VTZM(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VTZMX = dirinfo_VTZM(and([dirinfo_VTZM.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VTZM.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VTZMX.name_datenum}.'); dirinfo_VTZMX = dirinfo_VTZMX(index); clear index % sort by name; datenum could be date_modified  

        % VH110
        dirinfo_VH110 = dir(fullfile(bag.s_incoming_folder,bag.s_station,'height\H1d10','*.txt'));
        str_date = {dirinfo_VH110.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VH110(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VH110X = dirinfo_VH110(and([dirinfo_VH110.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VH110.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VH110X.name_datenum}.'); dirinfo_VH110X = dirinfo_VH110X(index); clear index % sort by name; datenum could be date_modified  

        % VAVH
        dirinfo_VAVH = dir(fullfile(bag.s_incoming_folder,bag.s_station,'height\H1d3','*.txt'));
        str_date = {dirinfo_VAVH.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VAVH(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VAVHX = dirinfo_VAVH(and([dirinfo_VAVH.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VAVH.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VAVHX.name_datenum}.'); dirinfo_VAVHX = dirinfo_VAVHX(index); clear index % sort by name; datenum could be date_modified  

        % VAVT 
        dirinfo_VAVT = dir(fullfile(bag.s_incoming_folder,bag.s_station,'height\TH1d3','*.txt'));
        str_date = {dirinfo_VAVT.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VAVT(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VAVTX = dirinfo_VAVT(and([dirinfo_VAVT.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VAVT.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VAVTX.name_datenum}.'); dirinfo_VAVTX = dirinfo_VAVTX(index); clear index % sort by name; datenum could be date_modified  

        % VHZA (Hav)
        dirinfo_VHZA = dir(fullfile(bag.s_incoming_folder,bag.s_station,'height\GGH','*.txt'));
        str_date = {dirinfo_VHZA.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VHZA(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VHZAX = dirinfo_VHZA(and([dirinfo_VHZA.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VHZA.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VHZAX.name_datenum}.'); dirinfo_VHZAX = dirinfo_VHZAX(index); clear index % sort by name; datenum could be date_modified  

        % VTZA (Tav)
        dirinfo_VTZA = dir(fullfile(bag.s_incoming_folder,bag.s_station,'height\GGT','*.txt'));
        str_date = {dirinfo_VTZA.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VTZA(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VTZAX = dirinfo_VTZA(and([dirinfo_VTZA.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VTZA.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VTZAX.name_datenum}.'); dirinfo_VTZAX = dirinfo_VTZAX(index); clear index % sort by name; datenum could be date_modified

        % VZNW (NumWaves)
        dirinfo_VZNW = dir(fullfile(bag.s_incoming_folder,bag.s_station,'height\AG2','*.txt'));
        str_date = {dirinfo_VZNW.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VZNW(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VZNWX = dirinfo_VZNW(and([dirinfo_VZNW.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VZNW.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VZNWX.name_datenum}.'); dirinfo_VZNWX = dirinfo_VZNWX(index); clear index % sort by name; datenum could be date_modified 

        % Water Level (lev, LEV)
        % SLEV_H1 
        dirinfo_SLEV_H1 = dir(fullfile(bag.s_incoming_folder,bag.s_station,'height\H1','*.txt'));
        str_date = {dirinfo_SLEV_H1.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_SLEV_H1(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_SLEV_H1X = dirinfo_SLEV_H1(and([dirinfo_SLEV_H1.name_datenum] >= datenum(bag.date_from_x),[dirinfo_SLEV_H1.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_SLEV_H1X.name_datenum}.'); dirinfo_SLEV_H1X = dirinfo_SLEV_H1X(index); clear index % sort by name; datenum could be date_modified 

        % SLEV_H10
        dirinfo_SLEV_H10 = dir(fullfile(bag.s_incoming_folder,bag.s_station,'height\H10','*.txt'));
        str_date = {dirinfo_SLEV_H10.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_SLEV_H10(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_SLEV_H10X = dirinfo_SLEV_H10(and([dirinfo_SLEV_H10.name_datenum] >= datenum(bag.date_from_x),[dirinfo_SLEV_H10.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_SLEV_H10X.name_datenum}.'); dirinfo_SLEV_H10X = dirinfo_SLEV_H10X(index); clear index % sort by name; datenum could be date_modified 

        % check if files exist 
        if isempty(dirinfo_VHM0X)
            error([datestr(bag.date_now) ' No Hm0 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_FpX)
            error([datestr(bag.date_now) ' No Fp data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VTM02X)
            error([datestr(bag.date_now) ' No Tm02 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VPEDX)
            error([datestr(bag.date_now) ' No Th0_B4 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VPSPX)
            error([datestr(bag.date_now) ' No S0bh_B4 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VMDRX)
            error([datestr(bag.date_now) ' No Th0 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VZMXX)
            error([datestr(bag.date_now) ' No Hmax data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VTZMX)
            error([datestr(bag.date_now) ' No Thmax data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VH110X)
            error([datestr(bag.date_now) ' No H1d10 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VAVHX)
            error([datestr(bag.date_now) ' No H1d3 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VAVTX)
            error([datestr(bag.date_now) ' No TH1d3 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VHZAX)
            error([datestr(bag.date_now) ' No GGH data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VTZAX)
            error([datestr(bag.date_now) ' No GGT data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VZNWX)
            error([datestr(bag.date_now) ' No AG2 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end
        
        if isempty(dirinfo_SLEV_H1X)
            error([datestr(bag.date_now) ' No H1 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_SLEV_H10X)
            error([datestr(bag.date_now) ' No H10 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end        

        % load data into workspace   
        % his
        T_HIS_VHM0 = timetable;
        for I2 = 1:1:numel(dirinfo_VHM0X)
            Table_HIS_RADAC_VHM0_temp = read_RADAC_HIS_VHM0(dirinfo_VHM0X(I2).name,dirinfo_VHM0X(I2).folder);
            T_HIS_VHM0 = [T_HIS_VHM0; Table_HIS_RADAC_VHM0_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_HIS_VHM0 = sortrows(T_HIS_VHM0);
        T_HIS_VHM0 = unique(T_HIS_VHM0); % remove duplicate rows with same time and data
        T_HIS_VHM0 = T_HIS_VHM0((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_HIS_VHM0.VHM0(isnan(T_HIS_VHM0.VHM0)) = -9999.000;

        T_HIS_Fp = timetable;
        for I2 = 1:1:numel(dirinfo_FpX)
            T_HIS_Fp_temp = read_RADAC_HIS_Fp(dirinfo_FpX(I2).name,dirinfo_FpX(I2).folder);
            T_HIS_Fp = [T_HIS_Fp; T_HIS_Fp_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_HIS_Fp = sortrows(T_HIS_Fp);
        T_HIS_Fp = unique(T_HIS_Fp); % remove duplicate rows with same time and data
        T_HIS_Fp = T_HIS_Fp((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_HIS_Fp.F_p(isnan(T_HIS_Fp.F_p)) = -9999.000;
        T_HIS_Fp.VTPK(isnan(T_HIS_Fp.VTPK)) = -9999.000;

        T_HIS_VTM02 = timetable;
        for I2 = 1:1:numel(dirinfo_VTM02X)
            T_HIS_VTM02_temp = read_RADAC_HIS_VTM02(dirinfo_VTM02X(I2).name,dirinfo_VTM02X(I2).folder);
            T_HIS_VTM02 = [T_HIS_VTM02; T_HIS_VTM02_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_HIS_VTM02 = sortrows(T_HIS_VTM02);
        T_HIS_VTM02 = unique(T_HIS_VTM02); % remove duplicate rows with same time and data
        T_HIS_VTM02 = T_HIS_VTM02((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_HIS_VTM02.VTM02(isnan(T_HIS_VTM02.VTM02)) = -9999.000;

        T_HIS_VPED = timetable;
        for I2 = 1:1:numel(dirinfo_VPEDX)
            T_HIS_VPED_temp = read_RADAC_HIS_VPED(dirinfo_VPEDX(I2).name,dirinfo_VPEDX(I2).folder);
            T_HIS_VPED = [T_HIS_VPED; T_HIS_VPED_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_HIS_VPED = sortrows(T_HIS_VPED);
        T_HIS_VPED = unique(T_HIS_VPED); % remove duplicate rows with same time and data
        T_HIS_VPED = T_HIS_VPED((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_HIS_VPED.VPED(isnan(T_HIS_VPED.VPED)) = -9999.000;

        T_HIS_VPSP = timetable;
        for I2 = 1:1:numel(dirinfo_VPSPX)
            T_HIS_VPSP_temp = read_RADAC_HIS_VPSP(dirinfo_VPSPX(I2).name,dirinfo_VPSPX(I2).folder);
            T_HIS_VPSP = [T_HIS_VPSP; T_HIS_VPSP_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_HIS_VPSP = sortrows(T_HIS_VPSP);
        T_HIS_VPSP = unique(T_HIS_VPSP); % remove duplicate rows with same time and data
        T_HIS_VPSP = T_HIS_VPSP((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_HIS_VPSP.VPSP(isnan(T_HIS_VPSP.VPSP)) = -9999.000;

        T_HIS_VMDR = timetable;
        for I2 = 1:1:numel(dirinfo_VMDRX)
            T_HIS_VMDR_temp = read_RADAC_HIS_VMDR(dirinfo_VMDRX(I2).name,dirinfo_VMDRX(I2).folder);
            T_HIS_VMDR = [T_HIS_VMDR; T_HIS_VMDR_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_HIS_VMDR = sortrows(T_HIS_VMDR);
        T_HIS_VMDR = unique(T_HIS_VMDR); % remove duplicate rows with same time and data
        T_HIS_VMDR = T_HIS_VMDR((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_HIS_VMDR.VMDR(isnan(T_HIS_VMDR.VMDR)) = -9999.000;

        % combine timetables
        T_HIS_temp0 = synchronize(T_HIS_VHM0,T_HIS_Fp,'union');
        T_HIS_temp1 = synchronize(T_HIS_temp0,T_HIS_VTM02,'union'); clear T_HIS_temp0;
        T_HIS_temp0 = synchronize(T_HIS_temp1,T_HIS_VPED,'union'); clear T_HIS_temp1;
        T_HIS_temp1 = synchronize(T_HIS_temp0,T_HIS_VPSP,'union'); clear T_HIS_temp0;
        T_HIS = synchronize(T_HIS_temp1,T_HIS_VMDR,'union'); clear T_HIS_temp1;
        clear T_HIS_*

        % hiw
        T_HIW_VZMX = timetable;
        for I2 = 1:1:numel(dirinfo_VZMXX)
            T_HIW_VZMX_temp = read_RADAC_HIW_VZMX(dirinfo_VZMXX(I2).name,dirinfo_VZMXX(I2).folder);
            T_HIW_VZMX = [T_HIW_VZMX; T_HIW_VZMX_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_HIW_VZMX = sortrows(T_HIW_VZMX);
        T_HIW_VZMX = unique(T_HIW_VZMX); % remove duplicate rows with same time and data
        T_HIW_VZMX = T_HIW_VZMX((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_HIW_VZMX.VZMX(isnan(T_HIW_VZMX.VZMX)) = -9999.000;

        T_HIW_VTZM = timetable;
        for I2 = 1:1:numel(dirinfo_VTZMX)
            T_HIW_VTZM_temp = read_RADAC_HIW_VTZM(dirinfo_VTZMX(I2).name,dirinfo_VTZMX(I2).folder);
            T_HIW_VTZM = [T_HIW_VTZM; T_HIW_VTZM_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_HIW_VTZM = sortrows(T_HIW_VTZM);
        T_HIW_VTZM = unique(T_HIW_VTZM); % remove duplicate rows with same time and data
        T_HIW_VTZM = T_HIW_VTZM((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_HIW_VTZM.VTZM(isnan(T_HIW_VTZM.VTZM)) = -9999.000;

        T_HIW_VH110 = timetable;
        for I2 = 1:1:numel(dirinfo_VH110X)
            T_HIW_VH110_temp = read_RADAC_HIW_VH110(dirinfo_VH110X(I2).name,dirinfo_VH110X(I2).folder);
            T_HIW_VH110 = [T_HIW_VH110; T_HIW_VH110_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_HIW_VH110 = sortrows(T_HIW_VH110);
        T_HIW_VH110 = unique(T_HIW_VH110); % remove duplicate rows with same time and data
        T_HIW_VH110 = T_HIW_VH110((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_HIW_VH110.VH110(isnan(T_HIW_VH110.VH110)) = -9999.000;

        T_HIW_VAVH = timetable;
        for I2 = 1:1:numel(dirinfo_VAVHX)
            T_HIW_VAVH_temp = read_RADAC_HIW_VAVH(dirinfo_VAVHX(I2).name,dirinfo_VAVHX(I2).folder);
            T_HIW_VAVH = [T_HIW_VAVH; T_HIW_VAVH_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_HIW_VAVH = sortrows(T_HIW_VAVH);
        T_HIW_VAVH = unique(T_HIW_VAVH); % remove duplicate rows with same time and data
        T_HIW_VAVH = T_HIW_VAVH((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_HIW_VAVH.VAVH(isnan(T_HIW_VAVH.VAVH)) = -9999.000;

        T_HIW_VAVT = timetable;
        for I2 = 1:1:numel(dirinfo_VAVTX)
            T_HIW_VAVT_temp = read_RADAC_HIW_VAVT(dirinfo_VAVTX(I2).name,dirinfo_VAVTX(I2).folder);
            T_HIW_VAVT = [T_HIW_VAVT; T_HIW_VAVT_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_HIW_VAVT = sortrows(T_HIW_VAVT);
        T_HIW_VAVT = unique(T_HIW_VAVT); % remove duplicate rows with same time and data
        T_HIW_VAVT = T_HIW_VAVT((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_HIW_VAVT.VAVT(isnan(T_HIW_VAVT.VAVT)) = -9999.000;

        T_HIW_VHZA = timetable;
        for I2 = 1:1:numel(dirinfo_VHZAX)
            T_HIW_VHZA_temp = read_RADAC_HIW_VHZA(dirinfo_VHZAX(I2).name,dirinfo_VHZAX(I2).folder);
            T_HIW_VHZA = [T_HIW_VHZA; T_HIW_VHZA_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_HIW_VHZA = sortrows(T_HIW_VHZA);
        T_HIW_VHZA = unique(T_HIW_VHZA); % remove duplicate rows with same time and data
        T_HIW_VHZA = T_HIW_VHZA((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_HIW_VHZA.VHZA(isnan(T_HIW_VHZA.VHZA)) = -9999.000;

        T_HIW_VTZA = timetable;
        for I2 = 1:1:numel(dirinfo_VTZAX)
            T_HIW_VTZA_temp = read_RADAC_HIW_VTZA(dirinfo_VTZAX(I2).name,dirinfo_VTZAX(I2).folder);
            T_HIW_VTZA = [T_HIW_VTZA; T_HIW_VTZA_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_HIW_VTZA = sortrows(T_HIW_VTZA);
        T_HIW_VTZA = unique(T_HIW_VTZA); % remove duplicate rows with same time and data
        T_HIW_VTZA = T_HIW_VTZA((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_HIW_VTZA.VTZA(isnan(T_HIW_VTZA.VTZA)) = -9999.000;

        T_HIW_VZNW = timetable;
        for I2 = 1:1:numel(dirinfo_VZNWX)
            T_HIW_VZNW_temp = read_RADAC_HIW_VZNW(dirinfo_VZNWX(I2).name,dirinfo_VZNWX(I2).folder);
            T_HIW_VZNW = [T_HIW_VZNW; T_HIW_VZNW_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_HIW_VZNW = sortrows(T_HIW_VZNW);
        T_HIW_VZNW = unique(T_HIW_VZNW); % remove duplicate rows with same time and data
        T_HIW_VZNW = T_HIW_VZNW((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_HIW_VZNW.VZNW(isnan(T_HIW_VZNW.VZNW)) = -9999.000;

        % % combine timetables
        T_HIW_temp0 = synchronize(T_HIW_VZMX,T_HIW_VTZM,'union');
        T_HIW_temp1 = synchronize(T_HIW_temp0,T_HIW_VH110,'union'); clear T_HIW_temp0;
        T_HIW_temp0 = synchronize(T_HIW_temp1,T_HIW_VAVH,'union'); clear  T_HIW_temp1;
        T_HIW_temp1 = synchronize(T_HIW_temp0,T_HIW_VAVT,'union'); clear T_HIW_temp0;
        T_HIW_temp0 = synchronize(T_HIW_temp1,T_HIW_VHZA,'union'); clear  T_HIW_temp1;
        T_HIW_temp1 = synchronize(T_HIW_temp0,T_HIW_VTZA,'union'); clear T_HIW_temp0;
        T_HIW = synchronize(T_HIW_temp1,T_HIW_VZNW,'union'); clear  T_HIW_temp1; 
        clear T_HIW_*
        
        % lev
        T_LEV_SLEV_H1 = timetable;
         for I2 = 1:1:numel(dirinfo_SLEV_H1X)
            T_LEV_SLEV_H1_temp = read_RADAC_LEV_SLEV_H1(dirinfo_SLEV_H1X(I2).name,dirinfo_SLEV_H1X(I2).folder);
            T_LEV_SLEV_H1 = [T_LEV_SLEV_H1; T_LEV_SLEV_H1_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_LEV_SLEV_H1 = sortrows(T_LEV_SLEV_H1);
        T_LEV_SLEV_H1 = unique(T_LEV_SLEV_H1); % remove duplicate rows with same time and data
        T_LEV_SLEV_H1 = T_LEV_SLEV_H1((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_LEV_SLEV_H1.SLEV_H1(isnan(T_LEV_SLEV_H1.SLEV_H1)) = -9999.000;

        T_LEV_SLEV_H10 = timetable;
        for I2 = 1:1:numel(dirinfo_SLEV_H10X)
            T_LEV_SLEV_H10_temp = read_RADAC_LEV_SLEV_H10(dirinfo_SLEV_H10X(I2).name,dirinfo_SLEV_H10X(I2).folder);
            T_LEV_SLEV_H10 = [T_LEV_SLEV_H10; T_LEV_SLEV_H10_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_LEV_SLEV_H10 = sortrows(T_LEV_SLEV_H10);
        T_LEV_SLEV_H10 = unique(T_LEV_SLEV_H10); % remove duplicate rows with same time and data
        T_LEV_SLEV_H10 = T_LEV_SLEV_H10((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_LEV_SLEV_H10.SLEV_H10(isnan(T_LEV_SLEV_H10.SLEV_H10)) = -9999.000;

        % combine timetables
        T_LEV = synchronize(T_LEV_SLEV_H1,T_LEV_SLEV_H10,'union'); 
        clear T_LEV_*        
        
        % RADAC sensor does not provide GPS information
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
        
        % pack your bag
        bag.T_HIW = T_HIW;
        bag.T_HIS = T_HIS;
        bag.T_GPS = T_GPS;  
        bag.T_LEV = T_LEV;     

    case 'RADAC_SINGLE'
        % select data 
        % data needs to be selected by dir*.name because dir*.datenum is the last
        % modified date of the file

        % History of spectral parameter (his), Table_HIS_RADAC
        % VHM0
        dirinfo_VHM0 = dir(fullfile(bag.s_incoming_folder,bag.s_station,'Hm0','*.txt'));
        str_date = {dirinfo_VHM0.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VHM0(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VHM0X = dirinfo_VHM0(and([dirinfo_VHM0.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VHM0.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VHM0X.name_datenum}.'); dirinfo_VHM0X = dirinfo_VHM0X(index); clear index % sort by name; datenum could be date_modified   

        % Fp
        dirinfo_Fp = dir(fullfile(bag.s_incoming_folder,bag.s_station,'Fp','*.txt'));
        str_date = {dirinfo_Fp.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_Fp(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_FpX = dirinfo_Fp(and([dirinfo_Fp.name_datenum] >= datenum(bag.date_from_x),[dirinfo_Fp.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_FpX.name_datenum}.'); dirinfo_FpX = dirinfo_FpX(index); clear index % sort by name; datenum could be date_modified     

        % VTM02
        dirinfo_VTM02 = dir(fullfile(bag.s_incoming_folder,bag.s_station,'Tm02','*.txt'));
        str_date = {dirinfo_VTM02.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VTM02(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VTM02X = dirinfo_VTM02(and([dirinfo_VTM02.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VTM02.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VTM02X.name_datenum}.'); dirinfo_VTM02X = dirinfo_VTM02X(index); clear index % sort by name; datenum could be date_modified 

        % History of upcross waves parameters (hiw), T_HIW
        % VZMX
        dirinfo_VZMX = dir(fullfile(bag.s_incoming_folder,bag.s_station,'Hmax','*.txt'));
        str_date = {dirinfo_VZMX.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VZMX(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VZMXX = dirinfo_VZMX(and([dirinfo_VZMX.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VZMX.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VZMXX.name_datenum}.'); dirinfo_VZMXX = dirinfo_VZMXX(index); clear index % sort by name; datenum could be date_modified  

        % VTZM 
        dirinfo_VTZM = dir(fullfile(bag.s_incoming_folder,bag.s_station,'THmax','*.txt'));
        str_date = {dirinfo_VTZM.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VTZM(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VTZMX = dirinfo_VTZM(and([dirinfo_VTZM.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VTZM.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VTZMX.name_datenum}.'); dirinfo_VTZMX = dirinfo_VTZMX(index); clear index % sort by name; datenum could be date_modified  

        % VH110
        dirinfo_VH110 = dir(fullfile(bag.s_incoming_folder,bag.s_station,'H1d10','*.txt'));
        str_date = {dirinfo_VH110.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VH110(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VH110X = dirinfo_VH110(and([dirinfo_VH110.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VH110.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VH110X.name_datenum}.'); dirinfo_VH110X = dirinfo_VH110X(index); clear index % sort by name; datenum could be date_modified  

        % VAVH
        dirinfo_VAVH = dir(fullfile(bag.s_incoming_folder,bag.s_station,'H1d3','*.txt'));
        str_date = {dirinfo_VAVH.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VAVH(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VAVHX = dirinfo_VAVH(and([dirinfo_VAVH.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VAVH.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VAVHX.name_datenum}.'); dirinfo_VAVHX = dirinfo_VAVHX(index); clear index % sort by name; datenum could be date_modified  

        % VAVT 
        dirinfo_VAVT = dir(fullfile(bag.s_incoming_folder,bag.s_station,'TH1d3','*.txt'));
        str_date = {dirinfo_VAVT.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VAVT(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VAVTX = dirinfo_VAVT(and([dirinfo_VAVT.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VAVT.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VAVTX.name_datenum}.'); dirinfo_VAVTX = dirinfo_VAVTX(index); clear index % sort by name; datenum could be date_modified  

        % VHZA (Hav)
        dirinfo_VHZA = dir(fullfile(bag.s_incoming_folder,bag.s_station,'GGH','*.txt'));
        str_date = {dirinfo_VHZA.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VHZA(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VHZAX = dirinfo_VHZA(and([dirinfo_VHZA.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VHZA.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VHZAX.name_datenum}.'); dirinfo_VHZAX = dirinfo_VHZAX(index); clear index % sort by name; datenum could be date_modified  

        % VTZA (Tav)
        dirinfo_VTZA = dir(fullfile(bag.s_incoming_folder,bag.s_station,'GGT','*.txt'));
        str_date = {dirinfo_VTZA.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VTZA(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VTZAX = dirinfo_VTZA(and([dirinfo_VTZA.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VTZA.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VTZAX.name_datenum}.'); dirinfo_VTZAX = dirinfo_VTZAX(index); clear index % sort by name; datenum could be date_modified

        % VZNW (NumWaves)
        dirinfo_VZNW = dir(fullfile(bag.s_incoming_folder,bag.s_station,'AG2','*.txt'));
        str_date = {dirinfo_VZNW.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_VZNW(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_VZNWX = dirinfo_VZNW(and([dirinfo_VZNW.name_datenum] >= datenum(bag.date_from_x),[dirinfo_VZNW.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_VZNWX.name_datenum}.'); dirinfo_VZNWX = dirinfo_VZNWX(index); clear index % sort by name; datenum could be date_modified 

        % Water Level (lev, LEV)
        % SLEV_H1 
        dirinfo_SLEV_H1 = dir(fullfile(bag.s_incoming_folder,bag.s_station,'H1','*.txt'));
        str_date = {dirinfo_SLEV_H1.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_SLEV_H1(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_SLEV_H1X = dirinfo_SLEV_H1(and([dirinfo_SLEV_H1.name_datenum] >= datenum(bag.date_from_x),[dirinfo_SLEV_H1.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_SLEV_H1X.name_datenum}.'); dirinfo_SLEV_H1X = dirinfo_SLEV_H1X(index); clear index % sort by name; datenum could be date_modified 

        % SLEV_H10
        dirinfo_SLEV_H10 = dir(fullfile(bag.s_incoming_folder,bag.s_station,'H10','*.txt'));
        str_date = {dirinfo_SLEV_H10.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_SLEV_H10(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        dirinfo_SLEV_H10X = dirinfo_SLEV_H10(and([dirinfo_SLEV_H10.name_datenum] >= datenum(bag.date_from_x),[dirinfo_SLEV_H10.name_datenum] <= datenum(bag.date_to_x))); 
        [~,index] = sortrows({dirinfo_SLEV_H10X.name_datenum}.'); dirinfo_SLEV_H10X = dirinfo_SLEV_H10X(index); clear index % sort by name; datenum could be date_modified 

        % check if files exist 
        if isempty(dirinfo_VHM0X)
            error([datestr(bag.date_now) ' No Hm0 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])           
        end

        if isempty(dirinfo_FpX)
            error([datestr(bag.date_now) ' No Fp data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VTM02X)
            error([datestr(bag.date_now) ' No Tm02 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VZMXX)
            error([datestr(bag.date_now) ' No Hmax data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VTZMX)
            warning([datestr(bag.date_now) ' No THmax data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VH110X)
            warning([datestr(bag.date_now) ' No H1d10 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VAVHX)
            warning([datestr(bag.date_now) ' No H1d3 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VAVTX)
            warning([datestr(bag.date_now) ' No TH1d3 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VHZAX)
            warning([datestr(bag.date_now) ' No GGH data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VTZAX)
            warning([datestr(bag.date_now) ' No GGT data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_VZNWX)
            warning([datestr(bag.date_now) ' No AG2 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_SLEV_H1X)
            warning([datestr(bag.date_now) ' No H1 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        if isempty(dirinfo_SLEV_H10X)
            error([datestr(bag.date_now) ' No H10 data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])            
        end

        % load data into workspace   
        % his
        T_HIS_VHM0 = timetable;
        for I2 = 1:1:numel(dirinfo_VHM0X)
            Table_HIS_RADAC_VHM0_temp = read_RADAC_HIS_VHM0(dirinfo_VHM0X(I2).name,dirinfo_VHM0X(I2).folder);
            T_HIS_VHM0 = [T_HIS_VHM0; Table_HIS_RADAC_VHM0_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_HIS_VHM0 = sortrows(T_HIS_VHM0);
        T_HIS_VHM0 = unique(T_HIS_VHM0); % remove duplicate rows with same time and data
        T_HIS_VHM0 = T_HIS_VHM0((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_HIS_VHM0.VHM0(isnan(T_HIS_VHM0.VHM0)) = -9999.000;

        T_HIS_Fp = timetable;
        for I2 = 1:1:numel(dirinfo_FpX)
            T_HIS_Fp_temp = read_RADAC_HIS_Fp(dirinfo_FpX(I2).name,dirinfo_FpX(I2).folder);
            T_HIS_Fp = [T_HIS_Fp; T_HIS_Fp_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_HIS_Fp = sortrows(T_HIS_Fp);
        T_HIS_Fp = unique(T_HIS_Fp); % remove duplicate rows with same time and data
        T_HIS_Fp = T_HIS_Fp((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_HIS_Fp.F_p(isnan(T_HIS_Fp.F_p)) = -9999.000;
        T_HIS_Fp.VTPK(isnan(T_HIS_Fp.VTPK)) = -9999.000;

        T_HIS_VTM02 = timetable;
        for I2 = 1:1:numel(dirinfo_VTM02X)
            T_HIS_VTM02_temp = read_RADAC_HIS_VTM02(dirinfo_VTM02X(I2).name,dirinfo_VTM02X(I2).folder);
            T_HIS_VTM02 = [T_HIS_VTM02; T_HIS_VTM02_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_HIS_VTM02 = sortrows(T_HIS_VTM02);
        T_HIS_VTM02 = unique(T_HIS_VTM02); % remove duplicate rows with same time and data
        T_HIS_VTM02 = T_HIS_VTM02((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_HIS_VTM02.VTM02(isnan(T_HIS_VTM02.VTM02)) = -9999.000;
        
        % combine timetables
        T_HIS_temp0 = synchronize(T_HIS_VHM0,T_HIS_Fp,'union');
        T_HIS = synchronize(T_HIS_temp0,T_HIS_VTM02,'union'); clear T_HIS_temp0;
        clear T_HIS_*

        % hiw
        T_HIW_VZMX = timetable;
        for I2 = 1:1:numel(dirinfo_VZMXX)
            T_HIW_VZMX_temp = read_RADAC_HIW_VZMX(dirinfo_VZMXX(I2).name,dirinfo_VZMXX(I2).folder);
            T_HIW_VZMX = [T_HIW_VZMX; T_HIW_VZMX_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_HIW_VZMX = sortrows(T_HIW_VZMX);
        T_HIW_VZMX = unique(T_HIW_VZMX); % remove duplicate rows with same time and data
        T_HIW_VZMX = T_HIW_VZMX((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_HIW_VZMX.VZMX(isnan(T_HIW_VZMX.VZMX)) = -9999.000;

        if isempty(dirinfo_VTZMX)
            rowTimes = bag.date_from_x : minutes(1) : bag.date_to_x; 
            T_HIW_VTZM = timetable(rowTimes', nan(length(rowTimes),1), 'VariableNames', {'VTZM'});
            T_HIW_VTZM.Properties.VariableUnits =  {'s'};
            T_HIW_VTZM.Time.TimeZone = 'UTC';
        else                    
            T_HIW_VTZM = timetable;
            for I2 = 1:1:numel(dirinfo_VTZMX)
                T_HIW_VTZM_temp = read_RADAC_HIW_VTZM(dirinfo_VTZMX(I2).name,dirinfo_VTZMX(I2).folder);
                T_HIW_VTZM = [T_HIW_VTZM; T_HIW_VTZM_temp]; %#ok<AGROW>
            end; clear I2 *temp
            T_HIW_VTZM = sortrows(T_HIW_VTZM);
            T_HIW_VTZM = unique(T_HIW_VTZM); % remove duplicate rows with same time and data
            T_HIW_VTZM = T_HIW_VTZM((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
            T_HIW_VTZM.VTZM(isnan(T_HIW_VTZM.VTZM)) = -9999.000;
        end

        if isempty(dirinfo_VH110X)
            rowTimes = bag.date_from_x : minutes(1) : bag.date_to_x; 
            T_HIW_VH110 = timetable(rowTimes', nan(length(rowTimes),1), 'VariableNames', {'VH110'});
            T_HIW_VH110.Properties.VariableUnits =  {'m'};
            T_HIW_VH110.Time.TimeZone = 'UTC';
        else  
            T_HIW_VH110 = timetable;
            for I2 = 1:1:numel(dirinfo_VH110X)
                T_HIW_VH110_temp = read_RADAC_HIW_VH110(dirinfo_VH110X(I2).name,dirinfo_VH110X(I2).folder);
                T_HIW_VH110 = [T_HIW_VH110; T_HIW_VH110_temp]; %#ok<AGROW>
            end; clear I2 *temp
            T_HIW_VH110 = sortrows(T_HIW_VH110);
            T_HIW_VH110 = unique(T_HIW_VH110); % remove duplicate rows with same time and data
            T_HIW_VH110 = T_HIW_VH110((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
            T_HIW_VH110.VH110(isnan(T_HIW_VH110.VH110)) = -9999.000;
        end
        
        if isempty(dirinfo_VAVHX)
            rowTimes = bag.date_from_x : minutes(1) : bag.date_to_x; 
            T_HIW_VAVH = timetable(rowTimes', nan(length(rowTimes),1), 'VariableNames', {'VAVH'});
            T_HIW_VAVH.Properties.VariableUnits =  {'m'};
            T_HIW_VAVH.Time.TimeZone = 'UTC';
        else  
            T_HIW_VAVH = timetable;
            for I2 = 1:1:numel(dirinfo_VAVHX)
                T_HIW_VAVH_temp = read_RADAC_HIW_VAVH(dirinfo_VAVHX(I2).name,dirinfo_VAVHX(I2).folder);
                T_HIW_VAVH = [T_HIW_VAVH; T_HIW_VAVH_temp]; %#ok<AGROW>
            end; clear I2 *temp
            T_HIW_VAVH = sortrows(T_HIW_VAVH);
            T_HIW_VAVH = unique(T_HIW_VAVH); % remove duplicate rows with same time and data
            T_HIW_VAVH = T_HIW_VAVH((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
            T_HIW_VAVH.VAVH(isnan(T_HIW_VAVH.VAVH)) = -9999.000;
        end
        
        if isempty(dirinfo_VAVTX)
            rowTimes = bag.date_from_x : minutes(1) : bag.date_to_x; 
            T_HIW_VAVT = timetable(rowTimes', nan(length(rowTimes),1), 'VariableNames', {'VAVT'});
            T_HIW_VAVT.Properties.VariableUnits =  {'s'};
            T_HIW_VAVT.Time.TimeZone = 'UTC';
        else  
            T_HIW_VAVT = timetable;
            for I2 = 1:1:numel(dirinfo_VAVTX)
                T_HIW_VAVT_temp = read_RADAC_HIW_VAVT(dirinfo_VAVTX(I2).name,dirinfo_VAVTX(I2).folder);
                T_HIW_VAVT = [T_HIW_VAVT; T_HIW_VAVT_temp]; %#ok<AGROW>
            end; clear I2 *temp
            T_HIW_VAVT = sortrows(T_HIW_VAVT);
            T_HIW_VAVT = unique(T_HIW_VAVT); % remove duplicate rows with same time and data
            T_HIW_VAVT = T_HIW_VAVT((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
            T_HIW_VAVT.VAVT(isnan(T_HIW_VAVT.VAVT)) = -9999.000;
        end
        
        if isempty(dirinfo_VHZAX)
            rowTimes = bag.date_from_x : minutes(1) : bag.date_to_x; 
            T_HIW_VHZA = timetable(rowTimes', nan(length(rowTimes),1), 'VariableNames', {'VHZA'});
            T_HIW_VHZA.Properties.VariableUnits =  {'m'};
            T_HIW_VHZA.Time.TimeZone = 'UTC';
        else  
            T_HIW_VHZA = timetable;
            for I2 = 1:1:numel(dirinfo_VHZAX)
                T_HIW_VHZA_temp = read_RADAC_HIW_VHZA(dirinfo_VHZAX(I2).name,dirinfo_VHZAX(I2).folder);
                T_HIW_VHZA = [T_HIW_VHZA; T_HIW_VHZA_temp]; %#ok<AGROW>
            end; clear I2 *temp
            T_HIW_VHZA = sortrows(T_HIW_VHZA);
            T_HIW_VHZA = unique(T_HIW_VHZA); % remove duplicate rows with same time and data
            T_HIW_VHZA = T_HIW_VHZA((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
            T_HIW_VHZA.VHZA(isnan(T_HIW_VHZA.VHZA)) = -9999.000;
        end
        
        if isempty(dirinfo_VTZAX)
            rowTimes = bag.date_from_x : minutes(1) : bag.date_to_x; 
            T_HIW_VTZA = timetable(rowTimes', nan(length(rowTimes),1), 'VariableNames', {'VTZA'});
            T_HIW_VTZA.Properties.VariableUnits =  {'s'};
            T_HIW_VTZA.Time.TimeZone = 'UTC';
        else          
            T_HIW_VTZA = timetable;
            for I2 = 1:1:numel(dirinfo_VTZAX)
                T_HIW_VTZA_temp = read_RADAC_HIW_VTZA(dirinfo_VTZAX(I2).name,dirinfo_VTZAX(I2).folder);
                T_HIW_VTZA = [T_HIW_VTZA; T_HIW_VTZA_temp]; %#ok<AGROW>
            end; clear I2 *temp
            T_HIW_VTZA = sortrows(T_HIW_VTZA);
            T_HIW_VTZA = unique(T_HIW_VTZA); % remove duplicate rows with same time and data
            T_HIW_VTZA = T_HIW_VTZA((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
            T_HIW_VTZA.VTZA(isnan(T_HIW_VTZA.VTZA)) = -9999.000;
        end
        
        if isempty(dirinfo_VZNWX)
            rowTimes = bag.date_from_x : minutes(1) : bag.date_to_x; 
            T_HIW_VZNW = timetable(rowTimes', nan(length(rowTimes),1), 'VariableNames', {'VZNW'});
            T_HIW_VZNW.Properties.VariableUnits =  {' '};
            T_HIW_VZNW.Time.TimeZone = 'UTC';
        else          
            T_HIW_VZNW = timetable;
            for I2 = 1:1:numel(dirinfo_VZNWX)
                T_HIW_VZNW_temp = read_RADAC_HIW_VZNW(dirinfo_VZNWX(I2).name,dirinfo_VZNWX(I2).folder);
                T_HIW_VZNW = [T_HIW_VZNW; T_HIW_VZNW_temp]; %#ok<AGROW>
            end; clear I2 *temp
            T_HIW_VZNW = sortrows(T_HIW_VZNW);
            T_HIW_VZNW = unique(T_HIW_VZNW); % remove duplicate rows with same time and data
            T_HIW_VZNW = T_HIW_VZNW((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
            T_HIW_VZNW.VZNW(isnan(T_HIW_VZNW.VZNW)) = -9999.000;
        end
        
        % combine timetables
        T_HIW_temp0 = synchronize(T_HIW_VZMX,T_HIW_VTZM,'union');
        T_HIW_temp1 = synchronize(T_HIW_temp0,T_HIW_VH110,'union'); clear T_HIW_temp0;
        T_HIW_temp0 = synchronize(T_HIW_temp1,T_HIW_VAVH,'union'); clear  T_HIW_temp1;
        T_HIW_temp1 = synchronize(T_HIW_temp0,T_HIW_VAVT,'union'); clear T_HIW_temp0;
        T_HIW_temp0 = synchronize(T_HIW_temp1,T_HIW_VHZA,'union'); clear  T_HIW_temp1;
        T_HIW_temp1 = synchronize(T_HIW_temp0,T_HIW_VTZA,'union'); clear T_HIW_temp0;
        T_HIW = synchronize(T_HIW_temp1,T_HIW_VZNW,'union'); clear  T_HIW_temp1; 
        clear T_HIW_*

        % lev
        if isempty(dirinfo_SLEV_H1X)
            rowTimes = bag.date_from_x : minutes(1) : bag.date_to_x; 
            T_LEV_SLEV_H1 = timetable(rowTimes', nan(length(rowTimes),1), 'VariableNames', {'SLEV_H1'});
            T_LEV_SLEV_H1.Properties.VariableUnits =  {'m'};
            T_LEV_SLEV_H1.Time.TimeZone = 'UTC';
        else      
            T_LEV_SLEV_H1 = timetable;
             for I2 = 1:1:numel(dirinfo_SLEV_H1X)
                T_LEV_SLEV_H1_temp = read_RADAC_LEV_SLEV_H1(dirinfo_SLEV_H1X(I2).name,dirinfo_SLEV_H1X(I2).folder);
                T_LEV_SLEV_H1 = [T_LEV_SLEV_H1; T_LEV_SLEV_H1_temp]; %#ok<AGROW>
            end; clear I2 *temp
            T_LEV_SLEV_H1 = sortrows(T_LEV_SLEV_H1);
            T_LEV_SLEV_H1 = unique(T_LEV_SLEV_H1); % remove duplicate rows with same time and data
            T_LEV_SLEV_H1 = T_LEV_SLEV_H1((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
            T_LEV_SLEV_H1.SLEV_H1(isnan(T_LEV_SLEV_H1.SLEV_H1)) = -9999.000;
        end
        
        T_LEV_SLEV_H10 = timetable;
        for I2 = 1:1:numel(dirinfo_SLEV_H10X)
            T_LEV_SLEV_H10_temp = read_RADAC_LEV_SLEV_H10(dirinfo_SLEV_H10X(I2).name,dirinfo_SLEV_H10X(I2).folder);
            T_LEV_SLEV_H10 = [T_LEV_SLEV_H10; T_LEV_SLEV_H10_temp]; %#ok<AGROW>
        end; clear I2 *temp
        T_LEV_SLEV_H10 = sortrows(T_LEV_SLEV_H10);
        T_LEV_SLEV_H10 = unique(T_LEV_SLEV_H10); % remove duplicate rows with same time and data
        T_LEV_SLEV_H10 = T_LEV_SLEV_H10((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        T_LEV_SLEV_H10.SLEV_H10(isnan(T_LEV_SLEV_H10.SLEV_H10)) = -9999.000;

        % combine timetables
        T_LEV = synchronize(T_LEV_SLEV_H1,T_LEV_SLEV_H10,'union'); 
        clear T_LEV_*

        % RADAC sensor does not provide GPS information
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
        
        % pack your bag
        bag.T_HIW = T_HIW(~all(ismissing(T_HIW),2),:); 
        bag.T_HIS = T_HIS(~all(ismissing(T_HIS),2),:); 
        bag.T_GPS = T_GPS; 
        bag.T_LEV = T_LEV(~all(ismissing(T_LEV),2),:);        
        
    otherwise
    warning('Unexpected sensor type.')     
       
end

return