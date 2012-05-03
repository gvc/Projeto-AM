function [ class ] = knn_classifier( e, k, data, class_label_1, class_label_2)
%KNN_CLASSIFIER Classifies e using the two datasets
    
    posterioris = knn(e, k, data, class_label_1, class_label_2);

    if posterioris(1) >= posterioris(2)
        class = class_label_1;
    else
        class = class_label_2;
    end
end
