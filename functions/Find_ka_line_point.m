function [xrange,yrange,xrange_idx,yrange_idx] = Find_ka_line_point(ka,lonl,lonr,latt,x_t,y_t)

    % select ka between lonl and lonr
    ka_new = ka(:, ka(1, :) >= lonl & ...
                       ka(1, :) <= lonr & ...
                       ka(2, :) <= latt | ...
                       isnan(ka(1, :)));   
    % find ka point on x_t & y_t
    xmin_degree = lonl;
    xmax_degree = lonr;
    xmin_index = find(abs(x_t - xmin_degree) == min(abs(x_t - xmin_degree)));
    xmax_index = find(abs(x_t - xmax_degree) == min(abs(x_t - xmax_degree)));
    xrange = x_t(xmin_index(1) : xmax_index(1));
    xrange_idx = xmin_index(1) : xmax_index(1);
    yrange = [];
    yrange_idx = [];
    for i = 1 : length(xrange)
        yi_ka_t_idx = find(abs(ka_new(1,:)-xrange(i))==...
                           min(abs(ka_new(1,:)-xrange(i))));
        if length(yi_ka_t_idx) > 1
            if i == 1 || isnan(yi_ka_t)
                yi_ka_t = min(ka_new(2, yi_ka_t_idx));
            else
                % find the closest point to the last point
                yi_ka_t = ka_new(2, ...
                    yi_ka_t_idx(find(abs(ka_new(2,yi_ka_t_idx)-yi_ka_t) == ...
                    min(abs(ka_new(2,yi_ka_t_idx)-yi_ka_t)), 1, "first")));
            end
        else
            yi_ka_t = ka_new(2, yi_ka_t_idx);
        end
        yi_t_idx = find(abs(y_t - yi_ka_t) == min(abs(y_t - yi_ka_t)));
        yrange = cat(2,yrange,y_t(yi_t_idx(1)));
        yrange_idx = cat(2, yrange_idx, yi_t_idx(1));
    end
