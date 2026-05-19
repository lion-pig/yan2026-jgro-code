clc;
clear;

T_degree = 15;
Southest = 1;

t_ys = 2015;
t_ms = 1;
t_ds = 1;
t_ye = 2021;
t_me = 10;
t_de = 31;
total_day = num_of_day(t_ys,t_ms,t_ds,t_ye,t_me,t_de);
disp("total_day : " + num2str(total_day))
DT = 1:total_day;
for dt = DT
    [t_dc,t_mc,t_yc,t_strc] = time_str(t_ds,t_ms,t_ys,dt-1);
    disp("t_strc : " + t_strc)
    % read data
    KA = readmatrix("KA\ka_" + t_strc + ".csv"); 
    lon = KA(1, :);
    lat = KA(2, :);
    % select contour line in the south coast of Japan
    nan_index = find(isnan(KA(1, :)));
    len = cat(2, nan_index(1)-1, diff(nan_index)-1);
    len_index = find(len > 100);
    KA_new = [];
    for i = 1 : length(len_index)
        if len_index(i) == 1
            KA_i = KA(:, 1: nan_index(1)-1);
        else
            KA_i = KA(:, nan_index(len_index(i)-1)+1 : nan_index(len_index(i))-1);
        end
        KA_check = KA_i(:, KA_i(1,:)>137 & KA_i(1,:)<139);
        if ~isempty(KA_check)
            KA_i = fliplr(KA_i);
            KA_new = cat(2, KA_new, KA_i);
        end
    end
    lon_new = KA_new(1, :);
    lat_new = KA_new(2, :);
    % FIND SOUTHEST POINT between 136 and 140
    lon_south = lon_new(lon_new>=136 & lon_new<=140);
    lat_south = lat_new(lon_new>=136 & lon_new<=140);
    lat_southest = min(lat_south);
    lat_southest_index = find(lat_south == lat_southest);
    lon_southest = lon_south(lat_southest_index);
    % check
    hold on
    plot(lon_southest, lat_southest, 'r*')
    % record
    SOUTHEST = cat(1, SOUTHEST, [y, m, d, lon_southest, lat_southest]);
end

% SAVE DATA
writematrix(SOUTHEST, "JCOPET_southern_most_location_of_KA_from_136E_to_140E_20150101_20211031.csv");