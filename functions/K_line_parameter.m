function [theta_d,xmin_degree,xmax_degree,ymin_degree] = K_line_parameter(t_strc,Var_str)
    if t_strc == "20180505"
        if Var_str == "W"
            theta_d = 50; % degree
            xmin_degree = 134.8;
            xmax_degree = 135.8;
            ymin_degree = 31.9;
        elseif Var_str == "ZETA"
            theta_d = 50; % degree
            xmin_degree = 135.3;
            xmax_degree = 136.3;
            ymin_degree = 31.9;
        elseif  Var_str == "HD"
            theta_d = 50; % degree
            xmin_degree = 135;
            xmax_degree = 136;
            ymin_degree = 31.9;
        end
    elseif t_strc == "20180501"
        if Var_str == "W"
            theta_d = 45; % degree
            xmin_degree = 134.8;
            xmax_degree = 135.8;
            ymin_degree = 32.1; % 31.9;
        elseif Var_str == "ZETA"
            theta_d = 50; % degree
            xmin_degree = 135.3;
            xmax_degree = 136.3;
            ymin_degree = 31.9;
        elseif  Var_str == "HD"||Var_str == "Ro_xy" || Var_str == "dpdx" ...
                || Var_str == "dpdy" || Var_str == "U_adv" ...
                || Var_str == "V_adv" || Var_str == "-fv" ...
                || Var_str == "fu" || Var_str == "Ro_y" || Var_str == "P" || Var_str == "pden"
            theta_d = 46; % degree
            xmin_degree = 134.6;
            xmax_degree = 135.8;
            ymin_degree = 31.9;
            % theta_d = 48; % degree
            % xmin_degree = 134.6;
            % xmax_degree = 136.5;
            % ymin_degree = 31.7;
        end
    elseif t_strc == "20180506"
        if Var_str == "W"
            theta_d = 50; % degree
            xmin_degree = 135;
            xmax_degree = 136;
            ymin_degree = 31.9;
        elseif Var_str == "ZETA" || Var_str == "Zeta"
            theta_d = 50; % degree
            xmin_degree = 135.3;
            xmax_degree = 136.3;
            ymin_degree = 31.9;
        elseif  Var_str == "HD"
            theta_d = 50; % degree
            xmin_degree = 134.8;
            xmax_degree = 135.8;
            ymin_degree = 31.9;
        end
    end