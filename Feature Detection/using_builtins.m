IMG1_PATH = 'pipe1.png';
IMG2_PATH = 'pipe0.png';
% read in image and grayscale it
I = rgb2gray(imread(IMG1_PATH));
J = rgb2gray(imread(IMG2_PATH));
%% HARRIS
points1 = detectHarrisFeatures(I);
points2 = detectHarrisFeatures(J);

[features1, valid_points1] = extractFeatures(I, points1);
[features2, valid_points2] = extractFeatures(J, points2);

indexPairs = matchFeatures(features1, features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

figure; showMatchedFeatures(I,J,matchedPoints1,matchedPoints2);

%% FAST

points1 = detectFASTFeatures(I);
points2 = detectFASTFeatures(J);

[features1, valid_points1] = extractFeatures(I, points1);
[features2, valid_points2] = extractFeatures(J, points2);

indexPairs = matchFeatures(features1, features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

figure; showMatchedFeatures(I,J,matchedPoints1,matchedPoints2);

%% SURF

points1 = detectFASTFeatures(I);
points2 = detectFASTFeatures(J);

[features1, valid_points1] = extractFeatures(I, points1);
[features2, valid_points2] = extractFeatures(J, points2);

indexPairs = matchFeatures(features1, features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

figure; showMatchedFeatures(I,J,matchedPoints1,matchedPoints2);
