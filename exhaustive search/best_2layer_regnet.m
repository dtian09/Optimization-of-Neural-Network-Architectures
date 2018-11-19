function [bestnet,bestnettr,bestnet_average_rmse,bestnet_rmses] = best_2layer_regnet(x,t,initial_nodes,k,m,trainFcn)
%Train 2-hidden layer mlps with equal number of hidden nodes in each layer
%The whole data set is randomly divided into training, testing and validation sets each of which consists of consecutive patterns in the whole dataset. 
%Output the best network
%Inputs: x, input features
%        t, targets
%        initial_nodes
%        k, number of network topologies
%        m, number of iterations to train each network
%        trainFcn
h1 = initial_nodes;%hidden layer 1 size
h2 = initial_nodes;%hidden layer 2 size
bestnet = -1;
bestnettr = -1;%training record of best network
bestnet_average_rmse = 100;
bestnet_rmses = 9999;
network_number = 1;
for j=1:k
    for i=1:m%train and test each network topology m times
        net = feedforwardnet([h1 h2],trainFcn);%set initial weights to random values and create a NN
        %==set normalization and data split ratios
        net.input.processFcns = {'removeconstantrows','mapminmax'};
        net.output.processFcns = {'removeconstantrows','mapminmax'};
        %net.input.processFcns = {'removeconstantrows','mapstd'};
        %net.output.processFcns = {'removeconstantrows','mapstd'};
        % Setup Division of Data for Training, Validation, Testing
        % For a list of all data division functions type: help nndivide
        net.divideFcn = 'dividerand';  %Divide data randomly
        net.divideMode = 'sample';  %Divide up every sample
        net.divideParam.trainRatio = 0.8;
        net.divideParam.valRatio = 0.1;
        net.divideParam.testRatio= 0.1;
        %net.divideParam.trainRatio = 0.5;
        %net.divideParam.valRatio = 0.25;
        %net.divideParam.testRatio= 0.25;
        net.trainParam.max_fail=10;
        net.performFcn = 'mse'; %mean squared error
        %regularization is fraction of performance associated with
        %minimizing the weights and biases of a network.  If this is set to 0
        %then only error is minimized.  If it is set greater than zero then
        %weights and biases are also minimized which can result in a smoother
        %network function with better generalization.
        %net.performParam.regularization=0.1;
        [net,tr] = train(net,x,t);
        % Test the Network
        y = net(x);
        testTargets = t .* tr.testMask{1};
        [average_rmse,rmses] = average_rmse_of_break_sizes(y,t,testTargets);
        if average_rmse < bestnet_average_rmse
             bestnet = net;
             bestnettr = tr;
             bestnet_average_rmse = average_rmse;
             bestnet_rmses = rmses;
        end
        network_number
        [h1 h2]
        average_rmse
        bestnet_average_rmse
        network_number = network_number+1;
    end
    h1 = h1 + 1;
    h2 = h2 + 1;
end
end