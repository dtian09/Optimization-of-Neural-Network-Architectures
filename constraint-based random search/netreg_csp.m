%constraint-based random search to find random network architectures
load 'all_break_sizes_interpolated3.csv';%all break sizes from 0% to 200% including interpolated data, BARC data and blind cases 2 3 4 5
load 'all_break_sizes_interpolated3_labels.csv';
x=all_break_sizes_interpolated3;
t=all_break_sizes_interpolated3_labels;
n=100;%number of networks to create
networks=create_nns(n);
%trainFcn = 'trainlm';
%[net,tr,bestnet_average_rmse,bestnet_rmses] = best_net(x,t,networks,trainFcn);
%bestnet_average_rmse
%bestnet_rmses
%save('bestnetreg','net');
%save('bestnetreg_tr','tr');

function networks=create_nns(n)
networks_inputs=string('[');
  for i=1:n-1
     networks_inputs=networks_inputs+string(37)+string(',');
  end
  networks_inputs=networks_inputs+string(37)+string(']');
  %constraint-based random search to find random network architectures
  %cmd='java -cp eclipse.jar;. -Declipse.directory="C:\Program Files\ECLiPSe 6.1" CallCP [15,20,30,20,18,21,20,25] networks';
  cmd=char(string('java -cp eclipse.jar;. -Declipse.directory="C:\Program Files\ECLiPSe 6.1" CallCP ')+string(networks_inputs)+string(' networks'));
  disp(cmd);
  [status,~] = system(cmd);
  if status ~= 0
     disp('CallCP ran unsuccessfully');
  end
  load networks;
end

function [bestnet,bestnettr,bestnet_average_rmse,bestnet_rmses] = best_net(x,t,networks,trainFcn)
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
for i=1:n
    network=networks(i,:);
    net = feedforwardnet([network(2) network(3) network(4)],trainFcn);
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
    if(average_rmse < bestnet_average_rmse)
       bestnet = net;
       bestnettr = tr;
       bestnet_average_rmse = average_rmse;
       bestnet_rmses = rmses; 
    end
    network_number = i
    network
    average_rmse
    bestnet_average_rmse
end
end
