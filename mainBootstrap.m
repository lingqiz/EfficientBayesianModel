%% TD Group Level
nBootstrap = 1e4; nBins = 24; 
load('woFB_td.mat');
[scale_woFB_td, noise_woFB_td] = bootstrap(allTarget', allResponse', nBootstrap, nBins);

load('wFB1_td.mat');
[scale_wFB1_td, noise_wFB1_td] = bootstrap(allTarget', allResponse', nBootstrap, nBins);
 
load('wFB2_td.mat');
[scale_wFB2_td, noise_wFB2_td] = bootstrap(allTarget', allResponse', nBootstrap, nBins);

%% ASD Group Level
nBootstrap = 1e4; nBins = 18;
load('woFB_asd.mat');
[scale_woFB_asd, noise_woFB_asd] = bootstrap(allTarget', allResponse', nBootstrap, nBins);

load('wFB1_asd.mat');
[scale_wFB1_asd, noise_wFB1_asd] = bootstrap(allTarget', allResponse', nBootstrap, nBins);

load('wFB2_asd.mat');
[scale_wFB2_asd, noise_wFB2_asd] = bootstrap(allTarget', allResponse', nBootstrap, nBins);

%% Plot Parameter Change
figure; subplot(1, 2, 1);
hold on; grid on;
errorbar([0.8, 2, 3.2], mean([scale_woFB_td; scale_wFB1_td; scale_wFB2_td], 2), ...
    2*std([scale_woFB_td; scale_wFB1_td; scale_wFB2_td], 0, 2), '--o', 'LineWidth', 2);

errorbar([0.8, 2, 3.2], mean([scale_woFB_asd; scale_wFB1_asd; scale_wFB2_asd], 2), ...
    2*std([scale_woFB_asd; scale_wFB1_asd; scale_wFB2_asd], 0, 2), '--o', 'LineWidth', 2);
legend({'Normal', 'ASD'});
xlim([0.5, 3.5]); xticks([0.8, 2, 3.2]); ylim([0, 0.8]);
xticklabels({'woFB', 'wFB1', 'wFB2'});
title('Prior Weight $$ \omega $$', 'interpreter', 'latex')

subplot(1, 2, 2);
hold on; grid on;
errorbar([0.8, 2, 3.2], mean([noise_woFB_td; noise_wFB1_td; noise_wFB2_td], 2), ...
    2*std([noise_woFB_td; noise_wFB1_td; noise_wFB2_td], 0, 2), '--o', 'LineWidth', 2);

errorbar([0.8, 2, 3.2], mean([noise_woFB_asd; noise_wFB1_asd; noise_wFB2_asd], 2), ...
    2*std([noise_woFB_asd; noise_wFB1_asd; noise_wFB2_asd], 0, 2), '--o', 'LineWidth', 2);

legend({'Normal', 'ASD'});
xlim([0.5, 3.5]); xticks([0.8, 2, 3.2]);
xticklabels({'woFB', 'wFB1', 'wFB2'});
title('Total $$ \sqrt{J(\theta)} $$', 'interpreter', 'latex')

%% Helper (bootstrap) function
function [scale, noise] = bootstrap(allTarget, allResponse, nBootstrap, nBins)
    scale = zeros(1, nBootstrap);
    noise = zeros(1, nBootstrap);
    
    parfor idx = 1:nBootstrap
        [target, response] = resample(allTarget, allResponse);
        [scale(idx), noise(idx)] = extractPrior(target, response, nBins, false);
    end
end