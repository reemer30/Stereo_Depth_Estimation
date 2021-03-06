im1 = rgb2gray(imread('pipes1.png'));
im2 = rgb2gray(imread('pipes2.png'));





d_range1 = disp_range_filter(im1, im2, 300);
d_range2 = disp_range_filter(im1, im2, 290);
d_range3 = disp_range_filter(im1, im2, 300);
d_range4 = disp_range_filter(im1, im2, 320);

disparityMap1 = disparitySGM(im1, im2, 'DisparityRange', d_range1, 'UniquenessThreshold', 10);
disparityMap2 = disparityBM(im1, im2, 'DisparityRange', d_range2, 'UniquenessThreshold', 10);
disparityMap3 = disparityBM(im1, im2, 'DisparityRange', d_range3, 'UniquenessThreshold', 10);
disparityMap4 = disparityBM(im1, im2, 'DisparityRange', d_range4, 'UniquenessThreshold', 10);
figure();

% subplot(2,2,1), imshow(disparityMap1, d_range1)
% title('Disparity Map, Max range = 250')
% colormap jet
% colorbar
% subplot(2,2,2), imshow(disparityMap2, d_range2)
% title('Disparity Map, Max range = 290')
% colormap jet
% colorbar
% subplot(2,2,3), imshow(disparityMap3, d_range3)
% title('Disparity Map, Max range = 300')
% colormap jet
% colorbar
% subplot(2,2,4), imshow(disparityMap4, d_range4)
% title('Disparity Map, Max range = 320')
% colormap jet
% colorbar
% text('Disparity map of varying disparity ranges, with uniqueness threshold = 5');



disparityMap_filtered = rmmissing(disparityMap1, 2);
H = fspecial('average', 5);
disparityMap_filtered = imfilter(disparityMap_filtered, H);
H = fspecial('gaussian', 5);
disparityMap_filtered = imfilter(disparityMap_filtered, H);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Distance calulation from disparity values
[M,N] = size(disparityMap_filtered);
f = 3997.684; %in pixels
baseline = 193.001; %camera baseline in mm
doffs=131.111; % x difference of pricipal points
dist = repmat((f*baseline),M,N);

%distance(in meters) = f*baseline/((disparity+doffs)*1000)




for i = 1:M
    for j = 1:N
        d= disparityMap_filtered(i,j);
         den=(doffs+d);
         dist(i,j)= dist(i,j)/(den*1000);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







disparityMap_resized = imresize(disparityMap_filtered, 0.1, 'nearest');

[m, n] = size(disparityMap_resized);


X = (1:m)';
X = repmat(X,1,n);

Y = (1:n);
Y = repmat(Y,m,1);
% 
surf(X,Y,disparityMap_resized);
colorbar




function disp_range = disp_range_filter(im1, im2, d_thresh)
%this function outputs a 2 unit vector with the minimum and maximum
%disparity ranges, determined by calculating the euclidean distance between
%matching features.

%detecting features
points1 = detectSURFFeatures(im1);
points2 = detectSURFFeatures(im2);
%using built in function to extract features
[features1, valid_points1] = extractFeatures(im1, points1);
[features2, valid_points2] = extractFeatures(im2, points2);

indexPairs = matchFeatures(features1, features2);
% 
matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

matches1 = [];
matches2 = [];
%initial filtering of matched points for outliers
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

%calculating distances between matching features
d = distance(...
    matchedPoints1.Location(:,1),...
    matchedPoints2.Location(:,1),...
    matchedPoints1.Location(:,2),...
    matchedPoints2.Location(:,2));

%filtering out distances that exceed the user defined threshold
for n = 1 : length(d)
    if(d(n) > d_thresh)
        d(n) = d_thresh;
    end
end
%disparity range must be integer values
d_max = round(max(d));
d_min = round(min(d));

%the difference between the maximum and minimum pixel distance must be
%divisible by 16 in order for the disparity mapping to work correctly.
while (rem(d_max-d_min, 16) ~= 0)
    d_max = d_max-1;
end
%output the results
disp_range = [d_min, d_max];
end 