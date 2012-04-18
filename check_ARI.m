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

    resposta = output{i}.clusters;
    total_acerto(i) = 300 - (output{i}.erro_1 + output{i}.erro_2);
    ari(i) = ARI(gabarito, resposta);
   
    
    [erro_1,erro_2] = debug_find_error(data,gabarito, resposta);
    
    if(size(erro_1,1)>0 && size(erro_2,1)>0)
        h = figure;
        plot(data(resposta == 1,1),data(resposta == 1,2),'bo',data(resposta == 2,1),data(resposta == 2,2),'gx', erro_2(:,1),erro_2(:,2),'ro',erro_1(:,1),erro_1(:,2),'rx');
        print( h, '-djpeg', [HOME,'/Debug/',num2str(i),'_acerto_',num2str(total_acerto(i)/300),'ari_',num2str(ari(i))]);
        close(h);
    elseif(size(erro_1,1)==0)
        h = figure;
        plot(data(resposta == 1,1),data(resposta == 1,2),'bo', data(resposta == 2,1),data(resposta == 2,2),'gx', erro_2(:,1),erro_2(:,2),'ro');
        print( h, '-djpeg', [HOME,'/Debug/',num2str(i),'_acerto_',num2str(total_acerto(i)/300),'ari_',num2str(ari(i))]);
        close(h); 
    elseif(size(erro_2,1)==0)
        h = figure;
        plot(data(resposta == 1,1),data(resposta == 1,2),'bo', data(resposta == 2,1),data(resposta == 2,2),'gx',erro_1(:,1),erro_1(:,2),'rx');
        print( h, '-djpeg', [HOME,'/Debug/',num2str(i),'_acerto_',num2str(total_acerto(i)/300),'ari_',num2str(ari(i))]);
        close(h);
    end
end

%total_acerto 0:300
%ari 0:1

acerto = sort(total_acerto ./ 300);
ari = sort(ari);

x = figure;
plot(1:100,acerto,'g-',1:100,ari,'r-');
print(x,'-djped',[HOME,'/Debug/report']);
close(x);

  



