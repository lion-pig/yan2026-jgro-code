clc;
clear;

disp(" calculate relative vorticity")
% period
t_ys = 2019;
t_ms = 1;
t_ds = 1;
t_ye = 2019;
t_me = 12;
t_de = 31;

% READ GRID DATA
x_t = readmatrix("x_t.csv");
y_t = readmatrix("y_t.csv");
z_d = readmatrix("z_d.csv");
[X_T, Y_T] = meshgrid(x_t, y_t);
nx = length(x_t);
ny = length(y_t);
nz = length(z_d);

% READ DX AND DY DATA FOR CALCULATING RELATIVE VORTICITY
R = 6371000;
dX = (x_t(2) - x_t(1))/360*2*pi*R*cos(Y_T/180*pi)';
DX = repmat(dX, [1,1,nz]);
dy = (y_t(2) - y_t(1))/360*2*pi*R;

day_num = num_of_day(t_ys, t_ms, t_ds, t_ye, t_me, t_de);
disp("number of days : " + num2str(day_num))

DAY = 1 : day_num;

for day = DAY

    [t_dc, t_mc, t_yc, t_strc] = time_str(t_ds, t_ms, t_ys, day-1);
    disp("Day present: " + t_strc)

    % read data
    U_var = read_dat_data("U_" + t_strc + "12.dat");
    V_var = read_dat_data("V_" + t_strc + "12.dat");
    U = reshape(U_var, nx, ny, nz);
    V = reshape(V_var, nx, ny, nz);
    U(U > 1*10^10) = nan;
    V(V > 1*10^10) = nan;
    
    % calculate zeta
    dVdx = V*nan;
    dVdx(2:end,:,:) = (V(2:end,:,:)-V(1:end-1,:,:))./dX(1:end-1,:,:);
    dUdy = U*nan;
    dUdy(:,2:end,:) = (U(:,2:end,:)-U(:,1:end-1,:))/dy;
    zeta = dVdx - dUdy;

    % save data
    save_dat_data(zeta,"ZETA_"+t_strc+"12.dat")

end