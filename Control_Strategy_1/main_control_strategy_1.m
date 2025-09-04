clear all
clc
format longg 
warning('off')

%% ------------------------------
% Switching frequency and sample time
% ------------------------------
Fs = 020e3;        % PWM Switching frequency (Hz)
Ts = 1/Fs;         % Sample time (s)

P=500; % nominal power
Q=0;   % nominal reactive power

               
                    
                                                                         
% === Pre-run setup scripts ===
run('dcdc_converter_parameters.m');
run('dcdc_converter_main.m');
run('acdc_converter_parameters.m');
run('acdc_converter_main.m');

%% Optional
% === Simulink-run ===
run('multi_simulation.m');

fprintf('✅ All simulations completed.\n');


