function Plot_topo_land(x_t,y_t,U)
    nx = length(x_t);
    ny = length(y_t);
    x_res = x_t(2) - x_t(1);
    y_res = y_t(2) - y_t(1);
    x_t = reshape(x_t,1,nx);
    y_t = reshape(y_t,1,ny);
    x_t_t = [x_t(1)-x_res, x_t, x_t(end)+x_res];
    y_t_t = [y_t(1)-y_res, y_t, y_t(end)+y_res];
    [X_T_T,Y_T_T] = meshgrid(x_t_t,y_t_t);
    U_lyr = U(:,:,1)';
    topo = U_lyr;
    topo(isnan(U_lyr))=100;
    topo = cat(1,ones(1,size(topo,2)),topo,ones(1,size(topo,2)));
    topo = cat(2,ones(size(topo,1),1),topo,ones(size(topo,1),1));
    figure
    [M_topo_0,~]=contour(X_T_T,Y_T_T,topo,[100 100]);
    close
    n = 1;
    while n < size(M_topo_0, 2)
        lon_n = M_topo_0(1, n+1:n+M_topo_0(2, n));
        lat_n = M_topo_0(2, n+1:n+M_topo_0(2, n));
        n = n + 1 + M_topo_0(2, n);
        fill(lon_n, lat_n, "k","EdgeColor","none")
    end