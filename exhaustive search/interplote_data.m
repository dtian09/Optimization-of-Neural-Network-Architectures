clear all;
load size0labelled.csv;
load size20.csv ;% 20% breaks
load size60.csv ;% 60%
load size100.csv;
load size120.csv;% 120%
load size200.csv;%200%
load Blind_Case2_Smart.csv;%break size 40%, in RIH (0) without availability ECCS (0)
load Blind_Case3_Smart.csv;%break size 75%, in RIH (0) with availability ECCS (1)
load Blind_Case4_Smart.csv;%break size 50%, in RIH (0) with availability ECCS (1)
load Blind_Case5_Smart.csv;%break size 160%, in RIH (0) with availability ECCS (1)
size0 = size0labelled;
subsample=size100(1:93,:);
size100_2=[size100;subsample];
% Whole dataset from different breaks
  for j=1:37
        rsize0(:,j)=resample(size0(:,j), size20(:,41),9);  
  end
  for j=1:37
        rsize20(:,j)=resample(size20(:,j), size20(:,41),9);
  end   
  for j=1:37
       rsize60(:,j)=resample(size60(:,j), size60(:,41),9); 
  end
  for j=1:37
        %rsize100(:,j)=resample(size100(:,j), size20(:,41),9);
        rsize100(:,j)=resample(size100_2(:,j), size20(:,41),9);   
  end
  for j=1:37
        rsize120(:,j)=resample(size120(:,j), size120(:,41),9); 
  end  
  for j=1:37
        rsize200(:,j)=resample(size200(:,j), size20(:,41),9); 
  end
  subsample=Blind_Case2_Smart(1:269,:);
  subsample2=Blind_Case2_Smart(1:3,:);
  rsize40=[Blind_Case2_Smart;subsample;subsample2];%create a size 40 dataset of size 541
  for j=1:37
       rsize40(:,j)=resample(rsize40(:,j), size20(:,41),9); 
  end
  subsample=Blind_Case3_Smart(1:222,:);
  subsample2=Blind_Case3_Smart(1:97,:);
  rsize75=[Blind_Case3_Smart;subsample;subsample2];%create a size 75 dataset of size 541
  for j=1:37
       rsize75(:,j)=resample(rsize75(:,j), size20(:,41),9); 
  end
  subsample=Blind_Case4_Smart(1:269,:);
  subsample2=Blind_Case4_Smart(1:3,:);
  rsize50=[Blind_Case4_Smart;subsample;subsample2]; %create a size50 dataset of size 541
  for j=1:37
       rsize50(:,j)=resample(rsize50(:,j), size20(:,41),9); 
  end
  subsample=Blind_Case5_Smart(1:270,:);
  subsample2=Blind_Case5_Smart(1,:);
  rsize160=[Blind_Case5_Smart;subsample;subsample2]; %create a size 160 dataset of size 541
  for j=1:37
       rsize160(:,j)=resample(rsize160(:,j), size20(:,41),9); 
  end  
  %interpolation more data points for break size
  for i=1:541%i=1:541
      for j=1:37        
        %px=[rsize0(i,j) rsize20(i,j) rsize60(i,j) rsize100(i,j) rsize120(i,j) rsize200(i,j)];
        %py=[0 20 60 100 120 200];
        px=[rsize0(i,j) rsize20(i,j) rsize40(i,j) rsize50(i,j) rsize60(i,j) rsize75(i,j) rsize100(i,j) rsize120(i,j) rsize160(i,j) rsize200(i,j)];
        py=[0 20 40 50 60 75 100 120 160 200];
        [a ,tp]=resample(px,py,0.4, 'linear');
        %[a ,tp]=resample(px,py,0.3999, 'linear');
        %[a ,tp]=resample(px,py,0.38, 'linear');
        %[a ,tp]=resample(px,py,0.3, 'linear');
        %[a ,tp]=resample(px,py,0.29, 'linear');
        %[a ,tp]=resample(px,py,0.275, 'linear');
        %[a ,tp]=resample(px,py,0.25, 'linear');
        %[a ,tp]=resample(px,py,0.2, 'linear');
        %[a ,tp]=resample(px,py,0.15, 'linear');
        %[a ,tp]=resample(px,py,0.1, 'linear');
        %[a,tp]=resample(px,py,0.05, 'linear');
        %[a ,tp]=resample(px,py,0.03, 'linear');
        %[b tf]=resample(a, 40, 10);
        %tp=py;
        psize(i,j,:)=a;
        % 'pchip'  - shape-preserving piecewise cubic interpolation
        % 'spline' - piecewise cubic spline interpolation[ 0 40 80 120 160 200],[0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200]); %[0 10 size(rsize20 30 40 50...200]
       end
  end
  ef=0;   
    for i=1:length(tp)
        if(tp(i)==200)
            ef=i;
        end
    end
    t=[];
    for j=1:ef
        for i=1:541
             t=[t tp(j)];
        end
    end
    x=[];
    for i=1:ef   
       if(tp(i)==0)
            c=rsize0(:,:);       
       elseif(tp(i)==20)
            c=rsize20(:,:);
       elseif(tp(i)==40)
            c=rsize40(:,:);              
       elseif(tp(i)==50)
            c=rsize50(:,:);                        
       elseif(tp(i)==60)
            c=rsize60(:,:);              
       elseif(tp(i)==75)
            c=rsize75(:,:);              
       elseif(tp(i)==100)
            c=rsize100(:,:);    
       elseif(tp(i)==120)
            c=rsize120(:,:);             
       elseif(tp(i)==160)
            c=rsize160(:,:);              
       elseif(tp(i)==200)
            c=rsize200(:,:);
       else
            c=psize(:,:,i);
       end
       x=[x;c];
   end   
   x=x';
