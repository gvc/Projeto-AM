
%10 fold crossvalidation estratificado



for k = 1:10
    new_list = [];
    for q = 1:15
        element_sorted = 1 + round(rand()*(size(classe_1,1)-1));
        new_list = [new_list; classe_1(element_sorted,:)];
        new_list = [new_list; classe_2(element_sorted,:)];       
    end   
    fold{k} = new_list;
end 

%cada loop, uma itera��o do crossvalidation
for k = 1:size(fold,2)
       
   test = fold{k};
   
   training = [];
   for q = 1:size(fold,2)
       if (k ~= q)
            training =  [training;fold{q}];
       end
   end
   
   new_fold.test = test;
   new_fold.training = training;
   
       
   save(['fold_',int2str(k),'.mat'],'new_fold');
   
% a partir daqui temos o conjunto de treinamento e de testes corretamente
% separados para cada etapa do CrossValidation
end