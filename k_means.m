load('fold_5')

data = [new_fold.training; new_fold.test];

sorted_training = sortrows(data, 3);
classe_1 = sorted_training(1:150, 1:2);
classe_2 = sorted_training(151:300, 1:2);

gabarito = data(:, 3);
numero_erros = 300;
melhor_resposta = [];


for i=1:100
    resposta_atual_1 = kmeans(data(:, 1:2), 2);
    resposta_atual_2 = zeros(size(resposta_atual_1,1),1);
    
    for z = 1:size(resposta_atual_1,1)
        if(resposta_atual_1(z) == 1)
            resposta_atual_2(z) = 2;
        else
            resposta_atual_2(z) = 1;
        end
    end
    
    
    
    resposta_corrigida_1 = gabarito - resposta_atual_1;
    resposta_corrigida_2 = gabarito - resposta_atual_2;
    
    if(sum(ismember(resposta_corrigida_1,0)) > sum(ismember(resposta_corrigida_2,0)))
         resposta_corrigida = resposta_corrigida_1;
         resposta_atual = resposta_atual_1;
    else
         resposta_corrigida = resposta_corrigida_2;
         resposta_atual = resposta_atual_2;
    end
    
    
     
     numero_erros_i = sum(ismember(resposta_corrigida, 1)) + ...
         sum(ismember(resposta_corrigida, -1));
     
     if numero_erros_i < numero_erros
        numero_erros = numero_erros_i;
        melhor_resposta = resposta_atual;
     end
    
     
%erro_1 ?? o erro na classe 1
%erro_2 ?? o erro na classe 2
%     output{i}.erro_1 = sum(ismember(resposta_corrigida, -1));
%     output{i}.erro_2 = sum(ismember(resposta_corrigida, 1));
%     output{i}.clusters = resposta_atual;
    
end


f = figure;
plot(classe_1(:, 1), classe_1(:, 2), 'bO', ...
     classe_2(:, 1), classe_2(:, 2), 'rX');
legend('Classe 1','Classe 2',...
       'Location','NW')
print(f,'-dpng',['.','/dados']);
close(f);

g = figure;
plot(data(melhor_resposta==1,1),data(melhor_resposta==1,2),'bO', ...
	data(melhor_resposta==2,1),data(melhor_resposta==2,2),'rX');
legend('Cluster 1','Cluster 2',...
       'Location','NW')
print(g,'-dpng',['.','/clusters']);

taxa_de_erro = numero_erros/size(data,2);


% anota????es da aula
% desempenho do modelo em termos de taxa de erro 
% estimativa da taxa de erro:
%     1. Pontual
%     2. Por intrevalo de coonfia??a