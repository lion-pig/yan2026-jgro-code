function GBR = Plot_topo(x_t,y_t,z_d,U,topo_depth,color_map)

    hold on
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
    nx = length(x_t);
    ny = length(y_t);
    x_res = x_t(2) - x_t(1);
    y_res = y_t(2) - y_t(1);
    x_t = reshape(x_t,1,nx);
    y_t = reshape(y_t,1,ny);
    x_t_t = [x_t(1)-x_res, x_t, x_t(end)+x_res];
    y_t_t = [y_t(1)-y_res, y_t, y_t(end)+y_res];
    [X_T_T,Y_T_T] = meshgrid(x_t_t,y_t_t);
    
    Z_var = [];
    for lyr = 1 : length(z_d)
        z_lyr = ones(nx*ny, 1) * (-z_d(lyr));
        Z_var = cat(1, Z_var, z_lyr);
    end
    
    for i = 1:length(topo_layer)
        layer_i = topo_layer(i);
        GBR_i = GBR(i,:);
        U_lyr = U(:,:,layer_i)';
        topo = U_lyr;
        topo(isnan(U_lyr))=100;
        topo = cat(1,ones(1,size(topo,2)),topo,ones(1,size(topo,2)));
        topo = cat(2,ones(size(topo,1),1),topo,ones(size(topo,1),1));
        figure
        [M_topo,~]=contour(X_T_T,Y_T_T,topo,[100 100]);
        close
        n = 1;
        while n < size(M_topo, 2)
            lon_n = M_topo(1, n+1:n+M_topo(2, n));
            lat_n = M_topo(2, n+1:n+M_topo(2, n));
            n = n + 1 + M_topo(2, n);
            fill(lon_n, lat_n, GBR_i,"EdgeColor","none")
        end
    end
    