function [bag] = DQC_Test11(bag,I2)

Sf_tot = sum(bag.Table_SPEC_temp.Sf); 
Sf_004 = sum(bag.Table_SPEC_temp.Sf(bag.Table_SPEC_temp.f <= 0.04)); % 
Sf_060 = sum(bag.Table_SPEC_temp.Sf(bag.Table_SPEC_temp.f >= 0.6)); % 

bag.Table_SPT_qc0.dqf_Sf_11(bag.Table_SPT_dqf_03.Time(I2))  = double(and(Sf_004 < 0.05 * Sf_tot, Sf_060 < 0.05 * Sf_tot)); % pass   
bag.Table_SPT_qc0.dqf_Sf_11(bag.Table_SPT_qc0.dqf_Sf_11==0) = 4; % fail
     
clear Sf_*

switch upper(bag.s_sensor)
    case 'DWR'  
        %{
        figure; 
        plot(Table_SPEC_temp.f,Table_SPEC_temp.SfSmax); 
        hold on;
        plot(Table_SPEC_temp.f,Table_SPEC_temp.Sf); 
        hold off;
        legend('SfSmax','Sf')
        %}
                
        bag = rmfield(bag,{'Table_SPT_temp', 'Table_SPEC_temp'});
    
    case {'RADAC', 'RADAC_SINGLE'}
                
        bag = rmfield(bag,{'Table_SPEC_temp'});
        
    case 'AWAC'
        
    otherwise
        warning('Unexpected sensor type.')     
end

return