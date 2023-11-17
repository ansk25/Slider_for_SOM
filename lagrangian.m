function [min_f, g_min_f] = lagrangian(sMap, thresholdValue)

    numNodes = size(sMap.codebook, 1);

    g = [];
    f_g = [];
    min_f = [];
    g_min_f = [];

    for i = 1:numNodes
        if sMap.codebook(i, 4) < thresholdValue
            g = [g; sMap.codebook(i, 4)]; 

            f_value = sMap.codebook(i, 3); 
            f_g = [f_g; f_value];
        end
    end

    min_f = min(f_g);
    
    index_min_f = find(f_g == min_f, 1);

    g_min_f = g(index_min_f);
    % disp(['g = ', num2str(g_min_f)]);
    % disp(['f = ', num2str(min_f)]);
end
