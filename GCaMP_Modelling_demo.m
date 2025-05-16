%% Modelling GCaMP increase and decrease
% Xiong Xiao, 05/14/2025 @Shanghai
clear,clc; close all

rng(1); % for reproducibility

%% Set parameters, simulate GCaMP events and Laser events
% Parameters
duration = 15; % duration in seconds
dt = 0.005; % time step in seconds
latency_activation = 0.015;  % seconds
latency_inhibition = 0.005;  % seconds

time = 0:dt:duration;

evt_t = zeros(1, length(time));
Spike_Events_t = [1, 6, 12];
for k=1:length(Spike_Events_t)
    [~,idx]=min(abs(time-Spike_Events_t(k)));
    evt_t(idx(1)) = 1;
end

laser_t = [6.5, 11.7];
for k=1:length(laser_t)
    [~,idx]=min(abs(time-laser_t(k)));%
    laser_idx(k) = idx(1);
end

laser_duration = 0.5;

evt_t_activation = evt_t;
evt_t_inhibition = evt_t;
for trial_id = 1:length(laser_t)
    % activation
    effect_index0 = find(time>laser_t(trial_id)+latency_activation & time<laser_t(trial_id)+laser_duration);
    effect_index = effect_index0(1:20:end);
    evt_t_activation(effect_index) = 1;
    % inhibition
    effect_index0 = find(time>laser_t(trial_id)+latency_activation & time<laser_t(trial_id)+laser_duration);
    evt_t_inhibition(effect_index0) = 0;
end

gcamp_conv_control = gcamp_cov(evt_t,dt)';
gcamp_conv_activation = gcamp_cov(evt_t_activation,dt)';
gcamp_conv_inhibition = gcamp_cov(evt_t_inhibition,dt)';

%% Plots
figure('Position',[300,300,900,400])

hh = [];
hh(1) = subplot(3,1,1);
hold on
plot(time, gcamp_conv_control, 'LineWidth', 2);
tt = time(evt_t>0);
xline(tt, 'Color','k','LineWidth',1);
xlim([0,time(end)]);
set(gca,'TickDir','out','TickLength',[0.015 0],'FontSize',12,'LineWidth',0.75,'box','off');

hh(2) = subplot(3,1,2);
hold on
plot(time, gcamp_conv_activation, 'LineWidth', 2);
tt = time(evt_t_activation>0);
xline(tt, 'Color','k','LineWidth',1);
xline(laser_t, 'Color','b','LineWidth',2);
xlim([0,time(end)]);
set(gca,'TickDir','out','TickLength',[0.015 0],'FontSize',12,'LineWidth',0.75,'box','off');

hh(3) = subplot(3,1,3);
hold on
plot(time, gcamp_conv_inhibition, 'LineWidth', 2);
tt = time(evt_t_inhibition>0);
xline(tt, 'Color','k','LineWidth',1);
xline(laser_t, 'Color','b','LineWidth',2);
set(gca,'TickDir','out','TickLength',[0.015 0],'FontSize',12,'LineWidth',0.75,'box','off');

xlim([0,time(end)]);

linkaxes(hh, 'xy')
print('-dpng','GCaMP_Activation_Inhibition_Fig')
set(gcf,'Render','Painter')
print('-dpdf','GCaMP_Activation_Inhibition_Fig')
