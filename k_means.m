if(exist('data') == 0)
   data_generation 
end

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
    
    
     
%     numero_erros_i = sum(ismember(resposta_corrigida, 1)) + ...
%         sum(ismember(resposta_corrigida, -1));
%     
%     if numero_erros_i < numero_erros
%        numero_erros = numero_erros_i;
%        melhor_resposta = resposta;
%     end
    
     
%erro_1 é o erro na classe 1
%erro_2 é o erro na classe 2
    output{i}.erro_1 = sum(ismember(resposta_corrigida, -1));
    output{i}.erro_2 = sum(ismember(resposta_corrigida, 1));
    output{i}.clusters = resposta_atual;
    
end

% anotações da aula
% desempenho do modelo em termos de taxa de erro 
% estimativa da taxa de erro:
%     1. Pontual
%     2. Por intrevalo de coonfiaça