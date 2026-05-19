clc;
clear;

var_name = ["sla","ugos","ugosa","vgos","vgosa"];

t_ys = 2015;
t_ms = 1;
t_ds = 1;

filename = "c3s_obs-sl_glo_phy-ssh_my_twosat-l4-duacs-0.25deg_P1D_multi-vars_125.12E-164.88E_20.12N-49.88N_2015-01-01-2023-06-07.nc";

ncdisp(filename)

time = ncread(filename, "time");

for var_str = var_name

    disp(var_str)

    var = ncread(filename, var_str);

    for dt = 1 : length(time)
    
        [~,~,~,t_strc] = time_str(t_ds,t_ms,t_ys,dt-1);
        
        disp(t_strc)
    
        var_n = var(:,:,dt);
        
        var_filename = var_str + "_" + t_strc + ".dat";
        
        save_dat_data(var_filename, var_n);
    
    end

end


