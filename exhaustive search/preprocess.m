%clear all;
load size20.csv ;% 20% break size
load size60.csv ;% 60%
load size100.csv;% 100%
load size120.csv;% 120%
load size200.csv;% 200%
load NormalData.txt; % 0%
%generate duplicates of 0% break size
size0 = zeros(length(size20),37);
for i=1:length(size0)
    size0(i,:)= NormalData(1,1:37);
end
%create size 0 labels
for i=1:length(size0)
      size0labels(i,1) = 0;
end
%add size 0 labels to size 0 data
size0data = [size0,size0labels];
csvwrite('size0labelled.csv',size0data);
% resample each break size and add class labels
    for j=1:37
        rsize20(:,j)=resample(size20(:,j), size20(:,41),9);%resample each column to the rate of transient time/9 where transient time is at 41st column
    end
    %create size 20 labels
    for i=1:length(rsize20)
        size20labels(i,1)=20;
    end
    %add size 20 labels to resampled break size
    size20data = [rsize20,size20labels];
    %csvwrite('size20labelled.csv',size20data);
    
    for j=1:37
        rsize60(:,j)=resample(size60(:,j), size60(:,41),9);  
    end
     %create size 60 labels
    for i=1:length(rsize60)
        size60labels(i,1)=60;
    end
    %add size 60 labels to resampled break size
    size60data = [rsize60,size60labels];
    
    for j=1:37
        rsize120(:,j)=resample(size120(:,j), size120(:,41),9);  
    end
    %create size 120 labels
    for i=1:length(rsize120)
        size120labels(i,1)=120;
    end
    %add size 120 labels to resampled break size
    size120data = [rsize120,size120labels];
    
    for j=1:37
        rsize200(:,j)=resample(size200(:,j), size120(:,41),9);
    end
    %create size 200 labels
    for i=1:length(rsize200)
        size200labels(i,1)=200;
    end
    %add size 200 labels to resampled break size
    size200data = [rsize200,size200labels];
    
    for j=1:37
        rsize100(:,j)=resample(size100(:,j), size100(:,41),9);
    end
    %create size 100 labels
    for i=1:length(rsize100)
        size100labels(i,1)=100;
    end
    %add size 100 labels to resampled break size
    size100data = [rsize100,size100labels];
csvwrite('size100labelled.csv',size100data);
%merge 0%, 20%, 60%, 100%, 120% and 200% break sizes into a dataset
mergeddata = [size0data;size20data;size60data;size100data;size120data;size200data];
csvwrite('mergeddata.csv',mergeddata);
%===create class labels of dataset
load 'mergeddata.csv';
d = size(mergeddata,2);
classes = 6;
targets = zeros(size(mergeddata,1),classes);
for i=1:size(mergeddata,1)
    if mergeddata(i,d)==0
        targets(i,:) = [1 0 0 0 0 0];
    elseif mergeddata(i,d)==20 
        targets(i,:) = [0 1 0 0 0 0];
    elseif mergeddata(i,d)==60
        targets(i,:) = [0 0 1 0 0 0];
    elseif mergeddata(i,d)==100
        targets(i,:) = [0 0 0 1 0 0];
    elseif mergeddata(i,d)==120
        targets(i,:) = [0 0 0 0 1 0];
    elseif mergeddata(i,d)==200
        targets(i,:) = [0 0 0 0 0 1];
    else
        disp('unknown break size: ');
        disp(mergeddata(i,d));
    end
end
csvwrite('mergeddatalabels.csv',targets);
%===create training set (50%), test set (25%) and validation set (25%) from mergeddata.csv using weka
%train set contains 1080 examples. validation set contains 540 examples.
%test set contains 544 examples.
%normalize training set, validation set and test set using z-score normalization for network training
%load trainset.csv
%load validset.csv
%load testset.csv
%input data format of mapstd: Rows are features. Columns are examples (observations)
%[trainsetinputs,ps] = mapstd(trainset(:,1:37)');
%testsetinputs = mapstd('apply',testset(:,1:37)',ps);
%validsetinputs = mapstd('apply',validset(:,1:37)',ps);
%trainsetlabels = trainset(:,38);
%testsetlabels = testset(:,38);
%validsetlabels = validset(:,38);
%csvwrite('trainsetinputs.csv',trainsetinputs');
%csvwrite('testsetinputs.csv',testsetinputs');
%csvwrite('validsetinputs.csv',validsetinputs');
%csvwrite('trainsetlabels.csv',trainsetlabels);
%csvwrite('testsetlabels.csv',testsetlabels);
%csvwrite('validsetlabels.csv',validsetlabels);
