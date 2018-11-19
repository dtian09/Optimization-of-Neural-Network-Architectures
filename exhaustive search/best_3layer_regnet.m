function [bestNetwork,bestNettr] = best_3layer_regnet(x,t,initial_nodes,k,m,trainFcn)
%Train 3-hidden layer mlps so that each network has same number of nodes in each hidden layer. 
%Output the best network
%Inputs: x, input features
%        t, targets
%        initial_nodes
%        k, number of network topologies
%        m, number of iterations to train each network
%        trainFcn
h1 = initial_nodes;%hidden layer 1 size
h2 = initial_nodes;%hidden layer 2 size
h3 = initial_nodes;%hidden layer 3 size
bestNetwork = -1;
bestNettr = -1;%training record of best network
best_average_rmse = 100;
network_number = 1;
for j=1:k
    for i=1:m%train and test each network topology m times
        net = feedforwardnet([h1 h2 h3],trainFcn);
        %net = set_weights(net);%set initial weights to between -0.5 and 0.5
        %==set normalization and data split ratios
        net.input.processFcns = {'removeconstantrows','mapminmax'};
        net.output.processFcns = {'removeconstantrows','mapminmax'};
        %net.input.processFcns = {'removeconstantrows','mapstd'};
        %net.output.processFcns = {'removeconstantrows','mapstd'};
        % Setup Division of Data for Training, Validation, Testing
        net.divideFcn = 'dividerand';  %Divide data randomly
        net.divideMode = 'sample';  %Divide up every sample
        net.divideParam.trainRatio = 0.5;
        net.divideParam.valRatio = 0.25;
        net.divideParam.testRatio= 0.25;
        net.performFcn = 'mse'; %mean squared error
        %regularization is fraction of performance associated with
        %minimizing the weights and biases of a network.  If this is set to 0
        %then only error is minimized.  If it is set greater than zero then
        %weights and biases are also minimized which can result in a smoother
        %network function with better generalization.
        net.performParam.regularization=0.2;
        [net,tr] = train(net,x,t);
        % Test the Network
        y = net(x);
        testTargets = t .* tr.testMask{1};
        average_rmse = average_rmse_of_break_sizes(y,t,testTargets);
        if(average_rmse < best_average_rmse)
             bestNetwork = net;
             bestNettr = tr;
             best_average_rmse = average_rmse;
        end
        network_number = network_number+1
        [h1 h2 h3]
        average_rmse
        best_average_rmse
    end
    h1 = h1 + 1;
    h2 = h2 + 1;
    h3 = h3 + 1;
end
end