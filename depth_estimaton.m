function [depth_vals] = depth_estimaton(base, focal, match_pts1, match_pts2, upper_thresh, lower_thresh)
%function [depth_pts,depth_loc] = depth_estimaton(base, focal, match_pts1, match_pts2)
%   Calculates the depth based on the input base length, focal length, and
%   match points locations
%
%   Inputs and outputs: 
%   depth_vals = the depth values calculated for each pair of matches: [z x y] 
%   base = the baseline distance between the different cameras
%   focal = the focal length of the cameras
%   match_pts1 = the match points of the first image
%   match_pts2 = the match points of the second image
%   upper_thresh, lower_thresh = upper and lower thresholds for valid depth values 

    % z = f * b/(x1 - x2) = f * b/d
    % x = x1 * z/f
    % y = y1 * z/f

    % x -> col; y -> row

    len = length(match_pts1);
    idx = 0;
% %     temp_depth_vals = zeros(len, 3);

    for n = 1:len
%         % z = f * b/(x1 - x2) = f * b/d
%         z = focal * (base/(match_pts1.Location(n,2) - match_pts2.Location(n,2)));
%         % x = x1 * z/f
%         x = match_pts1.Location(n,2) * (z/focal);
%         % y = y1 * z/f
%         y = match_pts1.Location(n,1) * (z/focal);
%         % Assign the output depth array the updates values

        z = (match_pts1.Location(n,2) - match_pts2.Location(n,2));
        % x = x1 * z/f
        x = match_pts1.Location(n,2);
        % y = y1 * z/f
        y = match_pts1.Location(n,1);
        % Assign the output depth array the valaid values
        if z < upper_thresh && z > lower_thresh
            idx = idx + 1;
            depth_vals(idx,:) = [z x y];
        end
    end
    
    % TODO: Add mathCost and smoothnessCost
    
end

