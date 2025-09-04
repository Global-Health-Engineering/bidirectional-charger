% === Simulink Model Name ===
%=== Define Test Set ===
P_array = [500, 500, 500, -500, -500, -500];   % Active power input list
Q_array = [  0, 500,-500,    0,  500, -500];   % Reactive power input list

%=== Set Initial Q ===
% 1--> set Q to zero for the first instants of the simulation,
% 0--> set Q to current Q_array value since the simulation start
Q_switch_array = [0,1,1,1,1,1]; 


model = 'control_strategy_1';

% === Run Simulink for each test case ===
for i = 1:length(P_array)
    fprintf('Running test %d: P = %d W, Q = %d VAR\n', i, P_array(i), Q_array(i));

    % Assign test-specific power values to base workspace
    assignin('base', 'P', P_array(i));
    assignin('base', 'Q', Q_array(i));
    assignin('base', 'q_switch', Q_switch_array(i));
    
    % Run simulation
    simOut = sim(model, ...
        'SaveOutput', 'on', ...
        'ReturnWorkspaceOutputs', 'on');

    % Optional: extract and store logged signals
    %logsout = simOut.logsout;
    %Pmeas_log   = logsout.getElement('Pmeas_log');
    %Qmeas_log   = logsout.getElement('Qmeas_log');


    
    % Save or plot results as needed
    %results(i).P = P_array(i);
    %results(i).Q = Q_array(i);

end
