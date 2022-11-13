clear variables

recording_time=5; %seconds
sample_rate=200;    %max 200
samples_in_package=500; %max 500
fusion_decimation_factor=2;

% disp(serialportlist) % list available ports

num_of_packets = ceil(recording_time*sample_rate/samples_in_package);

try
    a=arduino('COM4', 'Mega2560', 'Libraries', 'I2C');
catch exception
    error_msg=append(exception.message,'\nAvailable ports: ',serialportlist,'\n');
    error(sprintf(error_msg))
end

sensor=mpu6050(a,'SampleRate',sample_rate,'SamplesPerRead',samples_in_package,'OutputFormat', 'matrix');

%preallocating vectors
dataAcc=zeros(num_of_packets*samples_in_package,3);
dataGyro=zeros(num_of_packets*samples_in_package,3);
dataTimestamps = NaT(num_of_packets*samples_in_package,1,'TimeZone','Europe/Prague','Format','yyyy-MMMM-dd HH:mm:ss.SSS');    %not-a-time matrix

disp('START!')
for i = (1:num_of_packets)
    [accel, gyro, timeStamps, overrun] = sensor.read;
    dataAcc((i-1)*samples_in_package+1:i*samples_in_package,:)=accel;
    dataGyro((i-1)*samples_in_package+1:i*samples_in_package,:)=gyro;
    dataTimestamps((i-1)*samples_in_package+1:i*samples_in_package,:)=timeStamps;
end

%% POSTPROCESSING
dataGyro(:,1)=dataGyro(:,1)+0.0822;
dataGyro(:,2)=dataGyro(:,2)-0.0435;
dataGyro(:,3)=dataGyro(:,3)+0.0118;

plot(dataTimestamps,dataAcc);
title('Acc')
legend('X', 'Y', 'Z')
xlabel('Time')
ylabel('Acceleration (m/s^2)')
figure;
plot(dataTimestamps, dataGyro);
title('Gyro')
legend('X', 'Y', 'Z')
xlabel('Time')
ylabel('Angular velocity (rad/s)')

%% DATA FUSION
fuse = imufilter('SampleRate',sample_rate,'DecimationFactor',fusion_decimation_factor);

q = fuse(dataAcc,dataGyro);

figure;
timesAfterFuse=dataTimestamps(1:fusion_decimation_factor:end);
plot(timesAfterFuse,eulerd(q,'ZYX','frame'))
title('Orientation Estimate')
legend('Z-axis', 'Y-axis', 'X-axis')
xlabel('Time')
ylabel('Rotation (degrees)')

%% POSE PLOT
figure;
pp = poseplot;
for i = 1:size(q,1)
    set(pp, "Orientation", q(i))
    drawnow limitrate
    pause(0.01)
end
    
