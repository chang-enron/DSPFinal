clear
bb=12; % block size
RR=2; % redundancy factor
K=RR*bb^2; % number of atoms in the dictionary

sigma = 25; 

waitBarOn = 1;
if (sigma > 5)
    numIterOfKsvd = 10;
else
    numIterOfKsvd = 5;
end
C = 1.15;
maxBlocksToConsider = 260000;
slidingDis = 1;

maxNumBlocksToTrainOn = 65000;
displayFlag = 1;

varargin='';
for argI = 1:2:length(varargin)
    if (strcmp(varargin{argI}, 'slidingFactor'))
        slidingDis = varargin{argI+1};
    end
    if (strcmp(varargin{argI}, 'errorFactor'))
        C = varargin{argI+1};
    end
    if (strcmp(varargin{argI}, 'maxBlocksToConsider'))
        maxBlocksToConsider = varargin{argI+1};
    end
    if (strcmp(varargin{argI}, 'numKSVDIters'))
        numIterOfKsvd = varargin{argI+1};
    end
    if (strcmp(varargin{argI}, 'blockSize'))
        bb = varargin{argI+1};
    end
    if (strcmp(varargin{argI}, 'maxNumBlocksToTrainOn'))
        maxNumBlocksToTrainOn = varargin{argI+1};
    end
    if (strcmp(varargin{argI}, 'displayFlag'))
        displayFlag = varargin{argI+1};
    end
end

% first, train a dictionary on blocks from the noisy image

pathForImages ='../dsp_homework/train data/wood/';
%imageName = char('agave2_t0.png','cactus4_t0.png','cactus6_t0.png','cactus7_t0.png', 'cactus9_t0.png','cactus11_t0.png','cactus12_t0.png','cactus13_t0.png' ,'plants12_t0.png');
imageName = char('oak_t0.png','wood1_t0.png','wood2_t0.png','wood3_t0.png','wood4_t0.png','wood4a_t0.png','wood_t0.png');
pixel_step = 2;
blocknum = (512-12)/pixel_step+1;

blkMatrix = zeros(bb^2,blocknum^2*9);
blkindex = 0;
reduceDC = 1;
for index = 1:1:7
    
       disp(imageName(index,:));
    [IMin0,pp]=imread(strcat([pathForImages,imageName(index,:)]));
    IMin0=im2double(IMin0);
    if (length(size(IMin0))>2)
        IMin0 = rgb2gray(IMin0);
    end
    if (max(IMin0(:))<2)
        IMin0 = IMin0*255;
    end
    Image = IMin0;
    [NN1,NN2] = size(Image);

    for i=1:pixel_step:NN1-bb+1
        for j=1:pixel_step:NN2-bb+1
            currBlock = Image(i:i+bb-1,j:j+bb-1);
            blkindex=blkindex+1;
            blkMatrix(:,blkindex) = currBlock(:);
        end
    end
end
param.K = K;
param.numIteration = numIterOfKsvd ;

param.errorFlag = 1; % decompose signals until a certain error is reached. do not use fix number of coefficients.
param.errorGoal = sigma*C;
param.preserveDCAtom = 0;

disp('start training...');
Pn=ceil(sqrt(K));
DCT=zeros(bb,Pn);
for k=0:1:Pn-1,
    V=cos([0:1:bb-1]'*k*pi/Pn);
    if k>0, V=V-mean(V); end;
    DCT(:,k+1)=V/norm(V);
end;
DCT=kron(DCT,DCT);

param.initialDictionary = DCT(:,1:param.K );
param.InitializationMethod =  'GivenMatrix';

if (reduceDC)
    vecOfMeans = mean(blkMatrix);
    blkMatrix = blkMatrix - ones(size(blkMatrix,1),1)*vecOfMeans;
end


param.displayProgress = displayFlag;
[Dictionary,output] = KSVD(blkMatrix,param);


if (displayFlag)
    disp('finished Trainning dictionary');
end

    
    