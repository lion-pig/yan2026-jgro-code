function Plot_Kuroshio_axis(x_t,y_t,T_lyr,color_RBG,LineWidth)
    [X_T, Y_T] = meshgrid(x_t, y_t);    
    % deal with temperature
    figure
    [M_T,~] = contour(X_T, Y_T, T_lyr, [15 15]);
    close;
    % temperature
    M_t = 1;
    while M_t <= size(M_T, 2)
        M_tt = M_t + M_T(2, M_t);
        value = M_T(1, M_t);
        x_temp = M_T(1, M_t+1 : M_tt);
        y_temp = M_T(2, M_t+1 : M_tt); 
        if value == 15 % && min(y_temp)<32
            plot(x_temp, y_temp, 'Color', color_RBG, 'LineWidth', LineWidth)
        end
        hold on
        M_t = M_tt+1;
    end