function plotPerformance(est, act)
% Plot the orientation error in degrees in a new figure window.

est_quat=quaternion(rotm2quat(est));
act_quat=quaternion(eul2quat(act));
plot((norm(est_quat-act_quat)));
end