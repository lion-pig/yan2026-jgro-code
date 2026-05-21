function [T_X_Y_STR,T_X_Y_END] = case_dashed_line(var_along_ka,var_c,case_dashed_line_var,color_str,linewidth_var,shift_east_degree)
%CASE_CONTOUR 此处显示有关此函数的摘要
%   此处显示详细说明
time = var_along_ka(:, 1) + (var_along_ka(:, 2) - 1) / 12 + var_along_ka(:, 3) / 365;
M_i = 1;
T_X_Y_STR = [];
T_X_Y_END = [];
while M_i <= size(var_c, 2)
    M_ii = M_i + var_c(2, M_i);
    value = var_c(1, M_i);
    x_i = var_c(1, M_i+1 : M_ii);
    t_i = var_c(2, M_i+1 : M_ii); 
    ti_str = min(t_i);
    ti_end = max(t_i);
    xi_str = min(x_i(t_i == ti_str))+shift_east_degree;
    xi_end = max(x_i(t_i == ti_end))+shift_east_degree;
    if mean(x_i) > 135 && ...
       mean(x_i) < 138.5 && ...
       length(x_i) > 60 && ...
       ti_str >= (2017 + (9-1)/12 + 10/365) % after 2017 LM
        if round(value, 2) == case_dashed_line_var            
            plot([xi_str xi_end],[ti_str ti_end],'Color',color_str,'LineWidth',linewidth_var,'LineStyle','--')
            % start point
            t_str_ymd = var_along_ka(find(abs(time-ti_str) == min(abs(time-ti_str)), 1, "first"), 1:3);
            t_str_y = t_str_ymd(1);
            t_str_m = t_str_ymd(2);
            t_str_d = t_str_ymd(3);
            [~,~,~,t_str_str] = time_str(t_str_d,t_str_m,t_str_y,0);                   
            ka_i = readmatrix("KA\ka_" + t_str_str + ".csv");
            yi_str = ka_i(2, find(abs(ka_i(1, :)-xi_str) == min(abs(ka_i(1,:)-xi_str)), 1, "first"));
            T_X_Y_STR = cat(1, T_X_Y_STR, [t_str_ymd, xi_str, yi_str, ti_str]);
            % end point
            t_end_num = var_along_ka(find(abs(time - ti_end) == min(abs(time - ti_end)), 1, "first"), 1:3);
            t_end_y = t_end_num(1);
            t_end_m = t_end_num(2);
            t_end_d = t_end_num(3);
            [~,~,~,t_end_str] = time_str(t_end_d,t_end_m,t_end_y,0);                
            ka_i = readmatrix("KA\ka_" + t_end_str + ".csv");
            yi_end = ka_i(2, find(abs(ka_i(1, :)-xi_end) == min(abs(ka_i(1,:)-xi_end)), 1, "first"));
            T_X_Y_END = cat(1, T_X_Y_END, [t_end_num, xi_end, yi_end, ti_end]);                    
        end
    end
    M_i = M_ii+1;
end