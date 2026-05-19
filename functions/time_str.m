function [t_d, t_m, t_y, t_str] = time_str(t_dc, t_mc, t_yc, dt)

    if t_dc > 31 && ~isempty(find(t_mc == [1,3,5,7,8,10,12], 1))
        error("Please enter correct day!")
    elseif t_dc > 30 && ~isempty(find(t_mc == [4,6,9,11], 1))
        error("Please enter correct day!")
    elseif t_dc > 28 && t_mc == 2 && mod(t_yc, 4) ~= 0
        error("Please enter correct day!")
    elseif t_dc > 29 && t_mc == 2 && mod(t_yc, 4) == 0
        error("Please enter correct day!")
    elseif t_mc > 12 || t_mc < 0
        error("Please enter correct month!")
    elseif t_yc < 0
        error("Please enter correct year!")
    elseif fix(t_dc) ~= t_dc || fix(t_mc) ~= t_mc || fix(t_yc) ~= t_yc
        error("Please enter correct date!")
    end
    
    % new date
    t_d = t_dc + dt;
    t_m = t_mc;
    t_y = t_yc;
    
    if dt > 0
        while (t_d > 31 && ~isempty(find(t_m == [1,3,5,7,8,10,12], 1))) || ...
              (t_d > 30 && ~isempty(find(t_m == [4,6,9,11], 1))) || ...
              (t_d > 28 && t_m == 2 && mod(t_y,4) ~= 0) || ...
              (t_d > 29 && t_m == 2 && mod(t_y,4) == 0)
            if t_d > 31 && ~isempty(find(t_m == [1,3,5,7,8,10,12], 1))
                t_d = t_d - 31;
                t_m = t_m + 1;
            elseif t_d > 30 && ~isempty(find(t_m == [4,6,9,11], 1))
                t_d = t_d - 30;
                t_m = t_m + 1;
            elseif t_d > 28 && t_m == 2 && mod(t_y,4) ~= 0
                t_d = t_d - 28;
                t_m = t_m + 1;
            elseif t_d > 29 && t_m == 2 && mod(t_y,4) == 0
                t_d = t_d - 29;
                t_m = t_m + 1;
            end
            if t_m > 12
                t_m = t_m - 12;
                t_y = t_y + 1;
            end
        end
    else
        while t_d <= 0
            t_m = t_m - 1;
            if ~isempty(find(t_m == [0,1,3,5,7,8,10,12], 1))
                t_d = t_d + 31;
            elseif ~isempty(find(t_m == [4,6,9,11], 1))
                t_d = t_d + 30;
            elseif t_m == 2
                if mod(t_y, 4) ~= 0
                    t_d = t_d + 28;
                elseif mod(t_y, 4) == 0
                    t_d = t_d + 29;
                end
            end
        end
        if t_m <= 0
            t_m = t_m + 12;
            t_y = t_yc - 1;
        end
    end
    
    % new time string
    if t_d < 10
        d_str = "0" + num2str(t_d);
    else
        d_str = "" + num2str(t_d);
    end
    if t_m < 10
        m_str = "0" + num2str(t_m);
    else
        m_str = "" + num2str(t_m);
    end
    y_str = "" + num2str(t_y);
    t_str = y_str + m_str + d_str;

