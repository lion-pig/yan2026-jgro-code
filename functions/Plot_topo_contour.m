function GBR = Plot_topo_contour(x_t,y_t,z_d,U_var,topo_depth,color_map)
    nx = length(x_t);
    ny = length(y_t);
    [X_T, Y_T] = meshgrid(x_t, y_t);
    % topo depth
    topo_layer = [];
    GBR = [];
    c_interval = floor(size(color_map,1)/75);
    for i = 1:length(topo_depth)
        topo_depth_i = topo_depth(i);
        topo_layer_i = find(abs(z_d-topo_depth_i)==min(abs(z_d-topo_depth_i)),1,"first");
        topo_layer = cat(2, topo_layer,topo_layer_i);
        GBR_i = color_map(topo_layer_i*c_interval,:);
        GBR = cat(1,GBR, GBR_i);
    end
    Z_var = [];
    for lyr = 1 : length(z_d)
        z_lyr = ones(nx*ny, 1) * (-z_d(lyr));
        Z_var = cat(1, Z_var, z_lyr);
    end
    
    % abstract value on the topography grid point
    Z_var(~isnan(U_var)) = nan;
    Z_var = reshape(Z_var, nx, ny, length(z_d));
    Z_lyr_end = Z_var(:, :, end);
    for lyr = length(z_d)-1 : -1 : 1
        Z_lyr = Z_var(:, :, lyr);
        Z_lyr_end(Z_lyr > Z_lyr_end) = Z_lyr(Z_lyr > Z_lyr_end);
    end
    Z_T = Z_lyr_end';
    for i = 1:length(topo_depth)
        % find contour line
        figure;
        [M_topo_i, ~] = contour(X_T,Y_T,Z_T,[-topo_depth(i) -topo_depth(i)]);
        close
        % plot contour line
        n = 1;
        while n < size(M_topo_i, 2)
            lon_n = M_topo_i(1, n + 1 : n + M_topo_i(2, n));
            lat_n = M_topo_i(2, n + 1 : n + M_topo_i(2, n));
            n = n + 1 + M_topo_i(2, n);
            hold on
            plot(lon_n, lat_n, "Color", GBR(i,:), "LineWidth", 1)
        end
    end
end

