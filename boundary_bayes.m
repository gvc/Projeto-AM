load('fold_5')
training = new_fold.training;

min_x = min(training(: , 1));
max_x = max(training(: , 1));

min_y = min(training(: , 1));
max_y = max(training(: , 1));

steps = 100;

sorted_training = sortrows(training, 3);
s_class_1 = sorted_training(1:135, 1:2);
s_class_2 = sorted_training(136:270, 1:2);

class_1 = repmat(0, steps^2, 2);
class_1_index = 1;
class_2 = repmat(0, steps^2, 2);
class_2_index = 1;

x_step = (max_x - min_x)/steps;
y_step = (max_y - min_y)/steps;

for i = 1:steps
    
    for j = 1:steps
        e = [min_x + x_step * i, min_y + y_step * j];

        prob_1 = questao_2_a_1(e, s_class_1);
        prob_2 = questao_2_a_2(e, s_class_2);
    
        if prob_1 >= prob_2
          classe = 1;
        else
          classe = 2;
        end
        
        
        if classe == 1
            class_1(class_1_index, :) = e;
            class_1_index = class_1_index + 1;
        else
            class_2(class_2_index, :) = e;
            class_2_index = class_2_index + 1;
        end
    end
end

class_1 = class_1(1:class_1_index-1, :);
class_2 = class_2(1:class_2_index-1, :);

hold on
axis([min_x max_x min_y max_y])
scatter(class_1(:, 1), class_1(:, 2), 'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'none');
scatter(class_2(:, 1), class_2(:, 2), 'MarkerFaceColor', [.87 .87 .87], 'MarkerEdgeColor', 'none');
scatter(s_class_1(:, 1), s_class_1(:, 2), 'MarkerFaceColor', 'none', 'MarkerEdgeColor', 'b', 'Marker', 'o');
scatter(s_class_2(:, 1), s_class_2(:, 2), 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'Marker', 'x');
hold off


