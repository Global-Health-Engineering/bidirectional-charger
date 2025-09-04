% File: parameters.m
% System parameters for DQ Control and Analysis

format longg 
warning('off')

%% ============================== PARAMETERS ==============================

% ------------------------------ Timing ------------------------------
Fs = 20e3;         % Switching frequency (Hz)
Ts = 1/Fs;         % Sample time (s)

F28M35_freq = 150e6;   % Microcontroller clock (Hz)
Dead_time = 20e-6;     % Dead time for complementary PWM (s)

% ------------------------ ADC Conversion Factors ------------------------
adc_slope = 0.000812146;       % V/digital
adc_intercept = 0.005546262;   % V offset
ac_volt_sens_offset = 1.51;    % V
ac_volt_sens_slope = 33.33 * 1.00; % V/V

adc_slope_volt = 0.00081 * 1.0; % V/digital
adc_intercept_volt = 0.0024;   % V offset
dc_volt_sens_offset = 0.981;   % V
dc_volt_sens_slope = 15.122 * 1.0; % V/V

ac_curr_sens_offset = 1.252;   % V
ac_curr_sens_slope = 20.39465588 * 1; % V/V

% ------------------------- PLL Parameters -------------------------
Kp_pll = 500;
Ki_pll = 10000;
wn = 2*pi*60; % Nominal grid frequency

% --------------------- Circuit Parameters (AC Side) ---------------------
Lc = 2.54e-3;
rac = 1e-3;
Vs = 20/sqrt(2);
P = 0.041;
Is = P / Vs;
f = 60;
w = 2*pi*f;
Zl = w * Lc;
Iqref = 0;
C_filtre = 1e-6;
f_filtre = 1 / (2*pi*sqrt(Lc*C_filtre));

% --------------------- Circuit Parameters (DC Side) ---------------------
Cdc = 2200e-6;
Vdc = 30;
rdc = Vdc^2 / P;

% --------------------- Operating Point ---------------------
Id = (Vs - Is*rac) * Is / Vdc;
Iq = 0;
Vac0 = Vs - rac*Is;

Vmod0_complex = (Vs-1i*Zl*Is-Is*rac)/Vdc; 
Vmod0_real = abs(Vmod0_complex);
Vmod0_imag = imag(Vmod0_complex);
