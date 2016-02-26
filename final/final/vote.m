pic = load('test_0_MOD_12_8.mat');      
[m,n] = size(pic.m);
result = pic.m;
bb = 8;
step = 8;
for aa=0:1:-1
    cc = 2;
    for i=cc+1:step:m-(cc+1)
        for j=cc+1:step:n-(cc+1)
            a=0;
            for k=-cc:1:cc
                for l =-cc:1:cc
                   if(pic.m(i+k+1,j+l+1)==255)
                       a =a+1;
                   end
                end
            end
            
            if(a>10)
                result(i:i+7,j:j+7) = zeros(8,8)+255;
            else
                result(i:i+7,j:j+7) = zeros(8,8);
               end
            end
    end
end
     imshow(result);        
          
             