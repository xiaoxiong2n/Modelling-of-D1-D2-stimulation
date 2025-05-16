%% Modelling GCaMP increase and decrease
% Xiong Xiao, 05/14/2025 @Shanghai
clear,clc; close all

%% Simulation of GCaMP response
% Time vector (in seconds)
t = 0:0.001:5;  % 5 seconds at 1 ms resolution

% Parameters
t_on = 1;         % Time of stimulus onset
amp = 1;          % Peak amplitude of GCaMP response
% Parameters based on https://www.nature.com/articles/nature12354
% PMID: 23868258
tau_rise = 0.18;   % Rise time constant (seconds) - fast
tau_decay = 0.55;  % Decay time constant (seconds) - slow

% Create GCaMP response
gcamp = zeros(size(t));
idx = t >= t_on;
t_shifted = t(idx) - t_on;

% Bi-exponential function: fast rise, slow decay
gcamp(idx) = amp * (1 - exp(-t_shifted / tau_rise)) .* exp(-t_shifted / tau_decay);

% Plot the GCaMP trace
figure('Position', [200, 200, 500, 400]);
plot(t - t_on, gcamp, 'LineWidth', 2);
xlabel('Time (s)', 'FontSize', 12);
ylabel('GCaMP Fluorescence (a.u.)', 'FontSize', 12);
title('Simulated GCaMP Response: Fast Rise, Slow Decay');
grid on;

print('-dpng','GCaMP_rise_decay_curve')
print('-dpdf','GCaMP_rise_decay_curve')
