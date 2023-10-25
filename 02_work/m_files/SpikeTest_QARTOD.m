function [Flag,deSpiked] = SpikeTest_QARTOD(heave)
% spikeTest:   Detects spikes in data
%             Points > M standard deviations are regarded as spikes, 
%             removed and then replaced by linear interpolation. See a
%             detailed description in QARTOD (2019)
%
% heave: incoming times series (1D); heave = bag.Table_RAW_temp.heave;
% Flag: outgoing flag
% deSpiked: outgoing despiked time series (1D)
%
% Note: counter = sum(despiked~=heave); wie viele werte wurden
% linearisiert? denn m1 kann den gleichen spike mehrfach zählen wenn einmal
% linearisieren nicht reicht

M = 4; % spike is a value > M * std
M1 = 0; % spike counter during loop
P = 2; % number of iterations
N_procent_allowed = 10; % acceptable ratio in [%] of spikes / data points   

deSpiked = heave;
for i3=1:1:P
    heave_mean_loop = mean(deSpiked,'omitnan'); % 
    heave_std_loop = std(deSpiked,'omitnan'); % 
    for i4 = 2:1:size(deSpiked,1)-1 % exclude endpoint
        if abs(deSpiked(i4) - heave_mean_loop) > M * heave_std_loop
            deSpiked(i4) = (deSpiked(i4-1) + deSpiked(i4+1)) / 2;
            M1 = M1+1;
        end
    end; clear i4;
    clear heave_mean_loop heave_std_loop;
end; clear i3;

m2 = find(abs(deSpiked - mean(deSpiked,'omitnan')) > M * std(deSpiked,'omitnan'));
M2 = length(m2);
N_procent_is = M1 * 100 / size(deSpiked,1);

if N_procent_is < N_procent_allowed && M2 == 0
    Flag = 1 ; % pass
elseif N_procent_is > N_procent_allowed || M2 > 0
    Flag = 4 ; % fail
else
    Flag = 3; % suspect
end    
