IMG1_PATH = 'pipe1.png';
IMG2_PATH = 'pipe0.png';
% read in image and grayscale it
I = rgb2gray(imread(IMG1_PATH));
J = rgb2gray(imread(IMG2_PATH));
I_C = imread(IMG1_PATH);
J_C = imread(IMG2_PATH);

% Using Harris Feature Points
points1 = detectHarrisFeatures(I);
points2 = detectHarrisFeatures(J);

[features1, valid_points1] = extractFeatures(I, points1);
[features2, valid_points2] = extractFeatures(J, points2);

indexPairs = matchFeatures(features1, features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

% Display the Matched Features
figure; showMatchedFeatures(I,J,matchedPoints1,matchedPoints2);
title("Matched Features");

% More built-ins time
% Camera Intrinsic Matrixcies: [fx 0 0; 1 fy 0; cx cy 1; 0 0 1]
cameraMatrix1 = [3968.297 0  0; 1 3968.297 0; 1188.925 979.657 1; 0 0 1];
cameraMatrix2 = [3968.297 0  0; 1 3968.297 0; 1266.14 979.657 1; 0 0 1];

% Extract the 3D World coordinates
worldPoints = triangulate(matchedPoints1.Location, matchedPoints2.Location,...
  cameraMatrix1, cameraMatrix2);

len = length(matchedPoints1);
distanceInMeters = zeros (len, 1);

% Compute the depth in meters
for i = 1:len
    dist = norm(worldPoints(i, :));
    distanceInMeters(i,1) = dist;
end

% Add the depth measurements to both images 
for N = 1:len
    I_C = insertObjectAnnotation(I_C, 'rectangle', [matchedPoints1.Location(N, :) 5 5] , sprintf('%0.3f m',distanceInMeters(N)), ...
    'FontSize', 18);
    J_C = insertObjectAnnotation(J_C, 'rectangle', [matchedPoints2.Location(N, :) 5 5], sprintf('%0.3f m',distanceInMeters(N)), ...
    'FontSize', 18);
%     I = insertShape(I, 'FilledRectangle', matchedPoints1(N, :)');
%     J = insertShape(J, 'FilledRectangle', matchedPoints2(N, :)');
end
figure; imshowpair(I_C, J_C, 'montage'); 
title("Depth of Matched Points for Both Images")

figure; imshow(I_C); title("Depth of Matched Points for a Single Image")


% Only relevant if we do not use the triangulate builtin
pipe_base = 236.922;
pipe_focal = 3968.297;

% Find the relative depth distances
[depth_vals] = depth_estimaton(pipe_base, pipe_focal, matchedPoints1,matchedPoints2, 5, 0);

% Farther points should be more green
color = [0, 255, 0];

% Display 'X' markers with the color weighted by the distance
depth_color = depth_vals(:,1).*color;
mark_pipes = insertMarker(I_C, depth_vals(:,2:3), 'x', 'color', depth_color, 'size', 50);
figure; imshow(mark_pipes); title("Marked Pipes 2")