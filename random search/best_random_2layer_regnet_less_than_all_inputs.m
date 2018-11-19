function [bestnet,bestnettr,bestnet_subset,bestnet_top,bestnet_average_rmse,bestnet_obj,bestnet_rmses,topologies_average_rmses,objs] = best_random_2layer_regnet_less_than_all_inputs(x,t,mini_size,max_size,mini_nodes,max_nodes,m,trainFcn)
%Train randomly created 2-hidden layer mlps with < 37 inputs and mini_nodes to max_nodes in each layer
%The training, validation and test patterns are selected randomly and uniformly over the whole data set (60s duration)
%Output the best network
%Inputs: x, input features
%        t, targets
%        mini_size, mini subset size
%        max_size, max subset size
%        mini_nodes
%        max_nodes
%        m, total number of network architectures
%        trainFcn
bestnet = -1;
bestnettr = -1;%training record of best network
bestnet_top=-1;
bestnet_subset=-1;
bestnet_rmses = 9999;
bestnet_obj=100;
bestnet_average_rmse=100;
topologies_average_rmses =zeros(m,3);
objs=zeros(m,1);
for i=1:m
            subset_size=randi([mini_size,max_size],1,1);
            %fs_indx=randperm(37,subset_size);
            fs_indx=randperm(18,subset_size);
            x2=x(fs_indx,:);
            h1=randi([mini_nodes,max_nodes],1,1);
            h2=randi([mini_nodes,max_nodes],1,1);             
            net = feedforwardnet([h1 h2],trainFcn);%set initial weights to random values and create a NN
            %net.input.processFcns = {'removeconstantrows','mapminmax'};
            %net.output.processFcns = {'removeconstantrows','mapminmax'};
            net.input.processFcns = {'removeconstantrows','mapstd'};
            net.output.processFcns = {'removeconstantrows','mapstd'};
            net.trainParam.max_fail=6;
            net.performFcn = 'mse'; %mean squared error
            %net=random_split(net);
            %net=select_patterns_uniformly_at_random(net,t);
            net=select_specific_patterns(net,size(x2,2));%select specified patterns as training, validation and test sets        
            [net,tr] = train(net,x2,t);
            % Test the Network
            testset=x2(:,tr.testInd);
            testtargets=t(tr.testInd);
            y=net(testset);
            %[average_rmse,rmses] = average_rmse_of_break_sizes(y,testtargets);
            %obj=average_rmse;                        %average_rmse+std(rmses);
            %objs(i)=obj;
            rmse=sqrt(perform(net,testtargets,y));%get mse of network on testset (mse is used for UCI datasets e.g. skillcraft)
            obj=rmse;                        
            objs(i)=obj;
            if obj < bestnet_obj
                    bestnet_obj = obj;
                    bestnet_average_rmse=rmse;
                    bestnet = net;
                    bestnettr = tr;
                    %bestnet_rmses = rmses;
                    bestnet_top = [subset_size h1 h2];
                    bestnet_subset = fs_indx;
            end
            topologies_average_rmses(i,:)=[subset_size h1 h2];
            %average_rmses = [average_rmses;average_rmse];
            i
            %[subset_size h1 h2]
            %average_rmse
            bestnet_obj
end
end
function net=select_specific_patterns(net,n)
    %n, data size
    pc=0.8;%training set percentage
    m=round(n*pc);%training set size
    net.divideFcn='divideind';
    k=round((n-m)/2);%test set size
    net.divideParam.trainInd=1:m;% frist 80% data for training
    net.divideParam.valInd=m+1:m+k;% 10% validation data
    net.divideParam.testInd=m+k+1:n;% 10% test data
    net.performFcn='mse'; %mean squared error
end
function net=random_split(net)
        net.divideFcn = 'dividerand';
        net.divideMode = 'sample'; 
        net.divideParam.trainRatio = 0.5;
        net.divideParam.valRatio = 0.25;
        net.divideParam.testRatio= 0.25;
        net.performFcn = 'mse';
end
function net=select_patterns_uniformly_at_random(net,t)
%Select patterns randomly and uniformly for training, validation and testing
                indxtrain0=1:270;% 50% of all data
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
                net.divideFcn = 'divideind';
                net.divideParam.trainInd = indxtrain;
                net.divideParam.valInd = indxval;
                net.divideParam.testInd = indxtest;
                net.trainParam.max_fail=10;
                net.performFcn = 'mse'; %mean squared error
end