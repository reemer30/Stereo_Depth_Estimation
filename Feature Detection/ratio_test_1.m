% Setup: clear and recreate variables
clear
figure(1)
%%
matches1 = [];
matches2 = [];
IMG1_PATH = 'shelf1.png';
IMG2_PATH = 'shelf0.png';
% read in image and grayscale it
I = rgb2gray(imread(IMG1_PATH));
J = rgb2gray(imread(IMG2_PATH));
% optional use SURF or FAST feature detector and select 100 strongest points
points_I = detectSURFFeatures(I);
points_J = detectSURFFeatures(J);

% extract features using raw pixel data and 5x5 window
features_i = my_extractFeatures_b(I, selectStrongest(points_I, 100));
features_j = my_extractFeatures_b(J, selectStrongest(points_J, 100));

for N = 1:size(features_i.pos, 1)
% Compare keypoint N with all keypoints in image 2
match_index = match_feature_r(features_i.d(N, :), features_j.d, 1);
    
    % If matching fails, skips saving the location
    if match_index ~= 'NULL'
        % Store pixel coordinates for the match and original pixel
        % Concatenate the new pixels into the match list
        loc = features_i.pos(N, :);
        m_loc = features_j.pos(match_index, :);
        matches1 = cat(1, matches1, loc );
        matches2 = cat(1, matches2, m_loc);
    end
end

% Display matched locations with built-in function
if(size(matches1, 1) > 0)
    showMatchedFeatures(imread(IMG1_PATH), imread(IMG2_PATH), matches1, matches2, 'montage');
    title('Matching with SIFT Descriptors: Ratio = 0.5');
end