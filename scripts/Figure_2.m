clc;
clear;

figure;
set(gcf, 'units', 'centimeters', 'position', [1, 1, 22, 15]);

%% 1. SOUTHERNMOST LOCATION
ax1 = subplot(2,1,1);
hold on
% read data
SOUTHEST_JMA = readtable("G:\JMA_data\Monthly latitude of the Kuroshio axis between 136 to 140.txt");
% 2. transform txt to matrix (JMA)
Time = [];
for i = 1 : height(SOUTHEST_JMA)
    time_table = SOUTHEST_JMA(i, "Var1");
    time_array = table2array(time_table);
    time_matri = cell2mat(time_array);
    time_year = str2double(time_matri(1:4));
    time_month = str2double(time_matri(6:7));
    Time = cat(1, Time, [time_year, time_month]);
end
Lat_table = SOUTHEST_JMA(:, "Var2");
Lat = table2array(Lat_table);
Lat_JMA = [Time, Lat];


% 3. plot
x_time = Lat_JMA(:, 1) + (Lat_JMA(:, 2)-1)/12;
y_lat = Lat_JMA(:, 3);
y_lat_mov = movmean(y_lat,13,"omitnan");
plot(x_time, y_lat, 'LineWidth', 1, 'Color', 'R', 'LineStyle', '-')
plot(x_time,y_lat_mov, 'LineWidth', 3, 'Color', 'k', 'LineStyle', '-')
ylim([29 34])
xlim([1960, 2025])
xticks(1960:5:2025)
xticklabels("auto")
xlabel("Year")
ylabel("Latitude (°N)")
set(gca, 'FontSize', 12)
set(gca, "LineWidth", 1)
t = title("JMA Southernmost latitude of the Kuroshio between 136°E and 140°E");
t.Position(2) = t.Position(2)+0.01;
grid on
set(gca,"GridLineStyle","--")

% mark Kuroshio LM period
[lm_r,lm_c] = find(y_lat_mov < 31.8);
d_lm_r = diff(lm_r);
[d_r,d_c] = find(d_lm_r ~= 1);
d_r = cat(1,0,d_r,length(lm_r));
for i = 1 : length(d_r) - 1
    sec_l_idx = d_r(i) + 1;
    sec_r_idx = d_r(i + 1);
    sec_l = lm_r(sec_l_idx);
    sec_r = lm_r(sec_r_idx);
    hold on
    fill([x_time(sec_l),x_time(sec_r),x_time(sec_r),x_time(sec_l)], ...
         [29,29,34,34],[42,95,255]/255, ...
         "FaceAlpha", 0.3, "EdgeColor", "none")
end
xl=xlim;
yl=ylim;
text(xl(1)+(xl(2)-xl(1))/20,yl(1)+(yl(2)-yl(1))/10,"a.","FontSize",24,"FontWeight","bold")
hold off

%% 2. SEA LEVEL DIFFERENCE
ax2 = subplot(2,1,2);
hold on
ssh_diff_jma = readtable("G:\JMA_data\Sea surface difference between Kushimoto and Uragami.txt");
Time = [];
for i = 1 : height(ssh_diff_jma)
    time_table = ssh_diff_jma(i, "Var1");
    time_array = table2array(time_table);
    time_matri = cell2mat(time_array);
    time_year = str2double(time_matri(1:4));
    time_month = str2double(time_matri(6:7));
    Time = cat(1, Time, [time_year, time_month]);
end
ssh_diff_table = ssh_diff_jma(:, "Var2");
ssh_diff_array = table2array(ssh_diff_table);
ssh_diff_jma = [Time, ssh_diff_array];
x_time_jma = ssh_diff_jma(:, 1) + (ssh_diff_jma(:, 2) - 1) / 12;
y_ssh_diff_jma = ssh_diff_jma(:, 3)/100;
y_ssh_diff_jma_mov = movmean(y_ssh_diff_jma,13,"omitnan");

% plot
plot(x_time_jma, y_ssh_diff_jma, 'LineWidth', 1, 'Color', 'R', 'LineStyle', '-')
plot(x_time_jma,y_ssh_diff_jma_mov, 'LineWidth', 3, 'Color', 'k', 'LineStyle', '-')
% ylim([29 34])
xlim([1960, 2025])
xticks(1960:5:2025)
xticklabels("auto")
xlabel("Year")
ylabel("SSH_K_u_s_h_i_m_o_t_o - SSH_U_r_a_g_a_m_i (m)")
set(gca, 'FontSize', 12)
set(gca, "LineWidth", 1)
t = title("JMA Sea Level Difference between Kushimoto and Uragami Tide Gauge Station (m)");
t.Position(2) = t.Position(2)+0.01;
grid on
set(gca,"GridLineStyle","--")

% mark Kuroshio LM period
[lm_r,lm_c] = find(y_lat_mov < 31.8);
d_lm_r = diff(lm_r);
[d_r,d_c] = find(d_lm_r ~= 1);
d_r = cat(1,0,d_r,length(lm_r));
for i = 1 : length(d_r) - 1
    sec_l_idx = d_r(i) + 1;
    sec_r_idx = d_r(i + 1);
    sec_l = lm_r(sec_l_idx);
    sec_r = lm_r(sec_r_idx);
    hold on
    fill([x_time(sec_l),x_time(sec_r),x_time(sec_r),x_time(sec_l)], ...
         [0,0,0.4,0.4],[42,95,255]/255, ...
         "FaceAlpha", 0.3, "EdgeColor", "none")
end
ylim([0 0.4])
xl=xlim;
yl=ylim;
text(xl(1)+(xl(2)-xl(1))/20,yl(1)+(yl(2)-yl(1))/10,"b.","FontSize",24,"FontWeight","bold")
%% save figure
% saveas(gcf, "Results\Figure\I_Paper\Figure_1_2.jpg")