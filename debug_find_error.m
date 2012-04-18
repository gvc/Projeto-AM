function [err_1, err_2] = debug_find_error(data,gabarito, prova)

err_1 = [];
err_2 = [];

for i = 1:size(gabarito,1)
   if(gabarito(i) == 1 && prova(i) == 2)
       err_1 = [err_1;data(i,:)];
   end
   
   if(gabarito(i) == 2 && prova(i) == 1)
       err_2 = [err_2;data(i,:)];
   end  
    
end    
        
end  