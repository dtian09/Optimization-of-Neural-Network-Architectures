%load mergeddata.csv;
%load reduced_mergeddata.csv;
%load mergeddatalabels.csv;%6 columns labels
%load minitrain996.csv;
%load minitrain1092.csv
%load minitest2155.csv
%load 'merged_data_blindtests2_3_4_5.csv';
%load SkillCraft1_Dataset_no_missing.csv;
%x=SkillCraft1_Dataset_no_missing(:,2:19)';
%t=SkillCraft1_Dataset_no_missing(:,1)';%output variable: leagueindex
%load cbm_data.txt %UCI CBM data.txt 
%x=cbm_data(:,1:16)';
%t=cbm_data(:,18)';%output: GT Turbine decay state coefficient
%mergeddata = addnoise(mergeddata,0.1,3);%add gaussian noise to original data and merge the noise data with original data before training, validation and testing
%mergeddata = addnoise(mergeddata,0.3,3);%add gaussian noise to original data and merge the noise data with original data before training, validation and testing
%x = mergeddata(:,1:37);%transpose the inputs so that rows are features, columns are instances
%x = mergeddata(:,[1:27,29:33,35:37])';%exclude 28th, 34th features from the dataset (both features are considered noise as they have different value ranges for Blind_Case1_Smart.csv and the break size datasets)
%x = mergeddata(:,[1:27,29:37])';%exclude 28th feature from the dataset (the 28th feature is considered noise as its value range for Blind_Case1_Smart.csv is outside the range of the 28th feature in the break size datasets)
%t = mergeddata(:,38);%transpose the last column (targets) to a row vector
%x = merged_data_blindtests2_3_4_5(:,1:37)';
%t = merged_data_blindtests2_3_4_5(:,38)';
%x = reduced_mergeddata';
%t = mergeddatalabels';
%x=minitrain996(:,1:37)';
%t=minitrain996(:,38)';
% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
%x=minitrain1092(:,1:37);
%t=minitrain1092(:,38);
%x2=minitest2155(:,1:37);
%t2=minitest2155(:,38);
%data=[x;x2];
%label=[t;t2];
%trainindx=1:1092;
%valindx=1:1092;
%testindx=1093:size(data,1);
%testindx=1093:1093+1077;
%valindx=1093+1078:size(data,1);
%testindx=1093:size(data,1);
%valindx=testindx;
%trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.
%mini_nodes=1;
%mini_nodes=12;
%mini_nodes=5;
%mini_nodes=8;
%max_nodes=8;
%max_nodes=9;
%max_nodes=10;
%max_nodes=12;
%max_nodes=20;
%max_nodes=7;
%max_nodes=15;
%max_nodes=30;
%max_nodes=40;
%m=10;%each network architecture is trained m times
%[net,tr,mean_rmse,rmses,topologies_average_rmses] = best_singlelayer_regnet2(x,t,mini_nodes,max_nodes,m,trainFcn);
%[net,tr,mean_rmse,rmses] = best_2layer_regnet(x,t,mini_nodes,k,m,trainFcn);
%[net,tr,mean_rmse,rmses,average_rmses_of_all_topologies] = best_2layer_regnet2(data',label',m,mini_nodes,max_nodes,trainFcn,trainindx,testindx,valindx);
%[net,tr,mean_rmse,rmses,average_rmses_of_all_topologies] = best_2layer_regnet3(x',t',mini_nodes,max_nodes,m,trainFcn);
%[net,tr,mean_rmse,rmses,topologies_average_rmses] = best_2layer_regnet4(x,t,mini_nodes,max_nodes,m,trainFcn);
%[indxtrain,~] = getIndices(minitrain,mergeddata);
%[indxval,~] = getIndices(minitest,mergeddata);
%indxtest=[];
%save('bestnetreg','net');
%save('bestnetreg_tr','tr');
%rmses
%mean_rmse
%average_rmses_of_all_topologies
%csvwrite('all_topologies_average_rmses.csv',average_rmses_of_all_topologies);
%mini_subset_size=5;
%max_subset_size=36;
%max_subset_size=17;
%m=24000;
%[bestnet,bestnettr,bestnet_subset,bestnet_top,bestnet_average_rmse,bestnet_obj,bestnet_rmses,topologies_average_rmses,objs] =best_random_2layer_regnet_less_than_all_inputs(x,t,mini_subset_size,max_subset_size,mini_nodes,max_nodes,m,trainFcn);
%save('bestnetreg_random','bestnet');
%save('bestnetreg_tr_random','bestnettr');
%save('bestnet_subset_random','bestnet_subset');
%csvwrite('bestnet_rmses_random.csv',bestnet_rmses);
%csvwrite('topologies_netreg_random.csv',topologies_average_rmses);
%csvwrite('objs_random.csv',objs);
%bestnet_obj
%bestnet_average_rmse
%bestnet_rmses
%bestnet_top

load mergeddata.csv;
%load minitest.csv;
%load minitest2155.csv;
%load test50percent.csv;
%load minitrainnet5jun17.mat;
%load bestnetreg_50percent_of_minitrainset
load bestnetreg_50percent_of_transientdata
load bestnetreg_50percent_of_transientdata_tr
net=net2;
tr=tr2;
x=mergeddata;
testset=x(tr.testInd,:);
%[rmse0_test,rmse20_test,rmse60_test,rmse100_test,rmse120_test,rmse200_test,average_rmse]=testnet(net,minitest2155)
[rmse0_test,rmse20_test,rmse60_test,rmse100_test,rmse120_test,rmse200_test,average_rmse]=testnet(net,testset)
%load Blind_Case1_Smart.csv;
%load Blind_Case2_Smart.csv;
%load Blind_Case3_Smart.csv;
%load Blind_Case4_Smart.csv;
%y1=net(Blind_Case1_Smart')';
%y2=net(Blind_Case2_Smart')';
%y3=net(Blind_Case3_Smart')';
%y4=net(Blind_Case4_Smart')';

function [rmse0_test,rmse20_test,rmse60_test,rmse100_test,rmse120_test,rmse200_test,average_rmse]=testnet(net,testdata)
y=net(testdata(:,1:37)');
y=y';
testTargets=testdata(:,38);
mask0_test =  create_mask(testTargets,0);
mask20_test =  create_mask(testTargets,20);
mask60_test = create_mask(testTargets,60);
mask100_test = create_mask(testTargets,100);
mask120_test = create_mask(testTargets,120);
mask200_test = create_mask(testTargets,200);
%Get network outputs of test set
testOutputs0 = y .* mask0_test;
testOutputs20 = y .* mask20_test;
testOutputs60 = y .* mask60_test;
testOutputs100 = y .* mask100_test;
testOutputs120 = y .* mask120_test;
testOutputs200 = y .* mask200_test;
testTargets0 = testTargets .* mask0_test;
testTargets20 = testTargets .* mask20_test;
testTargets60 = testTargets .* mask60_test;
testTargets100 = testTargets .* mask100_test;
testTargets120 = testTargets .* mask120_test;
testTargets200 = testTargets .* mask200_test;
rmse0_test = rmse(testOutputs0,testTargets0);
rmse20_test = rmse(testOutputs20,testTargets20);
rmse60_test = rmse(testOutputs60,testTargets60);
rmse100_test = rmse(testOutputs100,testTargets100);
rmse120_test = rmse(testOutputs120,testTargets120);
rmse200_test = rmse(testOutputs200,testTargets200);
average_rmse = (rmse0_test + rmse20_test + rmse60_test + rmse100_test + rmse120_test + rmse200_test)/6;
end