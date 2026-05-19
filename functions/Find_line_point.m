function [theta_d,xrange,yrange,X_V,Z_D] = Find_line_point(Var_str,t_strc)

x_t = readmatrix("..\data\JCOPE-T\x_t.csv");
y_t = readmatrix("..\data\JCOPE-T\y_t.csv");
z_d = readmatrix("..\data\JCOPE-T\z_d.csv") * 10^-3; % km

[theta_d,xmin_degree,xmax_degree,ymin_degree] = K_line_parameter(t_strc,Var_str);
k = tan(theta_d/180*pi); % line slope
xmin_index = find(abs(x_t - xmin_degree) == min(abs(x_t - xmin_degree)));
xmax_index = find(abs(x_t - xmax_degree) == min(abs(x_t - xmax_degree)));
ymin_index = find(abs(y_t - ymin_degree) == min(abs(y_t - ymin_degree)));
ymin = y_t(ymin_index(1));
xrange = x_t(xmin_index(1) : xmax_index(1));
yrange = ymin;
yi_degree = ymin;
for i = 2 : length(xrange)
    dxi = xrange(i) - xrange(i-1);
    dyi = k * dxi;
    yi_degree = yi_degree + dyi;
    yi_index = find(abs(y_t - yi_degree) == min(abs(y_t - yi_degree)));
    yi = y_t(yi_index(1));
    yrange = cat(2, yrange, yi);
end
[X_V, Z_D] = meshgrid(xrange, -z_d);
