clc;
clear;

figure
set(gcf,'units','centimeters','position',[1, 1, 25, 20]);

%% 1. snapshots of W
[~,~,~,~,~,~,lonl,lonr,latb,latt] = figure_size("CR_snapshot");
x_t = readmatrix("..\data\JCOPE-T\x_t.csv");
y_t = readmatrix("..\data\JCOPE-T\y_t.csv");
z_d = readmatrix("..\data\JCOPE-T\z_d.csv");
[X,Y] = meshgrid(x_t,y_t);
nx = length(x_t);
ny = length(y_t);
nz = length(z_d);
lyr = find(abs(z_d-400) == min(abs(z_d-400)),1,"first");
Fontsize_num = 12;
Date_str = ["20180610" "20180605" "20180531" ...
            "20180526" "20180521" "20180516" ...
            "20180511" "20180506" "20180501"];
lon_cape = 135.7544;
lat_cape = 33.4375;
for n = 1 :  length(Date_str)
    ax = subplot(length(Date_str),4,n*4-3);
    ax.Position(1) = ax.Position(1)-0.1;
    ax.Position(2) = ax.Position(2)+0.04-0.055/(length(Date_str)-1)*(n-1);
    ax.Position(3) = ax.Position(3)-0.025;
    ax.Position(4) = ax.Position(4)+0.025;
    hold on
    % date
    date = Date_str(n);
    date_str = num2str(str2double(date));
    y_str = date_str(1:4);
    md_str = date_str(5:6)+"/"+date_str(7:8);
    disp(date)
    % read data
    U_var=read_dat_data("..\data\JCOPE-T\U_"+date+"12.dat");
    U_var(U_var>10^10) = nan;
    U = reshape(U_var,nx,ny,nz);
    U_lyr = U(:,:,lyr)';
    V_var=read_dat_data("..\data\JCOPE-T\V_"+date+"12.dat");
    V_var(V_var>10^10) = nan;
    V = reshape(V_var,nx,ny,nz);
    V_lyr = V(:,:,lyr)';
    T_var = read_dat_data("..\data\JCOPE-T\T_"+date+"12.dat");
    T_var(T_var > 1*10^20) = nan;
    T = reshape(T_var,nx,ny,nz);
    T_lyr = T(:,:,15)';
    Var_str = "W";
    Var_var = read_dat_data("..\data\JCOPE-T\"+Var_str+"_"+date+"12.dat");
    Var = reshape(Var_var,nx,ny,nz);
    Var(Var>10^10)=nan;
    Var_shading_lyr = Var(:,:,lyr)';
    % shading
    [Var_shading_lyr,var_shading_range,c_shading_range,h_shading_tick,c_shading_map,c_shading_label] = ...
    var_range_map("W_negative",Var_shading_lyr);
    [~,c] = contourf(X,Y,Var_shading_lyr,var_shading_range);
    set(c,'Linestyle','none');
    clim(c_shading_range);
    colormap(ax,c_shading_map)
    if n == length(Date_str)
        h = colorbar("southoutside");
        h.Ticks = h_shading_tick;
        h.Ruler.TickLabelRotation = 0;
        h.FontSize = 12;
        h.Position = [ax.Position(1),ax.Position(2)-0.025,ax.Position(3),0.015];
        ylabel(h,c_shading_label,"FontSize",14,"FontWeight","bold","Interpreter","latex");
    end
    % topo
    figure
    colorMap = colormap("gray");
    close
    Plot_topo(x_t,y_t,z_d,U,[3000,2000,1000],colorMap);
    Plot_topo_land(x_t,y_t,U)
    % horizontal velocity
    res = 20;
    U_lyr_t = omit_rc_idx(U_lyr,1:res:length(y_t),1:res:length(x_t));
    V_lyr_t = omit_rc_idx(V_lyr,1:res:length(y_t),1:res:length(x_t));
    quiver(X,Y,U_lyr_t,V_lyr_t,0,'Color',[0.4 0.4 0.4],'LineWidth',0.01);
    % Kuroshio axis
    Plot_Kuroshio_axis(x_t,y_t,T_lyr,"r",1);
    % location of Cape Shiono-misaki
    plot(lon_cape,lat_cape,...
         "Marker","o",...
         "Color","g",...
         "MarkerSize",4,...
         "MarkerFaceColor","g")
    % set axis
    set(ax,'XTickLabel',[],'XTick',lonl:1:lonr,'YTick',latb:1:latt,'TickDir','both')
    set(ax,'YTickLabel',[],'XTick',lonl:1:lonr,'YTick',latb:1:latt,'TickDir','both')
    xl = [lonl lonr];
    yl = [latb latt];
    plot(xl, [yl(1) yl(1)],'k-','LineWidth',0.5) % 下边
    plot(xl, [yl(2) yl(2)],'k-','LineWidth',0.5) % 上边
    plot([xl(1) xl(1)], yl,'k-','LineWidth',0.5) % 左边
    plot([xl(2) xl(2)], yl,'k-','LineWidth',0.5) % 右边
    text(135.3,34.1,"Kii","FontSize",10,"Color","w")
    text(lonl+0.15,latb+0.55,md_str,"FontSize",12,"Color","k")
    xlim(xl)
    ylim(yl)
    set(gca,"LineWidth",0.5,"FontSize",Fontsize_num,"TickDir","both")
    hold off
end

%% 2. time evolution of wflux along KA
ax = subplot(length(Date_str),4,2:4:length(Date_str)*4-2);
ax.Position(1) = ax.Position(1)-0.07;
ax.Position(2) = ax.Position(2)+0.025;
ax.Position(4) = ax.Position(4)+0.04;
hold on
% read data
var_str = "W"; % "ZETA";
var_select = "nega"; % "posi"; 
type = "flux";
year = [2017 2018];
var_dep = 400;
lonl_ka = 133;
lonr_ka = 139;
xrange = readmatrix("..\data\JCOPE-T\xrange_for_"+...
                     var_str+"_ka_lon_"+...
                     num2str(lonl_ka)+"_"+...
                     num2str(lonr_ka)+".csv");
z_d = readmatrix("..\data\JCOPE-T\z_d.csv");
var_lyr = find(abs(z_d-var_dep)==min(abs(z_d-var_dep)),1,"first");
Var_KA = [];
for year_i = year
    Var_KA_i = readmatrix("..\data\JCOPE-T\Time_evo_of_"+...
        var_str+"_"+var_select+"_"+type+"_along_ka_from_lon_"+...
        num2str(lonl_ka) + "_to_" + num2str(lonr_ka) + ...
        "_at_depth_" + num2str(z_d(var_lyr)) + "_m" + ...
        "_during_year_" + num2str(year_i) + ".csv");
    Var_KA = cat(1,Var_KA, Var_KA_i);
end
time = Var_KA(:, 1) + (Var_KA(:, 2) - 1) / 12 + Var_KA(:, 3) / 365;
var_line = Var_KA(:, 4 : end);

% time tick
start_date_for_meander = "20170820";
DAY_STR = ["20170101" "20170301" "20170501" ...
           "20170701" "20170901" "20171101" ...
           "20180101" "20180301" "20180501" "20180610" ...
           "20180701" "20180901" "20181101" "20181231" ...
           "20190101" "20190301" "20190501" ...
           "20190701" "20190901" "20191101" ...
           "20200101" "20200301" "20200501" ...
           "20200701" "20200901" "20201101" ...
           "20210101" "20210301" "20210501" ...
           "20210701" "20210901" "20211031"]; 
Highlight_period = ["20180501" "20180610"];
time_index = [];
ticklabel_str = [];
H_period_idx = [];
for i = 1 : size(Var_KA, 1)
    y_str_c = "" + num2str(Var_KA(i, 1),'%04i');
    m_str_c = "" + num2str(Var_KA(i, 2),'%02i');
    d_str_c = "" + num2str(Var_KA(i, 3),'%02i');
    if ~~any(y_str_c + m_str_c + d_str_c == DAY_STR, "all")
        time_index = cat(1, time_index, i);
        if ~isempty(ticklabel_str) && any(1 == contains(ticklabel_str, y_str_c))
            time_str_c = m_str_c + "-" + d_str_c;
        else
            time_str_c = y_str_c + "-" + m_str_c + "-" + d_str_c;
        end
        ticklabel_str = cat(1, ticklabel_str, time_str_c);
    end
    if y_str_c + m_str_c + d_str_c == start_date_for_meander
        start_date_for_meander_idx = i;
    end
    if ~~any(y_str_c + m_str_c + d_str_c == Highlight_period, "all")
        H_period_idx = cat(2,H_period_idx,i);
    end
end

% mesh grid
[LONG, TIME] = meshgrid(xrange, time(time_index(1):time_index(end)));

% abstract data
time_lmin = min(time(time_index(1):time_index(end)));
time_lmax = max(time(time_index(1):time_index(end)));
var_line = var_line((time_index(1):time_index(end)),:);
var_shading = smoothdata(var_line, 'gaussian');
var_shading_str = var_str + "_" + var_select+"_"+type;
[var_shading,var_shading_range,c_shading_range,h_shading_tick,c_shading_map,c_shading_label] = ...
var_range_map(var_shading_str,var_shading);
[var_c, c] = contourf(LONG,TIME,var_shading,var_shading_range);
set(c,'Linestyle','none')
clim(c_shading_range);
colormap(ax,c_shading_map)
h = colorbar("southoutside");
h.Ticks = h_shading_tick;
h.FontSize = 12;
h.Ruler.TickLabelRotation = 0;
h.Position = [ax.Position(1),ax.Position(2)-0.065,ax.Position(3),0.015];
ylabel(h,c_shading_label,...
       'FontSize',14,...
       "LineWidth", 1,...
       "Interpreter","latex");

% dashed line for start date to meander
if exist('start_date_for_meander_idx',"var")
    plot([lonl_ka lonr_ka],...
         [time(start_date_for_meander_idx) time(start_date_for_meander_idx)],...
         "-.r", "LineWidth",1.5)
    text(134.25,time(start_date_for_meander_idx-25),...
         "Start to Meander","FontSize",14,"Color","r")
end
% dashed line for location of Cape Shiono-misaki
Cape_line = 1;
contour_line = 1;
case_line = 0;
case_line_dw = 0;
if var_str == "W"
    shift_east_degree = 0;
elseif var_str == "ZETA"
    shift_east_degree = 0.3;
end

if Cape_line == 1
    yl = ylim(gca);
    plot([135.75 135.75], [yl(1) yl(2)], "k--","LineWidth",1)
end

% contour line
if contour_line == 1
    [~,contour_idx] = sort(abs(h_shading_tick));
    contour_var = h_shading_tick(contour_idx(3));
    case_contour(var_c,contour_var,134.5,138.5,5,'k',1);
    if var_str == "W"
        contour_var = h_shading_tick(contour_idx(2));
        case_contour(var_c,contour_var,134.5,138.5,47,'k',1);
    elseif var_str == "ZETA"
        contour_var = h_shading_tick(contour_idx(4));
        case_contour(var_c,contour_var,135,139,5,'k',1);
    end
end
% case line
if case_line == 1
    [~,contour_idx] = sort(abs(h_shading_tick));
    contour_var = h_shading_tick(contour_idx(2));
    [T_X_Y_STR,T_X_Y_END] = case_dashed_line(Var_KA,var_c,contour_var,'k',1,shift_east_degree);
end
if case_line_dw == 1
    % read data
    dw_lonl = 133;
    dw_lonr = 139;
    dw_str = "W"; % "ZETA";% ["W" "Zeta"]; % ["P_a" "dw_ori"];
    dw_select = "nega"; % "posi"; % ["nega" "posi"];
    dw_type = "flux";
    var_dep = 400;
    z_d = readmatrix("..\data\JCOPE-T\z_d.csv");
    var_lyr = find(abs(z_d-var_dep)==min(abs(z_d-var_dep)),1,"first");
    DW_KA = [];
    for year_i = year
        Var_KA_i = readmatrix("..\data\JCOPE-T\Time_evo_of_"+...
            dw_str+"_"+dw_select+"_"+dw_type+"_along_ka_from_lon_"+...
            num2str(dw_lonl) + "_to_" + num2str(dw_lonr) + ...
            "_at_depth_" + num2str(z_d(var_lyr)) + "_m" + ...
            "_during_year_" + num2str(year_i) + ".csv");
        DW_KA = cat(1,DW_KA, Var_KA_i);
    end
    dw_line = DW_KA(:, 4 : end);
    dw_shading = smoothdata(dw_line, 'gaussian');
    dw_shading_str = dw_str+"_"+dw_select+"_"+dw_type;
    [dw_shading,dw_range,~,h_dw_tick,~,~] = ...
    var_range_map(dw_shading_str,dw_shading);
    dw_xrange = readmatrix("..\data\JCOPE-T\xrange_for_"+dw_str+"_ka_lon_"+num2str(dw_lonl)+"_"+num2str(dw_lonr)+".csv");
    [DW_LONG, DW_TIME] = meshgrid(dw_xrange, time);
    figure
    [dw_c,~] = contourf(DW_LONG,DW_TIME,dw_shading,dw_range);
    close
    [~,dw_contour_idx] = sort(abs(h_dw_tick));
    dw_contour_var = h_dw_tick(dw_contour_idx(2));
    [T_X_Y_STR,T_X_Y_END] = case_dashed_line(DW_KA,...
                            dw_c,dw_contour_var,'k',2,shift_east_degree);
end

% highlight period
xl = xlim(ax);
xl(1) = 134;
fill([xl(1) xl(2) xl(2) xl(1)],...
     [time(H_period_idx(1)),time(H_period_idx(1)),...
      time(H_period_idx(2)),time(H_period_idx(2))],...
      "k", ...
      "FaceAlpha", 0.2, "EdgeColor", "none")

% set axis
xlim(xl)
yl = ylim(ax);
plot(xl, [yl(1) yl(1)], 'k-', 'LineWidth',0.5) % 下边
plot(xl, [yl(2) yl(2)], 'k-', 'LineWidth',0.5) % 上边
plot([xl(1) xl(1)], yl, 'k-', 'LineWidth',0.5) % 左边
plot([xl(2) xl(2)], yl, 'k-', 'LineWidth',0.5) % 右边
yticks(time(time_index))
yticklabels(ticklabel_str)
xlim([134, lonr_ka]);
ylim([time_lmin, time_lmax])
xticks(134:2:139)
xtickformat("%gE")
set(gca,'FontSize',12,"LineWidth", 1,"TickDir","both")

%% 3. snapshots of Zeta
[~,~,~,~,~,~,lonl,lonr,latb,latt] = figure_size("CR_snapshot");
x_t = readmatrix("..\data\JCOPE-T\x_t.csv");
y_t = readmatrix("..\data\JCOPE-T\y_t.csv");
z_d = readmatrix("..\data\JCOPE-T\z_d.csv");
[X,Y] = meshgrid(x_t,y_t);
nx = length(x_t);
ny = length(y_t);
nz = length(z_d);
lyr = find(abs(z_d-400) == min(abs(z_d-400)),1,"first");
Fontsize_num = 12;
Date_str = ["20180610" "20180605" "20180531" ...
            "20180526" "20180521" "20180516" ...
            "20180511" "20180506" "20180501"];
for n = 1 : length(Date_str)
    ax = subplot(length(Date_str),4,n*4-1);
    ax.Position(1) = ax.Position(1)-0.06;
    ax.Position(2) = ax.Position(2)+0.04-0.055/(length(Date_str)-1)*(n-1);
    ax.Position(3) = ax.Position(3)-0.025;
    ax.Position(4) = ax.Position(4)+0.025;
    hold on
    % date
    date = Date_str(n);
    date_str = num2str(str2double(date));
    y_str = date_str(1:4);
    md_str = date_str(5:6)+"/"+date_str(7:8);
    disp(date)
    % read data
    U_var=read_dat_data("..\data\JCOPE-T\U_"+date+"12.dat");
    U_var(U_var>10^10) = nan;
    U = reshape(U_var,nx,ny,nz);
    U_lyr = U(:,:,lyr)';
    V_var=read_dat_data("..\data\JCOPE-T\V_"+date+"12.dat");
    V_var(V_var>10^10) = nan;
    V = reshape(V_var,nx,ny,nz);
    V_lyr = V(:,:,lyr)';
    Var_str = "Zeta";
    Var_var = read_dat_data("..\data\JCOPE-T\"+Var_str+"_"+date+"12.dat");
    Var = reshape(Var_var,nx,ny,nz);
    Var(Var>10^10)=nan;
    Var_shading_lyr = Var(:,:,lyr)';
    % shading
    [Var_shading_lyr,var_shading_range,c_shading_range,h_shading_tick,c_shading_map,c_shading_label] = ...
    var_range_map("Zeta_positive",Var_shading_lyr);
    [~,c] = contourf(X,Y,Var_shading_lyr,var_shading_range);
    set(c,'Linestyle','none');
    clim(c_shading_range);
    colormap(ax,c_shading_map)
    if n == length(Date_str)
        h = colorbar("southoutside");
        h.Ticks = h_shading_tick;
        h.Ruler.TickLabelRotation = 0;
        h.FontSize = 12;
        h.Position = [ax.Position(1),ax.Position(2)-0.025,ax.Position(3),0.015];
        ylabel(h,c_shading_label,"FontSize",14,"FontWeight","bold","Interpreter","latex");
    end
    % topo
    figure
    colorMap = colormap("gray");
    close
    Plot_topo(x_t,y_t,z_d,U,[3000,2000,1000],colorMap);
    Plot_topo_land(x_t,y_t,U);
    % horizontal velocity
    res = 20;
    U_lyr_t = omit_rc_idx(U_lyr,1:res:length(y_t),1:res:length(x_t));
    V_lyr_t = omit_rc_idx(V_lyr,1:res:length(y_t),1:res:length(x_t));
    quiver(X,Y,U_lyr_t,V_lyr_t,0,'Color',[0.4 0.4 0.4],'LineWidth',0.01);
    % Kuroshio axis
    Plot_Kuroshio_axis(x_t,y_t,T_lyr,"r",4)
    % Location of Cape Shiono-misaki
    plot(lon_cape,lat_cape,...
         "Marker","o",...
         "Color","g",...
         "MarkerSize",4,...
         "MarkerFaceColor","g")
    % set axis
    set(ax,'XTickLabel',[],'XTick',lonl:1:lonr,'YTick',latb:1:latt,'TickDir','both')
    set(ax,'YTickLabel',[],'XTick',lonl:1:lonr,'YTick',latb:1:latt,'TickDir','both')
    xl = [lonl lonr];
    yl = [latb latt];
    plot(xl, [yl(1) yl(1)],'k-','LineWidth',0.5) % 下边
    plot(xl, [yl(2) yl(2)],'k-','LineWidth',0.5) % 上边
    plot([xl(1) xl(1)], yl,'k-','LineWidth',0.5) % 左边
    plot([xl(2) xl(2)], yl,'k-','LineWidth',0.5) % 右边
    text(135.3,34.1,"Kii","FontSize",10,"Color","w")
    text(lonl+0.15,latb+0.55,md_str,"FontSize",12,"Color","k")
    xlim(xl)
    ylim(yl)
    set(gca,"LineWidth",0.5,"FontSize",Fontsize_num,"TickDir","both")
    hold off
end

%% 4. time evolution of zeta flux along KA
ax = subplot(length(Date_str),4,4:4:length(Date_str)*4);
ax.Position(1) = ax.Position(1)-0.03;
ax.Position(2) = ax.Position(2)+0.025;
ax.Position(4) = ax.Position(4)+0.04;
hold on
% read data
var_str = "ZETA";
var_select = "posi"; 
type = "flux";
year = [2017 2018];
var_dep = 400;
lonl_ka = 133;
lonr_ka = 139;
xrange = readmatrix("..\data\JCOPE-T\xrange_for_"+...
                     var_str+"_ka_lon_"+...
                     num2str(lonl_ka)+"_"+...
                     num2str(lonr_ka)+".csv");
z_d = readmatrix("Results\Data\z_d.csv");
var_lyr = find(abs(z_d-var_dep)==min(abs(z_d-var_dep)),1,"first");
Var_KA = [];
for year_i = year
    Var_KA_i = readmatrix("..\data\JCOPE-T\Time_evo_of_"+...
        var_str+"_"+var_select+"_"+type+"_along_ka_from_lon_"+...
        num2str(lonl_ka) + "_to_" + num2str(lonr_ka) + ...
        "_at_depth_" + num2str(z_d(var_lyr)) + "_m" + ...
        "_during_year_" + num2str(year_i) + ".csv");
    Var_KA = cat(1,Var_KA, Var_KA_i);
end
time = Var_KA(:, 1) + (Var_KA(:, 2) - 1) / 12 + Var_KA(:, 3) / 365;
var_line = Var_KA(:, 4 : end);

% time tick
start_date_for_meander = "20170820";
DAY_STR = ["20170101" "20170301" "20170501" ...
           "20170701" "20170901" "20171101" ...
           "20180101" "20180301" "20180501" "20180610" ...
           "20180701" "20180901" "20181101" "20181231" ...
           "20190101" "20190301" "20190501" ...
           "20190701" "20190901" "20191101" ...
           "20200101" "20200301" "20200501" ...
           "20200701" "20200901" "20201101" ...
           "20210101" "20210301" "20210501" ...
           "20210701" "20210901" "20211031"]; 
Highlight_period = ["20180501" "20180610"];
time_index = [];
ticklabel_str = [];
H_period_idx = [];
for i = 1 : size(Var_KA, 1)
    y_str_c = "" + num2str(Var_KA(i, 1),'%04i');
    m_str_c = "" + num2str(Var_KA(i, 2),'%02i');
    d_str_c = "" + num2str(Var_KA(i, 3),'%02i');
    if ~~any(y_str_c + m_str_c + d_str_c == DAY_STR, "all")
        time_index = cat(1, time_index, i);
        if ~isempty(ticklabel_str) && any(1 == contains(ticklabel_str, y_str_c))
            time_str_c = m_str_c + "-" + d_str_c;
        else
            time_str_c = y_str_c + "-" + m_str_c + "-" + d_str_c;
        end
        ticklabel_str = cat(1, ticklabel_str, time_str_c);
    end
    if y_str_c + m_str_c + d_str_c == start_date_for_meander
        start_date_for_meander_idx = i;
    end
    if ~~any(y_str_c + m_str_c + d_str_c == Highlight_period, "all")
        H_period_idx = cat(2,H_period_idx,i);
    end
end

% mesh grid
[LONG, TIME] = meshgrid(xrange, time(time_index(1):time_index(end)));

% abstract data
time_lmin = min(time(time_index(1):time_index(end)));
time_lmax = max(time(time_index(1):time_index(end)));
var_line = var_line((time_index(1):time_index(end)),:);
var_shading = smoothdata(var_line, 'gaussian');

% shading
var_shading_str = var_str + "_" + var_select+"_"+type;
[var_shading,var_shading_range,c_shading_range,h_shading_tick,c_shading_map,c_shading_label] = ...
var_range_map(var_shading_str,var_shading);
[var_c, c] = contourf(LONG,TIME,var_shading,var_shading_range);
set(c,'Linestyle','none')
clim(c_shading_range);
colormap(ax,c_shading_map)
h = colorbar("southoutside");
h.Ticks = h_shading_tick;
h.FontSize = 12;
h.Ruler.TickLabelRotation = 0;
h.Position = [ax.Position(1),ax.Position(2)-0.065,ax.Position(3),0.015];
ylabel(h,c_shading_label,'FontSize',14,"LineWidth", 1,"Interpreter","latex");

% dashed line for start date to meander
if exist('start_date_for_meander_idx',"var")
    plot([lonl_ka lonr_ka],...
         [time(start_date_for_meander_idx) time(start_date_for_meander_idx)],...
         "-.r", "LineWidth",1.5)
    text(134.25,time(start_date_for_meander_idx-25),...
         "Start to Meander","FontSize",14,"Color","r")
end
% dashed line for location of Cape Shiono-misaki
Cape_line = 1;
contour_line = 1;
case_line = 0;
case_line_dw = 0;
if var_str == "W"
    shift_east_degree = 0;
elseif var_str == "ZETA"
    shift_east_degree = 0.3;
end

if Cape_line == 1
    yl = ylim(gca);
    plot([135.75 135.75], [yl(1) yl(2)], "k--","LineWidth",1)
end

% contour line
if contour_line == 1
    [~,contour_idx] = sort(abs(h_shading_tick));
    contour_var = h_shading_tick(contour_idx(3));
    if var_str == "W"
        case_contour(var_c,contour_var,134.5,138.5,5,'k',1);
        contour_var = h_shading_tick(contour_idx(2));
        case_contour(var_c,contour_var,134.5,138.5,47,'k',1);
    elseif var_str == "ZETA"
        case_contour(var_c,contour_var,135,138.5,5,'k',1);
        contour_var = h_shading_tick(contour_idx(4));
        case_contour(var_c,contour_var,135.5,139,5,'k',1);
    end
end
% case line
if case_line == 1
    [~,contour_idx] = sort(abs(h_shading_tick));
    contour_var = h_shading_tick(contour_idx(2));
    [T_X_Y_STR,T_X_Y_END] = case_dashed_line(Var_KA,var_c,contour_var,'k',1,shift_east_degree);
end
if case_line_dw == 1
    % read data
    dw_lonl = 133;
    dw_lonr = 139;
    dw_str = "W"; % "ZETA";% ["W" "Zeta"]; % ["P_a" "dw_ori"];
    dw_select = "nega"; % "posi"; % ["nega" "posi"];
    dw_type = "flux";
    var_dep = 400;
    z_d = readmatrix("..\data\JCOPE-T\z_d.csv");
    var_lyr = find(abs(z_d-var_dep)==min(abs(z_d-var_dep)),1,"first");
    DW_KA = [];
    for year_i = year
        Var_KA_i = readmatrix("..\data\JCOPE-T\Time_evo_of_"+...
            dw_str+"_"+dw_select+"_"+dw_type+"_along_ka_from_lon_"+...
            num2str(dw_lonl) + "_to_" + num2str(dw_lonr) + ...
            "_at_depth_" + num2str(z_d(var_lyr)) + "_m" + ...
            "_during_year_" + num2str(year_i) + ".csv");
        DW_KA = cat(1,DW_KA, Var_KA_i);
    end
    dw_line = DW_KA(:, 4 : end);
    dw_shading = smoothdata(dw_line, 'gaussian');
    dw_shading_str = dw_str+"_"+dw_select+"_"+dw_type;
    [dw_shading,dw_range,~,h_dw_tick,~,~] = ...
    var_range_map(dw_shading_str,dw_shading);
    dw_xrange = readmatrix("..\data\JCOPE-T\xrange_for_"+dw_str+"_ka_lon_"+num2str(dw_lonl)+"_"+num2str(dw_lonr)+".csv");
    [DW_LONG, DW_TIME] = meshgrid(dw_xrange, time);
    figure
    [dw_c,~] = contourf(DW_LONG,DW_TIME,dw_shading,dw_range);
    close
    [~,dw_contour_idx] = sort(abs(h_dw_tick));
    dw_contour_var = h_dw_tick(dw_contour_idx(2));
    [T_X_Y_STR,T_X_Y_END] = case_dashed_line(DW_KA,...
                            dw_c,dw_contour_var,'k',2,shift_east_degree);
end

% highlight period
xl = xlim(ax);
xl(1) = 134;
fill([xl(1) xl(2) xl(2) xl(1)],...
     [time(H_period_idx(1)),time(H_period_idx(1)),...
      time(H_period_idx(2)),time(H_period_idx(2))],...
      "k", ...
      "FaceAlpha", 0.2, "EdgeColor", "none")

% set axis
xlim(xl)
yl = ylim(ax);
plot(xl, [yl(1) yl(1)], 'k-', 'LineWidth',0.5) % 下边
plot(xl, [yl(2) yl(2)], 'k-', 'LineWidth',0.5) % 上边
plot([xl(1) xl(1)], yl, 'k-', 'LineWidth',0.5) % 左边
plot([xl(2) xl(2)], yl, 'k-', 'LineWidth',0.5) % 右边
yticks(time(time_index))
yticklabels(ticklabel_str)
xlim([134, lonr_ka]);
ylim([time_lmin, time_lmax])
xticks(134:2:139)
xtickformat("%gE")
set(gca,'FontSize',12,"LineWidth", 1,"TickDir","both")
%% SAVE
saveas(gcf,"..\figure\Figure_6.jpg")