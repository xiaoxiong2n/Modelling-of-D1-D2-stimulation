%% Modelling ACh increase and decrease
% Xiong Xiao, 05/14/2025 @Shanghai
clear,clc; close all

%% Simulation of ACh response
% Time vector (in seconds)
t = 0:0.001:5;  % 5 seconds at 1 ms resolution

% Parameters
t_on = 1;         % Time of stimulus onset
amp = 1;          % Peak amplitude of ACh response
tau_rise = 0.112;   % Rise time constant (seconds) - fast
tau_decay = 0.580;  % Decay time constant (seconds) - slow

% Create ACh response
ach = zeros(size(t));
idx = t >= t_on;
t_shifted = t(idx) - t_on;

% Bi-exponential function: fast rise, slow decay
ach(idx) = amp * (1 - exp(-t_shifted / tau_rise)) .* exp(-t_shifted / tau_decay);

% Plot the ACh trace
figure('Position', [200, 200, 500, 400]);
plot(t - t_on, ach, 'LineWidth', 2);
xlabel('Time (s)', 'FontSize', 12);
ylabel('ACh Fluorescence (a.u.)', 'FontSize', 12);
title('Simulated ACh Response: Fast Rise, Slow Decay');
grid on;

print('-dpng','ACh_rise_decay_curve')
print('-dpdf','ACh_rise_decay_curve')
