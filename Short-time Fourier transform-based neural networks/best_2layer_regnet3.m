function [bestnet,bestnettr,bestnet_average_rmse,bestnet_rmses,average_rmses_of_all_topologies] = best_2layer_regnet3(x,t,mini_nodes,max_nodes,m,trainFcn)
%Train 2-hidden layer mlps with different number of hidden nodes in each layer
%The whole data set is randomly divided into training, testing and validation sets each of which consists of consecutive patterns in the whole dataset. 
%Output the best network
%Inputs: x, input features
%        t, targets
%        mini_nodes of a hidden layer
%        max_nodes of a hidden layer
%        m, train and test each network topology m times
%        trainFcn
%h1 = initial_nodes;%hidden layer 1 size
%h2 = initial_nodes;%hidden layer 2 size
bestnet = -1;
bestnettr = -1;%training record of best network
bestnet_average_rmse = 100;
bestnet_rmses = 9999;
network_number = 1;
network_topologies=(max_nodes-mini_nodes+1)^2;
average_rmses_of_all_topologies=zeros(network_topologies,3);%best average rmse of each topology, format: [h1,h2,average_rmse;...]                                                                             
%average_rmses = [];
for h1=mini_nodes:max_nodes
    for h2=mini_nodes:max_nodes
        bestnet_average_rmse2=100;%best average rmse of a topology
        for i=1:m%train and test each network topology m times
            net = feedforwardnet([h1 h2],trainFcn);%set initial weights to random values and create a NN
            %==set normalization and data split ratios
            %net.input.processFcns = {'removeconstantrows','mapminmax'};
            %net.output.processFcns = {'removeconstantrows','mapminmax'};
            net.input.processFcns = {'removeconstantrows','mapstd'};
            net.output.processFcns = {'removeconstantrows','mapstd'};
            %==randomly divide data into training, validation and testing
            %sets
            net.divideFcn = 'dividerand';  %Divide data randomly
            net.divideMode = 'sample';  %Divide up every sample
            %net.divideParam.trainRatio=0.8;
            %net.divideParam.valRatio=0.1;
            %net.divideParam.testRatio=0.1;
            %net.divideParam.trainRatio=0.5;
            %net.divideParam.valRatio=0.25;
            %net.divideParam.testRatio=0.25;
            net.divideParam.trainRatio=0.7;
            net.divideParam.valRatio=0.15;
            net.divideParam.testRatio=0.15;
            %net.divideParam.trainRatio=0.6;
            %net.divideParam.valRatio=0.2;
            %net.divideParam.testRatio=0.2;
            net.trainParam.max_fail=6;
            net.performFcn = 'mse'; %mean squared error
            %net=select_specific_patterns(net,size(x,2));%select specified patterns as training, validation and test sets        
            [net,tr] = train(net,x,t);
            % Test the Network
            testset=x(:,tr.testInd);
            testtargets=t(tr.testInd);
            y=net(testset);
            %rmse=sqrt(perform(net,testtargets,y));%get mse of network on testset (mse is used for UCI datasets e.g. skillcraft)
            [average_rmse,rmses] = average_rmse_of_break_sizes2(y,testtargets);
            %average_rmse=rmse;
            if average_rmse < bestnet_average_rmse2
                 bestnet_average_rmse2=average_rmse;
            end
            if average_rmse < bestnet_average_rmse
                 bestnet = net;
                 bestnettr = tr;
                 bestnet_average_rmse = average_rmse;
                 bestnet_rmses = rmses;
            end
            %average_rmses = [average_rmses;average_rmse];
            network_number
            i
            [h1 h2]
            average_rmse
            bestnet_average_rmse
        end
        average_rmses_of_all_topologies(network_number,:)=[h1,h2,bestnet_average_rmse2];
        network_number = network_number+1;  
    end
end
end
%function net=select_specific_patterns(net,n)
    %n, data size
 %   pc=0.8;%training set percentage
 %  m=round(n*pc);%training set size
 %   net.divideFcn='divideind';
 %   k=round((n-m)/2);%test set size
 %   net.divideParam.trainInd=1:m;% frist 80% data for training
 %   net.divideParam.valInd=m+1:m+k;% 10% validation data
 %   net.divideParam.testInd=m+k+1:n;% 10% test data
 %   net.performFcn='mse'; %mean squared error
%end