function [gcamp_conv_event] = gcamp_cov(evt_t,bin_size)
%% used to convolve the event with GCaMP basis
% Xiong Xiao, 05/14/2025 @Shanghai
%
% INPUTS:
% evt_t: event (0, none; 1, occurance)
% bin_size: bin_size (seconds)

%% generate GCaMP basis for convolution
t = 0:bin_size:5;  % Time vector (in seconds)

% Parameters
amp = 1;          % Peak amplitude of GCaMP response
tau_rise = 0.18;   % Rise time constant (seconds) - fast
tau_decay = 0.55;  % Decay time constant (seconds) - slow

% Create GCaMP response
gcamp_basis = zeros(size(t));
idx = t >= 0;
t_shifted = t(idx);

% Bi-exponential function: fast rise, slow decay
gcamp_basis(idx) = amp * (1 - exp(-t_shifted / tau_rise)) .* exp(-t_shifted / tau_decay);

%%
cur_event_var = zeros(length(evt_t), 1);
bin_shift = 0;

w = conv(evt_t ,gcamp_basis');
gcamp_conv_event = w(1+bin_shift:length(evt_t)+bin_shift);

end
