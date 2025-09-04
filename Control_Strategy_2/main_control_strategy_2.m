clear all
clc
format longg 
warning('off')


%% ------------------------------
% Active and reactive nominal power
% ------------------------------
P=500; % nominal power
Q=0;   % nominal reactive power


%% ------------------------------
% Switching frequency and sample time
% ------------------------------
Fs = 020e3;        % PWM Switching frequency (Hz)
Ts = 1/Fs;         % Sample time (s)


% === Pre-run setup scripts ===
run('dcdc_converter_parameters.m');
run('dcdc_converter_main.m');
run('acdc_converter_parameters.m');
run('acdc_converter_main.m');


% Optional for multi simulation
run('multi_simulation.m');

fprintf('✅ All simulations completed.\n');




