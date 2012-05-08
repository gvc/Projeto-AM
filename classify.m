function [] = classify()
  
%   resultados_bayes = repmat(0, 10);
%   resultados_knn = repmat(0, 10);
%   resultados_parzen = repmat(0, 10);
%   resultados_combinados = repmat(0, 10);
%   
  for i=1:10
    load(strcat('fold_',int2str(i),'.mat')); 
    fprintf('\nFOLD %d\n', i)
    train = new_fold.training;
    test = new_fold.test;
    
    resultados_bayes{i} = bayes_classify(test, train);
    resultados_knn{i} = knn_classify(test, train);
    resultados_parzen{i} = parzen_classify(test, train);
    resultados_combinados{i} = combine_classify(test, train);
  end
  
    relatorio(resultados_bayes, 'BAYES');
    relatorio(resultados_combinados, 'CLASSIFICADORES COMBINADOS');
    relatorio_composto(resultados_knn, 'kNN');
    relatorio_composto(resultados_parzen, 'JANELA DE PARZEN');
end

function [] = relatorio(resultados, label)
    taxa_erro = 0;
    mc = [0 0; 0 0];
    for i=1:size(resultados, 2)
        taxa_erro = taxa_erro + resultados{i}.taxa_erro;
        mc = mc + resultados{i}.matriz_confusao;
    end
    
    fprintf('%s\nTaxa de erro: %.3f\n', label, taxa_erro / size(resultados, 2));
    fprintf('\tClasse real\n\tC1\tC2\nC1\t%d\t%d\nC2\t%d\t%d\n\n', mc(1, 1), mc(1, 2), mc(2, 1), mc(2, 2));
end

function [] = relatorio_composto(resultados, label)
    
    fprintf('%s\n', label);

    for i=1:size(resultados{1}, 2)
       taxa_erro = 0;
       mc = [0, 0; 0, 0];
       
       for j=1:size(resultados,2)
           taxa_erro = taxa_erro + resultados{j}{i}.resultado.taxa_erro;
           mc = mc + resultados{j}{i}.resultado.matriz_confusao;
       end
       
       fprintf('Par?metro: %.5f\nTaxa de erro: %.3f\n', resultados{1}{i}.parametro, taxa_erro / size(resultados, 2));
       fprintf('\tClasse real\n\tC1\tC2\nC1\t%d\t%d\nC2\t%d\t%d\n\n', mc(1, 1), mc(1, 2), mc(2, 1), mc(2, 2));
    end
end

function [resultado] = bayes_classify(test, train)
  sorted_training = sortrows(train, 3);
  class_1 = sorted_training(1:135, 1:2);
  class_2 = sorted_training(136:270, 1:2);
  
  tp = 0;
  tn = 0;
  
  fp = 0;
  fn = 0;
  
  for j=1:size(test,1)
    e = test(j, 1:2);
    classe = test(j, 3);
    
    prob_1 = questao_2_a_1(e, class_1);
    prob_2 = questao_2_a_2(e, class_2);
    
    if prob_1 >= prob_2
      if classe == 1
        tp = tp + 1;
      else
        fp = fp + 1;
      end
    else
      if classe == 2
        tn = tn + 1;
      else
        fn = fn + 1;
      end
    end
  end
  
  resultado.taxa_erro = (fn + fp)/(fn + fp + tp + tn);
  resultado.matriz_confusao = [tp, fp; fn, tn];
  
%   fprintf('Bayes\nTaxa de erro: %.3f\n', (fn + fp)/(fn + fp + tp + tn));
%   fprintf('\tClasse real\n\tC1\tC2\nC1\t%d\t%d\nC2\t%d\t%d\n\n', tp, fp, fn, tn);
end

function [resultado] = combine_classify(test, train)
  h_estimate = 1/sqrt(size(train, 1)/2);
  k_estimate = int16(sqrt(size(train, 1)/2));
  
  sorted_training = sortrows(train, 3);
  class_1 = sorted_training(1:135, 1:2);
  class_2 = sorted_training(136:270, 1:2);
  
  tp = 0;
  tn = 0;
  
  fp = 0;
  fn = 0;
  
  for j=1:size(test,1)
    e = test(j, 1:2);
    classe = test(j, 3);
    
    pp_c1_bayes = questao_2_a_1(e, class_1);
    pp_c2_bayes = questao_2_a_2(e, class_2);
    
    pp_c1_parzen = parzen_window(e, class_1, h_estimate);
    pp_c2_parzen = parzen_window(e, class_2, h_estimate);
    
    knn_answer = knn(e, k_estimate, train, 1, 2);
    pp_c1_knn = knn_answer(1);
    pp_c2_knn = knn_answer(2);
    
    pp_c1 = sum([pp_c1_parzen pp_c1_knn pp_c1_bayes]);
    pp_c2 = sum([pp_c2_parzen pp_c2_knn pp_c2_bayes]);
    
    
    if pp_c1 >= pp_c2
      if classe == 1
        tp = tp + 1;
      else
        fp = fp + 1;
      end
    else
      if classe == 2
        tn = tn + 1;
      else
        fn = fn + 1;
      end
    end
  end
  
  resultado.taxa_erro = (fn + fp)/(fn + fp + tp + tn);
  resultado.matriz_confusao = [tp, fp; fn, tn];
  
%   fprintf('Combinacao\tTaxa de erro: %.3f\n', (fn + fp)/(fn + fp + tp + tn));
%   fprintf('\tClasse real\n\tC1\tC2\nC1\t%d\t%d\nC2\t%d\t%d\n\n', tp, fp, fn, tn);
end

function [resultados] = parzen_classify(test, train)
  display('Rodando Parzen Windows');
  
  h_estimate = 0.25/sqrt(size(train, 1)/2);
  h_oitavo = h_estimate / 7;
  
  sorted_training = sortrows(train, 3);
  
  for j=-5:5
    h = max([(j * h_oitavo + h_estimate) 0]);
    tp = 0;
    tn = 0;
  
    fp = 0;
    fn = 0;
    
    for ii=1:size(test, 1)
      expected_class = test(ii, 3);

      parzen_class = parzen_window_classifier(test(ii, 1:2), h, sorted_training(1:135, 1:2), sorted_training(136:270, 1:2), 1, 2);
      
      if parzen_class == expected_class
        if expected_class == 1
          tp = tp + 1;
        else
          tn = tn + 1;
        end
      else
        if expected_class == 2
          fp = fp + 1;
        else
          fn = fn + 1;
        end
      end
    end
    
    resultado.taxa_erro = (fn + fp)/(fn + fp + tp + tn);
    resultado.matriz_confusao = [tp, fp; fn, tn];
    
    resultados{j+6}.resultado = resultado;
    resultados{j+6}.parametro = h;
    
%     fprintf('h = %f\tTaxa de erro: %.3f\n', h, resultado.taxa_erro);
%     fprintf('\tClasse real\n\tC1\tC2\nC1\t%d\t%d\nC2\t%d\t%d\n\n', tp, fp, fn, tn);
  end
end

function [resultados] = knn_classify(test, train)
  display('Rodando kNN');

  k_estimate = int16(sqrt(size(train, 1)));

  for k=max([1, k_estimate - 5]):(k_estimate + 5)
    tp = 0;
    tn = 0;
  
    fp = 0;
    fn = 0;
       
    for j=1:size(test, 1)
      expected_class = test(j, 3);
      knn_class = knn_classifier(test(j, 1:2), k, train, 1, 2);
      
      if knn_class == expected_class
        if expected_class == 1
          tp = tp + 1;
        else
          tn = tn + 1;
        end
      else
        if expected_class == 2
          fp = fp + 1;
        else
          fn = fn + 1;
        end
      end
    end
    
    resultado.taxa_erro = (fn + fp)/(fn + fp + tp + tn);
    resultado.matriz_confusao = [tp, fp; fn, tn];
    
    resultados{k - k_estimate + 6}.resultado = resultado;
    resultados{k - k_estimate + 6}.parametro = k;
  end
end