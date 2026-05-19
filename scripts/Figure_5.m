clc
clear
disp("Horizonal and Vertical distribution of W & ZETA")

% PARAMETER
[~,~,~,~,~,~,lonl,lonr,latb,latt] = figure_size("CR_paper");
date_str = "20180506";
date_char = char(date_str);
date_text = date_char(1:4)+"/"+date_char(5:6)+"/"+date_char(7:8);
% READ GRID DATA
x_t = readmatrix("..\data\JCOPE-T\x_t.csv");
y_t = readmatrix("..\data\JCOPE-T\y_t.csv");
z_d = readmatrix("..\data\JCOPE-T\z_d.csv");
nx = length(x_t);
ny = length(y_t);
nz = length(z_d);
dep_idx = find(abs(z_d-400)==min(abs(z_d-400)),1,"first");
[X,Y] = meshgrid(x_t,y_t);
lon_cape = 135.7544;
lat_cape = 33.4375;
% font size
axis_font_size = 18;

% PLOT
figure
set(gcf, 'units', 'centimeters', 'position', [0.5, 1, 40, 18]);



%% 1. HW on 20170101
ax = subplot(2,3,1);
ax.Position(1) = ax.Position(1)-0.08;
ax.Position(3) = ax.Position(3)-0.02;
hold on

% read data
U_var = read_dat_data("..\data\JCOPE-T\U_2017010112.dat");
U_var(U_var > 1*10^20) = nan;
U = reshape(U_var,nx,ny,nz);
U_lyr = U(:,:,dep_idx)';
V_var = read_dat_data("..\data\JCOPE-T\V_2017010112.dat");
V_var(V_var > 1*10^20) = nan;
V = reshape(V_var,nx,ny,nz);
V_lyr = V(:,:,dep_idx)';
W_var = read_dat_data("..\data\JCOPE-T\W_2017010112.dat");
W_var(W_var > 1*10^20) = nan;
W = reshape(W_var,nx,ny,nz);
W_lyr = W(:,:,dep_idx)';
T_var = read_dat_data("..\data\JCOPE-T\T_2017010112.dat");
T_var(T_var > 1*10^20) = nan;
T = reshape(T_var,nx,ny,nz);
T_lyr = W(:,:,15)';

% shading
[var_shading_lyr,var_shading_range,c_shading_range,h_shading_tick,c_shading_map,c_shading_label] = ...
var_range_map("W_negative",W_lyr);
[~,c] = contourf(X,Y,var_shading_lyr,var_shading_range);
set(c,'Linestyle','none')
colormap(ax,c_shading_map)
clim(c_shading_range);
h = colorbar;
h.Ticks = h_shading_tick;
h.FontSize = axis_font_size;
h.Position = [ax.Position(1)+ax.Position(3)+0.01,ax.Position(2),0.01,ax.Position(4)];
title(h,c_shading_label,"FontSize",axis_font_size,"FontWeight","bold","Interpreter","latex");

% topo
Plot_topo(x_t,y_t,z_d,U,[3000,2000,1000],gray);
Plot_topo_land(x_t,y_t,U);

% Horizontal velocity
res = 8;
U_lyr_t = omit_rc_idx(U_lyr,1:res:length(y_t),1:res:length(x_t));
V_lyr_t = omit_rc_idx(V_lyr,1:res:length(y_t),1:res:length(x_t));
quiver(X, Y, U_lyr_t, V_lyr_t, 0, 'Color', [0.2 0.2 0.2]);

% Kuroshio axis
Plot_Kuroshio_axis(x_t,y_t,T_lyr,"r",4)

% Location of Cape Shiono-misaki
plot(lon_cape,lat_cape,...
     "Marker","o",...
     "Color","g",...
     "MarkerSize",6,...
     "MarkerFaceColor","g")

% set axis
xl = [lonl lonr];
yl = [latb latt];
plot(xl, [yl(1) yl(1)], 'k-', 'LineWidth',1) % 下边
plot(xl, [yl(2) yl(2)], 'k-', 'LineWidth',1) % 上边
plot([xl(1) xl(1)], yl, 'k-', 'LineWidth',1) % 左边
plot([xl(2) xl(2)], yl, 'k-', 'LineWidth',1) % 右边
xlim(xl)
ylim(yl)
xticks_arr = ceil(lonl):1:ceil(lonr);
yticks_arr = ceil(latb):1:ceil(latt);
xticks(xticks_arr);yticks(yticks_arr)
xlabels = strings(size(xticks_arr));
ylabels = strings(size(yticks_arr));
xlabels(mod(xticks_arr,2)==1) = string(xticks_arr(mod(xticks_arr,2)==1)+"E");
ylabels(mod(yticks_arr,2)==1) = string(yticks_arr(mod(yticks_arr,2)==1)+"N");
xticklabels(xlabels);
yticklabels(ylabels);
xtickangle(0);
hold off
text(lonl,latt+0.3,"2017/01/01","FontSize",axis_font_size,"Color","k","FontWeight","normal")
text(135.4,34,"Kii","FontSize",16,"Color","w","FontWeight","bold")
text(lonl+0.3,latb+0.3,"a.","FontSize",24,"Color","k","FontWeight","bold")
set(gca,"LineWidth",1,"FontSize",axis_font_size,"TickDir","both")
            
%% 2. HW on date_str
ax = subplot(2,3,2);
ax.Position(1) = ax.Position(1)-0.03;
ax.Position(3) = ax.Position(3)-0.02;
hold on

% read data
U_var = read_dat_data("..\data\JCOPE-T\U_"+date_str+"12.dat");
U_var(U_var > 1*10^20) = nan;
U = reshape(U_var,nx,ny,nz);
U_lyr = U(:,:,dep_idx)';
V_var = read_dat_data("..\data\JCOPE-T\V_"+date_str+"12.dat");
V_var(V_var > 1*10^20) = nan;
V = reshape(V_var,nx,ny,nz);
V_lyr = V(:,:,dep_idx)';
W_var = read_dat_data("..\data\JCOPE-T\W_"+date_str+"12.dat");
W_var(W_var > 1*10^20) = nan;
W = reshape(W_var,nx,ny,nz);
W_lyr = W(:,:,dep_idx)';
T_var = read_dat_data("..\data\JCOPE-T\T_2017010112.dat");
T_var(T_var > 1*10^20) = nan;
T = reshape(T_var,nx,ny,nz);
T_lyr = W(:,:,15)';

% shading
[var_shading_lyr,var_shading_range,c_shading_range,h_shading_tick,c_shading_map,c_shading_label] = ...
var_range_map("W_negative",W_lyr);
[~,c] = contourf(X,Y,var_shading_lyr,var_shading_range);
set(c,'Linestyle','none')
colormap(ax,c_shading_map)
h = colorbar;
h.Ticks = h_shading_tick;
h.FontSize = axis_font_size;
h.Position = [ax.Position(1)+ax.Position(3)+0.01,ax.Position(2),0.01,ax.Position(4)];
clim(c_shading_range);
title(h,c_shading_label,"FontSize",axis_font_size,"FontWeight","bold","Interpreter","latex");

% topo
Plot_topo(x_t,y_t,z_d,U,[3000,2000,1000],gray);
Plot_topo_land(x_t,y_t,U);

% Horizontal velocity
res = 8;
U_lyr_t = omit_rc_idx(U_lyr,1:res:length(y_t),1:res:length(x_t));
V_lyr_t = omit_rc_idx(V_lyr,1:res:length(y_t),1:res:length(x_t));
quiver(X, Y, U_lyr_t, V_lyr_t, 0, 'Color', [0.2 0.2 0.2]);

% Kuroshio axis
Plot_Kuroshio_axis(x_t,y_t,T_lyr,"r",4)

% line
[~,xrange,yrange,~,~] = Find_line_point("W",date_str);
plot(xrange, yrange, '-.k', 'LineWidth', 3)

% rectangle
plot([135, 136],[32 32],"-k","LineWidth", 1)
plot([135, 136],[33 33],"-k","LineWidth", 1)
plot([135, 135],[32 33],"-k","LineWidth", 1)
plot([136, 136],[32 33],"-k","LineWidth", 1)

% Location of Cape Shiono-misaki
plot(lon_cape,lat_cape,...
     "Marker","o",...
     "Color","g",...
     "MarkerSize",6,...
     "MarkerFaceColor","g")

% set axis
xl = [lonl lonr];
yl = [latb latt];
plot(xl, [yl(1) yl(1)], 'k-', 'LineWidth',1) % 下边
plot(xl, [yl(2) yl(2)], 'k-', 'LineWidth',1) % 上边
plot([xl(1) xl(1)], yl, 'k-', 'LineWidth',1) % 左边
plot([xl(2) xl(2)], yl, 'k-', 'LineWidth',1) % 右边
xlim(xl)
ylim(yl)
xticks_arr = ceil(lonl):1:ceil(lonr);
yticks_arr = ceil(latb):1:ceil(latt);
xticks(xticks_arr);yticks(yticks_arr)
xlabels = strings(size(xticks_arr));
ylabels = strings(size(yticks_arr));
xlabels(mod(xticks_arr,2)==1) = string(xticks_arr(mod(xticks_arr,2)==1)+"E");
ylabels(mod(yticks_arr,2)==1) = string(yticks_arr(mod(yticks_arr,2)==1)+"N");
xticklabels(xlabels);
yticklabels(ylabels);
xtickangle(0);
hold off
text(lonl,latt+0.3,date_text,"FontSize",axis_font_size,"Color","k","FontWeight","normal")
text(135.4,34,"Kii","FontSize",16,"Color","w","FontWeight","bold")
text(lonl+0.3,latb+0.3,"b.","FontSize",24,"Color","k","FontWeight","bold")
set(gca,"LineWidth",1,"FontSize",axis_font_size,"TickDir","both")


%% 3. HZeta on date_str
ax = subplot(2,3,3);
ax.Position(1) = ax.Position(1)+0.02;
ax.Position(3) = ax.Position(3)-0.02;
hold on

% read data
U_var = read_dat_data("..\data\JCOPE-T\U_"+date_str+"12.dat");
U_var(U_var > 1*10^20) = nan;
U = reshape(U_var,nx,ny,nz);
U_lyr = U(:,:,dep_idx)';
V_var = read_dat_data("..\data\JCOPE-T\V_"+date_str+"12.dat");
V_var(V_var > 1*10^20) = nan;
V = reshape(V_var,nx,ny,nz);
V_lyr = V(:,:,dep_idx)';
Zeta_var = read_dat_data("..\data\JCOPE-T\Zeta_"+date_str+"12.dat");
Zeta = reshape(Zeta_var,nx,ny,nz);
Zeta_lyr = Zeta(:,:,dep_idx)';
T_var = read_dat_data("..\data\JCOPE-T\T_2017010112.dat");
T_var(T_var > 1*10^20) = nan;
T = reshape(T_var,nx,ny,nz);
T_lyr = W(:,:,15)';

% shading
[var_shading_lyr,var_shading_range,c_shading_range,h_shading_tick,c_shading_map,c_shading_label] = ...
var_range_map("Zeta_positive",Zeta_lyr);
[~,c] = contourf(X,Y,var_shading_lyr,var_shading_range);
set(c,'Linestyle','none')
colormap(ax,c_shading_map)
h = colorbar;
h.Ticks = h_shading_tick;
h.FontSize = axis_font_size;
h.Position = [ax.Position(1)+ax.Position(3)+0.01,ax.Position(2),0.01,ax.Position(4)];
clim(c_shading_range);
title(h,c_shading_label,"FontSize",axis_font_size,"FontWeight","bold","Interpreter","latex");

% topo
Plot_topo(x_t,y_t,z_d,U,[3000,2000,1000],gray);
Plot_topo_land(x_t,y_t,U);

% Horizontal velocity
res = 8;
U_lyr_t = omit_rc_idx(U_lyr,1:res:length(y_t),1:res:length(x_t));
V_lyr_t = omit_rc_idx(V_lyr,1:res:length(y_t),1:res:length(x_t));
quiver(X, Y, U_lyr_t, V_lyr_t, 0, 'Color', [0.2 0.2 0.2]);

% Kuroshio axis
Plot_Kuroshio_axis(x_t,y_t,T_lyr,"r",4)

% dashed line
[~,xrange,yrange,~,~] = Find_line_point("ZETA",date_str);
plot(xrange, yrange, '-.k', 'LineWidth', 3)

% Location of Cape Shiono-misaki
plot(lon_cape,lat_cape,...
     "Marker","o",...
     "Color","g",...
     "MarkerSize",6,...
     "MarkerFaceColor","g")

% set axis
xl = [lonl lonr];
yl = [latb latt];
plot(xl, [yl(1) yl(1)], 'k-', 'LineWidth',1) % 下边
plot(xl, [yl(2) yl(2)], 'k-', 'LineWidth',1) % 上边
plot([xl(1) xl(1)], yl, 'k-', 'LineWidth',1) % 左边
plot([xl(2) xl(2)], yl, 'k-', 'LineWidth',1) % 右边
xlim(xl)
ylim(yl)
xticks_arr = ceil(lonl):1:ceil(lonr);
yticks_arr = ceil(latb):1:ceil(latt);
xticks(xticks_arr);yticks(yticks_arr)
xlabels = strings(size(xticks_arr));
ylabels = strings(size(yticks_arr));
xlabels(mod(xticks_arr,2)==1) = string(xticks_arr(mod(xticks_arr,2)==1)+"E");
ylabels(mod(yticks_arr,2)==1) = string(yticks_arr(mod(yticks_arr,2)==1)+"N");
xticklabels(xlabels);
yticklabels(ylabels);
xtickangle(0);
hold off
text(lonl,latt+0.3,date_text,"FontSize",axis_font_size,"Color","k","FontWeight","normal")
text(135.4,34,"Kii","FontSize",16,"Color","w","FontWeight","bold")
text(lonl+0.3,latb+0.3,"c.","FontSize",24,"Color","k","FontWeight","bold")
set(gca,"LineWidth",1,"FontSize",axis_font_size,"TickDir","both")


%% 4. VW
ax = subplot(2,3,4);
ax.Position(1) = ax.Position(1)-0.08;
ax.Position(3) = ax.Position(3)-0.02;
hold on

% read data
W_var = read_dat_data("..\data\JCOPE-T\W_"+date_str+"12.dat");
W_var(W_var > 1*10^20) = nan;
W = reshape(W_var,nx,ny,nz);

% w shading
[~,line_xrange,line_yrange,X_V,Z_D] = Find_line_point("W",date_str);
Var_shading = Find_line_var(W,line_xrange,line_yrange,x_t,y_t);
[Var_shading,var_shading_range,c_shading_range,h_shading_tick,c_shading_map,c_shading_label] = ...
var_range_map("W",Var_shading);
[~,c] = contourf(X_V,Z_D,Var_shading,var_shading_range);
set(c,'Linestyle','none')
h = colorbar;
h.Ticks = h_shading_tick;
h.FontSize = axis_font_size;
h.Position = [ax.Position(1)+ax.Position(3)+0.01,ax.Position(2),0.01,ax.Position(4)];
h.Ruler.TickLabelRotation=0;
clim(c_shading_range);
colormap(gca,c_shading_map)
title(h,c_shading_label,"FontSize",axis_font_size,"FontWeight","bold","Interpreter","latex");
        
% land
Nodes = Find_nodes(Var_shading,line_xrange,-[0,z_d*10^(-3)]);
Plot_mask_land(Nodes,[0,0,0])

% depth line
plot([min(line_xrange) max(line_xrange)], [-2 -2], "--K", "LineWidth", 2)
plot([min(line_xrange) max(line_xrange)], [-0.5 -0.5], "--k", "LineWidth", 2)

% set axis
xlim([min(line_xrange) 135.54])
ylim([-5 0]);
xl = xlim;
yl = ylim;
plot(xl, [yl(1) yl(1)], 'k-', 'LineWidth',1) % 下边
plot(xl, [yl(2) yl(2)], 'k-', 'LineWidth',1) % 上边
plot([xl(1) xl(1)], yl, 'k-', 'LineWidth',1) % 左边
plot([xl(2) xl(2)], yl, 'k-', 'LineWidth',1) % 右边
ylabel("Depth(km)", "FontSize", 12)
xlabel("Longitude(°E)")
xticks(fix(min(line_xrange))+0.1:0.2:round(max(line_xrange),1))
yticks_arr = -5 : 0.5 : 0;
yticks(yticks_arr)
ylabels = strings(size(yticks_arr));
ylabels(mod(yticks_arr,1)==0) = string(yticks_arr(mod(yticks_arr,1)==0));
ylabels(yticks_arr==-0.5) = string(-0.5);
yticklabels(ylabels);
xtickangle(0);
text(xl(1)+(xl(2)-xl(1))/25,yl(1)+(yl(2)-yl(1))/15,"d.","FontSize",24,"Color","w","FontWeight","bold")
set(gca,"LineWidth",1,"FontSize",axis_font_size,"TickDir","both")

%% 5. W average
ax = subplot(2,3,5);
ax.Position(3) = ax.Position(3)-0.05;
hold on

% read data
W_region_ave = readmatrix("..\data\JCOPE-T\W_regional_ave_on_"+date_str+"_in_135_136_32_33.csv");
W_region_ave = W_region_ave * 1000;
% figure
plot(W_region_ave, -z_d*10^(-3), "LineWidth", 2, "Color", "k");

% depth line
plot([min(W_region_ave) max(W_region_ave)], [-2 -2], "--K", "LineWidth", 2)
plot([min(W_region_ave) max(W_region_ave)], [-0.5 -0.5], "--k", "LineWidth", 2)

% set axis
xlim([min(W_region_ave) max(W_region_ave)])
ylim([-5 0])
xl = xlim;
yl = ylim;
plot(xl, [yl(1) yl(1)], 'k-', 'LineWidth',1) % 下边
plot(xl, [yl(2) yl(2)], 'k-', 'LineWidth',1) % 上边
plot([xl(1) xl(1)], yl, 'k-', 'LineWidth',1) % 左边
plot([xl(2) xl(2)], yl, 'k-', 'LineWidth',1) % 右边
yticks_arr = -5 : 0.5 : 0;
yticks(yticks_arr)
ylabels = strings(size(yticks_arr));
ylabels(mod(yticks_arr,1)==0) = string(yticks_arr(mod(yticks_arr,1)==0));
ylabels(yticks_arr==-0.5) = string(-0.5);
yticklabels(ylabels);
xtickangle(0);
xlabel("W (×10^-^3 m/s)")
ylabel("Depth (km)")  
text(xl(1)+(xl(2)-xl(1))/25,yl(1)+(yl(2)-yl(1))/15,"e.","FontSize",24,"Color","k","FontWeight","bold")
set(gca,"LineWidth",1,"FontSize",axis_font_size,"TickDir","both")
hold off

%% 6. VZETA
ax = subplot(2,3,6);
ax.Position(1) = ax.Position(1)+0.02;
ax.Position(3) = ax.Position(3)-0.02;
hold on

% read data
Zeta_var = read_dat_data("..\data\JCOPE-T\ZETA_"+date_str+"12.dat");
Zeta_var(Zeta_var > 1*10^20) = nan;
Zeta = reshape(Zeta_var,nx,ny,nz);
% zeta shading
[~,line_xrange,line_yrange,X_V,Z_D] = Find_line_point("ZETA",date_str);
Var_shading = Find_line_var(Zeta,line_xrange,line_yrange,x_t,y_t);
[Var_shading,var_shading_range,c_shading_range,h_shading_tick,c_shading_map,c_shading_label] = ...
var_range_map("ZETA",Var_shading);
[~,c] = contourf(X_V,Z_D,Var_shading,var_shading_range);
set(c,'Linestyle','none')
clim(c_shading_range);
colormap(gca,c_shading_map)
h = colorbar;
h.Ticks = h_shading_tick;
h.FontSize = axis_font_size;
h.Ruler.TickLabelRotation=0;
h.Position = [ax.Position(1)+ax.Position(3)+0.01,ax.Position(2),0.01,ax.Position(4)];
title(h,c_shading_label,"FontSize",axis_font_size,"FontWeight","bold","Interpreter","latex");

% land
Nodes = Find_nodes(Var_shading,line_xrange,-[0,z_d*10^(-3)]);
Plot_mask_land(Nodes,[0,0,0])

% depth line
plot([min(line_xrange) max(line_xrange)], [-2 -2], "--K", "LineWidth", 2)
plot([min(line_xrange) max(line_xrange)], [-0.5 -0.5], "--K", "LineWidth", 2)

% set axis
xlim([min(line_xrange) 136.04]);
ylim([-5 0])
xl = xlim;
yl = ylim;
plot(xl, [yl(1) yl(1)], 'k-', 'LineWidth',1) % 下边
plot(xl, [yl(2) yl(2)], 'k-', 'LineWidth',1) % 上边
plot([xl(1) xl(1)], yl, 'k-', 'LineWidth',1) % 左边
plot([xl(2) xl(2)], yl, 'k-', 'LineWidth',1) % 右边
yticks_arr = -5 : 0.5 : 0;
yticks(yticks_arr)
ylabels = strings(size(yticks_arr));
ylabels(mod(yticks_arr,1)==0) = string(yticks_arr(mod(yticks_arr,1)==0));
ylabels(yticks_arr==-0.5) = string(-0.5);
yticklabels(ylabels);
xtickangle(0);
xticks(fix(min(line_xrange))+0.2:0.2:round(max(line_xrange),1));
xlabel("Longitude(°E)")
ylabel("Depth(km)")
text(xl(1)+(xl(2)-xl(1))/25,yl(1)+(yl(2)-yl(1))/15,"f.","FontSize",24,"Color","w","FontWeight","bold")
set(gca,"LineWidth",1,"FontSize",axis_font_size,"TickDir","both")
%% save
saveas(gcf,"..\figure\Figure_5.jpg")
