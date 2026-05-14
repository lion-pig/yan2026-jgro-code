clc;
clear;

%% set figure
figure
set(gcf, 'units', 'centimeters', 'position', [1, 1, 22, 20]);

%% 1. JCOPET Domain
ax = subplot(2,1,1);
% ax.Position(1) = ax.Position(1)+0.04;
ax.Position(2) = ax.Position(2)-0.08;
ax.Position(3) = ax.Position(3)-0.12;
ax.Position(4) = ax.Position(4)+0.14;
hold on
% read global topo data
x = ncread('..\data\ETOPO\ETOPO1_Bed_c_gmt4.grd', 'x');
y = ncread('..\data\ETOPO\ETOPO1_Bed_c_gmt4.grd', 'y');
z = ncread('..\data\ETOPO\ETOPO1_Bed_c_gmt4.grd', 'z');
x(x<0) = x(x<0)+360;
[x, idx] = sort(x);
z = z(idx,:);
x_t = readmatrix("..\data\x_t.csv");
y_t = readmatrix("..\data\y_t.csv");
lonl_figure = 100;
lonr_figure = 190;
latb_figure = 0;
latt_figure = 70;
lonl_jcope2 = 108;
lonr_jcope2 = 180;
latb_jcope2 = 10.5;
latt_jcope2 = 62;
lonl_jcopet = 117;
lonr_jcopet = 150;
latb_jcopet = 17;
latt_jcopet = 50;
lonl_data = min(x_t);
lonr_data = max(x_t);
latb_data = min(y_t);
latt_data = max(y_t);
x_t_figure = x(x>=lonl_figure & x<=lonr_figure);
y_t_figure = y(y>=latb_figure & y<=latt_figure);
z_t_figure = z(x>=lonl_figure & x<=lonr_figure, ...
               y>=latb_figure & y<=latt_figure);
[X_T_figure, Y_T_figure] = meshgrid(x_t_figure, y_t_figure);
% Kuroshio current
nc_file_uo = "..\data\CMS\Global Ocean Physics Reanalysis\uo_glo_phy_2017.nc";
nc_file_vo = "..\data\CMS\Global Ocean Physics Reanalysis\vo_glo_phy_2017.nc";
uo = ncread(nc_file_uo,'uo');
uo = reshape(uo,size(uo,1),size(uo,2),size(uo,4));
uo_ave = mean(uo,3)';
vo = ncread(nc_file_vo,'vo');
vo = reshape(vo,size(vo,1),size(vo,2),size(vo,4));
vo_ave = mean(vo,3)';
abs_u_ave = sqrt(uo_ave.*uo_ave + vo_ave.*vo_ave);
lat_uo = ncread(nc_file_uo,'latitude');
lon_uo = ncread(nc_file_uo,'longitude');
[X_uo,Y_uo] = meshgrid(lon_uo,lat_uo);
[~,c] = contourf(X_uo,Y_uo,abs_u_ave,0:0.1:2);
set(c,"LineStyle","none")
clim([0 1])
colormap(ax,nebula)
h = colorbar;
h.FontSize = 14;
h.Position = [ax.Position(1)+ax.Position(3)+0.04,ax.Position(2),0.02,ax.Position(4)];
ylabel(h,"Sea Surface Horizontal Velocity (m/s)")
% land
[~,c] = contourf(X_T_figure,Y_T_figure,z_t_figure',[0,0],...
                 "FaceColor",[0 0 0]);
set(c,'Linestyle','none')
% jcope2 domian
rectangle('position',[lonl_jcope2,latb_jcope2,...
                      lonr_jcope2-lonl_jcope2,...
                      latt_jcope2-latb_jcope2],...
          "LineWidth",1.5,"EdgeColor","w","LineStyle","-.")
% jcopet domain
rectangle('position',[lonl_jcopet,latb_jcopet,...
                      lonr_jcopet-lonl_jcopet,...
                      latt_jcopet-latb_jcopet],...
          "LineWidth",1.5,"EdgeColor","w","LineStyle","-")
% data domain
rectangle('position',[lonl_data,latb_data,...
                      lonr_data-lonl_data,...
                      latt_data-latb_data],...
          "LineWidth",1.5,"EdgeColor","k","LineStyle","-")
% set axis
xlim([lonl_figure, lonr_figure])
ylim([latb_figure, latt_figure])
xTicks = lonl_figure:10:lonr_figure;
yTicks = latb_figure:10:latt_figure;
xticks(xTicks)
yticks(yTicks)
xtickLabels = string(xTicks)+"E";
ytickLabels = string(yTicks)+"N";
xtickLabels(xTicks>180) = string(abs(xTicks(xTicks>180)-360))+"W";
ytickLabels(yTicks<0) = string(abs(yTicks(yTicks<0)))+"S";
xtickLabels_new = strings(size(xtickLabels));
ytickLabels_new = strings(size(ytickLabels));
xtickLabels_new(2:2:end) = xtickLabels(2:2:end);
ytickLabels_new(1:2:end) = ytickLabels(1:2:end);
xticklabels(xtickLabels_new);
yticklabels(ytickLabels_new);
xtickangle(0)
xl = xlim;
yl = ylim;
plot(xl, [yl(2) yl(2)], 'k-', 'LineWidth',1.5) % 上边
plot([xl(2) xl(2)], yl, 'k-', 'LineWidth',1.5) % 右边
text(136,39,"Japan","FontSize",14,"Color","w")
text(lonl_jcope2,latt_jcope2+2,"JCOPE2 Domain",...
     "FontSize",14,"FontWeight","bold","Color","w")
text(lonl_jcopet,latt_jcopet+2,"JCOPE-T Domain",...
     "FontSize",14,"FontWeight","bold","Color","w")
text(lonr_jcope2-23,latb_jcope2+15,...
     ["Western","North Pacific"],...
     "FontSize",14,"Color","w","FontWeight","bold")
text(123.3,21.7,"Kuroshio","FontSize",9,"Rotation",40,...
    "FontWeight","bold","Color","w")
text(121,16,"\rightarrow","FontSize",12,"Rotation",-10,...
    "FontWeight","bold","Color","w")
text(124,15,"Philippines","FontSize",10,"Rotation",0,...
    "FontWeight","bold","Color","w")
text(145,13,"NEC","FontSize",12,"Rotation",0,...
    "FontWeight","bold","Color","w")
text(117,22,"Taiwan","FontSize",8,"Rotation",-20,...
    "FontWeight","bold","Color","w")
text(119,22,"\leftarrow","FontSize",8,"Rotation",40,...
    "FontWeight","normal","Color","w")
text(123,29,"ECS","FontSize",10,"Rotation",40,...
    "FontWeight","bold","Color","w")
text(146.7,37.3,"KE","FontSize",10,"Rotation",0,...
    "FontWeight","bold","Color","w")
text(131.5,29,"TS","FontSize",8,"Rotation",0,...
    "FontWeight","bold","Color","w")
text(130,31,"\rightarrow","FontSize",8,"Rotation",-30,...
    "FontWeight","normal","Color","w")
text(135.5,30,"SB","FontSize",8,"Rotation",0,...
    "FontWeight","bold","Color","w")
text(lonl_figure+(lonr_figure-lonl_figure)/20,...
     latb_figure+(latt_figure-latb_figure)/15,...
     "a.","FontSize",22,"FontWeight","bold","Color","w")
set(gca,'FontSize',14,"LineWidth",1.5,"TickDir","both")

%% 2. Schematic Kuroshio path off south coast of Japan
ax = subplot(2,1,2);
% ax.Position(1) = ax.Position(1)+0.04;
ax.Position(2) = ax.Position(2)-0.06;
ax.Position(3) = ax.Position(3)-0.12;
ax.Position(4) = ax.Position(4)+0.02;
hold on
% READ DATA
x_t = readmatrix("..\data\x_t.csv");
y_t = readmatrix("..\data\y_t.csv");
z_d = readmatrix("..\data\z_d.csv");
[X_T,Y_T] = meshgrid(x_t,y_t);
nx = length(x_t);
ny = length(y_t);
nz = length(z_d);
lonl_data = min(x_t);
lonr_data = max(x_t);
latb_data = min(y_t);
latt_data = max(y_t);
lonl_target = 133.5;
lonr_target = 141;
latb_target = 30;
latt_target = 35;
% topo
U_ave_var = read_dat_data("..\data\U_ave_20180101_20181231.dat");
U_ave = reshape(U_ave_var,nx,ny,nz);
figure
colorMap = colormap("gray");
close
topo_depth = 5000:-1000:0;
Plot_topo(x_t,y_t,z_d,U_ave,0,colorMap);
GBR = Plot_topo_contour(x_t,y_t,z_d,U_ave_var,topo_depth,colorMap);
colormap(ax,GBR)
clim([0 length(topo_depth)*0.2])
h = colorbar;
h.Ticks = 0.1:0.2:length(topo_depth)*0.2-0.1;
h.TickLabels = string(topo_depth)+"m";
h.Position = [ax.Position(1)+ax.Position(3)+0.04,ax.Position(2),0.02,ax.Position(4)];
ylabel(h,"Depth")
% nNLM path
lon_lat_nnlm = readmatrix("..\data\Kuroshio_nNLM_schematic_position.csv");
lon_nnlm = lon_lat_nnlm(:,1);
lat_nnlm = lon_lat_nnlm(:,2);
plot(lon_nnlm,lat_nnlm,"b-","LineWidth",3);
% oNLM path
lon_lat_onlm = readmatrix("..\data\Kuroshio_oNLM_schematic_position.csv");
lon_onlm = lon_lat_onlm(:,1);
lat_onlm = lon_lat_onlm(:,2);
plot(lon_onlm,lat_onlm,"Color",[0, 153, 0]/255,"LineStyle","-","LineWidth",3)
% LM path
lon_lat_lm = readmatrix("..\data\Kuroshio_LM_schematic_position.csv");
lon_lm = lon_lat_lm(:,1);
lat_lm = lon_lat_lm(:,2);
plot(lon_lm,lat_lm,"r-","LineWidth",3);
% target domain
rectangle('position',[lonl_target,latb_target,...
                      lonr_target-lonl_target,...
                      latt_target-latb_target],...
          "LineWidth",1,"EdgeColor","r","LineStyle","-.")
% 136E and 140E dashed line
plot([136 136], [latb_data latt_data],"Color","k","LineStyle","--","LineWidth",1)
plot([140 140], [latb_data latt_data],"Color","k","LineStyle","--","LineWidth",1)
% Kushimoto & Uragami location
Kushimoto_lon = 135.78;
Kushimoto_lat = 33.47;
Uragami_lon = 135.93;
Uragami_lat = 33.58;
scatter(Kushimoto_lon,Kushimoto_lat,100,"magenta","filled","square");
scatter(Uragami_lon,Uragami_lat,100,"cyan","filled","^");
% set axis
xlim([lonl_data lonr_data])
ylim([latb_data latt_data])
xl = xlim;
yl = ylim;
plot(xl, [yl(2) yl(2)], 'k-', 'LineWidth',1.5) % 上边
plot([xl(2) xl(2)], yl, 'k-', 'LineWidth',1.5) % 右边
xTicks = floor(lonl_data):1:floor(lonr_data);
yTicks = ceil(latb_data):1:ceil(latt_data);
xticks(xTicks);
yticks(yTicks);
xtickLabels = strings(1,length(xTicks));
ytickLabels = strings(1,length(yTicks));
xtickLabels(1:2:end) = string(xTicks(1:2:end))+"E";
ytickLabels(1:2:end) = string(yTicks(1:2:end))+"N";
xticklabels(xtickLabels);
yticklabels(ytickLabels);
xtickangle(0);
text(137,35.5,"Honshu","FontSize",14,"Color","w","FontWeight","bold") 
text(135.5,34.2,"Kii","FontSize",14,"Color","w","FontWeight","bold") 
text(133.6,30.8,["Koshu" "Seamount"],...
     "FontSize",12,"Color","k","FontWeight","bold")
text(135.5,31.5,"\rightarrow",...
     "FontSize",14,"Color","k","FontWeight","bold",...
     "Rotation",-150)
text(139.8,31.8,"Izu Ridge",...
     "FontSize",16,"Color","k","FontWeight","bold",...
     "Rotation",-70) 
text(130.8,31.8,"Kyushu",...
     "FontSize",12,"Color","w","FontWeight","bold","Rotation",65) 
text(132.7,33.5,"Shikoku",...
     "FontSize",12,"Color","w","FontWeight","bold","Rotation",20)
text(lonl_data+(lonr_data-lonl_data)/20,...
     latb_data+(latt_data-latb_data)/15,...
     "b.","FontSize",22,"FontWeight","bold")
text(136.8,30.8,"LM","Color","r",...
     "FontSize",15,"FontWeight","bold","Rotation",-20)
text(136.5,32.5,"oNLM","Color",[0, 153, 0]/255,...
     "FontSize",15,"FontWeight","bold",...
     "Rotation",-13)
text(137.8,33,"nNLM","Color","b","FontSize",15,"FontWeight","bold",...
     "Rotation",15)
text(136.2,33.5,"Enshu-nada",...
     "Color","k","FontSize",13,...
     "FontWeight","bold",...
     "Rotation",15)
set(gca,"LineWidth",1.5,"FontSize",14,"TickDir","both")
% hold off
%% save figure
saveas(gcf, "..\figure\Figure_1.jpg")
