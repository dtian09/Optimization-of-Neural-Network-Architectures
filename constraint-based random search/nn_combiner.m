%create a neural network ensemble to combine outputs of multiple neural
%networks to make a single prediction
load 'merged_data_blindtests2_3_4_5.csv';
load netreg_26feb18.mat %a 2-hidden layer network
load netreg_tr_26feb18.mat
net1=net;
tr1=tr;
load netreg_27feb18.mat %a 3-hidden layer network: 37,11,39,13,1
load netreg_tr_27feb18.mat
net2=net;
tr2=tr;
load netreg_23feb18.mat %a 4-hidden layer network: 37,11,22,11,48,1
load netreg_tr_23feb18.mat
net3=net;
tr3=tr;
%create a testset which is the union of the testsets of the models
x=merged_data_blindtests2_3_4_5(:,1:37);
t=merged_data_blindtests2_3_4_5(:,38);
testset1=x(tr1.testInd,:);
testtargets1=t(tr1.testInd);
%testset2=x(tr2.testInd,:);
%testtargets2=t(tr2.testInd);
%testset3=x(tr3.testInd,:);
%testtargets3=t(tr3.testInd);
%[testset1_2,~,~]=union([testset1 testtargets1],[testset2 testtargets2],'rows');
%[testset1_2_3,~,~]=union(testset1_2,[testset3 testtargets3],'rows');
%size_of_testset1_2_3=size(testset1_2_3,1)
%predictions of the models on the testset
%y1=net1(testset1_2_3(:,1:37)');
%y2=net2(testset1_2_3(:,1:37)');
%y3=net3(testset1_2_3(:,1:37)');
y1=net1(testset1(:,1:37)');
y2=net2(testset1(:,1:37)');
y3=net3(testset1(:,1:37)');
%y1=net1(testset2(:,1:37)');
%y2=net2(testset2(:,1:37)');
%y3=net3(testset2(:,1:37)');
%y1=net1(testset3(:,1:37)');
%y2=net2(testset3(:,1:37)');
%y3=net3(testset3(:,1:37)');
%==blind case test sets==
%load Blind_Case3_Smart.csv; %break size 75%, in RIH (0) with availability ECCS (1)
%load Blind_Case4_Smart.csv; %break size 50%, in RIH (0) with availability ECCS (1)
%load my_blind_case5.csv;%break size 160%, in RIH (0) with availability ECCS (1)
%x=Blind_Case3_Smart;
%x=Blind_Case4_Smart;
%x=my_blind_case5;
%t=ones(size(x,1),1)*75;
%t=ones(size(x,1),1)*50;
%t=ones(size(x,1),1)*160;
%y1=net1(x')';
%y2=net2(x')';
%y3=net3(x')';

%==combination strategy: mean of the outputs of the models
%y=(y1+y2+y3)/3;
%[average_rmse,rmses] = average_rmse_of_break_sizes(y,testset1_2_3(:,38)')
%[average_rmse,rmses] = average_rmse_of_break_sizes(y,testtargets1')
%[average_rmse,rmses] = average_rmse_of_break_sizes(y,testtargets2')
%[average_rmse,rmses] = average_rmse_of_break_sizes(y,testtargets3')
%==combination strategy: weighted mean of the outputs of the models
%performance on the union of testset1, testset2 and testset3
%[average_rmse1,rmses1]=average_rmse_of_break_sizes(y1,testset1_2_3(:,38)')
%[average_rmse2,rmses2]=average_rmse_of_break_sizes(y2,testset1_2_3(:,38)')
%[average_rmse3,rmses3]=average_rmse_of_break_sizes(y3,testset1_2_3(:,38)')
%performance on testset1
[average_rmse1,rmses1]=average_rmse_of_break_sizes(y1,testtargets1')
[average_rmse2,rmses2]=average_rmse_of_break_sizes(y2,testtargets1')
[average_rmse3,rmses3]=average_rmse_of_break_sizes(y3,testtargets1')
%performance on testset2
%[average_rmse1,rmses1]=average_rmse_of_break_sizes(y1,testtargets2')
%[average_rmse2,rmses2]=average_rmse_of_break_sizes(y2,testtargets2')
%[average_rmse3,rmses3]=average_rmse_of_break_sizes(y3,testtargets2')
%performance on testset3
%[average_rmse1,rmses1]=average_rmse_of_break_sizes(y1,testtargets3')
%[average_rmse2,rmses2]=average_rmse_of_break_sizes(y2,testtargets3')
%[average_rmse3,rmses3]=average_rmse_of_break_sizes(y3,testtargets3')
s=average_rmse1+average_rmse2+average_rmse3;
mean_of_average_rmse1=average_rmse1/s;
mean_of_average_rmse2=average_rmse2/s;
mean_of_average_rmse3=average_rmse3/s;
adjusted_mean_rmse1=1-mean_of_average_rmse1;
adjusted_mean_rmse2=1-mean_of_average_rmse2;
adjusted_mean_rmse3=1-mean_of_average_rmse3;
s2=adjusted_mean_rmse1+adjusted_mean_rmse2+adjusted_mean_rmse3;
w1=adjusted_mean_rmse1/s2;
w2=adjusted_mean_rmse2/s2;
w3=adjusted_mean_rmse3/s2;
y=w1*y1+w2*y2+w3*y3;%ensemble outputs
%[average_rmse,rmses]=average_rmse_of_break_sizes(y,testset1_2_3(:,38)')
[average_rmse,rmses]=average_rmse_of_break_sizes(y,testtargets1')
%[average_rmse,rmses]=average_rmse_of_break_sizes(y,testtargets2')
%[average_rmse,rmses]=average_rmse_of_break_sizes(y,testtargets3')
%==performance on a Blind Case test set
%rmse1=rmse(y1,t)
%rmse2=rmse(y2,t)
%rmse3=rmse(y3,t)
%s=rmse1+rmse2+rmse3;
%mean_of_rmse1=rmse1/s;
%mean_of_rmse2=rmse2/s;
%mean_of_rmse3=rmse3/s;
%adjusted_mean_rmse1=1-mean_of_rmse1;
%adjusted_mean_rmse2=1-mean_of_rmse2;
%adjusted_mean_rmse3=1-mean_of_rmse3;
%s2=adjusted_mean_rmse1+adjusted_mean_rmse2+adjusted_mean_rmse3;
%w1=adjusted_mean_rmse1/s2;
%w2=adjusted_mean_rmse2/s2;
%w3=adjusted_mean_rmse3/s2;
%y=w1*y1+w2*y2+w3*y3;%ensemble outputs
%[average_rmse,rmses]=average_rmse_of_break_sizes(y,testset1_2_3(:,38)')
%[average_rmse,rmses]=average_rmse_of_break_sizes(y,testtargets1')
%[average_rmse,rmses]=average_rmse_of_break_sizes(y,testtargets2')
%[average_rmse,rmses]=average_rmse_of_break_sizes(y,testtargets3')
%==performance of ensemble on Blind_Case
%RMSE=rmse(y,t)