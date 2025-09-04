format longg
warning('off')

%% ---------------------------------------------
% AC System Parameters and Rated Values
%% ---------------------------------------------

%% Grid Side (Input AC)
Lc      = 2.5e-3;             % Coupling inductor (H)
rac     = 1e-3;               % Grid-side resistance (Ohm)
Vac     = 120;                % RMS grid voltage (V)
Is      = P / Vac;            % RMS current through inductor (A)
f       = 60;                 % Grid frequency (Hz)
w       = 2 * pi * f;         % Angular frequency (rad/s)
Zl      = w * Lc;             % Inductive reactance (Ohm)
Iqref   = 0;                  % Reference for reactive current (Iq = 0 → unity power factor)
C_filtre = 1 / (Lc * (2 * pi * 2000)^2);  % AC-side filter capacitor (F), 2 kHz cutoff

%% DC Link Side (DC Output)
Cdc     = 2200e-6;            % DC link capacitor (F)
Vdc     = 200;                % DC link voltage (V, steady-state)

%% ---------------------------------------------
% Operating Point for Linearization
%% ---------------------------------------------

Is0   = Is;                   % Steady-state AC current
Vs0   = Vac;                  % Steady-state source voltage (RMS)
Vdc0  = Vdc;                  % Steady-state DC link voltage

% Complex modulation index at steady-state
Vmod0_complex = (Vs0 - 1i * Zl * Is0 - Is0 * rac) / Vdc0;

% Extract modulation parameters
Vmod0_real = abs(Vmod0_complex);          % Magnitude
Vmod0_imag = imag(Vmod0_complex);         % Imaginary part
Vmod0_rad  = angle(Vmod0_complex);        % Phase in radians
phase_deg  = rad2deg(Vmod0_rad);          % Phase in degrees

% Estimate DC resistance required to match steady-state power balance
rdc = Vdc0^2 / (P - rac^2 * Is0);

% Input DC current estimation (used for linking AC to DC side)
Idc0 = Vmod0_real * Is0;

% Internal voltage at Filtre capacitor (after rac drop)
Vac0 = Vs0 - rac * Is0;

% dq0 reference currents (used for state-space modeling or dq control)
Id0 = Is0 * sqrt(2);          % Convert from RMS to peak for d-axis current
Iq0 = 0;                      % q-axis current is zero (unity power factor)

%% ---------------------------------------------
% dq Reference Voltages for Simulink
%% ---------------------------------------------
Vdref  = Vs0;                 % Reference d-axis voltage = RMS grid voltage
Vqref  = 0;                   % Reference q-axis voltage = 0 (no reactive power)
phase  = 0;                   % Phase angle initialization

%% ------------------------------
% Current Controller desired bandwidth (d&q)
% ------------------------------
w_i = 2000;                        % Desired bandwidth (Hz)

%% ------------------------------
% Voltage Controller desired bandwidth (d)
% ------------------------------
band_volt = 80;        % Desired bandwidth for voltage loop (rad/s)
%% ------------------------------
% Reactive Power Controller desired bandwidth (q)
% ------------------------------
band_volt_q = 20;       % Desired bandwidth for reactive loop (rad/s)