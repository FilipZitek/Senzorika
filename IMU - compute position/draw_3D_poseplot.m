function draw_3D_poseplot(rot_matrices)
figure;
pp = poseplot;
xlabel('x');ylabel('y');zlabel('z');
for i = 1:size(rot_matrices,3)
    set(pp, "Orientation", rot_matrices(:,:,i))
%     drawnow limitrate
    pause(0.0005)
end
end