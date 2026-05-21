clc;
clear;
% CHOOSE Variable
Var_str = "ZETA"; % "W"; % 
Anormaly_lyr = 0;
Anormaly_ka = 0;
Var_select = "posi"; % "nega"; % 
type = "ave";
% CHOOSE Depth
Depth = 400;
% CHOOSE Period
t_ys = 2017;
t_ms = 1;
t_ds = 1;
t_ye = 2017;
t_me = 12;
t_de = 31;
% axis range
deg_y = 0.5;

% ------------------------- Program Start ----------------------------

% READ GRID DATA
x_t = readmatrix("x_t.csv");
y_t = readmatrix("y_t.csv");
z_d = readmatrix("z_d.csv");
nx = length(x_t);
ny = length(y_t);
nz = length(z_d);
lonl_rg = 132;
lonr_rg = 140;
latb_rg = 28;
latt_rg = 35;
lonl_ka = 133;
lonr_ka = 139;
latt_ka = 33.5;
lonl_rg_idx = find(abs(x_t-lonl_rg)==min(abs(x_t-lonl_rg)),1,"first");
lonr_rg_idx = find(abs(x_t-lonr_rg)==min(abs(x_t-lonr_rg)),1,"first");
latb_rg_idx = find(abs(y_t-latb_rg)==min(abs(y_t-latb_rg)),1,"first");
latt_rg_idx = find(abs(y_t-latt_rg)==min(abs(y_t-latt_rg)),1,"first");
x_rg = x_t(lonl_rg_idx:lonr_rg_idx);
y_rg = y_t(latb_rg_idx:latt_rg_idx);
[X_RG,Y_RG] = meshgrid(x_rg,y_rg);
R = 6371000;
dXS_RG = (x_t(2) - x_t(1)) / 360 * 2 * pi * R * cos(Y_RG / 180 * pi);
dys = (y_t(2) - y_t(1)) / 360 * 2 * pi * R;
dS_RG = dXS_RG * dys;
deg_y_n = round(deg_y / (y_t(2)-y_t(1)),0);
d_dy = -deg_y_n:deg_y_n;

layer = find(abs(z_d-Depth)==min(abs(z_d-Depth)),1,"first");
disp("depth = " + num2str(z_d(layer)) + " m")


% CALCULATE
day_num = num_of_day(t_ys,t_ms,t_ds,t_ye,t_me,t_de);
disp("number of days : " + num2str(day_num))

DT = 1 : day_num;

VAR_KA_TYPE = [];
for dt = DT
    [t_dc,t_mc,t_yc,t_strc] = time_str(t_ds,t_ms,t_ys,dt-1);
    disp(t_strc)
    % read variable data
    Var_var = read_dat_data(Var_str+"_"+t_strc+"12.dat");
    Var = reshape(Var_var, nx,ny,nz);
    Var(Var > 1*10^20) = nan;
    if Var_str == "P"
        Var = Var/10^4; % dbar
    end
    Var = Var(lonl_rg_idx:lonr_rg_idx,latb_rg_idx:latt_rg_idx,:);
    Var_lyr = Var(:,:,layer)';
    if Anormaly_lyr == 1
        Var_lyr_ave = mean(Var_lyr,"all","omitmissing");
        Var_lyr = Var_lyr - Var_lyr_ave;
    end
    % abstract data along ka
    ka = readmatrix("KA\ka_"+t_strc+".csv");
    [xrange,yrange,xrange_idx,yrange_idx]=...
        Find_ka_line_point(ka,lonl_ka,lonr_ka,latt_ka,x_rg,y_rg);
    var_ka_type = [];
    for i = 1 : length(xrange_idx)
        var_i_type = 0;
        num = 0;
        ds_total = 0;
        for j = d_dy
            var_ij = Var_lyr(yrange_idx(i)+j, xrange_idx(i));
            ds_ij = dS_RG(yrange_idx(i)+j, xrange_idx(i));
            if Var_select == "nega" 
                if var_ij < 0
                    var_i_type = var_i_type + var_ij*ds_ij;
                    ds_total = ds_total + ds_ij;
                end
            elseif Var_select == "posi" 
                if var_ij > 0
                    var_i_type = var_i_type + var_ij*ds_ij;
                    ds_total = ds_total + ds_ij;
                end
            else
                var_i_type = var_i_type + var_ij*ds_ij;
                ds_total = ds_total + ds_ij;
            end
        end
        if type == "flux"
            var_ka_type = cat(2, var_ka_type, var_i_type);
        elseif type == "ave"
            var_ka_type = cat(2, var_ka_type, var_i_type/ds_total);
        end
    end
    if Anormaly_ka == 1
        var_ka_type = var_ka_type - mean(var_ka_type,"all","omitmissing");
    end
    VAR_KA_TYPE = cat(1, VAR_KA_TYPE, [t_yc t_mc t_dc var_ka_type]);
end
% save data
disp("    -- save data")
if Anormaly_lyr==1
    Var_str = Var_str+"_a";
end
if Anormaly_ka == 1
    Var_str = Var_str+"_ka";
end
writematrix(xrange, "xrange_for_"+Var_str+"_ka_lon_"+...
            num2str(lonl_ka) + "_" + num2str(lonr_ka) + ".csv");
writematrix(VAR_KA_TYPE, ...
            "Time_evo_of_"+...
            Var_str+"_"+Var_select+"_"+...
            type+"_along_ka_from_lon_" + ...
            num2str(lonl_ka) + "_to_" + num2str(lonr_ka) + ...
            "_at_depth_" + num2str(z_d(layer)) + "_m" + ...
            "_during_year_" + num2str(t_yc) + ".csv");