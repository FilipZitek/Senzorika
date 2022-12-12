function plotPerformance(est, act)
% Plot the orientation error in degrees in a new figure window.

time_vector=(0:5:5*7699)'/1000;
est_quat=quaternion(rotm2quat(est));
act_quat=quaternion(eul2quat(act));

plot(time_vector,(norm(est_quat-act_quat)));
end