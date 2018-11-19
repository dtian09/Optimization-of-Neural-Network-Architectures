function [bestnet,bestnettr,bestnet_average_rmse,bestnet_rmses,average_rmses_of_all_topologies] = best_2layer_regnet2(x,t,m,mini_nodes,max_nodes,trainFcn,indxtrain,indxtest,indxval)
%Train 2-hidden layer mlps with equal number of hidden nodes in each layer
%The training, validation and test sets are specified.
%Output the best network
%Inputs: x, input features
%        t, targets
%        mini_nodes
%        max_nodes
%        m, number of iterations to train each network
%        trainFcn
bestnet = -1;
bestnettr = -1;%training record of best network
bestnet_average_rmse = 100;%best average rmse of all topologies
bestnet_rmses = 9999;
network_number = 1;
network_topologies=(max_nodes-mini_nodes+1)^2;
average_rmses_of_all_topologies=zeros(network_topologies,1);%best average rmse of each topology
for h1=mini_nodes:max_nodes
  for h2=mini_nodes:max_nodes
      bestnet_average_rmse2 = 100; %best average rmse of a topology
      for i=1:m%train and test each network topology m times
        net = feedforwardnet([h1 h2],trainFcn);%set initial weights to random values and create a NN
        %==set normalization and data split ratios
        net.input.processFcns = {'removeconstantrows','mapminmax'};
        net.output.processFcns = {'removeconstantrows','mapminmax'};
        %net.input.processFcns = {'removeconstantrows','mapstd'};
        %net.output.processFcns = {'removeconstantrows','mapstd'};
        % Setup Division of Data for Training, Validation, Testing
        % For a list of all data division functions type: help nndivide
        net.divideFcn = 'divideind';%use the specified train set, validation set and test set
        net.divideParam.trainInd = indxtrain;
        net.divideParam.valInd = indxval;
        net.divideParam.testInd = indxtest;
        net.trainParam.max_fail=6;
        net.performFcn = 'mse'; %mean squared error
        %regularization is fraction of performance associated with
        %minimizing the weights and biases of a network.  If this is set to 0
        %then only error is minimized.  If it is set greater than zero then
        %weights and biases are also minimized which can result in a smoother
        %network function with better generalization.
        %net.performParam.regularization=0.1;
        [net,tr] = train(net,x,t);
        % Test the Network
        testset=x(:,tr.testInd);
        testTargets=t(tr.testInd);
        y=net(testset);
        [average_rmse,rmses] = average_rmse_of_break_sizes2(y,testTargets);
        if average_rmse < bestnet_average_rmse2
            bestnet_average_rmse2=average_rmse;
        end
        if average_rmse < bestnet_average_rmse
             bestnet = net;
             bestnettr = tr;
             bestnet_average_rmse = average_rmse;
             bestnet_rmses = rmses;
        end
        network_number
        [h1 h2]
        i
        average_rmse
        bestnet_average_rmse
      end
      average_rmses_of_all_topologies(network_number)=bestnet_average_rmse2;
      network_number = network_number+1;  
  end
end
end