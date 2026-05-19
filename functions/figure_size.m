function [fh,fw,ax,ay,ah,aw,lonl,lonr,latb,latt] = figure_size(Domain)
if Domain == "WR"
    % Whole Domain
    lonl = 130;
    lonr = 142;
    latb = 28.5;
    latt = 36;
    rate = 2;
    ax = 0.1;
    ay = 0.1;
    ah = 0.75;
    aw = 0.8;
elseif Domain == "WR_paper"
    lonl = 130;
    lonr = 141;
    latb = 28;
    latt = 36;
    rate = 2;
    ax = 0.1;
    ay = 0.1;
    ah = 0.75;
    aw = 0.8;
elseif Domain == "CR_paper"
    % Coastal Domain
    lonl = 134; % 134.5;
    lonr = 140; % 140;
    latb = 31;
    latt = 35;
    rate = 3;
    ax = 0.2;
    ay = 0.2;
    aw = 0.65;
    ah = 0.65;
elseif Domain == "CR_snapshot"
    % Coastal Domain
    lonl = 133.5; % 134.5;
    lonr = 140; % 140;
    latb = 30;
    latt = 35;
    rate = 3;
    ax = 0.2;
    ay = 0.2;
    aw = 0.65;
    ah = 0.65;
elseif Domain == "CR"
    % Coastal Domain
    lonl = 134.5; % 134.5;
    lonr = 140; % 140;
    latb = 29.5;
    latt = 35;
    rate = 3;
    ax = 0.15;
    ay = 0.15;
    aw = 0.75;
    ah = 0.7;
elseif Domain == "DW"
    % Coastal Domain
    lonl = 135;
    lonr = 136;
    latb = 32;
    latt = 33;
    rate = 14;
    ax = 0.2;
    ay = 0.2;
    ah = 0.5;
    aw = 0.7;
elseif Domain == "SMCR"
    % Small Coastal Domain for density
    lonl = 133;
    lonr = 138;
    latb = 31;
    latt = 35;
    rate = 6;
    ax = 0.15;
    ay = 0.15;
    ah = 0.8;
    aw = 0.8;
elseif Domain == "CAP"
    % Small Coastal Domain for density
    lonl = 134.5;
    lonr = 137.5;
    latb = 31;
    latt = 34;
    rate = 3;
    ax = 0.15;
    ay = 0.15;
    ah = 0.8;
    aw = 0.8;
end
% figure size
fh = (latt - latb) * rate;
fw = fh * (lonr - lonl) / (latt - latb);

