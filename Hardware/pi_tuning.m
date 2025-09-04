% File: pi_tuning.m
% PI Controller tuning for ID, IQ, Voltage, and Reactive Power loops

%% ======================= ID CURRENT CONTROLLER ==========================

A_id = [-(rac)/Lc            -1/Lc; 
         1/C_filtre      -1/(rac*C_filtre) ];
B_id = [1/Lc; 0];
C_id = [1 0];
D_id = 0;

[N_id,D_id_tf] = ss2tf(A_id,B_id,C_id,D_id,1);
iov_id = minreal(zpk(tf(N_id,D_id_tf)));
Poles_id = pole(iov_id);
DCGain_id = dcgain(iov_id);

Wp1_in = min(abs(real(Poles_id)));
Wbi = 1*2*pi*(Fs/2);
KP_curr_d = Wbi / (DCGain_id * Wp1_in);
KI_curr_d = KP_curr_d * Wp1_in;

fprintf('ID Controller: KP = %.6f, KI = %.6f\n', KP_curr_d, KI_curr_d);

%% ======================= IQ CURRENT CONTROLLER ==========================
KP_curr_q = KP_curr_d;
KI_curr_q = KI_curr_d;

fprintf('IQ Controller: KP = %.6f, KI = %.6f\n', KP_curr_q, KI_curr_q);

%% ======================= VOLTAGE CONTROLLER =============================

A_v = [-(rac+KP_curr_q)/Lc  0  0  KI_curr_q/Lc  0;
        0 -(rac+KP_curr_q)/Lc 0  0 KI_curr_q/Lc;
       -Vmod0_real/Cdc -Vmod0_imag/Cdc -1/(rdc*Cdc) 0 0;
       -1 0 0 0 0;
        0 -1 0 0 0];

B_v = [KP_curr_q/Lc 0 0 0;
        0 KP_curr_q/Lc 0 0;
        0 0 -Id/Cdc -Iq/Cdc;
        1 0 0 0;
        0 1 0 0];

C_v = [0 0 1 0 0];
D_v = [0 0 0 0];

[N_vod,D_volt] = ss2tf(A_v,B_v,C_v,D_v,1);
iov_volt = minreal(zpk(tf(N_vod,D_volt)));
Poles_volt = pole(iov_volt);
DCGain_volt = dcgain(iov_volt);

Wp1_volt = min(abs(real(Poles_volt)));
band_volt = 5000 * Wp1_volt;
C_volt = pidtune(iov_volt, 'PI', band_volt);
KP_volt = C_volt.Kp;
KI_volt = C_volt.Ki;

fprintf('Voltage Controller: KP = %.6f, KI = %.6f\n', KP_volt, KI_volt);

%% ===================== REACTIVE POWER CONTROLLER ========================

C_q = [0 1 0 0 0];
D_q = [0 0 0 0];

[N_q,D_q_tf] = ss2tf(A_v,B_v,C_q,D_q,2);
iov_q = minreal(zpk(tf(N_q,D_q_tf)));
Poles_q = pole(iov_q);
DCGain_q = dcgain(iov_q);

Wp1_q = min(abs(real(Poles_q)));
band_volt_q = 20 * Wp1_q;
C_q_ctrl = pidtune(iov_q, 'PI', band_volt_q);
KP_q = C_q_ctrl.Kp;
KI_q = C_q_ctrl.Ki;

fprintf('Reactive Power Controller: KP = %.6f, KI = %.6f\n', KP_q, KI_q);
