function [Var_output,var_range,c_range,h_tick,c_map,c_label] = ...
    var_range_map(Var_str,Var_input)

    if Var_str == "W" || Var_str == "W_cal" || Var_str == "W_on_iso_pden_surface"
        Var_output = Var_input * 10^3;
    elseif Var_str == "ZETA_both_upper_lyr_ave"
        Var_output = Var_input * 10^4;
    elseif Var_str == "trace_Zeta"
        Var_output = Var_input * 10^4;
        var_range = -0.4 : 0.1 : 0.4;
        c_range = [-0.4 0.4];
        h_tick = -0.4:0.1:0.4;
        c_map = [0 0 1
                 15/255 130/255 1
                 0 1 1
                 204/255 250/255 1
                 245/255 255/255 190/255
                 1 1 0
                 1 136/255 9/255
                 1 0 0];
        c_label = "$\zeta \left(\times 10^{-4} s^{-1}\right)$";  
    elseif Var_str == "trace_Ro_xy"
        Var_output = Var_input;
        var_range = 0 : 0.1 : 0.5;
        c_range = [0 0.5];
        h_tick = 0:0.1:0.5;
        c_map = jet(length(h_tick)-1);
        c_label = "$Ro_xy$";
    elseif Var_str == "trace_Ro_x"
        Var_output = Var_input;
        var_range = 0 : 0.1 : 0.5;
        c_range = [0 0.5];
        h_tick = 0:0.1:0.5;
        c_map = jet(length(h_tick)-1);
        c_label = "$Ro_x$";
    elseif Var_str == "trace_Ro_y"
        Var_output = Var_input;
        var_range = 0 : 0.1 : 0.5;
        c_range = [0 0.5];
        h_tick = 0:0.1:0.5;
        c_map = jet(length(h_tick)-1);
        c_label = "$Ro_y$";
    elseif Var_str == "trace_stch"
        Var_output = Var_input * 10^(10);
        var_range = -5 : 1 : 5;
        c_range = [5 5];
        h_tick = -5:1:5;
        c_map = jet(length(h_tick)-1);
        c_label = "$-f \frac{\partial w}{\partial z}$";
    elseif Var_str == "EL"
        Var_output = Var_input;
    elseif Var_str == "fu_minus"
        Var_output = Var_input * 10^5;
    elseif Var_str == "ddpdxdx" || Var_str == "ddpdydy"
        Var_output = Var_input * 10^8;
    elseif Var_str == "rho_dpdx" || Var_str == "rho_dpdy"
        Var_output = Var_input * 10^4;
    elseif Var_str == "Vy"
        Var_output = Var_input * 10^5;
    elseif Var_str == "Ux"
        Var_output = Var_input * 10^5;
    elseif Var_str == "Ut"
        Var_output = Var_input * 10^6;
        var_range = -2:0.1:2;
        c_range = [-1 1];
        h_tick = -1:0.2:1;
        c_map = jet(length(h_tick)-1);
        c_label = "$ \frac{\partial u}{\partial t} \left( \times 10^{-6} m^{2}s^{-1} \right)$";  
    elseif Var_str == "EL_a"
        Var_output = Var_input;
    elseif Var_str == "-fv_plus_rho_dpdx" || Var_str == "fu_plus_rho_dpdy"
        Var_output = Var_input * 10^5;
    elseif Var_str == "W_sum"
        Var_output = Var_input * 10^2;
    elseif Var_str == "HD_sum"
        Var_output = Var_input * 10^4;
    % elseif Var_str == "P_a"
        % Var_input = Var_input/10^4; % dbar
        % Var_ave = mean(Var_input,[1,2],"omitmissing");
        % Var_output = Var_input - Var_ave;
    elseif Var_str == "P" || Var_str == "P_a"
        Var_output = Var_input/10^4; % dbar
    elseif Var_str == "ZETA_posi_flux"
        Var_output = Var_input / 10^3;
    elseif Var_str == "ZETA_sum" || Var_str == "Zeta_sum"
        Var_output = Var_input * 10^3;
    elseif Var_str == "iso_pden_theta"
        Var_output = Var_input * 10^2;
    elseif Var_str == "iso_P_theta"
        Var_output = Var_input * 10^5;
    elseif Var_str == "scalar_product_of_UVW_pden_xpden_ypden_z"
        Var_output = Var_input * 10^6;
    elseif Var_str == "Time_change_of_thickness_of_isopycnal_layer"
        Var_output = Var_input * 10^5;
    elseif Var_str == "cross_product_of_laplace_P_and_laplace_pden_k_component" || ...
           Var_str == "cross_product_of_laplace_pden_and_laplace_P_k_component"
        Var_output = Var_input * 10^7;
    else
        Var_output = Var_input;
    end

    if Var_str == "Ro"
        var_range = 0:0.05:2;
        c_range = [0 0.5];
        h_tick = 0:0.05:0.5;
        c_map = jet(length(h_tick)-1);
        c_label = "Rossby number";
    elseif Var_str == "Ro_x"
        var_range = 0:0.05:2;
        c_range = [0 0.5];
        h_tick = 0:0.05:0.5;
        c_map = jet(length(h_tick)-1);
        c_label = "$\frac{\left|{\mathbf{\vec{v}} \cdot \nabla u}\right|}{\left|{-fv}\right|} $";    
    elseif Var_str == "Ro_y"
        var_range = 0:0.05:2;
        c_range = [0 0.4];
        h_tick = 0:0.05:0.4;
        c_map = jet(length(h_tick)-1);
        c_label = "$\frac{\left|{\mathbf{\vec{v}} \cdot \nabla v}\right|}{\left|{fu}\right|} $";    
    elseif Var_str == "Ro_xy"
        var_range = 0:0.05:1;
        c_range = [0 0.4];
        h_tick = 0:0.1:0.4;
        h_range = 0:0.05:0.4;
        c_map = jet(length(h_range)-1);
        c_label = "Ro";    
    elseif Var_str == "EL"
        var_range = -1:0.1:1;
        c_range = [-1 1];
        h_tick = -1:0.2:1;
        c_map = jet(length(h_tick)-1);
        c_label = "Sea surface height (m)";    
    elseif Var_str == "ddpdxdx"
        var_range = -0.5:0.02:0.5;
        c_range = [-0.2 0.2];
        h_tick = -0.2:0.04:0.2;
        c_map = jet(length(h_tick)-1);
        c_label = "$\frac{1}{\rho_0} \frac{\partial^{2} p}{\partial x^{2}} \left( \times 10^{-8} s^{-2} \right)$";  
    elseif Var_str == "ddpdydy"
        var_range = -0.5:0.02:0.5;
        c_range = [-0.2 0.2];
        h_tick = -0.2:0.04:0.2;
        c_map = jet(length(h_tick)-1);
        c_label = "$\frac{1}{\rho_0} \frac{\partial^{2} p}{\partial y^{2}} \left( \times 10^{-8} s^{-2} \right)$";  
    elseif Var_str == "dpdy"
        Var_output = Var_input * 10^4;
        var_range = -2:0.1:2;
        c_range = [-1 1];
        h_tick = -1:0.2:1;
        c_map = jet(length(h_tick)-1);
        c_label = "$\frac{1}{\rho_0} \frac{\partial p}{\partial y} \left( \times 10^{-4} m s^{-2} \right)$";  
    elseif Var_str == "dpdy_minus"
        Var_output = Var_input * 10^4;
        var_range = -1:0.1:1;
        c_range = [-1 1];
        h_tick = -1:0.2:1;
        c_map = jet(length(h_tick)-1);
        c_label = "$-\frac{1}{\rho_0} \frac{\partial p}{\partial y} \left( \times 10^{-4} m s^{-2} \right)$"; 
    elseif Var_str == "fu"
        Var_output = Var_input * 10^4;
        var_range = -1:0.1:1;
        c_range = [-1 1];
        h_tick = -1:0.2:1;
        c_map = jet(length(h_tick)-1);
        c_label = "$fu \left( \times 10^{-4} m s^{-2} \right)$";  
    elseif Var_str == "fu_minus"
        var_range = -10:1:10;
        c_range = [-5 5];
        h_tick = -5:1:5;
        c_map = jet(length(h_tick)-1);
        c_label = "$-fu \left( \times 10^{-5} m s^{-2} \right)$"; 
    elseif Var_str == "dpdx"
        Var_output = Var_input * 10^4;
        var_range = -1:0.1:1;
        c_range = [-1 1];
        h_tick = -1:0.2:1;
        c_map = jet(length(h_tick)-1);
        c_label = "$\frac{1}{\rho_0} \frac{\partial p}{\partial x} \left( \times 10^{-4} m s^{-2} \right)$"; 
    elseif Var_str == "dpdx_minus"
        Var_output = Var_input * 10^4;
        var_range = -1:0.1:1;
        c_range = [-1 1];
        h_tick = -1:0.2:1;
        c_map = jet(length(h_tick)-1);
        c_label = "$-\frac{1}{\rho_0} \frac{\partial p}{\partial x} \left( \times 10^{-4} m s^{-2} \right)$";
    elseif Var_str == "V_adv"
        Var_output = Var_input * 10^5;
        var_range = -2:0.1:2;
        c_range = [-1 1];
        h_tick = -1:0.2:1;
        c_map = jet(length(h_tick)-1);
        c_label = "$\mathbf{\vec{v}} \cdot \nabla v \left( \times 10^{-5} s^{-1} \right)$";
    elseif Var_str == "U_adv"
        Var_output = Var_input * 10^5;
        var_range = -1:0.1:1;
        c_range = [-1 1];
        h_tick = -1:0.2:1;
        c_map = jet(length(h_tick)-1);
        c_label = "$\mathbf{v} \cdot \nabla u \left( \times 10^{-5} s^{-1} \right)$";
    elseif Var_str == "U_adv./-fv"
        Var_output = Var_input;
        var_range = -1:0.1:1;
        c_range = [-0.5 0.5];
        h_tick = -0.5:0.1:0.5;
        c_map = jet(length(h_tick)-1);
        c_label = "$\frac{\mathbf{v} \cdot \nabla u}{-fv}$";
    elseif Var_str ==  "U_adv_abs./-fv_abs"
        Var_output = Var_input;
        var_range = 0:0.05:1;
        c_range = [0 0.4];
        h_tick = 0:0.05:0.4;
        c_map = jet(length(h_tick)-1);
        c_label = "$\frac{\left|\mathbf{v} \cdot \nabla u\right|}{\left|-fv\right|}$";
    elseif Var_str == "rho_dpdy"
        var_range = -2:0.1:2;
        c_range = [-1 1];
        h_tick = var_range;
        c_map = jet(length(h_tick)-1);
        c_label = "$\frac{1}{\rho} \frac{\partial p}{\partial y} \left( \times 10^{-4} s^{-1} \right)$";
    elseif Var_str == "-fv"
        Var_output = Var_input * 10^4;
        var_range = -1:0.1:1;
        c_range = [-1 1];
        h_tick = -1:0.2:1;
        c_map = jet(length(h_tick)-1);
        c_label = "$-fv \left( \times 10^{-4} s^{-1} \right)$";
    elseif Var_str == "rho_dpdx"
        var_range = -1:0.1:1;
        c_range = [-1 1];
        h_tick = var_range;
        c_map = jet(length(h_tick)-1);
        c_label = "$\frac{1}{\rho} \frac{\partial p}{\partial x} \left( \times 10^{-4} s^{-1} \right)$";
    elseif Var_str == "Vy"
        var_range = -4:0.1:4;
        c_range = [-2 2];
        h_tick = -2:0.4:2;
        c_map = jet(length(h_tick)-1);
        c_label = "${\partial v}/{\partial y} \left( \times 10^{-5} s^{-1} \right)$";
    elseif Var_str == "Ux"
        var_range = -4:0.1:4;
        c_range = [-2 2];
        h_tick = -2:0.4:2;
        c_map = jet(length(h_tick)-1);
        c_label = "${\partial u}/{\partial x} \left( \times 10^{-5} s^{-1} \right)$";
    elseif Var_str == "EL_a"
        var_range = -1:0.01:1;
        c_range = [-0.2 0.2];
        h_tick = -0.2:0.02:0.2;
        c_map = jet(length(h_tick)-1);
        c_label = "SSH anormaly(m)";
    elseif Var_str == "-fv_plus_rho_dpdx"
        var_range = -2:0.1:2;
        c_range = [-1 1];
        h_tick = var_range;
        c_map = jet(length(h_tick)-1);
        c_label = "$-fv + \frac{1}{\rho_0} \frac{\partial p}{\partial x} \left( \times 10^{-5} \ \mathrm{m/s}^2 \right)$";
    elseif Var_str == "fu_plus_rho_dpdy"
        var_range = -4:0.1:4;
        c_range = [-1 1];
        h_tick = var_range;
        c_map = jet(length(h_tick)-1);
        c_label = "$fu + \frac{1}{\rho_0} \frac{\partial p}{\partial y} \left( \times 10^{-5} \ \mathrm{m/s}^2 \right)$";
    elseif Var_str == "W" || Var_str == "W_cal"|| Var_str == "W_on_iso_pden_surface"
        var_range = -10:0.05:10;
        c_range = [-0.8 0.8];
        h_tick = -0.8:0.4:0.8;
        c_map = W_map_num("both",8);
        c_label = "$ w \left( \times 10^{-3} m s^{-1} \right) $";
    elseif Var_str == "W_negative"
        Var_output = Var_input * 10^3;
        var_range = -10:0.05:0;
        c_range = [-0.8 0];
        h_tick = -0.8:0.2:0;
        % c_map = jet(length(h_tick)-1);
        % c_map = W_map("both");
        c_map = W_map_num("nega",length(h_tick)-1);
        c_label = "$ w \; \left( \times 10^{-3} \; m s^{-1} \right) $";
    elseif Var_str == "W_nega_flux"
        Var_output = Var_input * 10^(-5);
        var_range = -7:0.1:0;
        h_tick = -3.6:0.9:0;
        c_range = [-3.6 0];
        c_map = W_map_num("nega",length(h_tick)-1);
        c_label = '$ \int\!\!\int_A w \, dA \left( \times 10^{5} \; m^{3} s^{-1} \right) $';
    elseif Var_str == "W_nega_ave"
        Var_output = Var_input * 10^(3);
        var_range = -5:0.1:0;
        h_tick = -1.6:0.4:0;
        c_range = [-1.6 0];
        c_map = W_map_num("nega",length(h_tick)-1);
        c_label = "$ w \left( \times 10^{3} \; m s^{-1} \right) $";
    elseif Var_str == "W_sum"
        var_range = -10:0.05:10;
        c_range = [-2 2];
        h_tick = -2:0.4:2;
        c_map = W_map("both");
        c_label = "W (×10^-^2 m/s)";
    elseif Var_str == "HD"|| Var_str == "HD_on_iso_pden_surface"
        Var_output = Var_input * 10^5;
        var_range = -2:0.04:2;
        c_range = [-0.8 0.8];
        h_tick = -0.8:0.4:0.8;
        map = [51  94  56
               83  152 98
               197 200 101
               255 255 255
               255 255 255
               253 167 89
               252 76  62
               148 44  36]/255;
        c_map = map; % jet(length(h_tick)-1);
        c_label = "$\mathbf{\nabla_h} \cdot \vec{\mathbf{u}} \left( \times 10^{-5} s^{-1} \right)$";
    elseif Var_str == "HD_negative"
        Var_output = Var_input * 10^5;
        var_range = -2:0.02:2;
        c_range = [-0.32 0];
        h_tick = -0.32:0.08:0;
        map = [51  94  56
               83  152 98
               197 200 101
               255 255 255]/255;
        c_map = map; % jet(length(h_tick)-1);
        c_label = "$\nabla \cdot \mathbf{u}_h \left( \times 10^{-5} s^{-1} \right)$";
    elseif Var_str == "HD_sum"
        var_range = -1:0.05:1;
        c_range = [-0.2 0.2];
        h_tick = -0.2:0.04:0.2;    
        c_map = jet(length(h_tick)-1);
        c_label = "HD(×10^-^4 s^-^1)";
    elseif Var_str == "P_a"
        var_range = -1:0.01:1;
        c_range = [-0.06 0.06];
        h_tick = -0.06:0.01:0.06;
        c_map = jet(length(h_tick)-1);
        c_label = "Pressure anomraly (dbar)";
    elseif Var_str == "P"
        var_min = min(Var_output,[],"all");
        var_max = max(Var_output,[],"all");
        interval = (var_max-var_min)/100;
        var_range = var_min:interval:var_max;
        lower = prctile(Var_output(:), 1);    % 下5%分位数
        upper = prctile(Var_output(:), 99);   % 上95%分位数
        var_min = lower;
        var_max = upper;
        interval = (var_max-var_min)/10;
        h_tick = var_min:interval:var_max;
        c_range = [var_min var_max];
        c_map = jet(length(h_tick)-1);
        c_label = "Pressure (dbar)";
    elseif Var_str == "pden"
        var_min = min(Var_output,[],"all");
        var_max = max(Var_output,[],"all");
        interval = (var_max-var_min)/100;
        var_range = var_min:interval:var_max;
        lower = prctile(Var_output(:), 1);    % 下5%分位数
        upper = prctile(Var_output(:), 99);   % 上95%分位数
        var_min = lower;
        var_max = upper;
        interval = (var_max-var_min)/10;
        h_tick = var_min:interval:var_max;
        c_range = [var_min var_max];
        c_map = jet(length(h_tick)-1);
        % c_label = 'Time change of thickness of isopycnal layer (×10^-^5 m/s)';
        % var_range = 1022:0.1:1028;
        % c_range = [1025 1027.8];
        % h_tick = 1025:0.2:1027.8;
        % c_map = jet(length(h_tick)-1);
        c_label = "Potential density (kg/m^3)";
    elseif Var_str == "pden_a"
        var_range = -2:0.1:2;
        c_range = [-1 1];
        h_tick = -1:0.1:1;
        c_map = jet(length(h_tick)-1);
        c_label = "Potential density anormaly (kg/m^3)";
    elseif Var_str == "ZETA" || ...
           Var_str == "Zeta"|| ...
           Var_str == "Zeta_on_iso_pden_surface"|| ...
           Var_str == "dVdx_minus_dUdy" || ...
           Var_str == "dvdx-dudy"
        Var_output = Var_input * 10^4;
        var_range = -1:0.05:1;
        h_tick = -0.2 : 0.1 : 0.2;
        c_range = [-0.2 0.2];
        c_map = W_map_num("both",8);
        c_label = '$\zeta \left( \times 10^{-4} s^{-1} \right)$';
    elseif Var_str == "ZETA_positive" || Var_str == "Zeta_positive"
        Var_output = Var_input * 10^4;
        var_range = 0:0.05:1;
        h_tick = 0 : 0.05 : 0.2;
        % h_tick = 0 : 0.1 : 0.4;
        c_range = [0 0.2];
        % c_range = [0 0.4];
        c_map = W_map_num("posi",length(h_tick)-1);
        c_label = '$\zeta \left( \times 10^{-4} s^{-1} \right)$';
    elseif Var_str == "ZETA_posi_flux" 
        var_range = 0:0.1:10;
        h_tick = 0 : 1.8 : 7.2;
        c_range = [0 7.2];
        c_map = W_map_num("posi",length(h_tick)-1);
        c_label = '$\int\!\!\int_A \zeta \, \mathrm{d}A \left( \times 10^{3} \; m^{2}s^{-1} \right)$';
    elseif Var_str == "ZETA_both_upper_lyr_ave"
        var_range = -1:0.05:1;
        h_tick = -0.4 : 0.2 : 0.4;
        c_range = [-0.4 0.4];
        c_map = [0 0 1
                 15/255 130/255 1
                 0 1 1
                 204/255 250/255 1
                 245/255 255/255 190/255
                 1 1 0
                 1 136/255 9/255
                 1 0 0];
        c_label = '$\zeta \left( \times 10^{-4} s^{-1} \right)$';
    elseif Var_str == "ZETA_sum" || Var_str == "Zeta_sum"
        var_range = -1:0.05:1;
        h_tick = -0.5 : 0.1 : 0.5;
        c_range = [-0.5 0.5];
        c_map = jet(length(h_tick)-1);
        c_label = '\zeta(×10^-^3 s^-^1)';
    elseif Var_str == "iso_pden_theta"
        var_range = -5:0.05:0;
        h_tick = -1 : 0.1 : 0;
        c_range = [-1 0];
        c_map = jet(length(h_tick)-1);
        c_label = 'isopycnal slope (×10^-^2)';
    elseif Var_str == "iso_P_theta"
        var_range = -1:0.1:0;
        h_tick = -1 : 0.1 : 0;
        c_range = [-1 0];
        c_map = jet(length(h_tick)-1);
        c_label = 'isobaric slope (×10^-^5)';
    elseif Var_str == "scalar_product_of_UVW_pden_xpden_ypden_z"
        var_range = -10:0.1:10;
        h_tick = -1 : 0.2 : 1;
        c_range = [-1 1];
        c_map = jet(length(h_tick)-1);
        c_label = '(U,V,W).*(pden_x,pden_y,pden_z) (×10^-^6)';
    elseif Var_str == "iso_pden_thickness"
        var_range = 0:0.5:20;
        h_tick = 0:1:20;
        c_range = [0 20];
        c_map = jet(length(h_tick)-1);
        c_label = 'Thickness of isopycnal layer (m)';
    elseif Var_str == "Time_change_of_thickness_of_isopycnal_layer"
        var_min = floor(min(Var_output,[],"all") / 10) * 10;
        var_max = ceil(max(Var_output,[],"all") / 10) * 10;
        interval = (var_max-var_min)/100;
        var_range = var_min:interval:var_max;
        lower = prctile(Var_output(:), 1);    % 下5%分位数
        upper = prctile(Var_output(:), 99);   % 上95%分位数
        var_min = floor(lower / 10) * 10;
        var_max = ceil(upper / 10) * 10;
        interval = (var_max-var_min)/10;
        h_tick = var_min:interval:var_max;
        c_range = [var_min var_max];
        c_map = jet(length(h_tick)-1);
        c_label = 'Time change of thickness of isopycnal layer (×10^-^5 m/s)';
    elseif Var_str == "depth_of_iso_pden_surface"
        var_min = floor(min(Var_output,[],"all") / 10) * 10;
        var_max = ceil(max(Var_output,[],"all") / 10) * 10;
        interval = (var_max-var_min)/100;
        var_range = var_min:interval:var_max;
        lower = prctile(Var_output(:), 0.1);    % 下1%分位数
        upper = prctile(Var_output(:), 99.9);   % 上99%分位数
        var_min = floor(lower / 10) * 10;
        var_max = ceil(upper / 10) * 10;
        interval = (var_max-var_min)/10;
        h_tick = var_min:interval:var_max;
        c_range = [var_min var_max];
        c_map = jet(length(h_tick)-1);
        c_label = 'Depth of isopycnal surface(m)';
    elseif Var_str == "U_on_iso_pden_surface" || Var_str == "V_on_iso_pden_surface"
        var_range = -0.5:0.01:0.5;
        h_tick = -0.5:0.1:0.5;
        c_range = [-0.5 0.5];
        c_map = jet(length(h_tick)-1);
        c_label = 'Horizontal velocity (m/s)';
    elseif Var_str == "cross_product_of_laplace_P_and_laplace_pden_k_component" || ...
           Var_str == "cross_product_of_laplace_pden_and_laplace_P_k_component"
        var_range = -10:0.1:10;
        h_tick = -5:1:5;
        c_range = [-5 5];
        c_map = jet(length(h_tick)-1);
        c_label = '\nabla p \times \nabla \rho(×10^-^7)';
    elseif Var_str == "kappa"
        Var_output = Var_input*10^4;
        var_range = -1:.1:1;
        h_tick = -1:.2:1;
        c_range = [-1 1];
        c_map = jet(length(h_tick)-1);
        c_label = '$kappa(\times 10^{-4} m^{-1})$';
    end
