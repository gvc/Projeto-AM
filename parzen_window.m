function [ posteriori_probability ] = parzen_window( elemento, dados, tamanho_janela)
    p = size(dados, 2);
    n = size(dados, 1);
    somatorio = 0;
    
    for i = 1:n
        t = (elemento - dados(i, :)) / tamanho_janela;
        
        somatorio = somatorio + gaussian_kernel(t, p)/(tamanho_janela^p);
    end
    
    posteriori_probability = somatorio/n;
end


function [kernel] = gaussian_kernel(x, p)
    kernel = (2 * pi) ^ (-p/2);
    
    kernel = kernel * exp((x*x')/-2);
end