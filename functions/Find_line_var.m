function V_Var = Find_line_var(Var,line_xrange,line_yrange,x_t,y_t)
V_Var = [];
for lyr = 1 : size(Var,3)
    Var_lyr = Var(:,:,lyr)';
    var_l_profile = [];  
    for i = 1 : length(line_xrange)
        vari = Var_lyr(y_t == line_yrange(i), x_t == line_xrange(i));
        var_l_profile = cat(2, var_l_profile, vari);
    end
    V_Var = cat(1, V_Var, var_l_profile);
end

