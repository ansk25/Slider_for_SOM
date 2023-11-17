function updateThreshold_final(source, event, sMap, fig_no, constraint, min_values, max_values, current_values, constraints_all, sliders)
    thresholdValue = get(source, 'Value');

    disp([constraint, ': ', num2str(thresholdValue)]);

    num_constraints = length(constraints_all);

    con_sliders = {}; 

    for i = 1:num_constraints
                if sliders(i) == 1
                    con_sliders{end+1} = constraints_all{i}; 
                end
    end

    x = {}; 

    num_sliders = length(con_sliders);
            
    y = num_constraints - num_sliders;
            
    for i = 1:num_sliders
          y = y + 1;
          x{end+1} = y; 
    end

    h_fes = {};

    for i = 1:num_sliders
        h_fes{i} = zeros(sMap.topol.msize(1) * sMap.topol.msize(2), 1);
        h_fes{i}(find(sMap.codebook(:,x{i})>current_values(x{i})))=1;
    end

    col = cell(1, num_sliders);
    
    % Generate random colors
    for i = 1:num_sliders
        % Generate a random RGB color
        col{i} = rand(1, 3);
    end

    % h_fes1 = zeros(sMap.topol.msize(1) * sMap.topol.msize(2), 1); 
    % h_fes2 = zeros(sMap.topol.msize(1) * sMap.topol.msize(2), 1);
    % h_fes3 = zeros(sMap.topol.msize(1) * sMap.topol.msize(2), 1);
    % 
    % a = current_values(4); b = current_values(5); c = current_values(6);
    % h_fes1(find(sMap.codebook(:,4)>a))=1;
    % h_fes2(find(sMap.codebook(:,5)>b))=1;
    % h_fes3(find(sMap.codebook(:,6)>c))=1;

    % constraints = {'x1', 'x2', 'f', 'g1', 'g2', 'g3'};   %constraints_all

    if ~isnan(thresholdValue)
            % Update the highlighted regions based on the new threshold
            h_RoI = zeros(sMap.topol.msize(1) * sMap.topol.msize(2), 1);
            
            % Create a loop to iterate over the constraints
            for i = 1:num_sliders
     
                if strcmp(constraint, con_sliders{i})
                   
                h_RoI(sMap.codebook(:, x{i}) > thresholdValue) = 1;
                current_values(x{i}) = thresholdValue;
                som_show_slider_final1(sMap, constraints_all, fig_no, sliders, current_values, 'comp', 'all','bar','horiz');
                arr1 = [];
                for k=1:num_constraints
                    if sliders(k) == 0
                    arr1(end+1) = k;
                    end
                end
                arr1(end+1) = x{i};
                som_show_add('hit', h_RoI,'Markersize', 1, 'MarkerColor', 'none', 'EdgeColor', col{i}, 'Subplot', arr1);              
                for j = 1:num_sliders
                    if j~=i
                        arr2 = [];
                        for l=1:num_constraints
                            if sliders(l) == 0
                            arr2(end+1) = l;
                            end
                        end
                        arr2(end+1) = x{j};
                        som_show_add('hit',h_fes{j},'Markersize',1,'MarkerColor','none','EdgeColor',col{j},'Subplot',arr2);
                    end
                end
                end
            end

            % if strcmp(constraint, 'g1')
            %     x = 4;
            %     h_RoI(sMap.codebook(:, x) > thresholdValue) = 1;
            %     current_values(x) = thresholdValue;
            %     som_show_slider_final(sMap, min_values, max_values, current_values, constraints_all, 6, fig_no, sliders, 'comp', 'all','bar','horiz');
            %     som_show_add('hit', h_RoI,'Markersize', 1, 'MarkerColor', 'none', 'EdgeColor', 'r', 'Subplot', [1,2,3,4]);              
            %     som_show_add('hit',h_fes2,'Markersize',1,'MarkerColor','none','EdgeColor','m','Subplot',[1,2,3,5]);
            %     som_show_add('hit',h_fes3,'Markersize',1,'MarkerColor','none','EdgeColor','k','Subplot',[1,2,3,6]);
            % elseif strcmp(constraint, 'g2')
            %     x = 5;
            %     h_RoI(sMap.codebook(:, x) > thresholdValue) = 1;
            %     current_values(x) = thresholdValue;
            %     som_show_slider_final(sMap, min_values, max_values, current_values, constraints_all, 6, fig_no, sliders, 'comp', 'all','bar','horiz');
            %     som_show_add('hit', h_fes1,'Markersize', 1, 'MarkerColor', 'none', 'EdgeColor', 'r', 'Subplot', [1,2,3,4]);              
            %     som_show_add('hit',h_RoI,'Markersize',1,'MarkerColor','none','EdgeColor','m','Subplot',[1,2,3,5]);
            %     som_show_add('hit',h_fes3,'Markersize',1,'MarkerColor','none','EdgeColor','k','Subplot',[1,2,3,6]);
            % elseif strcmp(constraint, 'g3')
            %     x = 6;
            %     h_RoI(sMap.codebook(:, x) > thresholdValue) = 1;
            %     current_values(x) = thresholdValue;
            %     som_show_slider_final(sMap, min_values, max_values, current_values, constraints_all, 6, fig_no, sliders, 'comp', 'all','bar','horiz');
            %     som_show_add('hit', h_fes1,'Markersize', 1, 'MarkerColor', 'none', 'EdgeColor', 'r', 'Subplot', [1,2,3,4]);              
            %     som_show_add('hit',h_fes2,'Markersize',1,'MarkerColor','none','EdgeColor','m','Subplot',[1,2,3,5]);
            %     som_show_add('hit',h_RoI,'Markersize',1,'MarkerColor','none','EdgeColor','k','Subplot',[1,2,3,6]);
            % end

            % Update the SOM plot (adjust this part according to your plot setup)
%             figure(fig_no); hold on;
%             som_show_slider(sMap,fig_no, 'comp', 'all');
            
        % cur_val = current_values;
        end
end

