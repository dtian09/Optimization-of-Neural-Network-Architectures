function [bestnet,bestnettr,bestnet_average_rmse,bestnet_rmse,mean_rmse_of_all_networks] = iter_train_network2(net,x,t,m,trainAlg)
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
bestnet_average_rmse = 999;%dummy value
bestnet_rmse = 100;
mean_rmse_of_all_networks = 999;%dummy value
%n=size(x,2);
%pc=0.8;%training set percentage
%pc=0.5;%training set percentage
%q=round(n*pc);%training set size
%k=round((n-q)/2);%test set size
for i=1:m
    %==use first part of data for training, 2nd part for validation and last
    %part for testing
    %net.divideFcn='divideind';
    %net.divideParam.trainInd=1:q;% 80% training data
    %net.divideParam.valInd=q+1:q+k;% 10% validation data
    %net.divideParam.testInd=q+k+1:n;% 10% test data
    %==random split data
    net=random_split(net);
    [net,tr] = train(net,x,t);
    %==Test the Network
    testset=x(:,tr.testInd);
    testtargets=t(tr.testInd);
    y=net(testset);
    rmse=sqrt(perform(net,testtargets,y));
    if rmse < bestnet_rmse
        bestnet = net;
        bestnettr = tr;
        bestnet_rmse = rmse;
    end
    i
    rmse
end
end
function net=random_split(net)
        net.divideFcn = 'dividerand';
        net.divideMode = 'sample'; 
        net.divideParam.trainRatio = 0.5;
        net.divideParam.valRatio = 0.25;
        net.divideParam.testRatio= 0.25;
        net.performFcn = 'mse';
end