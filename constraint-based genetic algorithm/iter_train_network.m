function [bestnet,bestnettr,bestnet_average_rmse,bestnet_rmses,mean_rmses_of_all_networks] = iter_train_network(net,x,t,m,trainAlg)
%Iteratively train a trained network m times to find the best network
%The weights are initialized to the weights of the trained network before
%training starts.
%Inputs: a trained network
%        inputs
%        targets
%        m, number of iterations to train the network
%        trainFcn
bestnet = -1;
bestnettr = -1;%training record of best network
bestnet_average_rmse = 100;
bestnet_rmses = 100;
bestnet_objective=100;
mean_rmses_of_all_networks = zeros(1,m);
net.divideFcn='dividerand';  %Divide data randomly
net.divideMode='sample';  %Divide up every sample
net.divideParam.trainRatio=0.5;
net.divideParam.valRatio=0.25;
net.divideParam.testRatio=0.25;    
net.trainFcn = trainAlg;
%net.trainParam.max_fail=6;  
net.trainParam.max_fail=10;  
for i=1:m
    %regularization is fraction of performance associated with
    %minimizing the weights and biases of a network.  If this is set to 0
    %then only error is minimized.  If it is set greater than zero then
    %weights and biases are also minimized which can result in a smoother
    %network function with better generalization.
    %net.performParam.regularization=0.2;
    %Select patterns uniformly at random for training, validation and testing
    %[indxtrain,indxval,indxtest]=randomly_uniformlly_select_patterns(t);           
    [net,tr]=train(net,x,t);
    %==Test the Network
    testset=x(:,tr.testInd);
    testtargets=t(tr.testInd);
    y=net(testset);
    [average_rmse,rmses] = average_rmse_of_break_sizes(y,testtargets);%average of 10 break sizes
    %[average_rmse,rmses] = average_rmse_of_break_sizes2(y,testtargets);%average of 6 break sizes
    objective = average_rmse;% + std(rmses);
    if objective < bestnet_objective
    %if(average_rmse < bestnet_average_rmse)
        bestnet = net;
        bestnettr = tr;
        bestnet_average_rmse = average_rmse;
        bestnet_rmses = rmses;
        bestnet_objective=objective;
    end
    network_number=i
    average_rmse
    bestnet_average_rmse
    bestnet_rmses
    mean_rmses_of_all_networks(i)=average_rmse;
end
end

function [indxtrain,indxval,indxtest]=randomly_uniformlly_select_patterns(t)
                indxtrain0=1:270;% 50% of all break size data
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
end
