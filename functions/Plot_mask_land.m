function Plot_mask_land(Nodes,color_RGB)
    for i = 1 : length(Nodes)
        rectangle('Position', Nodes(i,:), 'FaceColor', color_RGB, 'EdgeColor', color_RGB)
        hold on;
    end

