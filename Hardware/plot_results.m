% File: plot_results.m
% Script to plot logged data from DQ control simulation

%% Time remapping for logs
Ts = 5e-5; 
N = length(pll_log);
time_log = (0:N-1)' * Ts;

x1 = 0.03855;  t1 = 20;
x2 = 0.09045;  t2 = 40;
a = (t2 - t1) / (x2 - x1);
b = t1 - a * x1;
time_log = a * time_log + b;

%% --- Plot PLL and DQ voltages ---
figure;
plot(time_log, pll_log, '-',  'LineWidth', 1.6); hold on;
plot(time_log, ac_voltage_log, '--', 'LineWidth', 1.4);
plot(time_log, VD_log, '-.', 'LineWidth', 1.4);
plot(time_log, VQ_log, ':',  'LineWidth', 1.6);
legend('PLL Output', 'AC Voltage', 'V_D', 'V_Q');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;
title('PLL and DQ Voltage Components');

%% --- Plot DQ currents ---
figure;
plot(time_log, ID_log, '-', 'LineWidth', 1.6); hold on;
plot(time_log, IQ_log, '--', 'LineWidth', 1.6);
legend('I_D', 'I_Q'); xlabel('Time (s)'); ylabel('Current (A)');
title('DQ Current Components'); grid on;

%% --- Plot Vmod signal ---
figure;
plot(time_log, Vmod, '-.', 'LineWidth', 1.6);
xlabel('Time (s)'); ylabel('V_{mod}'); grid on;
title('Modulation Signal');

%% --- Plot Q instant ---
figure;
plot(time_log, Q_inst, '-', 'LineWidth', 1.6);
xlabel('Time (s)'); ylabel('Q_{inst} (var)'); grid on;
title('Instantaneous Reactive Power');

%% --- Combined Voltage/Current Log ---
figure;
subplot(3,1,1); plot(time_log, ac_voltage_log); title('AC Voltage'); ylabel('Vac (V)'); grid on;
subplot(3,1,2); plot(time_log, Vdc_log); title('DC Voltage'); ylabel('Vdc (V)'); grid on;
subplot(3,1,3); plot(time_log, Iac_log); title('AC Current'); ylabel('Iac (A)'); xlabel('Time (s)'); grid on;

%% --- Overlay Plot: Vac, Vmod, ID ---
figure;
subplot(3,1,1); plot(time_log, ac_voltage_log); title('AC Voltage'); ylabel('Vac (V)'); grid on;
subplot(3,1,2); plot(time_log, Vmod); title('Modulation Signal'); ylabel('Vmod'); grid on;
subplot(3,1,3); plot(time_log, ID_log); title('D-Axis Current'); ylabel('I_D (A)'); xlabel('Time (s)'); grid on;
