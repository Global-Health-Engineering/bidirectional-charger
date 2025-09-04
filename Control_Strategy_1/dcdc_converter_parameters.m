format longg
warning('off')

%% Converter Side System Parameters and Operating Conditions



%% ------------------------------
% Converter Input (DC Link Side)
% ------------------------------
Ci  = 220e-6;      % Input capacitor (F)
rsi = 1e-3;        % Source-side resistance (Ohm)
Vsi = 200;         % Source-side rated voltage (V)
Lsi = 105e-6;      % dc link inductor  (H)


%% ------------------------------
% Converter Output (Battery side)
% ------------------------------
Lb = 3e-3;         % Output inductor value (H)
ro = 270e-3;       % ESR of output inductor (Ohm)
rb = 1e-3;         % Battery resistance (Ohm)
Vb = 48;           % Nominal output voltage (V)
Io = P / Vb;       % Rated output current (A)
rop = ro + rb;     % Total output series resistance (Ohm)
Ccb = 330e-6;      % Output capacitor (e.g., battery-side capacitor) (F)

%% ------------------------------
% Current Controller desired bandwidth
% ------------------------------
Wbi_dc =  2 * pi * (Fs / 10);   % Cutoff frequency (rad/s), 10% of Nyquist


%% ------------------------------
% Operating Point for Linearization
% ------------------------------

Io0 = Io;           % Operating point: output current (A)
Vsi0 = Vsi;         % Operating point: input voltage (V)
Vso0 = Vb;          % Operating point: output voltage (V)

% Duty cycle at steady state (approximate)
D0 = Vso0 / Vsi0;

% Input current at steady state (current through switch when ON)
It10 = D0 * Io0;    % Throw-1 current (from output to input side)
Isi0 = It10;        % Input-side current equals throw-1 at D0

% Internal voltages accounting for voltage drops
Vi0 = Vsi0 - rsi * Isi0;         % Inner voltage at input (after rsi)
Vo0 = Vso0 + rb * Io0;           % Inner voltage at output (before rb)


