function [ indice ] = ARI( set1, set2 )
%ARI Calculates the Adjusted Rand Index for two clusterings
    X1 = find(set1 == 1);
    X2 = find(set1 == 2);
    Y1 = find(set2 == 1);
    Y2 = find(set2 == 2);
    
    n11 = size(intersect(X1, Y1), 1);
    n12 = size(intersect(X1, Y2), 1);
    n21 = size(intersect(X2, Y1), 1);
    n22 = size(intersect(X2, Y2), 1);
    
    somatorio_1 = combinacao(n11, 2) + combinacao(n12, 2) + combinacao(n21, 2) + ...
        combinacao(n22, 2);
    
    somatorio_2 = combinacao(n11 + n12, 2) + combinacao(n21 + n22, 2);
    somatorio_3 = combinacao(n11 + n21, 2) + combinacao(n12 + n22, 2);
    
    dividendo = somatorio_1 - (somatorio_2 * somatorio_3) / nchoosek(300, 2);
    divisor = 0.5 * (somatorio_2 + somatorio_3) - (somatorio_2 * somatorio_3) / nchoosek(300, 2);
    
    indice = dividendo / divisor;
end

function [valor] = combinacao(n, k)
    if k > n
        valor = 0;
    else
        valor = nchoosek(n, k);
    end
end