function [depth_map] = create_depth_map(input_img, match_pts, depths)
%function [depth_map] = create_depth_map(input_img, match_pts, depths)e
%   Takes in a image, one set of matched points from a pair of stereo
%   images, and the corresponding depth of the image. This is used to
%   create a grayscale depth map with darker values representing closer
%   distances, and lighter values representing farther distances
%   Non-feature points are apprioximated to the same depth/intensity as the  
%   nearest feature distance/intensity
%
%   Inputs and outputs:
%   depth_map = the output normalized grayscale depth map
%   input_img = original input image
%   match_pts = the match points correspoinding to the input image 
%   depths = the depth values that correspond to each matched point
    
    % Get the number of rows and columns from the input image
    [rows, cols] = size(input_img);
    
    depth_map = zeros(rows,cols);
%     for n = 1:length(match_pts)
%             R = round(match_pts(n, 1));
%             C = round(match_pts(n, 2));
%             depth_map(R,C) = depths(n,1);
%     end
    
%     
%       len = length(features1(1, :));
%         for n = 1:100            
%             p = features1(n, :);
%             for m = 1:100               
%                 q = features2(m, :);
%                 diff = q - p;
%                 sq_diff = diff.^2;
%                 SSD = sum(sq_diff, 'all');
%                 dist = SSD.^(1/2);
%                 distances(m) = dist;
%             end      
    len_match = length(match_pts);
    
    for i = 1:rows        
        for j = 1:cols
%             if  depth_map(i,j) == 0
                curr_mat = input_img(i,j).*ones(len_match, 2);
                diff_x = curr_mat(:,1) - match_pts(:,1);
                diff_y = curr_mat(:,2) - match_pts(:,2);
                sq_diff = diff_x.^2 + diff_y.^2;
                %SSD = sum(sq_diff, 'all');
                %dist = sq_diff.^(1/2);
                [min_val, min_idx] = min(sq_diff);
                
%                 if min_idx(1) ~= min_idx(2)
%                     if min_val(1) < min_val(2)
%                         depth_map(i,j) = depths(min_idx(1));
%                     else
%                         depth_map(i,j) = depths(min_idx(2));
%                     end
%                 else 
                    depth_map(i,j) = depths(min_idx(1));
%                 end
%             end
        end        
    end
    
    depth_map = depth_map./(max(depth_map));
end

