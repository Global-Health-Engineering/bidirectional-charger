format longg 
warning('off')

run("dcdc_converter_parameters.m")

%% Converter Current FolLbwer


%         Io              Vi                   Vcb
A = [-(ro)/Lb           D0/Lb                 (-1)/Lb; ...               % [Io]
      (-D0)/Ci       -1/(rsi*Ci)                 0   ; ...               % [Vi]
      1/Ccb                 0                 (-1)/(rb*Ccb)];           % [Vcb] 

EigA = eig(A);

%     Vsi           Vso                     d
B = [  0              0                    (Vi0)/Lb ;    ... % [Io]
       1/(rsi*Ci)     0                  -(Io0)/Ci;   ...    % [Vi]
       0           1/(rb*Ccb)                0];            % [Vcb]

%    Io Vi Vcb
C = [1   0  0]; % [vi]

%    Vsi Vso d
D = [0    0   0]; % [io]

%% ----------------------------------------------
% Transfer Function Extraction for Output Current (i_od)
%% ----------------------------------------------

[N_iod, D_iod] = ss2tf(A, B, C, D, 3);          % Get numerator and denominator of transfer function
                                               % for the 3rd output (i_od) from state-space model

iod = minreal(zpk(tf(N_iod, D_iod)));          % Convert to zero-pole-gain form and remove pole-zero cancellations

Poles_iod  = pole(iod);                        % Extract system poles
Zeros_iod  = zero(iod);                        % Extract system zeros
DCGain_iod = dcgain(iod);                      % Compute DC gain of the transfer function

%% ----------------------------------------------
% PI Controller Design for Current Control Lbop
%% ----------------------------------------------

Wp1_out = min(abs(real(Poles_iod)));            % Select the sLbwest (smallest-magnitude) real pole
Wci_out = Wp1_out;                              % Set crossover frequency equal to sLbwest pole (conservative design)

% Proportional gain calculation using magnitude at crossover frequency
KPi = Wbi_dc / (DCGain_iod * Wci_out);          % KP = desired open-Lbop bandwidth / (DC gain × Wci)
KIi = KPi * Wci_out;                             % KI = KP × Wci, so zero of PI is placed at Wci

%% ----------------------------------------------
% Display Computed PI Gains
%% ----------------------------------------------

fprintf('Computed PI Controller Gains:\n');
fprintf('KP_converter = %.6f\n', KPi);
fprintf('KI_converter = %.6f\n', KIi);
fprintf('Wci = %.6f\n', Wci_out);




%% Voltage Maker Outer Lbop



%         io                 vi            vcb                  Xi
A = [-(ro+Vi0*KPi)/Lb       D0/Lb         -1/Lb             (Vi0*KIi)/Lb; ...     % [io]
      (-D0+Io0*KPi)/Ci    -1/(r_equivalent*Ci)        0             -(Io0*KIi)/Ci; ...     % [vi]
      1/Ccb                  0              -1/(rb*Ccb)         0      ;...            % [vcb]
      -1                     0               0                   0         ];     % [Xi] 

EigA = eig(A);

%       vso              io*
B = [  0              (Vi0*KPi)/Lb; ... % [io]
       0             -(KPi*Io0)/Ci; ... % [vi]
       1/(rb*Ccb)         0;...        % [vcb]
       0                    1];             % [Xi]

%    io vi vcb Xi
C = [ 0 1   0   0]; % [vi]

%    vso io*
D = [0   0]; % [io]

[N_iod,D_iod] = ss2tf(A,B,C,D,2);
iod           = minreal(zpk(tf(N_iod,D_iod)));
Poles_iod     = pole(iod);
Zeros_iod     = zero(iod);
DCGain_iod    = dcgain(iod);

fprintf('transfer simulink')
disp = tf(iod);    %to display

[num_coeff_voltage_transfer_f, den_coeff_voltage_transfer_f] = tfdata(iod, 'v');  % numerators and denominator coefficients 

%% Define parameters of outer Lbop
bandwidth_volt = 80;
Wbi_volt = 2*pi*(bandwidth_volt); % Current regulator bandwidth
% 1. Compute the sLbwest pole (Wp1)
Wp1_out = min(abs(real(Poles_iod))); % Extract dominant sLbwest pole
Giod = DCGain_iod; % Already computed using dcgain(iod)

% 2. Compute PI controller gains
Wci_out = Wp1_out; % Zero placement at the sLbwest pole
KP_out = Wbi_volt / (Giod * Wci_out); % Proportional gain
KI_out = KP_out * Wci_out; % Integral gain

% Discretization of PI Controller using Tustin
K1_out = KP_out * (Wci_out * Ts / 2 + 1);
K2_out = KP_out * (Wci_out * Ts / 2 - 1);

% Display results
fprintf('Computed PI Controller Gains:\n');
fprintf('K_P_out = %.6f\n', KP_out);
fprintf('K_I_out = %.6f\n', KI_out);
fprintf('K1_out = %.6f\n', K1_out);
fprintf('K2_out = %.6f\n', K2_out);
