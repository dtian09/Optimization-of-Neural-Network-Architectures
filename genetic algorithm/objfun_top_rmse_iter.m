function [objs, bestnet, bestnettr, bestnet_rmses, bestnet_top] = objfun_top_rmse_iter(topologies,x,t)
%compute the objective function to find optimal irregular NN topologies: 
%         average rmse of all break sizes + standard deviation of rmse
%inputs:  topologies, a population of chromosomes (mxn matrix) representing m topologies. 
%         x, a mxn data matrix with m the features, n the instances 
%         t, a 1xn targets vector with n instances
%Use iterative training of networks to find optimal network
objs = ones(size(topologies,1),1).*888;
bestobj=100;
bestnet=-1;
bestnettr=-1;
bestnet_rmses = 999;
bestnet_top = -1;
for i=1:size(topologies,1)
    %each NN topology is represented using a 8 bit chromosome (1st 4 bits represent nodes in 1st hidden layer)
    %                                                         (2nd 4 bits represent nodes in 2nd hidden layer)
    %max nodes in 1st layer: 15
    %max nodes in 2nd layer: 15
    top = topologies(i,:);
    %get nodes in the 1st hidden layer 
    wbin=top(1,1:4);
    wbin=num2str(wbin);
    h1=bin2dec(wbin); 
    %get nodes in the 2nd hidden layer 
    wbin=top(1,5:8);
    wbin=num2str(wbin);
    h2=bin2dec(wbin);
    if h1==0
       h1
    elseif h2==0
       h2
    else    
        trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.
        net = feedforwardnet([h1 h2],trainFcn);%set initial weights to random values and create a NN
        net.input.processFcns = {'removeconstantrows','mapminmax'};
        net.output.processFcns = {'removeconstantrows','mapminmax'};
        net.divideFcn = 'dividerand';
        net.divideMode = 'sample'; 
        net.divideParam.trainRatio = 0.5;
        net.divideParam.valRatio = 0.25;
        net.divideParam.testRatio= 0.25;
        net.performFcn = 'mse';
        %train the network iteratively
        m=10;
        [net,tr,average_rmse,rmses,~] = iter_train_network(net,x,t,m,trainFcn);
        obj = average_rmse + std(rmses);
        objs(i) = obj;
        if obj < bestobj
            bestobj = obj;
            bestnet = net;
            bestnettr = tr;
            bestnet_rmses = rmses;
            bestnet_top = [h1 h2];
        end
    end
end
end