function Nodes = Find_nodes(Var_2D,xrange,yrange)
    [Nr, Nc] = find(isnan(Var_2D));
    Nodes = zeros(length(Nc), 4) * nan;
    dx = xrange(2) -xrange(1);
    for i = 1 : length(Nc)
        Nodes(i, 1) = xrange(1, Nc(i))-dx;
        Nodes(i, 2) = yrange(1,Nr(i)+1);
        Nodes(i, 3) = 2*dx;
        Nodes(i, 4) = abs(Nodes(i, 2)- yrange(1,Nr(i)));
    end

