function [ prob ] = questao_2_a_1( elemento, dados )
    media = mean(dados);
    
    matriz = [0 0; 0 0];
    
    for i=1:size(dados, 1)
        t1 = dados(i, :)' - media'; 
        
        matriz = matriz + t1 * t1';
    end
    
    sigma = matriz/size(dados,1);
    
    prob = mvnpdf(elemento, media, sigma);
end
