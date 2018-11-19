function [objs, bestnet, bestnettr, bestnet_rmses, bestnet_obj, bestnet_top, bestnet_subset] = objfun_fs_top_rmse2(fs_tops,inputs,t)
%compute the objective function to select optimal features and find optimal hidden nodes: 
%         average rmse of all break sizes + standard deviation of rmse
%inputs:  fs_tops, a population of chromosomes (mxn matrix) representing a set of m architectures 
%         inputs, a mxn data matrix where m is features, n is instances 
%         t, a 1xn targets vector with n instances
%Use iterative training of networks to find optimal network
objs = ones(size(fs_tops,1),1).*888;
bestnet_obj=100;
bestnet=-1;
bestnettr=-1;
bestnet_rmses = 999;
bestnet_top = -1;
bestnet_subset = -1;
for i=1:size(fs_tops,1)
    %a chromosome has 49 bits with 37 bits representing a feature subset and 10 bits representing a NN topology 
    %(1st 6 bits represent nodes in 1st hidden layer and 2nd 6 bits represent nodes in 2nd hidden layer)
    %max nodes in 1st layer: 31
    %max nodes in 2nd layer: 31
    fs_top = fs_tops(i,:);
    %get the feature subset
    subset = fs_top(1:size(inputs,1));
    indx = find(subset==1);
    x = inputs(indx,:);
    %get nodes in the 1st hidden layer 
    wbin=fs_top(size(inputs,1)+1:size(inputs,1)+6);
    wbin=num2str(wbin);
    h1=bin2dec(wbin); 
    %get nodes in the 2nd hidden layer 
    wbin=fs_top(size(inputs,1)+7:size(inputs,1)+12);
    wbin=num2str(wbin);
    h2=bin2dec(wbin);
    if h1==0
       disp(h1);
    elseif h2==0
       disp(h2);
    else    
        trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.
        net = feedforwardnet([h1 h2],trainFcn);%set initial weights to random values and create a NN
        net.input.processFcns = {'removeconstantrows','mapminmax'};%for break size dataset, SML2010 dataset
        net.output.processFcns = {'removeconstantrows','mapminmax'};%for break size dataset, SML2010 dataset
        %net.trainParam.goal=2.5259e-10;
        net.trainParam.max_fail=6;      
        %net.trainParam.max_fail=10;
        %net.trainParam.epochs=500;
        net=random_split(net);
        %net=select_specific_patterns(net,size(x,2));%select specified patterns as training, validation and test sets        
        %net=select_patterns_uniformly_at_random(net,t);%select patterns randomly and uniformly for training, validation and testing 
        [net,tr]=train(net,x,t);
        testset=x(:,tr.testInd);
        testtargets=t(tr.testInd);
        y=net(testset);
        [average_rmse,rmses] = average_rmse_of_break_sizes(y,testtargets);
        obj=average_rmse;         %+std(rmses);
        %m=1;
        %[net,tr,average_rmse,rmses,~]=iter_train_network(net,x,t,m,trainFcn);%train the network iteratively m times
        objs(i) = obj;
        if obj < bestnet_obj
            bestnet_obj = obj;
            bestnet = net;
            bestnettr = tr;
            bestnet_rmses = rmses;
            bestnet_top = [h1 h2];
            bestnet_subset = indx;
        end
        i
        obj
        bestnet_obj
    end
end
end
function net=select_specific_patterns(net,n)
    %n, data size
    pc=0.8;%training set percentage
    m=round(n*pc);%training set size
    net.divideFcn='divideind';
    k=round((n-m)/2);%test set size
    q=n-m-k;%validation set size
    net.divideParam.trainInd=1:m;% frist 80% data for training
    net.divideParam.valInd=m+1:m+k;% 10% validation data
    net.divideParam.testInd=m+k+1:n;% 10% test data
    net.performFcn='mse'; %mean squared error
end
function net=random_split(net)
        net.divideFcn = 'dividerand';
        net.divideMode = 'sample'; 
        net.divideParam.trainRatio = 0.5;
        net.divideParam.valRatio = 0.25;
        net.divideParam.testRatio= 0.25;
        %net.divideParam.trainRatio = 0.333;
        %net.divideParam.valRatio = 0.333;
        %net.divideParam.testRatio= 0.334;
        net.performFcn = 'mse';
end
function net=select_patterns_uniformly_at_random(net,t)
%select uniformlly at random 50% data for training, 25% for validation and 25% for testing
                indxtrain0=1:270;% 50% of all data
                indxtest0=271:405;
                indxval0=405:541;
                indxsize20=find(t'==20)';%get size 20% data and transporse to row vector
                indxsize40=find(t'==40)';
                indxsize50=find(t'==50)';
                indxsize60=find(t'==60)';
                indxsize75=find(t'==75)';
                indxsize100=find(t'==100)';
                indxsize120=find(t'==120)';
                indxsize160=find(t'==160)';
                indxsize200=find(t'==200)';
                indxtrain20=indxsize20(randperm(541,270));%randomly and uniformly select training 270 patterns from the 541 patterns covering 0s to 60s
                indxtrain40=indxsize40(randperm(541,270));
                indxtrain50=indxsize50(randperm(541,270));
                indxtrain60=indxsize60(randperm(541,270));
                indxtrain75=indxsize75(randperm(541,270));
                indxtrain100=indxsize100(randperm(541,270));
                indxtrain120=indxsize120(randperm(541,270));
                indxtrain160=indxsize160(randperm(541,270));
                indxtrain200=indxsize200(randperm(541,270));
                indxtest_val20=setdiff(indxsize20,indxtrain20);%get the test set and validation set
                indxtest_val40=setdiff(indxsize40,indxtrain40);
                indxtest_val50=setdiff(indxsize50,indxtrain50);            
                indxtest_val60=setdiff(indxsize60,indxtrain60);
                indxtest_val75=setdiff(indxsize75,indxtrain75);      
                indxtest_val100=setdiff(indxsize100,indxtrain100);
                indxtest_val120=setdiff(indxsize120,indxtrain120);
                indxtest_val160=setdiff(indxsize160,indxtrain160);            
                indxtest_val200=setdiff(indxsize200,indxtrain200);      
                indxval20=indxtest_val20(randperm(270,135));%randomly and uniformly select 135 test patterns from the 270 selected patterns
                indxtest20=setdiff(indxtest_val20,indxval20);%get the validation set
                indxval40=indxtest_val40(randperm(270,135));
                indxtest40=setdiff(indxtest_val40,indxval40);
                indxval50=indxtest_val50(randperm(270,135));
                indxtest50=setdiff(indxtest_val50,indxval50);
                indxval60=indxtest_val60(randperm(270,135));
                indxtest60=setdiff(indxtest_val60,indxval60);
                indxval75=indxtest_val75(randperm(270,135));
                indxtest75=setdiff(indxtest_val75,indxval75);
                indxval100=indxtest_val100(randperm(270,135));
                indxtest100=setdiff(indxtest_val100,indxval100);
                indxval120=indxtest_val120(randperm(270,135));
                indxtest120=setdiff(indxtest_val120,indxval120);
                indxval160=indxtest_val160(randperm(270,135));
                indxtest160=setdiff(indxtest_val160,indxval160);
                indxval200=indxtest_val200(randperm(270,135));
                indxtest200=setdiff(indxtest_val200,indxval200);
                indxtrain=[indxtrain0 indxtrain20 indxtrain40 indxtrain50 indxtrain60 indxtrain75 indxtrain100 indxtrain120 indxtrain160 indxtrain200];
                indxval=[indxval0 indxval20 indxval40 indxval50 indxval60 indxval75 indxval100 indxval120 indxval160 indxval200];
                indxtest=[indxtest0 indxtest20 indxtest40 indxtest50 indxtest60 indxtest75 indxtest100 indxtest120 indxtest160 indxtest200];
                indxtest=setdiff(indxtest,indxval);
                net.divideFcn = 'divideind';
                net.divideParam.trainInd = indxtrain;
                net.divideParam.valInd = indxval;
                net.divideParam.testInd = indxtest;
                net.performFcn = 'mse'; %mean squared error
end