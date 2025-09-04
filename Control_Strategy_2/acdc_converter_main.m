format longg 
warning('off')

run("acdc_converter_parameters.m")

%% ---------------------------------------------
% ID Control Loop Design (d-axis current controller)
%% ---------------------------------------------

s = tf('s');                                      % Define Laplace variable for transfer function
iod_curr = 1 / (s * Lc + rac);                    % Open-loop transfer function of d-axis current path
Poles_curr_d  = pole(iod_curr);                   % Poles of the current transfer function
DCGain_curr_d = dcgain(iod_curr);                 % DC gain of the plant
[num_curr_d, den_curr_d] = tfdata(iod_curr, 'v'); % Numerator and denominator vectors

%% ---------------------------------------------
% PI Controller Design (pole cancellation approach)
%% ---------------------------------------------



% Pole-zero cancellation approach:
KP_curr_d = 2 * pi * w_i * Lc;     % Proportional gain 
KI_curr_d = 2 * pi * w_i * rac;    % Integral gain 

% Define PI controller in s-domain
K_s_curr_d = tf([KP_curr_d, KI_curr_d], [1, 0]);

% Closed-loop transfer function with unity feedback
T_s_curr_d = feedback(K_s_curr_d * iod_curr, 1);

% Optional: Step and frequency response analysis (commented out)
% figure; step(T_s_curr_d); title('ID Step Response of Closed-Loop System');
% figure; bode(T_s_curr_d); grid on; title('ID Bode Plot of Closed-Loop System');

% Display controller gains
fprintf('Computed PI Controller Gains:\n');
fprintf('KP_curr_d = %.6f\n', KP_curr_d);
fprintf('KI_curr_d = %.6f\n', KI_curr_d);

%% ---------------------------------------------
% IQ Control Loop Design (q-axis current controller)
%% ---------------------------------------------

s = tf('s');                                     % Re-define Laplace variable (optional redundancy)
ioq_curr = 1 / (s * Lc + rac);                   % Open-loop transfer function for q-axis current path
Poles_curr_q  = pole(ioq_curr);                 % Poles of the system
DCGain_curr_q = dcgain(ioq_curr);               % DC gain of the system
[num_curr_q, den_curr_q] = tfdata(ioq_curr, 'v'); % Numerator and denominator vectors

% PI Controller Gains (same as d-axis if system is symmetrical)
KP_curr_q = 2 * pi * w_i * Lc;                   % Proportional gain
KI_curr_q = 2 * pi * w_i * rac;                  % Integral gain

% Define PI controller
K_s_curr_q = tf([KP_curr_q, KI_curr_q], [1, 0]);

% Closed-loop transfer function
T_s_curr_q = feedback(K_s_curr_q * ioq_curr, 1);

% Optional: Step and Bode response
% figure; step(T_s_curr_q); title('IQ Step Response of Closed-Loop System');
% figure; bode(T_s_curr_q); grid on; title('IQ Bode Plot of Closed-Loop System');

% Display controller gains
fprintf('Computed PI Controller Gains:\n');
fprintf('KP_curr_q = %.6f\n', KP_curr_q);
fprintf('KI_curr_q = %.6f\n', KI_curr_q);

%% ---------------------------------------------
% DC Link Voltage Control
%% ---------------------------------------------

%% Outer loop State-space representation of vdc(s)/Id_ref(s) dynamics

%         Id                          Iq                Vdc         Xd             Xq
A_v = [-(rac+KP_curr_q)/Lc            0                 0        KI_curr_q/Lc        0; ...             % [Id]
           0                    -(rac+KP_curr_q)/Lc     0            0           KI_curr_q/Lc ; ...     % [Iq]
       -Vmod0_real/Cdc           -Vmod0_imag/Cdc    -1/(rdc*Cdc)     0                0; ...               %  [Vdc]
       -1                             0               0              0                0; ...               % [Xd]
       0                              -1               0             0                0];                % [Xq] 



%       Id_ref                  Iq_ref     Vmod_real   Vmod_imag       
B_v = [  KP_curr_q/Lc             0             0             0 ;    ...                % [Id]
         0                       KP_curr_q/Lc   0             0 ;   ...                 % [Iq]
         0                         0         -Id0/Cdc      -Iq0/Cdc;  ...       % [Vdc]
         1                         0            0             0;      ...        % [Xd]
         0                         1            0             0];                 % [Xd]

%      Id  Iq Vdc Xd  Xq
C_v = [0   0  1   0   0];                                                                   % [vdc]

%       Id_ref Iq_ref  Vmod_real  Vmod_imag
D_v = [   0      0         0         0];                 % []

%% ---------------------------------------------
% Voltage Control Loop PI Design (Ziegler-Nichols Based)
%% ---------------------------------------------

% Extract transfer function from state-space model (voltage control path)
[N_vod, D_volt] = ss2tf(A_v, B_v, C_v, D_v, 1);     % Transfer function for output 1
iov_volt = minreal(zpk(tf(N_vod, D_volt)));        % Simplify transfer function (cancel pole-zero pairs)

% Analyze system dynamics
Poles_volt  = pole(iov_volt);                      % Get poles of plant
Zeros_volt  = zero(iov_volt);                      % Get zeros of plant
DCGain_volt = dcgain(iov_volt);                    % Get DC gain of plant

%% ---------------------------------------------
% PI Controller Design using Ziegler-Nichols Tuning
%% ---------------------------------------------

% Automatically tune a PI controller using pidtune (control system toolbox)
C_volt = pidtune(iov_volt, 'PI', band_volt);        % PI tuning for target crossover frequency

% Extract controller gains from pidtune object
KP_volt = C_volt.Kp;                                % Proportional gain
KI_volt = C_volt.Ki;                                % Integral gain

% Define the continuous-time PI controller transfer function
K_s_volt = tf([KP_volt, KI_volt], [1, 0]);

% Compute closed-loop transfer function with unity feedback
T_s_volt = feedback(K_s_volt * iov_volt, 1);

%% ---------------------------------------------
% Step and Frequency Response Analysis
%% ---------------------------------------------

% % Step Response
% figure;
% step(T_s_volt);
% title('Volt Step Response of Closed-Loop System');

% % Bode Plot for Stability Analysis
% figure;
% bode(T_s_volt);
% grid on;
% title('Volt Bode Plot of Closed-Loop System');

%% ---------------------------------------------
% Display Controller Gains
%% ---------------------------------------------
fprintf('Computed PI Controller Gains:\n');
fprintf('KP_volt = %.6f\n', KP_volt);
fprintf('KI_volt = %.6f\n', KI_volt);



%% ---------------------------------------------
% Reactive Power Control Loop: PI Controller Design
%% ---------------------------------------------

%      Id   Iq   Vdc   Xd  Xq
C_q = [0    0    1      0     0];                                                                   % [vdc]

%       Id_ref Iq_ref  Vmod_real  Vmod_imag 
D_q = [   0      0         0         0];                 % []

% Extract transfer function from state-space (2nd output path)
[N_q, D_q] = ss2tf(A_v, B_v, C_q, D_q, 2);
iov_q = minreal(zpk(tf(N_q, D_q)));       % Simplified zero-pole-gain form

% Analyze system dynamics
Poles_q   = pole(iov_q);                  % Poles of the plant
Zeros_q   = zero(iov_q);                  % Zeros of the plant
DCGain_q  = dcgain(iov_q);                % DC gain of the system


%% ---------------------------------------------
% Controller Design: Ziegler-Nichols Tuning (Preferred)
%% ---------------------------------------------


% Tune a PI controller automatically using pidtune
C_q = pidtune(iov_q, 'PI', band_volt_q);

% Extract tuned gains
KP_q = C_q.Kp;
KI_q = C_q.Ki;

% Display controller parameters
fprintf('Computed PI Controller Gains:\n');
fprintf('KP_q = %.6f\n', KP_q);
fprintf('KI_q = %.6f\n', KI_q);

%% ---------------------------------------------
% Closed-Loop System Definition and Analysis
%% ---------------------------------------------

% Define PI controller transfer function
K_s_q = tf([KP_q, KI_q], [1, 0]);

% Compute closed-loop system with unity feedback
T_s_q = feedback(K_s_q * iov_q, 1);

% Optional: Step response
% figure;
% step(T_s_q);
% title('Reactive Power Control - Step Response');

% Optional: Frequency domain stability analysis
% figure;
% bode(T_s_q);
% grid on;
% title('Reactive Power Control - Bode Plot');
