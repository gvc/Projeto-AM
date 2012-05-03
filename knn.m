function [ posteriori_probabilities ] = knn( e, k, data, class_label_1, class_label_2 )
%KNN Summary of this function goes here
%   Detailed explanation goes here
    distances = repmat(0, size(data,1), 2);
    
    for i=1:size(data, 1)
        y = data(i, 1:2);
        distance = sum((e-y).^2).^0.5;
        
        distances(i, 1) = i;
        distances(i, 2) = distance;
    end
    
    sorted_distances = sortrows(distances, 2);
    
    indexes = sorted_distances(1:k, 1);
    
    nearest_neighbours = data(indexes, 3);
    
    posteriori_1 = sum(ismember(nearest_neighbours, class_label_1))/k;
    posteriori_2 = sum(ismember(nearest_neighbours, class_label_2))/k;
    posteriori_probabilities = [posteriori_1 posteriori_2];
end
