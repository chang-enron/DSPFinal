%load Dictionary
pk_Dict = load('Dictionary_KSVD_plants_12.mat');
pw_Dict = load('Dictionary_KSVD_wood_12.mat');
bb=12;
pathForImages ='../../dsp_homework/test data/';
imageName = 'test_0.jpg';
[IMin0,pp]=imread(strcat([pathForImages,imageName]));
image= rgb2gray(IMin0);
sigma = 25; 
C = 1.15;


%imshow(image);
disp(size(image));
pixel_step = 2;
[NN1,NN2] = size(image);

blkMatrix = zeros(bb^2,1);
 %m = zeros(NN1,NN2);
 m = image;
 dex =0;
 errT = 2;
    for i=1:pixel_step:NN1-bb+1
        for j=1:pixel_step:NN2-bb+1
           currBlock = image(i:i+bb-1,j:j+bb-1);
           dex=dex+1;
            blkMatrix(:,1) = currBlock(:);
            
            Coefp = OMP(pk_Dict.Dictionary,blkMatrix(:,1) ,errT);
            Coefw = OMP(pw_Dict.Dictionary,blkMatrix(:,1) ,errT);
            dicp = pk_Dict.Dictionary*Coefp;
            dicw = pw_Dict.Dictionary*Coefw;
            %minp = 12313231213213;
            %minw = 12312312132312;
            %tp = immse(dicp,blkMatrix(:,1));
            %tw = immse(dicw,blkMatrix(:,1));
            tp = norm(blkMatrix(:,1)-dicp);
            tw = norm(blkMatrix(:,1)-dicw);
            %for k =1:1:128
                %minp = min(minp,immse(pk_Dict.Dictionary(:,k),blkMatrix(:,1)));
                %minw = min(minw,immse(pw_Dict.Dictionary(:,k),blkMatrix(:,1)));
            %end 
            %compare.....
            if(tp>tw)
                %disp('asda');
                m(i:i+bb-1,j:j+bb-1) = zeros(bb,bb);
            else
                %disp('bbbbbbb');
                m(i:i+bb-1,j:j+bb-1) = zeros(bb,bb)+255;
            end
        end
    end
    imshow(m);
    
    



