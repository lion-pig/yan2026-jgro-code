clc;
clear;

%% READ DATA
x_t = readmatrix("Results\Data\x_t.csv");
y_t = readmatrix("Results\Data\y_t.csv");
z_d = readmatrix("Results\Data\z_d.csv");
[X_T,Y_T] = meshgrid(x_t,y_t);
nx = length(x_t);
ny = length(y_t);
nz = length(z_d);
lonl_target = min(x_t);
lonr_target = max(x_t);
latb_target = min(y_t);
latt_target = max(y_t);
%% set figure
figure
set(gcf, 'units', 'centimeters', 'position', [1, 1, 22, 16]);
ax = subplot(1,1,1);
ax.Position(1) = ax.Position(1)+0.04;
ax.Position(2) = ax.Position(2)+0.2;
ax.Position(3) = ax.Position(3)-0.12;
ax.Position(4) = ax.Position(4)-0.3;
hold on
%% topo
U_ave_var = read_dat_data("Results\Data\U_ave_20180101_20181231.dat");
U_ave = reshape(U_ave_var,nx,ny,nz);
figure
colorMap = colormap("gray");
close
topo_depth = 5000:-1000:0;
Plot_topo(x_t,y_t,z_d,U_ave,0,colorMap);
GBR = Plot_topo_contour(x_t,y_t,z_d,U_ave_var,topo_depth,colorMap);
colormap(GBR)
clim([0 length(topo_depth)*0.2])
h = colorbar("southoutside");
h.Ticks = 0.1:0.2:length(topo_depth)*0.2-0.1;
h.TickLabels = string(topo_depth);
h.Position = [ax.Position(1),ax.Position(2)-0.1,ax.Position(3),0.02];
ylabel(h,"Depth(m)")
%% set axis
xlim([lonl_target lonr_target])
ylim([latb_target latt_target])
xl = xlim;
yl = ylim;
plot(xl, [yl(1) yl(1)], 'k-', 'LineWidth',1) % 下边
plot(xl, [yl(2) yl(2)], 'k-', 'LineWidth',1) % 上边
plot([xl(1) xl(1)], yl, 'k-', 'LineWidth',1) % 左边
plot([xl(2) xl(2)], yl, 'k-', 'LineWidth',1) % 右边
xTicks = floor(lonl_target):2:floor(lonr_target);
yTicks = ceil(latb_target):2:ceil(latt_target);
xticks(xTicks);
yticks(yTicks);
xtickLabels = string(xTicks)+"E";
ytickLabels = string(yTicks)+"N";
xticklabels(xtickLabels);
yticklabels(ytickLabels);
% text(137,35.5,"Honshu","FontSize",14,"Color","w","FontWeight","bold") 
% text(135.5,34.2,"Kii","FontSize",14,"Color","w","FontWeight","bold") 
% text(134.5,32.1,["Koshu" "Seamount"],...
%      "FontSize",10,"Color","k","FontWeight","bold")
% text(135.6,31.6,"\rightarrow",...
%      "FontSize",12,"Color","k","FontWeight","bold","Rotation",150)
% text(140,33,"Izu Ridge",...
%      "FontSize",16,"Color","k","FontWeight","bold",...
%      "Rotation",-75) 
% text(130.8,31.8,"Kyushu",...
%      "FontSize",12,"Color","w","FontWeight","bold","Rotation",65) 
% text(132.7,33.5,"Shikoku",...
%      "FontSize",12,"Color","w","FontWeight","bold","Rotation",20)
% text(lonl_target+(lonr_target-lonl_target)/20,...
%      latb_target+(latt_target-latb_target)/15,...
%      "b.","FontSize",22,"FontWeight","bold")
set(gca,"LineWidth",1,"FontSize",14,"TickDir","both")
%% LM path
EL_LM_var = read_dat_data("Results\Data\EL_ave_20180101_20181231.dat");
EL_LM_var(EL_LM_var>10^10)=nan;
EL_LM = reshape(EL_LM_var,nx,ny)';
% contourf(X_T,Y_T,EL_LM)
figure
[lon_lm,lat_lm] = Plot_var_contour_single(x_t,y_t,EL_LM,0.4,"r",3);
close
% [lon_lm,~]=sort(lon_lm);
% [lon_lm,idx]=unique(lon_lm);
% lat_lm = lat_lm(idx);
lat_lm = lat_lm+0.2;
plot(lon_lm,lat_lm,"r-","LineWidth",3)
writematrix([lon_lm',lat_lm'],"Results\Data\Kuroshio_LM_schematic_position.csv")
%% nNLM
EL_nNLM_var = read_dat_data("Results\Data\EL_ave_20160101_20161231.dat");
EL_nNLM_var(EL_nNLM_var>10^10)=nan;
EL_nNLM = reshape(EL_nNLM_var,nx,ny)';
% contourf(X_T,Y_T,EL_nNLM)
figure
[lon_nnlm,lat_nnlm] = Plot_var_contour_single(x_t,y_t,EL_nNLM,0.15,"b",3);
close
[~,ca]=find(lon_nnlm<133.4,1,"first");
[~,cb]=find(lon_lm<133.4,1,"first");
lon_nnlm = cat(2,lon_nnlm(1:ca-1),lon_lm(cb:end));
lat_nnlm = cat(2,lat_nnlm(1:ca-1),lat_lm(cb:end)+0.09);
[~,cc] = find(lon_nnlm<133.4,1,"first");
lon_nnlm_new = linspace(min(lon_nnlm),max(lon_nnlm),200);
unique(lon_nnlm);
lat_nnlm_new = interp1(lon_nnlm([1:cc-300,cc:1:end]),...
                       lat_nnlm([1:cc-300,cc:1:end]),...
                       lon_nnlm_new,"pchip");
[~,cd] = find(lon_nnlm_new>137,1,"first");
lat_nnlm_neww = movmean(lat_nnlm_new(cd:end),40);
lat_nnlm_new = cat(2,lat_nnlm_new(1:cd+19),lat_nnlm_neww(21:end));
plot(lon_nnlm_new,lat_nnlm_new,"b-","LineWidth",3)
writematrix([lon_nnlm_new',lat_nnlm_new'],"Results\Data\Kuroshio_nNLM_schematic_position.csv")
%% oNLM
EL_oNLM_var = read_dat_data("Results\Data\EL_ave_20150101_20151231.dat");
EL_oNLM_var(EL_oNLM_var>10^10)=nan;
EL_oNLM = reshape(EL_oNLM_var,nx,ny)';
% contourf(X_T,Y_T,EL_oNLM)
figure
[lon_onlm,lat_onlm] = Plot_var_contour_single(x_t,y_t,EL_oNLM,0.35,"b",3);
close
[~,ce]=find(lon_onlm<136.5,1,"first");
lat_onlm(1:ce)=lat_onlm(1:ce)-0.2;
lat_onlm(ce:end)=lat_onlm(ce:end)+0.1;
[~,cf]=find(lon_onlm<141.7,1,"first");
lat_onlm(1:cf)=lat_onlm(1:cf)+0.3;
% plot(lon_onlm,lat_onlm,"g-","LineWidth",3)
lon_onlm_new = linspace(min(lon_onlm),max(lon_onlm),200);
lat_onlm_new = interp1(lon_onlm([1:1:cf-1,cf+1:ce-1,ce+140:1:end]),...
                       lat_onlm([1:1:cf-1,cf+1:ce-1,ce+140:1:end]),...
                       lon_onlm_new,"pchip");
[~,cg]=find(lon_onlm_new>132.5,1,"first");
[~,ch]=find(lon_onlm_new>139,1,"first");
lat_onlm_neww = movmean(lat_onlm_new(cg:ch),20);
lat_onlm_new = cat(2,lat_onlm_new(1:cg+25),...
                     lat_onlm_neww(27:end-10),...
                     lat_onlm_new(ch-9:end));
lat_onlm_new = movmean(lat_onlm_new,5);
plot(lon_onlm_new,lat_onlm_new,"g-","LineWidth",3)
writematrix([lon_onlm_new',lat_onlm_new'],"Results\Data\Kuroshio_oNLM_schematic_position.csv")
