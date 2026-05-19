clc;
clear;

Var_str = "W";
lonl = 135;
lonr = 136;
latb = 32;
latt = 33;
t_strc = '20180501';

disp("calculate "+Var_str+" on "+t_strc+" average in region from "+lonl+"°E to "+lonr+"°E, from "+latb+"°N to "+latt+"°N in each layer")

% READ GRID DATA
x_t = readmatrix("x_t.csv");
y_t = readmatrix("y_t.csv");
z_d = readmatrix("z_d.csv");
nx = length(x_t);
ny = length(y_t);
nz = length(z_d);

% READ VAR
Var_var = read_dat_data(Var_str+"_"+t_strc+"12.dat");
Var = reshape(Var_var,nx,ny,nz);
Var(Var>1*10^20) = nan;

% ABSTRACT VAR IN REGION
lonl_idx = find(abs(x_t-lonl)==min(abs(x_t-lonl)),1,"first");
lonr_idx = find(abs(x_t-lonr)==min(abs(x_t-lonr)),1,"first");
latb_idx = find(abs(y_t-latb)==min(abs(y_t-latb)),1,"first");
latt_idx = find(abs(y_t-latt)==min(abs(y_t-latt)),1,"first");
Var_region = Var(lonl_idx:lonr_idx,latb_idx:latt_idx,:);

% CALCULATE VAR AVERAGED IN REGION in each layer
Var_ave = mean(Var_region,[1,2],"omitmissing");
Var_ave = reshape(Var_ave,1,nz);

% SAVE 
writematrix(Var_ave,Var_str+"_regional_ave_on_"+t_strc+"_in_"+lonl+"_"+lonr+"_"+latb+"_"+latt+".csv");
