load('fold_10')
training = new_fold.training;

min_x = min(training(: , 1));
max_x = max(training(: , 1));

min_y = min(training(: , 1));
max_y = max(training(: , 1));

steps = 200;

sorted_training = sortrows(training, 3);
s_class_1 = sorted_training(1:135, 1:2);
s_class_2 = sorted_training(136:270, 1:2);

class_1 = [];
class_2 = [];

x_step = (max_x - min_x)/steps;
y_step = (max_y - min_y)/steps;

for i = 1:steps
    
    for j = 1:steps
        e = [min_x + x_step * i, min_y + y_step * j];

        classe = parzen_window_classifier(e, 0.5/16, s_class_1, s_class_2, 1, 2);

        if classe == 1
            class_1 = [class_1; e];
        else
            class_2 = [class_2; e];
        end
    end
end

hold on
axis([min_x max_x min_y max_y])
scatter(class_1(:, 1), class_1(:, 2), 'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'none');
scatter(class_2(:, 1), class_2(:, 2), 'MarkerFaceColor', 'c', 'MarkerEdgeColor', 'none');
scatter(s_class_1(:, 1), s_class_1(:, 2), 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k', 'Marker', '+');
scatter(s_class_2(:, 1), s_class_2(:, 2), 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'r', 'Marker', 'x');
hold off


