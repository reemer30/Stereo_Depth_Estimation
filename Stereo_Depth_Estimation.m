IMG1_PATH = 'bike1.png';
IMG2_PATH = 'bike0.png';% Camera Intrinsic Matrixcies: [fx 0 0; 1 fy 0; cx cy 1; 0 0 1]
% cameraMatrix1 = [3968.297 0  0; 1 3968.297 0; 1188.925 979.657 1; 0 0 1];
% cameraMatrix2 = [3968.297 0  0; 1 3968.297 0; 1266.14 979.657 1; 0 0 1];
% Pipes Camera Matricies
% cameraMatrix1 = [3968.297 0  0; 0 3968.297 0; 1188.925 979.657 1; 0 0 1];
% cameraMatrix2 = [3968.297 0  0; 0 3968.297 0; 1266.14 979.657 1; 0 0 1];
% Motorcycle Camera Matricies
cameraMatrix1 = [3979.911 0  0; 1 3979.911 0; 1244.772 1019.507 1; 0 0 1];
cameraMatrix2 = [3979.911 0  0; 1 3979.911 0; 1307.839 1019.507 1; 0 0 1];
% Jade Camera Matricies
% cameraMatrix1 = [7315.238 0  0; 1 7315.238 0; 997.555 980.754 1; 0 0 1];
% cameraMatrix2 = [7315.238 0  0; 1 7315.238 0; 1806.75 980.754 1; 0 0 1];
% Chair Camera Matricies
% cameraMatrix1 = [4161.221 0  0; 1 4161.221 0; 1445.577 984.686 1; 0 0 1];
% cameraMatrix2 = [4161.221 0  0; 1 4161.221 0; 1654.636 984.686 1; 0 0 1];
% Umbrella Camera Matricies
% cameraMatrix1 = [5806.559 0  0; 1 5806.559 0; 1429.219 993.403 1; 0 0 1];
% cameraMatrix2 = [5806.559 0  0; 1 5806.559 0; 1543.51  993.403 1; 0 0 1];
% Couch Camera Matricies
% cameraMatrix1 = [7193.133 0  0; 1 7193.133 0; 1080.083 1028.505 1; 0 0 1];
% cameraMatrix2 = [7193.133 0  0; 1 7193.133 0; 1555.895 1028.505 1; 0 0 1];

% read in image and grayscale it
% I_full = rgb2gray(imread(IMG1_PATH));
% J_full = rgb2gray(imread(IMG2_PATH));
% I = I_full(1:400, 400:800);
% J = J_full(1:400, 400:800);

I_C = imread(IMG1_PATH);
J_C = imread(IMG2_PATH);

I = rgb2gray(imread(IMG1_PATH));
J = rgb2gray(imread(IMG2_PATH));

I = imresize(I, .5);
J = imresize(J, .5);
I_C = imresize(I_C, .5);
J_C = imresize(J_C, .5);
I= imsharpen(I);
J= imsharpen(J);



%points1 = detectSURFFeatures(I, 'MetricThreshold', 500);
% Using Harris Feature Points
points1 = detectKAZEFeatures(I);
points2 = detectKAZEFeatures(J);

[features1, valid_points1] = extractFeatures(I, points1);
[features2, valid_points2] = extractFeatures(J, points2);
% 'MaxRatio', 0.6
indexPairs = matchFeatures(features1, features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

matches1 = [];
matches2 = [];
for N = 1:size(matchedPoints1.Location, 1) 
    if (abs(matchedPoints1.Location(N, 2) - matchedPoints2.Location(N, 2))) < 20
        matches1 = cat(1, matches1, matchedPoints1.Location(N,:));
        matches2 = cat(1, matches2, matchedPoints2.Location(N,:));
    end
end


% Display the Matched Features
figure; showMatchedFeatures(I,J,matches1,matches2);
title("Matched Features");
%%
% More built-ins time

% Extract the 3D World coordinates
worldPoints = triangulate(matches1, matches2,...
  cameraMatrix1, cameraMatrix2);

len = length(matches1);
distanceInMeters = zeros (len, 1);

% Compute the depth in meters
for i = 1:len
    dist = norm(worldPoints(i, :));
    distanceInMeters(i,1) = dist;
end

true_matches1 = [];
true_matches2 = [];
true_distanceInMeters = [];

% Filter distances that are greater than 20 meters
for j = 1:len
    if distanceInMeters(j,1) < 20
        true_distanceInMeters = cat(1, true_distanceInMeters, distanceInMeters(j,1));
        true_matches1 = cat(1, true_matches1, matches1(j,:));
        true_matches2 = cat(1, true_matches2, matches2(j,:));
    end
end

true_len = length(true_distanceInMeters);
% Add the depth measurements to both images 
for N = 1:true_len
    I_C = insertObjectAnnotation(I_C, 'rectangle', [true_matches1(N, :) 5 5] , sprintf('%0.3f m',true_distanceInMeters(N)), ...
    'FontSize', 18);
    J_C = insertObjectAnnotation(J_C, 'rectangle', [true_matches2(N, :) 5 5], sprintf('%0.3f m',true_distanceInMeters(N)), ...
    'FontSize', 18);
%     I = insertShape(I, 'FilledRectangle', matchedPoints1(N, :)');
%     J = insertShape(J, 'FilledRectangle', matchedPoints2(N, :)');
end
figure; imshowpair(I_C, J_C, 'montage'); 
title("Depth of Matched Points for Both Images")

figure; imshow(I_C); title("Depth of Matched Points for a Single Image")
%%
DM = create_depth_map(double(I), true_matches1, true_distanceInMeters);
figure; imshow(DM, [])
title("depth map, []")
%%
DM_norm = abs(DM - max(true_distanceInMeters));
figure; imshow(DM_norm, [])
title("depth map norm")
%%
% % %%
% % Only relevant if we do not use the triangulate builtin
% % pipe_base = 236.922;
% % pipe_focal = 3968.297;
% % 
% % Find the relative depth distances
% % [depth_vals] = depth_estimaton(pipe_base, pipe_focal, matchedPoints1,matchedPoints2, 5, 0);
% % 
% % Farther points should be more green
% % color = [0, 255, 0];
% % 
% % Display 'X' markers with the color weighted by the distance
% % depth_color = depth_vals(:,1).*color;
% % mark_pipes = insertMarker(I_C, depth_vals(:,2:3), 'x', 'color', depth_color, 'size', 50);
% % figure; imshow(mark_pipes); title("Marked Pipes 2")
