load 'all_break_sizes_interpolated3.csv';%all break sizes from 0% to 200% including interpolated data, BARC data and blind cases 2 3 4 5
load 'all_break_sizes_interpolated3_labels.csv';
load networks;
%network=[37 35 13];
x2=all_break_sizes_interpolated3;
t2=all_break_sizes_interpolated3_labels;
trainFcn = 'trainlm';
[net2,tr2,bestnet_average_rmse2,bestnet_rmses2,average_rmses2] = best_net(x2,t2,networks,trainFcn);
bestnet_average_rmse2
bestnet_rmses2
save('bestnetreg2','net2');
save('bestnetreg_tr2','tr2');

function [bestnet,bestnettr,bestnet_average_rmse,bestnet_rmses,average_rmses] = best_net(x,t,networks,trainFcn)
%Train 3-hidden layer mlps so that each network has same number of nodes in each hidden layer. 
%Output the best network
%Inputs: x, input features
%        t, targets
%        initial_nodes
%        k, number of network topologies
%        m, number of iterations to train each network
%        trainFcn
bestnet = -1;
bestnettr = -1;%training record of best network
bestnet_average_rmse = 100;
n=size(networks,1);
average_rmses=ones(n,1);%mean RMSE of each network
for i=1:n
    network=networks(i,:);
    net = feedforwardnet([network(2) network(3)],trainFcn);%2-hidden layer networks
    %net = feedforwardnet([network(2) network(3) network(4)],trainFcn);%3-hidden layer networks
    %net = feedforwardnet([network(2) network(3) network(4) network(5)],trainFcn);%4-hidden layer networks
   %==set normalization and data split ratios
    net.input.processFcns = {'removeconstantrows','mapminmax'};
    net.output.processFcns = {'removeconstantrows','mapminmax'};
    % Setup Division of Data for Training, Validation, Testing
    net.divideFcn = 'dividerand';  %Divide data randomly
    net.divideMode = 'sample';  %Divide up every sample
    net.divideParam.trainRatio = 0.5;
    net.divideParam.valRatio = 0.25;
    net.divideParam.testRatio= 0.25;
    net.trainParam.max_fail=6;
    net.performFcn = 'mse'; %mean squared error
    %regularization is fraction of performance associated with
    %minimizing the weights and biases of a network.  If this is set to 0
    %then only error is minimized. If it is set greater than zero then
    %weights and biases are also minimized which can result in a smoother
    %network function with better generalization.
    %net.performParam.regularization=0.2;
    [net,tr] = train(net,x,t);
    % Test the Network
    testset=x(:,tr.testInd);
    testTargets=t(tr.testInd);
    y=net(testset);
    [average_rmse,rmses] = average_rmse_of_break_sizes(y,testTargets);
    average_rmses(i)=average_rmse;
    if(average_rmse < bestnet_average_rmse)
       bestnet = net;
       bestnettr = tr;
       bestnet_average_rmse = average_rmse;
       bestnet_rmses=rmses;
    end
    network_number = i
    network
    average_rmse
    bestnet_average_rmse
end
end
