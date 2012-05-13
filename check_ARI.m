if(exist('output') == 0)
   k_means 
end

HOME = cd();

f = figure;
plot(classe_1(:, 1), classe_1(:, 2), 'bO', ...
     classe_2(:, 1), classe_2(:, 2), 'gX');
print(f,'-djpeg',[HOME,'/Debug/gabarito'])
close(f);

for i = 1:100
% 
     resposta = output{i}.clusters;
     total_acerto(i) = 300 - (output{i}.erro_1 + output{i}.erro_2);
     ari(i) = ARI(gabarito, resposta);
%    
%     
%     
end

% total_acerto 0:300
% ari 0:1

acerto = sort(total_acerto ./ 300);
ari = sort(ari);

x = figure;
plot(1:100,acerto,'g-',1:100,ari,'r-');
print(x,'-djpeg',[HOME,'/Debug/report']);
close(x);

  



