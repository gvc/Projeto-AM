if(exist('data') == 0)
   data_generation 
end

gabarito = data(:, 3);
numero_erros = 300;
melhor_resposta = [];

for i=i:100
    resposta = kmeans(data(:, 1:2), 2);
    
    resposta_corrigida = gabarito - resposta;
    numero_erros_i = sum(ismember(resposta_corrigida, 1)) + ...
        sum(ismember(resposta_corrigida, -1));
    
    if numero_erros_i < numero_erros
       numero_erros = numero_erros_i;
       melhor_resposta = resposta;
    end
end

erros_classe_1 = sum(ismember((gabarito - melhor_resposta), -1));
erros_classe_2 = sum(ismember((gabarito - melhor_resposta), 1));