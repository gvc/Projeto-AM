function [ class ] = parzen_window_classifier( e, h, dataset_1, dataset_2, class_label_1, class_label_2)
%PARZEN_WINDOW_CLASSIFIER Classifies e using the two datasets
    
    if parzen_window(e, dataset_1, h) >= parzen_window(e, dataset_2, h)
        class = class_label_1;
    else
        class = class_label_2;
    end
end
