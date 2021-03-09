IMG1_PATH = 'pipe1.png';
IMG2_PATH = 'pipe0.png';
% read in image and grayscale it
I = rgb2gray(imread(IMG1_PATH));
J = rgb2gray(imread(IMG2_PATH));
I_C = imread(IMG1_PATH);

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