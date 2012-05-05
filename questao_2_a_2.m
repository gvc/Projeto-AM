function posteriori = questao_2_a_2(elemento,dados)
%alimentar variavel dados sem informação de classe

rotulos = kmeans(dados,2);

componente_a = dados(rotulos == 1,:);
componente_b = dados(rotulos == 2,:);

apriori_a = size(componente_a,1)/size(dados,1);
apriori_b = size(componente_b,1)/size(dados,1);

[media_a, sigma_a] = max_verossimilhanca(componente_a);
[media_b, sigma_b] = max_verossimilhanca(componente_b);

temp_apriori = [apriori_a, apriori_b];
temp_media = [media_a; media_b];
temp_sigma = [sigma_a; sigma_b];


old_log_verossimilhanca = log_verossimilhanca(dados,temp_apriori,temp_media,temp_sigma);
non_stop = true;
count = 0;

while(non_stop)
      count = count + 1;
      nova_posteriori = expectation(dados, temp_apriori, temp_media, temp_sigma);
      [temp_apriori, temp_media, temp_sigma ] = maximization(dados, nova_posteriori); 
      
      log_verossimilhanca = log_verossimilhanca(dados,temp_apriori,temp_media,temp_sigma);
      
      if(abs(log_verossimilhanca-old_log_verossimilhanca) < abs(0.0001*log_verossimilhanca) || count == 100)
          non_stop = false;
          
          if(count < 100)
              fprintf('algoritmo EM convergiu após %d iterações\n',count)
          else
              fprintf('algoritmo EM finalizado após %d iterações sem convergência',count);
          end
      end
      
      old_log_verossimilhanca = log_verossimilhanca;
      
end
    
posteriori = temp_apriori(1)*mvnpdf(elemento,temp_media(1,:),temp_sigma(1:2,:)) + temp_apriori(2)*mvnpdf(elemento,temp_media(2,:),temp_sigma(3:4,:));


% DEBUG ESTABILIZACAO LOG-VEROSSIMILHANCA
% for k = 1:100   
%    nova_posteriori = expectation(dados, temp_apriori, temp_media, temp_sigma);
%    [temp_apriori, temp_media, temp_sigma ] = maximization(dados, nova_posteriori); 
% 
%    l(k) = log_verossimilhanca(dados,temp_apriori,temp_media,temp_sigma);
% end
% 
% plot(1:100,l,'r-')

end

function [media,sigma] = max_verossimilhanca(dados)

media = mean(dados);
    
    matriz = [0 0; 0 0];
    
    for i=1:size(dados, 1)
        t1 = dados(i, :)' - media';
        
        matriz = matriz + t1 * t1';
    end
    
    sigma = matriz/size(dados,1);
end

function [posteriori_saida] = expectation(dados, param_apriori, param_media, param_sigma)
    
    numerador_a = param_apriori(1).*mvnpdf(dados, param_media(1,:), param_sigma(1:2,:));
    numerador_b = param_apriori(2).*mvnpdf(dados, param_media(2,:), param_sigma(3:4,:));
    
    posteriori_a = numerador_a./(numerador_a+numerador_b);
    posteriori_b = numerador_b./(numerador_a+numerador_b);
    
    posteriori_saida = [posteriori_a, posteriori_b];
    
end

function [apriori_estimada, media_estimada, sigma_estimada] = maximization(dados, posteriori)
    
   new_media_a = sum(dados.*repmat(posteriori(:,1),1,2))./sum(posteriori(:,1));
   new_media_b = sum(dados.*repmat(posteriori(:,2),1,2))./sum(posteriori(:,2));
   
   new_sigma_a = [0 0; 0 0];
   new_sigma_b = [0 0; 0 0];
    for i = 1:size(dados,1)
        new_sigma_a = new_sigma_a + (((dados(i,:)-new_media_a)'*(dados(i,:)-new_media_a))*posteriori(i,1));
        new_sigma_b = new_sigma_b + (((dados(i,:)-new_media_b)'*(dados(i,:)-new_media_b))*posteriori(i,2));
    end
    
    new_sigma_a = new_sigma_a ./ sum(posteriori(:,1));
    new_sigma_b = new_sigma_b ./ sum(posteriori(:,2));
    
    
    apriori_estimada = mean(posteriori);
    media_estimada = [new_media_a; new_media_b];
    sigma_estimada = [new_sigma_a; new_sigma_b];
end


function soma = log_verossimilhanca(dados,param_apriori,param_media,param_sigma)

    soma = 0;
    for k = 1:size(dados,1)
        soma = soma + log(param_apriori(1)*mvnpdf(dados(k,:),param_media(1,:),param_sigma(1:2,:)) +  param_apriori(2)*mvnpdf(dados(k,:),param_media(2,:),param_sigma(3:4,:)));  
    end    

end