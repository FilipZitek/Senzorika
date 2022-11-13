clear variables

try
    a=arduino('COM4', 'Mega2560', 'Libraries', 'I2C');
catch exception
    error_msg=append(exception.message,'\nAvailable ports: ',serialportlist,'\n');
    error(sprintf(error_msg))
end

sensor=mpu6050(a);

% %preallocating vectors
% dataAcc=zeros(num_of_packets*samples_in_package,3);
% dataGyro=zeros(num_of_packets*samples_in_package,3);
% dataTimestamps = NaT(num_of_packets*samples_in_package,1,'TimeZone','Europe/Prague','Format','yyyy-MMMM-dd HH:mm:ss.SSS');    %not-a-time matrix

pp = poseplot;
view(45,20);
disp('START!')
while true
    accel = sensor.readAcceleration;
    gyro = sensor.readAngularVelocity;
    fuse = imufilter();
    q = fuse(accel,gyro);
    set(pp, "Orientation", q)
    drawnow limitrate
end

