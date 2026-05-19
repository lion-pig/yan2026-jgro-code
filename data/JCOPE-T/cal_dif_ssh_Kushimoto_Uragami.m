clc;
clear;
% 0. parameter
K_lon = 135.736; % 135+47/60;
K_lat = 33.4583; % 33+28/60;
U_lon = 135.958; % 135+55/60;
U_lat = 33.5694; % 33+34/60;

% 1. find location of Kushimoto & Uragami
x_t = readmatrix("x_t.csv");
y_t = readmatrix("y_t.csv");
nx = length(x_t);
ny = length(y_t);
[X_T, Y_T] = meshgrid(x_t, y_t);
K_lon_index = find(abs(x_t - K_lon) == min(abs(x_t - K_lon)), 1, "first");
K_lat_index = find(abs(y_t - K_lat) == min(abs(y_t - K_lat)), 1, "first");
U_lon_index = find(abs(x_t - U_lon) == min(abs(x_t - U_lon)), 1, "first");
U_lat_index = find(abs(y_t - U_lat) == min(abs(y_t - U_lat)), 1, "first");

K_lon_t = x_t(K_lon_index);
K_lat_t = y_t(K_lat_index);
U_lon_t = x_t(U_lon_index);
U_lat_t = y_t(U_lat_index);

% 2. read ssh data
t_ys = 2020;
t_ms = 2;
t_ds = 29;
t_ye = 2020;
t_me = 2;
t_de = 29;
total_day = num_of_day(t_ys,t_ms,t_ds,t_ye,t_me,t_de);
DT = 1:total_day;
for dt = DT
    [~,~,t_yc,t_strc] = time_str(t_ds,t_ms,t_ys,dt-1);    
    disp(t_strc)
    SSH_fileID = fopen("EL_" + t_strc + "12.dat");
    SSH_var = fread(SSH_fileID, 'single', 'b');
    SSH_var(SSH_var > 10^20) = nan;
    SSH = reshape(SSH_var, nx, ny)';
    % abstract ssh data 
    k_ssh = SSH(y_t == K_lat_t, x_t == K_lon_t);
    u_ssh = SSH(y_t == U_lat_t, x_t == U_lon_t);
    K_ssh = cat(1, K_ssh, [y, m, d, k_ssh]);
    U_ssh = cat(1, U_ssh, [y, m, d, u_ssh]);
    fclose('all');
end

% save data
writematrix(K_ssh, "Kushimoto_ssh.csv");
writematrix(U_ssh, "Uragami_ssh.csv");