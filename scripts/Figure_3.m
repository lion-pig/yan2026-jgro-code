clc;
clear;

% range
lonl = 134.5;
lonr = 140;
latb = 29.5;
latt = 35;
temp_range = 20:1:28;
tempa_range = -2.5:0.5:2.5;
adt_range = 0.4:0.2:2.2;
ka_value = 1;

% grid for adt & U
adt_folder = "..\data\CMS\C3S_GOG_L4\";
filename = adt_folder + "c3s_obs-sl_glo_phy-ssh_my_twosat-l4-duacs-0.25deg_P1D_multi-vars_125.12E-164.88E_20.12N-49.88N_2015-01-01-2023-06-07.nc";
ncdisp(filename);
lat_adt = ncread(filename,"latitude");
lon_adt = ncread(filename,"longitude");
nx_adt = length(lon_adt);
ny_adt = length(lat_adt);
latb_adt_idx = find(lat_adt>=latb,1,"first");
latt_adt_idx = find(lat_adt>=latt,1,"first");
lonl_adt_idx = find(lon_adt>=lonl,1,"first");
lonr_adt_idx = find(lon_adt<=lonr,1,"last");
lat_adt_domain = lat_adt(latb_adt_idx:latt_adt_idx);
lon_adt_domain = lon_adt(lonl_adt_idx:lonr_adt_idx);
[LON_ADT_domain, LAT_ADT_domain] = meshgrid(lon_adt_domain, lat_adt_domain);

% read data
t_ys = 2017;
t_ms = 10;
t_ds = 1;
t_ye = 2017;
t_me = 10;
t_de = 31;
[~,~,~,time_star] = time_str(t_ds,t_ms,t_ys,0);
[~,~,~,time_end] = time_str(t_de,t_me,t_ye,0);

total_day = num_of_day(t_ys, t_ms, t_ds, t_ye, t_me, t_de);
disp("total_day : " + num2str(total_day))
DT = 1 : total_day;
ugos_domain_sum = 0;
vgos_domain_sum = 0;
adt_domain_sum = 0;
% sst_domain_sum = 0;
for dt = DT
    [t_dc,t_mc,t_yc,t_strc] = time_str(t_ds,t_ms,t_ys,dt-1);
    disp(t_strc)

    % read velocity data
    ugos = read_dat_data(adt_folder + "ugos_" + t_strc + ".dat");    
    ugos(ugos < -10^9) = nan;
    ugos = reshape(ugos, nx_adt, ny_adt)';
    vgos = read_dat_data(adt_folder + "vgos_" + t_strc + ".dat");
    vgos(vgos < -10^9) = nan;
    vgos = reshape(vgos, nx_adt, ny_adt)';
    ugos_domain = ugos(latb_adt_idx:latt_adt_idx,lonl_adt_idx:lonr_adt_idx);
    vgos_domain = vgos(latb_adt_idx:latt_adt_idx,lonl_adt_idx:lonr_adt_idx);
    ugos_domain_sum = ugos_domain_sum + ugos_domain;
    vgos_domain_sum = vgos_domain_sum + vgos_domain;

    % read sea surface height
    adt = read_dat_data(adt_folder+"adt_" + t_strc + ".dat");
    adt(adt < -10^9) = nan;
    adt = reshape(adt, nx_adt, ny_adt)';
    adt_domain = adt(latb_adt_idx:latt_adt_idx,lonl_adt_idx:lonr_adt_idx);
    adt_domain_sum = adt_domain_sum + adt_domain;

end
ugos_domain_ave = ugos_domain_sum/total_day;
vgos_domain_ave = vgos_domain_sum/total_day;
adt_domain_ave = adt_domain_sum/total_day;

% Plot
figure
set(gcf, 'units', 'centimeters', 'position', [1, 1, 20, 15]);
set(gca,"position",[0.15,0.2,0.7,0.7])
hold on

% fill land
U_var = read_dat_data("..\data\JCOPE-T\U_2018010112.dat");
x_t = readmatrix("..\data\JCOPE-T\x_t.csv");
y_t = readmatrix("..\data\JCOPE-T\y_t.csv");
U = reshape(U_var,542,290,75);
Plot_topo_land(x_t,y_t,U);

% velocity arrows
res = 1;
u_domain_ave_omit = omit_rc_idx(ugos_domain_ave,1:res:size(ugos_domain_ave,1),1:res:size(ugos_domain_ave,2));
v_domain_ave_omit = omit_rc_idx(vgos_domain_ave,1:res:size(vgos_domain_ave,1),1:res:size(vgos_domain_ave,2));
quiver(LON_ADT_domain, LAT_ADT_domain, u_domain_ave_omit, v_domain_ave_omit, 4.5, 'Color', [0.4 0.4 0.4]);

% Kuroshio axis
figure
[M_ka,~] = contour(LON_ADT_domain,LAT_ADT_domain,adt_domain_ave,[ka_value ka_value]);
close
M_ka(:,M_ka(1,:)==ka_value)=nan;
plot(M_ka(1,:),M_ka(2,:)+0.15,'r-','LineWidth',3)


% sea surface height contour
[M,c] = contour(LON_ADT_domain,...
                LAT_ADT_domain,...
                adt_domain_ave,...
                adt_range,...
                "LineWidth",1.5,...
                "ShowText","on",...
                "TextList",adt_range(1:2:end),...
                "LineColor",[0.2 0.2 0.2],...
                "LabelSpacing",500,...
                "LabelFormat", "%gm");
clabel(M, c, 'FontSize', 14, ...
             'Color', 'black',...
             'FontWeight','bold');

% location of Cape Shiono-misaki
Cape_lon = 135.7544;
Cape_lat = 33.4375;
scatter(Cape_lon,Cape_lat,200,"b","filled","square");

% setting axis
xl = [lonl lonr];
yl = [latb latt];
plot(xl, [yl(1) yl(1)], 'k-', 'LineWidth',2) % 下边
plot(xl, [yl(2) yl(2)], 'k-', 'LineWidth',2) % 上边
plot([xl(1) xl(1)], yl, 'k-', 'LineWidth',2) % 左边
plot([xl(2) xl(2)], yl, 'k-', 'LineWidth',2) % 右边
xlim(xl)
ylim(yl)
xticks_arr = ceil(lonl):1:ceil(lonr);
yticks_arr = ceil(latb):1:ceil(latt);
xticks(xticks_arr);yticks(yticks_arr)
xlabels = strings(size(xticks_arr));
ylabels = strings(size(yticks_arr));
xlabels(mod(xticks_arr,2)==1) = string(xticks_arr(mod(xticks_arr,2)==1)+"E");
ylabels(mod(yticks_arr,2)==1) = string(yticks_arr(mod(yticks_arr,2)==1)+"N");
yticklabels(ylabels);
xticklabels(xlabels);
xtickangle(0);
text(135.5,34,"Kii","FontSize",24,"Color","w","FontWeight","bold")
text(136.8,33.6,["Westward Coastal" ...
                 " Countercurrent"],"FontSize",14,"Color","b","FontWeight","bold")
set(gca,"LineWidth",2,"FontSize",14,"TickDir","both")
title_str = "";
title(title_str, "Interpreter","none")
annotation('arrow',[0.73 0.85],[0.1 0.1],'LineWidth',1)
text(139.4,28.9,"1m/s","FontSize",14,"FontWeight","bold")
hold off
saveas(gcf, "..\figure\Figure_3.jpg");
