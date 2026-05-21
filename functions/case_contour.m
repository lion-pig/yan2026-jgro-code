function VALUE = case_contour(var_c,contour_var,lon_mean_llim,lon_mean_rlim,length_lim,color_str,linewidth_var)
    M_i = 1;
    VALUE = [];
    while M_i <= size(var_c, 2)
        M_ii = M_i + var_c(2, M_i);
        value = var_c(1, M_i);
        VALUE = cat(1, VALUE, value);
        x_i = var_c(1, M_i+1 : M_ii);
        t_i = var_c(2, M_i+1 : M_ii); 
        ti_str = min(t_i);
        if mean(x_i) > lon_mean_llim && ...
           mean(x_i) < lon_mean_rlim && ...
           length(x_i) > length_lim && ...
           ti_str >= (2017 + (8-1)/12 + 10/365) 
            if round(value, 2) == round(contour_var,2)
                plot(x_i, t_i, 'Color', color_str, "LineWidth", linewidth_var)
            end
        end
        M_i = M_ii+1;
    end
end