% File: main.m
% Master script for system initialization, controller tuning, and result plotting

% Load Parameters
run('parameters.m');

% Perform PI Controller Tuning
run('pi_tuning.m');

% Generate Plots
run('plot_results.m');