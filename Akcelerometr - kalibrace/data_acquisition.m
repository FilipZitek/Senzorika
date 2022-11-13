%daqreset
clear all
close all

dq = daq("ni");
ch_input=addinput(dq,"Dev1","ai4","Voltage");
ch_input_ref=addinput(dq,"Dev1","ai5","Voltage");
ch_input.TerminalConfig = "SingleEnded";
ch_input.Range = [-5 5];
ch_input_ref.TerminalConfig = "SingleEnded";
ch_input_ref.Range = [-5 5];

ch_output=addoutput(dq,"Dev1","ao1","Voltage");
% ch_output.Range=[];
ch_output.TerminalConfig="SingleEnded";
dq.Rate=10000;

%% Output Signal

amplitudePeakToPeak_ch1 = 0.03;    % V
sineFrequency = 1000;             % Hz
totalDuration = 10;             % seconds

outputSignal = [];
outputSignal(:,1) = createSine(amplitudePeakToPeak_ch1/2, sineFrequency, dq.Rate, "bipolar", totalDuration);
outputSignal(end+1,:) = 0;

%% Read & Write
disp('Start');
data1 = readwrite(dq, outputSignal);

plot(data1.Time, data1.Variables);
xlabel("Time");
ylabel("Voltage (V)");
title("Acquired Signal");
legend(data1.Properties.VariableNames);
grid on;

[acc1,acc2]=u2g(data1.Dev1_ai4,data1.Dev1_ai5);
figure(2);hold on;
plot(data1.Time, acc1);
plot(data1.Time, acc2);
xlabel("Time");
ylabel("Acc (g)");
title("Acceleration");
legend(data1.Properties.VariableNames);
grid on;


%%
function sine = createSine(A, f, sampleRate, type, duration)

numSamplesPerCycle = floor(sampleRate/f);
T = 1/f;
timestep = T/numSamplesPerCycle;
t = (0 : timestep : T-timestep)';

if type == "bipolar"
    y = A*sin(2*pi*f*t);
elseif type == "unipolar"
    y = A*sin(2*pi*f*t) + A;
end

numCycles = round(f*duration);
sine = repmat(y,numCycles,1);
end

