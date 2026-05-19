function num_of_day = num_of_day(t_ys, t_ms, t_ds, t_ye, t_me, t_de)
    
    [~,~,~,t_strs] = time_str(t_ds, t_ms, t_ys, 0);
    [~,~,~,t_stre] = time_str(t_de, t_me, t_ye, 0);
    
    t_strs_num = str2double(t_strs);
    t_stre_num = str2double(t_stre);
    
    if t_strs_num > t_stre_num
        error("The earlier date should be input first!")
    end
    
    if t_ys == t_ye && t_ms == t_me

        num_of_day = t_de - t_ds;

    elseif t_ye == t_ys && t_ms ~= t_me

        month_i = t_ms;

        if ~isempty(find(month_i == [1,3,5,7,8,10,12], 1))
            num_of_day = 31 - t_ds;
        elseif ~isempty(find(month_i == [4,6,9,11], 1))
            num_of_day = 30 - t_ds;
        elseif month_i == 2
            if mod(t_ys, 4) ~= 0
                num_of_day = 28 - t_ds;
            elseif mod(t_ys, 4) == 0
                num_of_day = 29 - t_ds;
            end
        end

        month_i = month_i + 1;

        while month_i < t_me
            if ~isempty(find(month_i == [1,3,5,7,8,10,12], 1))
                num_of_day = num_of_day + 31;
            elseif ~isempty(find(month_i == [4,6,9,11], 1))
                num_of_day = num_of_day + 30;
            elseif month_i == 2
                if mod(t_ys, 4) ~= 0
                    num_of_day = num_of_day + 28;
                elseif mod(t_ys, 4) == 0
                    num_of_day = num_of_day + 29;
                end
            end
            month_i = month_i + 1;
        end

        num_of_day = num_of_day + t_de;

    elseif t_ys ~= t_ye

        num_of_day = 0;
        year_i = t_ys;
        while year_i < t_ye
            if year_i == t_ys
                month_i = t_ms;
                if ~isempty(find(month_i == [1,3,5,7,8,10,12], 1))
                    num_of_day = 31 - t_ds;
                elseif ~isempty(find(month_i == [4,6,9,11], 1))
                    num_of_day = 30 - t_ds;
                elseif month_i == 2
                    if mod(year_i, 4) ~= 0
                        num_of_day = 28 - t_ds;
                    elseif mod(year_i, 4) == 0
                        num_of_day = 29 - t_ds;
                    end
                end
                month_i  = month_i + 1;
            else
                month_i = 1;
            end

            while month_i <= 12                
                if ~isempty(find(month_i == [1,3,5,7,8,10,12], 1))
                    num_of_day = num_of_day + 31;
                elseif ~isempty(find(month_i == [4,6,9,11], 1))
                    num_of_day = num_of_day + 30;
                elseif month_i == 2
                    if mod(year_i, 4) ~= 0
                        num_of_day = num_of_day + 28;
                    elseif mod(year_i, 4) == 0
                        num_of_day = num_of_day + 29;
                    end
                end
                month_i = month_i + 1;
            end

            year_i = year_i + 1;

        end

        month_i = 1;
        while month_i < t_me
            if ~isempty(find(month_i == [1,3,5,7,8,10,12], 1))
                num_of_day = num_of_day + 31;
            elseif ~isempty(find(month_i == [4,6,9,11], 1))
                num_of_day = num_of_day + 30;
            elseif month_i == 2
                if mod(t_ye, 4) ~= 0
                    num_of_day = num_of_day + 28;
                elseif mod(t_ye, 4) == 0
                    num_of_day = num_of_day + 29;
                end
            end
            month_i = month_i + 1;
        end
        num_of_day = num_of_day + t_de;
    end

    num_of_day = num_of_day + 1; % include the first day
