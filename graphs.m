%% 3d POINTS
threedee_points = cat(2, matches2, distanceInMeters);
figure;
heights = (max(threedee_points(:,3)) - threedee_points(:,3));
plot3(threedee_points(:,1),threedee_points(:,2),heights, '.');
hold on;      % Add to the plot
xlabel('x');
ylabel('y');
zlabel('z');
xImage = [0 2960; 0 2960];   % The x data for the image corners
yImage = [0 0; 1924 1924];             % The y data for the image corners
zImage = [0 0; 0 0];   % The z data for the image corners
surf(xImage,yImage,zImage,...    % Plot the surface
     'CData',I_C,...
     'FaceColor','texturemap');
 
%% 3D SURFACE
figure;
xy = double(threedee_points(:, 1:2));
x = double(threedee_points(:,1));
y = double(threedee_points(:,2));
v = double(threedee_points(:,3));
%v = double(heights);
[xq,yq] = meshgrid(0:1:2960, 0:1:1924);
vq = griddata(x,y,v,xq,yq, 'Natural');
%mesh(xq,yq,vq)
%mesh(xq,yq,vq,'FaceAlpha', '0.3')

% hold on;      % Add to the plot
% plot3(x,y,v,'o')
% xlabel('x');
% ylabel('y');
% zlabel('z');
% xImage = [0 2960; 0 2960];   % The x data for the image corners
% yImage = [0 0; 1924 1924];             % The y data for the image corners
% zImage = [0 0; 0 0];   % The z data for the image corners
% surf(xImage,yImage,zImage,...    % Plot the surface
%      'CData',I_C,...
%      'FaceColor','texturemap');

 %% STEM PLOT
 figure;
xlabel('x');
ylabel('y');
zlabel('z');
xImage = [0 2960; 0 2960];   % The x data for the image corners
yImage = [0 0; 1924 1924];             % The y data for the image corners
zImage = [0 0; 0 0];   % The z data for the image corners
surf(xImage,yImage,zImage,...    % Plot the surface
     'CData',I_C,...
     'FaceColor','texturemap');
 hold on
 a = stem3(x, y, v, '.'); % Use values created for mesh
 
 %% YUH
 figure(69)
 yeet = vq./(max(vq));
 imshow(yeet);
