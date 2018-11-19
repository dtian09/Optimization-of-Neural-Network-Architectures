function [bestnet,bestnettr,bestnet_average_rmse,bestnet_rmses] = best_singlelayer_regnet(x,t,initial_nodes,k,m,trainFcn)
%Train one or more single layer mlps with different number of hidden nodes
%Output the best network
%Inputs: x, input features
%        t, targets
%        initial_nodes
%        k, number of network topologies
%        m, number of iterations
%        trainFcn
hiddenLayerSize = initial_nodes;
bestnet = -1;
bestnettr = -1;%training record of best network
bestnet_average_rmse = 100;
bestnet_rmses = 999;
network_number = 1;
for j=1:k
    for i=1:m%train and test each network topology m times
        net = feedforwardnet(hiddenLayerSize,trainFcn);
        %net = set_weights(net);%set initial weights to between -0.5 and 0.5
        %==set normalization and data split ratios
        net.input.processFcns = {'removeconstantrows','mapminmax'};
        net.output.processFcns = {'removeconstantrows','mapminmax'};
        %net.input.processFcns = {'removeconstantrows','mapstd'};
        %net.output.processFcns = {'removeconstantrows','mapstd'};
        % Setup Division of Data for Training, Validation, Testing
        % For a list of all data division functions type: help nndivide
        net.divideFcn = 'dividerand';  %Divide data randomly
        net.divideMode = 'sample';  %Divide up every sample
        %net.divideParam.trainRatio = 0.5;
        %net.divideParam.valRatio = 0.25;
        %net.divideParam.testRatio= 0.25;
        net.divideParam.trainRatio = 0.9;
        net.divideParam.valRatio = 0.1;
        net.divideParam.testRatio= 0.1;
        net.performFcn = 'mse'; %mean squared error
        %regularization is fraction of performance associated with
        %minimizing the weights and biases of a network.  If this is set to 0
        %then only error is minimized.  If it is set greater than zero then
        %weights and biases are also minimized which can result in a smoother
        %network function with better generalization.
        %net.performParam.regularization=0.4;
        [net,tr] = train(net,x,t);
        % Test the Network
        y = net(x);
        testTargets = t .* tr.testMask{1};
        [average_rmse,rmses] = average_rmse_of_break_sizes(y,t,testTargets);
        if(average_rmse < bestnet_average_rmse)
             bestnet = net;
             bestnettr = tr;
             bestnet_average_rmse = average_rmse;
             bestnet_rmses = rmses;
        end
        network_number
        hiddenLayerSize
        average_rmse
        bestnet_average_rmse
        network_number = network_number+1;
    end
    hiddenLayerSize = hiddenLayerSize + 1;
end
end