format longg 
warning('off')

run("dcdc_converter_parameters.m")

%% Converter Current Follower


%         Io              Vi                   Vcb
A = [-(ro)/Lb           D0/Lb                 (-1)/Lb; ...               % [Io]
      (-D0)/Ci       -1/(rsi*Ci)                 0   ; ...               % [Vi]
      1/Ccb                 0                 (-1)/(rb*Ccb)];           % [Vcb] 

EigA = eig(A);

%     Vsi            Vb                     d
B = [  0              0                    (Vi0)/Lb ;    ... % [Io]
       1/(rsi*Ci)     0                  -(Io0)/Ci;   ...    % [Vi]
       0           1/(rb*Ccb)                0];            % [Vcb]

%    Io Vi Vcb
C = [1   0  0]; % [vi]

%    Vsi Vb d
D = [0    0   0]; % [io]

%% ----------------------------------------------
% Transfer Function Extraction for Output Current (i_od)
%% ----------------------------------------------

[N_iod, D_iod] = ss2tf(A, B, C, D, 3);         % Get numerator and denominator of transfer function
                                               % for the 3rd output (i_o) from state-space model

iod = minreal(zpk(tf(N_iod, D_iod)));          % Convert to zero-pole-gain form and remove pole-zero cancellations

Poles_iod  = pole(iod);                        % Extract system poles
Zeros_iod  = zero(iod);                        % Extract system zeros
DCGain_iod = dcgain(iod);                      % Compute DC gain of the transfer function

%% ----------------------------------------------
% PI Controller Design for Current Control Loop
Wp1_out = min(abs(real(Poles_iod)));           % Select the slowest (smallest-magnitude) real pole
Wci_out = Wp1_out;                             % Set crossover frequency equal to slowest pole (conservative design)

% Proportional gain calculation using magnitude at crossover frequency
KP = Wbi_dc / (DCGain_iod * Wci_out);          % KP = desired open-loop bandwidth / (DC gain × Wci)
KI = KP * Wci_out;                             % KI = KP × Wci, so zero of PI is placed at Wci

%% ----------------------------------------------
% Display Computed PI Gains
%% ----------------------------------------------

fprintf('Computed PI Controller Gains:\n');
fprintf('KP_converter = %.6f\n', KP);
fprintf('KI_converter = %.6f\n', KI);
fprintf('Wci = %.6f\n', Wci_out);

