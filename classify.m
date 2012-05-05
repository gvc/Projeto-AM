function [] = classify()

  for i=1:10
    load(strcat('fold_',int2str(i),'.mat')); 
    fprintf('FOLD %d \n\n', i)
    train = new_fold.training;
    test = new_fold.test;
    
    % knn_classify(test, train);
    % parzen_classify(test, train);
    combine_classify(test, train);
  end
end

function [] = combine_classify(test, train)
  h_estimate = 1/sqrt(size(train, 1)/2);
  k_estimate = int16(sqrt(size(train, 1)/2));
  
  sorted_training = sortrows(train, 3);
  class_1 = sorted_training(1:135, 1:2);
  class_2 = sorted_training(136:270, 1:2);
  
  acertos = 0;
  erros = 0;
  
  for j=1:size(test,1)
    e = test(j, 1:2);
    
    pp_c1_parzen = parzen_window(e, class_1, h_estimate);
    pp_c2_parzen = parzen_window(e, class_2, h_estimate);
    
    knn_answer = knn(e, k_estimate, train, 1, 2);
    pp_c1_knn = knn_answer(1);
    pp_c2_knn = knn_answer(2);
    
    pp_c1 = sum([pp_c1_parzen pp_c1_knn]);
    pp_c2 = sum([pp_c2_parzen pp_c2_knn]);
    
    if pp_c1 >= pp_c2
       if test(j, 3) == 1
          acertos = acertos + 1; 
       else
          erros = erros + 1; 
       end
    else
       if test(j, 3) == 2
           acertos = acertos + 1;
       else
          erros = erros + 1; 
       end
    end
  end
  
  fprintf('Combinacao\nAcertos: %d\nErros: %d\n\n', acertos, erros);
end

function [] = parzen_classify(test, train)
  display('Rodando Parzen Windows');
  
  h_estimate = 1/sqrt(size(train, 1)/2);
  h_oitavo = h_estimate / 6;
  
  sorted_training = sortrows(train, 3);
  
  for j=-5:5
    h = max([(j * h_oitavo + h_estimate) 0]);
    acertos = 0;
    erros = 0;
    
    for ii=1:size(test, 1)
      expected_class = test(ii, 3);

      parzen_class = parzen_window_classifier(test(ii, 1:2), h, sorted_training(1:135, 1:2), sorted_training(136:270, 1:2), 1, 2);

      if expected_class == parzen_class
        acertos = acertos + 1; 
      else
        erros = erros + 1;
      end
    end
    
    fprintf('h = %f\nAcertos: %d\nErros: %d\n\n', h, acertos, erros);
  end
end

function [] = knn_classify(test, train)
  display('Rodando kNN');

  k_estimate = int16(sqrt(size(train, 1)));

  for k=max([1, k_estimate - 5]):(k_estimate + 5)
    acertos = 0;
    erros = 0;
       
    for j=1:size(test, 1)
      expected_class = test(j, 3);
      knn_class = knn_classifier(test(j, 1:2), k, train, 1, 2);
           
      if expected_class == knn_class
        acertos = acertos + 1; 
      else
        erros = erros + 1;
      end
    end
    
    fprintf('k = %d\nAcertos: %d\nErros: %d\n\n', k, acertos, erros);
  end
end