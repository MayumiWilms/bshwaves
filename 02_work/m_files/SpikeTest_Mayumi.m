function [Flag,deSpiked,counter,cc,Flag_cc] = SpikeTest_Mayumi(xx,M,fs)
% spikeTest:   Detects spikes in data
%             Slides a moving average window through the time series. 
%             Points > M standard deviations are regarded as spikes, 
%             removed and then replaced by linear interpolation. 
%             Test is applied again to see if any more spikes, but for M 
%             standard deviations + 0.1 until no spikes are found. 
%
% xx: Incoming times series (1D)
% M: factor for std
% Flag: Outgoing flag (based on counter)
% Flag_cc: Outgoing flag (based on corrcoef)
% deSpiked: Outgoing despiked time series (1D)
%
% Note 1: original Richard Foreman script included a differentiation of xx 
% Note 2: M2_mod_temp = find(abs(deSpiked - mean(deSpiked,'omitnan')) > M * std(deSpiked,'omitnan'));
%     M2_mod = length(M2_mod_temp);
%     % a check for M2 is misleading because of the moving window method
%     % which checks only for M1

xxin = xx;

L = numel(xx); %data length
w = ceil(200*fs); %window width, in time domain: 200 s, ~10% of 30-min measurement
for k1 = 1:ceil(100*fs):L-w+1 %shift 128 points each time (~5%), ratio 256:128 is good
    if k1 > L-w %last window
        datawin = k1:L; %indexes for this window 
    else
        datawin = k1:k1+w-1; %indexes for this window
    end      
    counter_loop = 1;
    stdVal = M; %NaN values > stdVal*std

    while counter_loop > 0   
        xdloop = xx(datawin);
        xm = mean(xdloop,'omitnan');%mean in window
        xs = std(xdloop,'omitnan');%std in window
        ToNaN = abs(xdloop-xm)>stdVal*xs;%NaN values exceeding
        
        counter_loop = sum(ToNaN);%add found spikes to total
        xdloop(ToNaN)=NaN;%NaN;%clear spikes in data     
        xx(datawin) = xdloop;
        %fill NaN via linear interpolation
        xx(datawin)=fillmissing(xx(datawin),'linear');
        stdVal = stdVal + 0.1;
    end    
end

% nan is not a spike
counter = sum(xx~=xxin)-numel(find(ismember(find(isnan(xxin)),find(xx~=xxin)))); % counter = length(find(xx-xxin));

deSpiked = xx;

% figure
% plot(Table_RADAC_heave.Time,Table_RADAC_heave.heave,'-x'); 
% hold on; 
% plot(Table_RADAC_heave.Time,Table_RADAC_heave.deSpiked,'-.'); 
% xlim([Table_RADAC_heave.Time(8194)-seconds(10) Table_RADAC_heave.Time(8194)+seconds(10)]);
% hold off;

% mayumi wilms
N_procent_is_mod = counter * 100 / numel(deSpiked);

% evaluation with corrcoef
%{
if N_procent_is_mod <= 0.25 && cc >= 0.99 % 7 spikes are ok
    Table_QC_detailed.detailed_qf_heave_10_mod(I1,1) = 1 ; % good data        
elseif N_procent_is_mod <= 0.7 && cc >= 0.90 && cc < 0.99 % 16 spikes are ok
    Table_QC_detailed.detailed_qf_heave_10_mod(I1,1) = 2; % probably good        
elseif N_procent_is_mod > 1.0 && N_procent_is_mod <= 2.5 || cc < 0.90 && cc >= 0.80 % 
    Table_QC_detailed.detailed_qf_heave_10_mod(I1,1) = 3; % probably bad data                
elseif N_procent_is_mod > 2.5 || cc < 0.80 % 58 spikes
    Table_QC_detailed.detailed_qf_heave_10_mod(I1,1) = 4 ; % bad data
else 
    Table_QC_detailed.detailed_qf_heave_10_mod(I1,1) = 3 ; % probably bad data
end    
%}

% evaluation without corrcoef
if N_procent_is_mod <= 0.25 % 5 spikes are ok
    Flag = 1 ; % good data
elseif N_procent_is_mod <= 0.66 % 15 spikes are ok
    Flag = 2; % probably good 
elseif N_procent_is_mod > 0.66 && N_procent_is_mod <= 2.4  % 
    Flag = 3; % probably bad data  
elseif N_procent_is_mod > 2.4 % 55 spikes
    Flag = 4 ; % bad data
end   

% richard foreman
cc_temp = corrcoef(xx,xxin,'Rows','complete');
cc = cc_temp(2,1);
if cc < 0.99
    Flag_cc = 3;
    if counter > 0.05*L %from flat line test
        Flag_cc = 4;
    end
elseif cc >= 0.99 && cc < 0.999 && counter > 0.05*L 
    Flag_cc = 2;
else
    Flag_cc = 1;
end

end

