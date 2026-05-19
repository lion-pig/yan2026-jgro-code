clc;
clear;

disp("find Kuroshio Axis (15°C contour at 200m)")
t_degree = 15;

% READ GRID DATA
x_t = readmatrix("x_t.csv");
y_t = readmatrix("y_t.csv");
[X_T, Y_T] = meshgrid(x_t, y_t);
z_d = readmatrix("z_d.csv");
nx = length(x_t);
ny = length(y_t);
nz = length(z_d);

% READ NODE DATA
k_t = 15; % 20; % 
disp("for depth k_t = " + num2str(z_d(k_t)))

% PLOT
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
    T_filename = "T_" + t_strc + "12.dat";
    % read data
    T_var = read_dat_data(T_filename);
    T_var(T_var > 1*10^20) = nan;
    T = reshape(T_var,nx,ny,nz);
    T_lyr = T(:,:,k_t)';
    % deal with temperature
    figure
    [M_T,~] = contour(X_T, Y_T, T_lyr, 10:1:20);
    close;
    M_i = 1;
    ka_t = [];
    while M_i <= size(M_T, 2)
        M_ii = M_i + M_T(2, M_i);
        value = M_T(1, M_i);
        x_tem = M_T(1, M_i+1 : M_ii);
        y_tem = M_T(2, M_i+1 : M_ii);
        if value == t_degree
            ka_t = cat(2, ka_t, M_T(:, M_i+1 : M_ii), ones(2, 1)*nan);
        end   
        M_i = M_ii+1;
    end
    disp("    -- save axis data")
    writematrix(ka_t, "KA\ka_" + t_strc + ".csv");
end
