function Var_2D_output = omit_rc_idx(Var_2D_input,y_idx,x_idx)

    Var_2D_output = Var_2D_input*nan;
    Var_2D_output(y_idx,x_idx) = Var_2D_input(y_idx,x_idx);

