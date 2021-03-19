im1 = rgb2gray(imread('pipes1.png'));
im2 = rgb2gray(imread('pipes2.png'));

% detected_features1 = detectHarrisFeatures(im1);
% detected_features2 = detectHarrisFeatures(im2);
% 
% [features1, valid_points1] = extractFeatures(im1, detected_features1);
% [features2, valid_points2] = extractFeatures(im2, detected_features2);
% 
% indexPairs = matchFeatures(features1, features2);
% 
% matchedPoints1 = valid_points1(indexPairs(:,1),:);
% matchedPoints2 = valid_points2(indexPairs(:,2),:);
% 
% figure; showMatchedFeatures(im1,im2, matchedPoints1,matchedPoints2);

% imshow(im1),hold on; plot(detected_features1.selectStrongest(50));
% % subplot(1,2,2), imshow(im2), plot(detected_features2.selectStrongest(50));
% 
% extracted_features1 = my_extractFeatures(im0, detected_features1);
% 
% A = stereoAnaglyph(im1, im2);
% figure
% imtool(A)

% Camera Intrinsic Matrixcies: [fx 0 0; 1 fy 0; cx cy 1; 0 0 1]
cameraParameters1 = [3968.297 0  0; 1 3968.297 0; 1188.925 979.657 1; 0 0 1];
cameraParameters2 = [3968.297 0  0; 1 3968.297 0; 1266.14 979.657 1; 0 0 1];




d_range1 = disp_range_filter(im1, im2, 290);
% d_range2 = disp_range_filter(im1, im2, 300);
% d_range3 = disp_range_filter(im1, im2, 290);
% d_range4 = disp_range_filter(im1, im2, 280);

disparityMap1 = disparityBM(im1, im2, 'DisparityRange', d_range1, 'UniquenessThreshold', 10);
% figure;
% subplot(2,2,1), imshow(disparityMap1, d_range1)
% title('Disparity Map, Max range = 400')
% colormap jet
% colorbar


disparityMap_filtered = rmmissing(disparityMap1, 2);
H = fspecial('average', 5);
disparityMap_filtered = imfilter(disparityMap_filtered, H);
H = fspecial('gaussian', 5);
disparityMap_filtered = imfilter(disparityMap_filtered, H);

disparityMap_resized = imresize(disparityMap_filtered, 0.05, 'nearest');

[m, n] = size(disparityMap_resized);

% temp = disparityMap_resized.*3997.684;
% doffs=131.111;
% 
% 
% 
% for i = 1:m
%     for j = 1:n
%         d= disparityMap_resized(i,j);
%         
%         
% 
% X = (1:1940)';
% X = repmat(X,1,2933);
% 
% Y = (1:2933);
% Y = repmat(Y,1940,1);

X = (1:97)';
X = repmat(X,1,147);

Y = (1:147);
Y = repmat(Y,97,1);

surf(X,Y,disparityMap_resized);

% imshow(disparityMap_filtered, d_range1)

% stem3(X, Y, Z);

% dmap = zeros(m,n);
% dmap(:,:,1) = X;
% dmap(:,:,2) = Y;
% dmap(:,:,3) = disparityMap_resized;

Z = disparityMap_resized;





% surface(X,Y,Z);
% figure;
% imshow(disparityMap_resized, d_range1);
% 
% figure;
% plot3(X,Y,disparityMap_resized);



function disp_range = disp_range_filter(im1, im2, d_thresh)

points1 = detectSURFFeatures(im1);
points2 = detectSURFFeatures(im2);

[features1, valid_points1] = extractFeatures(im1, points1);
[features2, valid_points2] = extractFeatures(im2, points2);

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
% 
% worldPoints = triangulate(matches, matches2,...
%   cameraMatrix1, cameraMatrix2);

distance = @(x1,x2,y1,y2)sqrt((x2-x1).^2+(y2-y2).^2);

d = distance(...
    matchedPoints1.Location(:,1),...
    matchedPoints2.Location(:,1),...
    matchedPoints1.Location(:,2),...
    matchedPoints2.Location(:,2));

for n = 1 : length(d)
    if(d(n) > d_thresh)
        d(n) = 300;
    end
end
d_max = round(max(d));
d_min = round(min(d));

while (rem(d_max-d_min, 16) ~= 0)
    d_max = d_max-1;
end

disp_range = [d_min, d_max];
end 