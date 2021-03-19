function distance = euclidean_dist(feat1,feat2)
%EUCLIDEAN distance = euclidean_dist(feat1,feat2)
%   distance = euclidean_dist(feat1,feat2)
%   feat1 = 1xN feature vector
%   feat2 = 1xN feature vector
%   distance = euclidean distance between them
sum = 0;
for i = 1:size(feat1, 2)
  diff_sq = (feat1(i) - feat2(i))^2;
  sum = sum + diff_sq;
end
distance = sum;
%%distance = sqrt(sum);
end

