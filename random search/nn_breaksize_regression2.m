%m=1000;%iteratively training a trained network m times to find the best one
%m=500;
m=100;
[net,tr,mean_rmse,rmses,mean_rmses] = iter_train(m);
mean_rmse
rmses
save('netreg_iterpolate','net');
save('netreg_tr_iterpolate','tr');
%load minitest.csv;
%test_net2(net,minitest);
%[y,testTargets,rmses]=test_net()
%===iterative training of a trained network
function [net,tr,mean_rmse,rmses,mean_rmses] = iter_train(m)
%load 'all_break_sizes_interpolated.csv';%all break sizes from 0% to 200% including interpolated data and BARC data
%load 'all_break_sizes_interpolated_labels.csv';
%load 'all_break_sizes_interpolated2.csv';%all break sizes from 0% to 200% including interpolated data, BARC data and blind cases 2 3 4 5 step size 5%
%load 'all_break_sizes_interpolated2_labels.csv';
load 'all_break_sizes_interpolated3.csv';%all break sizes from 0% to 200% including interpolated data, BARC data and blind cases 2 3 4 5 step size 2.5%
load 'all_break_sizes_interpolated3_labels.csv';
%load 'bestnetreg_random_search';
%load 'merged_data_blindtests2_3_4_5.csv';
%load 'bestnet_subset_random_search';
%net=bestnet;
%load 'netreg_4sept17';
%load 'netreg_iterpolate'
%load bestnetreg2
%load netreg_21feb18_5
%load netreg_20feb18_6
%load 'netreg_4sept17_interpolate'
%load 'netreg_ga15sept17';
%load 'netreg_6oct17';
%load 'netreg_ga_subset_15sept17';
%load netreg_ga_22sept17;
%load netreg_ga_subset_22sept17;
%load 'netreg_iter_learn27feb';
%load 'netreg_iter_learn5';
%load 'netreg_linear_interpolate';
%load 'netregtr_linear_interpolate';
%load 'netreg0noise2layers';
%load 'netreg_ga_mar17';
%load 'netreg_ga_mar17_subset';
%load 'netreg_2layer_ga';
%load 'netreg_2layer_ga_subset';
%load netreg_19may17;
%load netreg_22may17;
%load netreg_ga_fs_top12april;
%load netreg_ga_fs_top12april_subset;
%load mergeddata.csv;
%load minitrainnet;
%load minitrainnet_tr;
%load netreg2layer9jun17;
%load netreg_ga_fs_top_elitism_0_0125;
load netreg_ga_fs_top_subset_elitism_0_0125;
load netreg_iterpolate;
%x=mergeddata(:,1:37)';
%t=mergeddata(:,38)';
%x=merged_data_blindtests2_3_4_5(:,1:37)';
%t=merged_data_blindtests2_3_4_5(:,38)';
%x = all_break_sizes_interpolated;%mxn matrix, m no. of features, n no. of instances
%t = all_break_sizes_interpolated_labels';
%x = all_break_sizes_interpolated2;%mxn matrix, m no. of features, n no. of instances
%t = all_break_sizes_interpolated2_labels;
x = all_break_sizes_interpolated3;%mxn matrix, m no. of features, n no. of instances
t = all_break_sizes_interpolated3_labels;
x = x(net_subset,:);
%x=x(bestnet_subset,:);
%x=x([1:27,29:33,35:37],:);%exclude 28th, 34th features from the dataset (both features are considered noise as they have different value ranges for Blind_Case1_Smart.csv and the break size datasets)
%x = x([1:27,29:37],:);%exclude 28th feature from the dataset (the 28th feature is considered noise as its value range for Blind_Case1_Smart.csv is outside the range of the 28th feature in the break size datasets)
trainFcn = 'trainlm';
%net=net2;
[net,tr,mean_rmse,rmses,mean_rmses] = iter_train_network(net,x,t,m,trainFcn);
end
%===Test a trained network
function test_net2(net,minitest)
y=net(minitest(:,1:37)');
y=y';
testTargets=minitest(:,38);
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
rmse0_test = rmse(testOutputs0,testTargets0)
rmse20_test = rmse(testOutputs20,testTargets20)
rmse60_test = rmse(testOutputs60,testTargets60)
rmse100_test = rmse(testOutputs100,testTargets100)
rmse120_test = rmse(testOutputs120,testTargets120)
rmse200_test = rmse(testOutputs200,testTargets200)
average_rmse = (rmse0_test + rmse20_test + rmse60_test + rmse100_test + rmse120_test + rmse200_test)/6
end
function [y,testTargets,rmses] = test_net()
%use the test set in the training record of net to evaluate performance of net
%load 'all_break_sizes_interpolated.csv';%all break sizes from 0% to 200% including interpolated data
load 'all_break_sizes_interpolated2.csv';%all break sizes from 0% to 200% including interpolated data
%load 'all_break_sizes_interpolated_labels.csv';
load 'all_break_sizes_interpolated2_labels.csv';
%load 'netreg_increm_learn27feb';
%load 'netregtr_increm_learn27feb';
%load netreg_iter_learn5;
%load netregtr_iter_learn5;
%load netreg_4sept17_interpolate;
%load netreg_tr_4sept17_interpolate;
load netreg_ga_15sept17_interpolate;
load netreg_ga_tr_15sept17_interpolate;
load netreg_ga_subset_15sept17;
%x = all_break_sizes_interpolated;%mxn matrix, m no. of features, n no. of instances
%t = all_break_sizes_interpolated_labels';
x = all_break_sizes_interpolated2;%mxn matrix, m no. of features, n no. of instances
t = all_break_sizes_interpolated2_labels;
x = x(net_subset,:);
y = net(x);
testTargets = t .* tr.testMask{1};
testTargets = testTargets';%transpose row vector to a column vector
y = y';%transpose y to a column vector
t = t';%transpose t to a column vector
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
testTargets0 = t .* mask0_test;
testTargets20 = t .* mask20_test;
testTargets60 = t .* mask60_test;
testTargets100 = t .* mask100_test;
testTargets120 = t .* mask120_test;
testTargets200 = t .* mask200_test;
%compute rmse of each break size
rmse0_test = rmse(testOutputs0,testTargets0);
rmse20_test = rmse(testOutputs20,testTargets20);
rmse60_test = rmse(testOutputs60,testTargets60);
rmse100_test = rmse(testOutputs100,testTargets100);
rmse120_test = rmse(testOutputs120,testTargets120);
rmse200_test = rmse(testOutputs200,testTargets200);
%rmse0_test
%rmse20_test
%rmse60_test
%rmse100_test
%rmse120_test
%rmse200_test
rmses=[rmse0_test rmse20_test rmse60_test rmse100_test rmse120_test rmse200_test];
end