clc;
clear;

%% set figure
figure
set(gcf,"Units","centimeters","Position",[1,1,22,20]);

%% 1. Southernmost location of KA from 136E TO 140E
ax1 = subplot(2,1,1);
ax1.Position(2)=ax1.Position(2)-0.01;
hold on

% 1.1 read data 
SOUTHEST_JCOPET = readmatrix("..\data\JCOPE-T\JCOPET_southern_most_location_of_KA_from_136E_to_140E_20150101_20211031.csv");
SOUTHEST_JMA = readtable("..\data\JMA\Monthly latitude of the Kuroshio axis between 136 to 140.txt");

% 1.2 transform txt to matrix (JMA)
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
x_time_jma = Lat_JMA(:, 1) + (Lat_JMA(:, 2)-1)/12;
y_lat_jma = Lat_JMA(:, 3);

% 1.3 calculate monthly-mean latitude (JCOPE-T)
J_D = SOUTHEST_JCOPET;
Lat_m_ave = [];
for y = 2015 : 2021
    for m = 1 : 12
        lat_m = J_D(J_D(:, 1) == y & J_D(:, 2) == m, 5);
        lat_ave = mean(lat_m);
        Lat_m_ave = cat(1, Lat_m_ave, [y, m, lat_ave]);
    end
end
x_time_jcopet = Lat_m_ave(:, 1) + (Lat_m_ave(:, 2)-1)/12;
y_lat_jcopet = Lat_m_ave(:, 3);

% 1.4 calculate correlation coefficient
lat_jcopet = Lat_m_ave;
lat_jma = Lat_JMA(Lat_JMA(:, 1) >= 2015 & Lat_JMA(:, 1)<=2021, :);
A = [lat_jma(:, 3), lat_jcopet(:, 3)];
A = A(~isnan(A(:,2)),:);
R = corrcoef(A,'Alpha',0.01, 'Rows','complete');

% 1.5 plot
plot(x_time_jma, y_lat_jma, 'LineWidth', 2, 'Color', 'k', 'LineStyle', '--')
plot(x_time_jcopet, y_lat_jcopet, 'LineWidth', 2, 'Color', 'k', 'LineStyle', '-')

% 1.6 hightlight LM period : 2017/9-2021/10
fill([2017+8/12,x_time_jma(end),x_time_jma(end),2017+8/12], ...
     [28,28,36,36],...
     "k","FaceAlpha", 0.2,"EdgeColor", "none")

% 1.7 set axis
xlim([2015, x_time_jcopet(end)])
ylim([28 36])
xl = xlim;
yl = ylim;
plot(xl, [yl(2) yl(2)], 'k-', 'LineWidth',2) % 上边
plot([xl(2) xl(2)], yl, 'k-', 'LineWidth',2) % 右边
lg = legend(["Observation (JMA)", "Simulation (JCOPE-T)" "" ""]);
lg.Position(1) = lg.Position(1)-0.04;
lg.Position(2) = lg.Position(2)-0.04;
lg.Position(4) = lg.Position(4)+0.04;
xTick = 2015:2021;
yTick = 28:36;
xTickLabel = strings(1,length(xTick));
yTickLabel = strings(1,length(yTick));
xTickLabel(1:end) = string(xTick);
yTickLabel(2:2:end) = string(yTick(2:2:end))+"N";
xticks(xTick)
yticks(yTick)
xticklabels(xTickLabel);
yticklabels(yTickLabel);
xlabel("Year")
ylabel("Latitude")
text(xl(1)+(xl(2)-xl(1))/10,yl(1)+(yl(2)-yl(1))/10,...
     "Correlation coefficient : "+string(R(1,2)*100)+"% with 99% confidence",...
     "FontSize",12);
text(xl(1)+(xl(2)-xl(1))/30,yl(1)+(yl(2)-yl(1))/10,...
     "a.","FontSize",22,"FontWeight","bold")
t1 = title("Southernmost location (°N) of the Kuroshio Axis from 136°E to 140°E");
t1.Position(2) = yl(2)+(yl(2)-yl(1))/25;
set(gca,"LineWidth",2,'FontSize',14,"TickDir","both")
hold off

%% 2. Sea surface difference between Kushimoto and Uragami
ax2 = subplot(2,1,2);
ax2.Position(2) = ax2.Position(2)-0.02;
hold on

% 2.1 transform txt to matrix (JMA)
ssh_diff_jma = readtable("..\data\JMA\Sea surface difference between Kushimoto and Uragami.txt");
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

% 2.2 calculate monthly-mean ssh_diff (JCOPE-T)
ssh_K_jcopet = readmatrix("..\data\JCOPE-T\Kushimoto_ssh.csv");
ssh_U_jcopet = readmatrix("..\data\JCOPE-T\Uragami_ssh.csv");
ssh_jcopet = [ssh_K_jcopet(:, 1 : 3), ssh_K_jcopet(:, 4) - ssh_U_jcopet(:, 4)];
J_D = ssh_jcopet;
ssh_diff_m_ave = [];
for y = 2015 : 2021
    for m = 1 : 12
        ssh_diff_m = J_D(J_D(:, 1) == y & J_D(:, 2) == m, 4);
        ssh_diff_ave = mean(ssh_diff_m);
        ssh_diff_m_ave = cat(1, ssh_diff_m_ave, [y, m, ssh_diff_ave]);
    end
end
x_time_jcopet = ssh_diff_m_ave(:, 1) + (ssh_diff_m_ave(:, 2) - 1)/12;
y_ssh_diff_jcopet = ssh_diff_m_ave(:, 3);

% 2.3 calculate correlation coefficient
ssh_jcopet = ssh_diff_m_ave*100;
ssh_jma = ssh_diff_jma(ssh_diff_jma(:, 1) >= 2015 & ssh_diff_jma(:, 1)<=2021, :);
A = [ssh_jma(:, 3), ssh_jcopet(:, 3)];
A = A(~isnan(A(:,2)),:);
R = corrcoef(A,'Alpha',0.01, 'Rows','complete');

% 2.4 plot
plot(x_time_jma, y_ssh_diff_jma, "Color", "K", "LineWidth", 2, 'LineStyle', '--')
plot(x_time_jcopet, y_ssh_diff_jcopet, 'Color', "k", "LineWidth", 2, "LineStyle", "-")

% 2.5 hightlight LM period : 2017/9-2021/10
fill([2017+8/12,x_time_jma(end),x_time_jma(end),2017+8/12], ...
     [-0.1,-0.1,0.3,0.3],...
     "k","FaceAlpha", 0.2,"EdgeColor", "none")

% 2.5 set axis
xlim([2015, x_time_jcopet(end)])
ylim([-0.1 0.3])
xl = xlim;
yl = ylim;
plot(xl, [yl(2) yl(2)], 'k-', 'LineWidth',2) % 上边
plot([xl(2) xl(2)], yl, 'k-', 'LineWidth',2) % 右边
lg = legend(["Observation (JMA)", "Simulation (JCOPE-T)" "" ""]);
lg.Position(1) = lg.Position(1)-0.04;
lg.Position(2) = lg.Position(2)-0.04;
lg.Position(4) = lg.Position(4)+0.04;
xTick = 2015:2021;
xTickLabel = strings(1,length(xTick));
xTickLabel(1:end) = string(xTick);
xticks(xTick)
xticklabels(xTickLabel);
xlabel("Year")
ylabel("SSH_K_u_s_h_i_m_o_t_o - SSH_U_r_a_g_a_m_i (m)")
text(xl(1)+(xl(2)-xl(1))/10,yl(1)+(yl(2)-yl(1))/10,...
     "Correlation coefficient : "+string(R(1,2)*100)+"% with 99% confidence",...
     "FontSize",12);
text(xl(1)+(xl(2)-xl(1))/30,yl(1)+(yl(2)-yl(1))/10,...
     "b.","FontSize",22,"FontWeight","bold")
t2= title("Sea surface difference (m) between Kushimoto and Uragami tide gauge stations");
t2.Position(2) = yl(2)+(yl(2)-yl(1))/20;
set(gca,"LineWidth",2,'FontSize',14,"TickDir","both")
hold off


% save figure
saveas(gcf,"..\figure\Figure_4.jpg")