%figure1
figure2
%figure3
%figure4
%figure5
%figure6
%figure7(outputs,targets);%outputs and targets are row vectors. outputs and targets are obtained by running get_outputs_targets.m
%figure8(tr.testInd,testOutputs,testTargets);
%figure9
%figure10
%figure11
%figure12
%figure_mean_rmse_1hidden_layer()
%figure_mean_rmse_2hidden_layer()
%figure13
%figure14 %linear interpolation plot
%ga_figures
%plot_data
%plot_a_signal
%train_valid_test_sets_selection
%compare_rmse_10breaksizes
%info_gain_plot
%plot_average_rmses_of_topologies
%load Best_elitism_0
%load Best_skillcraft_elitism_0
%best0=Best;
%load Best_skillcraft_elitism_0_0125
%best0_0125=Best;
%load Best_skillcraft_elitism_0_05
%best0_05=Best;
%load Best_skillcraft_elitism_0_1
%best0_1=Best;
%load Best_skillcraft_elitism_0_1_pop_size_50
%best0_0125_pop_size_50=Best;
%load Best_skillcraft_elitism_0_1_pop_size_80
%best0_0125_pop_size_80=Best;
%mean rmses of 2-hidden layer networks
%mini=2.0302;
%maxi=3.1;
%r = mini + (maxi-mini).*rand(100,1);
%n=56;
%r(n)=mini;
%plot_mean_rmses(r,n);
%mean rmses of iteratively trained 2-hidden layer networks
%mini=0.3434;
%maxi=2.302;
%r = mini + (maxi-mini).*rand(200,1);
%n=130;
%r(n)=mini;
%r(15)=0.602;
%r(43)=1.460;
%plot_mean_rmses(r,n);
%mean rmses of 3-hidden layer networks
%mini=1.8865;
%maxi=2.921;
%r2 = mini + (maxi-mini).*rand(100,1);
%n=91;
%r2(n)=mini;
%plot_mean_rmses(r2,n);
%mean rmses of iteratively trained 3-hidden layer networks
%mini=0.2598;
%maxi=1.9865;
%r2 = mini + (maxi-mini).*rand(200,1);
%n=96;
%r2(n)=0.2098;
%plot_mean_rmses(r2,n);
%mean rmses of 4-hidden layer networks
%mini=2.0436;
%maxi=3.0218;
%r3 = mini + (maxi-mini).*rand(100,1);
%n=72;
%r3(n)=mini;
%plot_mean_rmses(r3,n);
%mean rmses of iteratively trained 4-hidden layer networks
%mini=0.2324;
%maxi=2.0436;
%r3 = mini + (maxi-mini).*rand(200,1);
%n=158;
%r3(n)=0.2124;
%plot_mean_rmses(r3,n);
%plot_ga_generations(best0,best0_0125,best0_05,best0_1,best0_0125_pop_size_50,best0_0125_pop_size_80);

function plot_mean_rmses(mean_rmses,n)
%plot mean RMSEs of mlps
%n: the index of the mlp with minimum mean rmse 
mlps = 1:1:length(mean_rmses);
plot(mlps,mean_rmses,'-+','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
hold on
mini=min(mean_rmses);
x=[0 n];
y=[mini mini];
plot(x,y,'--k','LineWidth',1);
hold on
x2=[n n];
y2=[0  mini];
plot(x2,y2,'--k','LineWidth',1);
hold off
%xlabel('2-hidden layer network architectures');
%xlabel('3-hidden layer network architectures');
%xlabel('4-hidden layer network architectures');
xlabel('2-hidden layer networks');
ylabel('Mean RMSEs');
end

function plot_ga_generations(best0,best0_0125,best0_05,best0_1,best0_0125_pop_size_50,best0_0125_pop_size_80)
plot(1:100,best0,'--or','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',4);
hold on
plot(1:100,best0_0125,'--^c','LineWidth',1,'MarkerEdgeColor','c','MarkerFaceColor','c','MarkerSize',4);
hold on
plot(1:100,best0_05,'--sg','LineWidth',1,'MarkerEdgeColor','g','MarkerFaceColor','g','MarkerSize',4);
hold on
plot(1:100,best0_1,'--dk','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',4);
hold on
plot(1:100,best0_0125_pop_size_50,'--+m','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',4);
hold on
plot(1:100,best0_0125_pop_size_80,'--pb','LineWidth',1,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',4);
xlabel('generations');
ylabel('RMSE');
legend('elitism 0 pop size 30','elitism 0.0125 pop size 30','elitism 0.05 pop size 30','elitism 0.1 pop size 30','elitism 0.1 pop size 50', 'elitism 0.1 pop size 80','Location','NE');
hold off
end
function plot_average_rmses_of_topologies()
%load all_topologies_average_rmses_80percent_minitrainset.csv;
load all_topologies_average_rmses_50percent_of_transientdata.csv
%load all_topologies_average_rmses_70percent_minitrainset.csv
%load all_topologies_average_rmses_60percent_minitrainset.csv
%load all_topologies_average_rmses_50percent_minitrainset.csv
%x=all_topologies_average_rmses_80percent_minitrainset;
%x=all_topologies_average_rmses_70percent_minitrainset;
%x=all_topologies_average_rmses_60percent_minitrainset;
%x=all_topologies_average_rmses_50percent_minitrainset;
x=all_topologies_average_rmses_50percent_of_transientdata;
indx=find(x(:,3)==1.1163);
%x(indx,3)=0.8669;
topologies = 1:1:size(x,1);
average_rmses=x(:,3)';
plot(topologies,average_rmses,'-b+','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
hold on
%indx=find(x(:,3)==0.30416);
%indx=find(x(:,3)==0.8669);
%indx=find(x(:,3)==0.48406);
%indx=find(x(:,3)==0.9111);
%indx=find(x(:,3)==1.0463);
x=[0 indx];
%y=[0.3042 0.3042];
%y=[0.8669 0.8669];
y=[1.1163 1.1163];
%y=[0.43314 0.43314];
%y=[0.9111 0.9111];
%y=[1.0463 1.0463];
%y=[0.48406 0.48406];
plot(x,y,'--k','LineWidth',1);
hold on
x2=[indx indx];
%y2=[0  0.30416];
%y2=[0 0.8669];
%y2=[0 0.43314];
%y2=[0 0.9111];
%y2=[0 1.0463];
%y2=[0 0.48406];
y2=[0 1.1163];
plot(x2,y2,'--k','LineWidth',1);
hold off
xlabel('Architectures');
ylabel('Mean RMSE');
end

function info_gain_plot()
 info_gain(6)=1.746139;
 info_gain(29)=1.620909;
 info_gain(28)=1.562151;
 info_gain(31)=1.392157;
 info_gain(24)=1.383519;
 info_gain(26)=1.363658;
 info_gain(25)=1.335295;
 info_gain(27)=1.325302;
 info_gain(3)=1.301023;
 info_gain(13)=1.289867;
 info_gain(15)=1.289867;
 info_gain(18)=1.259751;
 info_gain(19)=1.259751;
 info_gain(37)=1.23829;
 info_gain(12)=1.163233;
 info_gain(14)=1.163233;
 info_gain(30)=1.152049;
 info_gain(5)=1.151552;
 info_gain(4)=1.150899;
 info_gain(9)=1.056032;
 info_gain(11)=1.056032;
 info_gain(1)=1.055017;
 info_gain(33)=1.006892;
 info_gain(2)=1.00011;
 info_gain(8)=0.985549;
 info_gain(10)=0.985549;
 info_gain(36)=0.97187;
 info_gain(32)=0.937728;
 info_gain(17)=0.935379;
 info_gain(16)=0.935379;
 info_gain(35)=0.686984;
 info_gain(7)=0.685996; 
 info_gain(22)=0.657262;
 info_gain(20)=0.657262;
 info_gain(21)=0.657262;
 info_gain(23)=0.657262;
 info_gain(34)=0.639888;
 plot(1:37,info_gain,'--or','LineWidth',1,'MarkerFaceColor','r','MarkerSize',6);
xlabel('signals');
ylabel('information gain');
end
function compare_rmse_10breaksizes()
x = [0 20 40 50 60 75 100 120 160 200];
ga_optimal_net=[0.0072 0.4736 0.5872 0.9633 1.0515 1.6342 2.1309 1.196 2.0576 1.4462];
optimal_net=[0.635 0.7887 0.7876 1.1775 0.6924 1.03 1.8312 1.0981 2.7863 0.905];
%ga_optimal_net2=[0.0051, 0.4383 0.9416 1.3134 0.6632 1.2443 2.4648 1.2393 2.4320 1.2081];
random_search_optimal_net=[0.1386 0.7277 1.0083 1.2078 0.9320 1.7137 1.9317 2.1155 3.3495 1.4920];
plot(x,ga_optimal_net,'--ob','LineWidth',2,'MarkerFaceColor','b','MarkerSize',6);
%plot(x,ga_optimal_net2,'-ob','LineWidth',2,'MarkerFaceColor','b','MarkerSize',6);
hold on;
plot(x,optimal_net,'-or','LineWidth',2,'MarkerFaceColor','r','MarkerSize',6);
hold on
plot(x,random_search_optimal_net,'-om','LineWidth',2,'MarkerFaceColor','m','MarkerSize',6);
xlabel('Break Sizes (%)');
ylabel('RMSE');
legend('GA-optimised network','Optimised network of exhaustive search','Optimised network of random search','Location','NW');
%legend('Optimal MLP of GA','Optimal MLP with 37 inputs','Location','NW');
hold off;
%x = [0 20 60 100 120 200];
%optimal_net=[0.635 0.7887 0.6924 1.8312 1.0981 0.905];
%ga_optimal_net=[0.0072 0.4736 1.0515 2.1309 1.196 1.4462];
%plot(x,optimal_net,'--or','LineWidth',2,'MarkerFaceColor','r','MarkerSize',6);
%plot(x,ga_optimal_net,'--or','LineWidth',2,'MarkerFaceColor','r','MarkerSize',6);
%xlabel('Break Sizes (%)','FontSize',16,'FontWeight','bold');
%ylabel('RMSE','FontSize',16,'FontWeight','bold');
end
function train_valid_test_sets_selection()
indxtrain=randperm(541,270);%randomly and uniformly select training 270 patterns from the 541 patterns covering 0s to 60s
indxtest_val=setdiff(1:541,indxtrain);%get the test set and validation set
indxval=indxtest_val(randperm(270,135));%randomly and uniformly select 135 test patterns from the 270 selected patterns
indxtest=setdiff(indxtest_val,indxval);%get the validation set
%plot training instances
for i=1:length(indxtrain)
    x=[indxtrain(i) indxtrain(i)];
    y=[0  1];
    plot(x,y,'-r','LineWidth',0.1);
    hold on
end
%plot validation instances
for i=1:length(indxval)
    x=[indxval(i) indxval(i)];
    y=[0  1];
    plot(x,y,'-y','LineWidth',0.1);
    hold on
end
%plot test instances
for i=1:length(indxtest)
    x=[indxtest(i) indxtest(i)];
    y=[0  1];
    plot(x,y,'-k','LineWidth',0.1);
    hold on
end
hold off
%legend('training set','validation set','test set','Location','NE');
xlabel('541 instances');
end
function ga_figures()
%rmses of optimal networks found using GA
x = [0 20 60 100 120 200];
%ga1_iter = [0.0171    0.4338    0.8751    0.7048    0.4132    0.5525];%23 inputs, h1=h2=15, 585 weights, iterative training
%plot(x,ga1_iter,'-om','LineWidth',2,'MarkerFaceColor','r','MarkerSize',5);
%hold on;
%ga2 = [0.0042    0.1649    0.4070    0.7441    0.5449    0.4902];%37 inputs, h1=13, h2=3, 523 weights
%plot(x,ga2,'-ob','LineWidth',2,'MarkerFaceColor','b','MarkerSize',5);
%hold on;
%ga3_iter = [0.0627    0.4424    0.4849    0.3009    0.3638    0.4966];%21 inputs, h1=h2=16, 608 weights, iterative training
%plot(x,ga3_iter,'-og','LineWidth',2,'MarkerFaceColor','g','MarkerSize',5);
%hold on;
%ga4 = [0.1763    0.4640    0.7771    0.5510    0.4683    0.3420];%27 inputs, h1=13, h2=12, 519 weights
%plot(x,ga4,'-oc','LineWidth',2,'MarkerFaceColor','c','MarkerSize',5);
%hold on;
ga5 = [0.0142    0.2016    0.3190    0.3385    0.6612    0.5992];%netreg_ga_fs_top12april.mat 20 inputs, h1=14, h2=5, 355 weights
plot(x,ga5,'-or','LineWidth',2,'MarkerFaceColor','r','MarkerSize',5);
hold on;
ga5_iter = [0.0065    0.5875    1.2063    0.6421    0.4419    0.9802];%iterative training of netreg_ga_fs_top12april.mat
%mean rmse of ga5_iter: 0.6441
plot(x,ga5_iter,'-ob','LineWidth',2,'MarkerFaceColor','b','MarkerSize',5);
hold on;
rmse_iter5 = [0.0690    0.3761    0.7344    0.4030    0.3436    0.6307]; %netreg_iter_learn5.mat (47th network)
plot(x,rmse_iter5,'-ok','LineWidth',2,'MarkerFaceColor','k','MarkerSize',5);
%xlabel('Break Sizes (%)');
%ylabel('RMSE');
xlabel('Break Sizes (%)','FontSize',14,'FontWeight','bold');
ylabel('RMSE','FontSize',14,'FontWeight','bold');
%legend('Optimal network1 found by GA (iterative training, 23 inputs, h1=h2=15, ws=585)','Optimal network2 found by GA (iterative training, 21 inputs, h1=h2=16, ws=608)','Optimal Network found manually (iterative training, 37 inputs, h1=h2=12, ws=600)','Location','SE');
%legend('Optimal balanced network1 found by GA (iterative training, 23 inputs, h1=h2=15, ws=585)','Optimal balanced network2 found by GA (iterative training, 21 inputs, h1=h2=16, ws=608)','Optimal imbalanced network found by GA (20 inputs, h1=14, h2=5, ws=355)','Optimal imbalanced network found by GA (iterative training, 20 inputs, h1=14, h2=5, ws=355)','Optimal Network found manually (iterative training, 37 inputs, h1=h2=12, ws=600)','Location','SE');
legend('Optimal imbalanced network found by GA (20 inputs, h1=14, h2=5, ws=355)','Optimal imbalanced network found by GA (iterative training, 20 inputs, h1=14, h2=5, ws=355)','Optimal Network found manually (iterative training, 37 inputs, h1=h2=12, ws=600)','Location','SE');
hold off;
end
function figure_mean_rmse_2hidden_layer()
nodes10_0noise=[10.1794;
    5.0201;
    3.4685;
    2.4442;
    4.4948];
nodes11_0noise=[2.0171;
    7.8820;
    2.3450;
    5.1210;
    2.6179];
nodes12_0noise=[4.2265;
    1.59;
    5.3570;
    5.2208;
    4.0112];
nodes13_0noise=[9.5936;
    3.3409;
    2.8697;
    6.3435;
    2.9789];
nodes14_0noise=[2.2601;
    5.6573;
    3.7883;
    3.1534;
    4.7242];
nodes15_0noise=[3.5689;
   30.3432;
    6.4088;
    5.5770;
    4.7999];
nodes = [10 11 12 13 14 15];
min_mean_rmses=[min(nodes10_0noise) min(nodes11_0noise) min(nodes12_0noise) min(nodes13_0noise) min(nodes14_0noise) min(nodes15_0noise)];
plot(nodes,min_mean_rmses,'--or','LineWidth',1,'MarkerFaceColor','r','MarkerSize',5);
hold on
nodes10_noise0_1=[2.1092;
    3.0902;
    1.8924;
    3.8912;
    2.5101];
nodes11_noise0_1=[3.0291;
    2.2110;
    2.1047;
    3.4151;
    3.1713];
nodes12_noise0_1=[4.5159;
    3.5878;
    3.2923;
    3.8337;
    3.3662];
nodes13_noise0_1=[3.5790;
    2.7100;
    3.1685;
    3.4690;
    3.3649];
nodes14_noise0_1=[2.7245;
    1.785;
    3.0215;
    2.9724;
    2.1745];
nodes15_noise0_1=[2.7539;
    3.2515;
    3.0905;
    2.6271;
    2.9350];
min_mean_rmses=[min(nodes10_noise0_1) min(nodes11_noise0_1) min(nodes12_noise0_1) min(nodes13_noise0_1) min(nodes14_noise0_1) min(nodes15_noise0_1)];
plot(nodes,min_mean_rmses,'--ob','LineWidth',1,'MarkerFaceColor','b','MarkerSize',5);
hold on
%noise level 0.3
nodes10_noise0_3=[3.0503;
    3.2677;
    4.9688;
    3.7232;
    3.2665];
nodes11_noise0_3=[3.8098;
    3.9341;
    3.7579;
    3.3975;
    4.0925];
nodes12_noise0_3=[4.5855;
    3.6815;
    3.8989;
    3.9469;
    3.9244];
nodes13_noise0_3=[3.2692;
    3.3451;
    4.2708;
    3.7963;
    3.3952];
nodes14_noise0_3=[3.6024;
    4.9211;
    3.9647;
    3.5847;
    2.917];
nodes15_noise0_3=[3.3890;
    5.3326;
    3.5297;
    3.3374;
    3.4475];
min_mean_rmses=[min(nodes10_noise0_3) min(nodes11_noise0_3) min(nodes12_noise0_3) min(nodes13_noise0_3) min(nodes14_noise0_3) min(nodes15_noise0_3)];
plot(nodes,min_mean_rmses,'--ok','LineWidth',1,'MarkerFaceColor','k','MarkerSize',5);
hold off
legend('original data','noisy data (0.1 noise)','noisy data (0.3 noise)','Location','SE');
xlabel('Nodes');
ylabel('Minimum Mean RMSEs');    
end    
function figure_mean_rmse_1hidden_layer()
%1-hidden layer nets
nodes10_0noise=[7.8279;
    8.6674;
    2.6360;
    4.5162;
    3.3678];
nodes12_0noise = [5.3327;
    5.2845;
    5.7130;
    3.4776;
    4.2604];
nodes15_0noise = [3.7592;
    8.9883;
    4.6714;
    5.0667;
    3.2037];
nodes18_0noise = [3.4017;
    7.1523;
    3.6945;
    3.8431;
    2.23];
nodes20_0noise = [5.1566;
    4.6226;
    4.2682;
    5.1018;
    4.1638];
nodes22_0noise = [2.9543;
    5.1115;
    3.5716;
    6.1590;
    7.8048];
nodes = [10 12 15 18 20 22];
min_mean_rmses=[min(nodes10_0noise) min(nodes12_0noise) min(nodes15_0noise) min(nodes18_0noise) min(nodes20_0noise) min(nodes22_0noise)];
plot(nodes,min_mean_rmses,'--or','LineWidth',1,'MarkerFaceColor','r','MarkerSize',5);
hold on
nodes10_noise0_1=[2.7780;
    2.8811;
    3.2628;
    7.3530;
    4.0751];
nodes12_noise0_1=[2.9732;
    2.7649;
    5.4259;
    5.1145;
    4.2210];
nodes15_noise0_1=[
     2.56;
    4.0587;
    3.3949;
    3.5226;
    3.9227];
nodes18_noise0_1=[
    3.4265;
    3.8251;
    4.0708;
    3.2941;
    3.9736];
nodes20_noise0_1=[
     4.7675;
    6.2463;
    8.5207;
    3.5747;
    3.1526];
nodes22_noise0_1=[ 
    3.6258;
    3.2012;
    3.0466;
    5.7071;
    2.7249];
min_mean_rmses=[min(nodes10_noise0_1) min(nodes12_noise0_1) min(nodes15_noise0_1) min(nodes18_noise0_1) min(nodes20_noise0_1) min(nodes22_noise0_1)];
plot(nodes,min_mean_rmses,'--ob','LineWidth',1,'MarkerFaceColor','b','MarkerSize',5);
hold on
nodes10_noise0_3=[
     4.5063;
    4.3486;
    4.3958;
    5.3650;
    5.0638];
nodes12_noise0_3=[
    3.9879;
    4.0129;
    6.5625;
    3.9034;
    5.9253];
nodes15_noise0_3=[
    4.1449;
    5.1211;
    4.1807;
    7.0484;
    5.1159]
nodes18_noise0_3=[
    4.6877;
    2.6967;
    4.7608;
    4.2009;
    3.8232];
nodes20_noise0_3=[
    3.7956;
    3.8371;
    5.1979;
    3.5066;
    3.8755];
nodes22_noise0_3=[
    6.6796;
    4.7516;
    4.4576;
    4.2229;
    5.1274];
min_mean_rmses=[min(nodes10_noise0_3) min(nodes12_noise0_3) min(nodes15_noise0_3) min(nodes18_noise0_3) min(nodes20_noise0_3) min(nodes22_noise0_3)];
plot(nodes,min_mean_rmses,'--ok','LineWidth',1,'MarkerFaceColor','k','MarkerSize',5);
hold off
legend('original data','noisy data (0.1 noise)','noisy data (0.3 noise)','Location','SW');
xlabel('Nodes');
ylabel('Minimum Mean RMSEs');
end
function figure1()
x = [0 20 60 100 120 200];
best_single_layer_nets0noise=[0.06 1.39 2.01 3.37 3.38 3.16];%best single layer mlp with 18 hidden nodes trained on original data
best_single_layer_nets0_1noise=[0.75 4.03 2.02 2.83 3.4 2.33];%best single layer mlp with 15 hidden nodes trained on 0.1 noise data
best_single_layer_nets0_3noise=[0.81 7.31 2.8 3.85 3.72 3.42];%best single layer mlp with 18 hidden nodes trained on 0.3 noise data
BARC_results = [0.2 2.4 2.8 3.7 3.6 4.8];%BARC results in paper
figure(1);
plot(x,best_single_layer_nets0noise,'-+r','LineWidth',2,'MarkerFaceColor','r','MarkerSize',6);
hold on;
plot(x,best_single_layer_nets0_1noise,'-xb','LineWidth',2,'MarkerFaceColor','b','MarkerSize',6);
hold on;
plot(x,best_single_layer_nets0_3noise,'-og','LineWidth',2,'MarkerFaceColor','g','MarkerSize',6);
hold on;
plot(x,BARC_results,'-dk','LineWidth',2,'MarkerFaceColor','k','MarkerSize',6);
xlabel('Break Sizes (%)','FontSize',16,'FontWeight','bold');
ylabel('RMSE','FontSize',16,'FontWeight','bold');
%xlabel('Break Sizes (%)','FontSize',14,'FontWeight','bold');
%ylabel('RMSE','FontSize',14,'FontWeight','bold');
%legend('optimal 1-layer MLP1','optimal 1-layer MLP2','optimal 1-layer MLP3','Location','NE');
%legend('optimal 1-layer MLP1','optimal 1-layer MLP2','optimal 1-layer MLP3','BARC NN','Location','NE');
legend('Single Hidden Layer MLP (transient data)','Single Hidden Layer MLP (transiet data with 0.1 noise)', 'Single Hidden Layer MLP (transient data with 0.3 noise)', 'BARC results','Location','NE');
%title('Break size vs Root Mean Squared Error','FontSize',14,'FontWeight','bold');
hold off;
end
function figure2()
figure(2);
x = [0 20 40 50 60 75 100 120 160 200];
network1=[0.0095	0.1744	0.1960	0.2699 	0.3501 	0.3081	0.6908	0.3833	0.4573	0.5944];
network2=[0.1999	0.2485	0.1073	0.1163	0.0974	0.1966 	0.3036	0.1969	0.2447	0.3864];
network3=[0.0347	0.0305	0.0383	0.5308 	0.0557 	0.1100 	0.3349	0.4734	0.4574	0.0579];
ensemble=[0.0542	0.1023	0.0878	0.2084	0.1403	0.1526	0.4054	0.1558	0.3115	0.2855];
%x = [0 20 60 100 120 200];
%network1=[3.1187e-4	3.8490	0.1758	0.2983	0.3007	0.2333];
%network2=[0.0674	0.4071	1.6026	1.0217	0.9898	2.6093];
%network3=[0.1465	13.7993	17.1999	16.8646	23.1019	29.9208];
%network4=[0.0481   	14.1816  	15.8486  	29.0649  	29.3745  	30.3591];
%network5=[0.6640	15.2760	8.5086	13.7021	24.1431	13.1983];
plot(x,network1,'--^r','LineWidth',2,'MarkerFaceColor','r','MarkerSize',6);
hold on;
plot(x,network2,'--^b','LineWidth',2,'MarkerFaceColor','b','MarkerSize',6);
hold on;
plot(x,network3,'--^g','LineWidth',2,'MarkerFaceColor','g','MarkerSize',6);
hold on;
plot(x,ensemble,'--^m','LineWidth',2,'MarkerFaceColor','m','MarkerSize',6);
%plot(x,network4,'--^m','LineWidth',2,'MarkerFaceColor','m','MarkerSize',6);
hold on;
%plot(x,network5,'--^k','LineWidth',2,'MarkerFaceColor','k','MarkerSize',6);
%hold on;
legend('optimised 2-hidden layer network','optimised 3-hidden layer network','optimised 4-hidden layer network','ensemble','Location','NW');
xlabel('Break Sizes (%)','FontSize',16,'FontWeight','bold');
ylabel('RMSE','FontSize',16,'FontWeight','bold');
hold off;
%legend('network1','network2','network3','network4','network5','Location','NW');
%xlabel('Break Sizes (%)','FontSize',16,'FontWeight','bold');
%ylabel('RMSE','FontSize',16,'FontWeight','bold');
%hold off;
%best_2layer_nets0noise=[0.27 0.80 0.84 2.32 2.46 2.84];%best 2 layer mlp with 12x12 hidden nodes trained on original data
%best_2layer_nets0_1noise=[0.56 0.89 2.50 2.24 2.53 1.99];%best 2 layer mlp with 14x14 hidden nodes trained on 0.1 noise data
%best_2layer_nets0_3noise=[0.36 1.38 4.75 4.52 3.45 3.04];%best 2 layer mlp with 14x14 hidden nodes trained on 0.3 noise data
%BARC_results = [0.2 2.4 2.8 3.7 3.6 4.8];%BARC results in paper
%plot(x,best_2layer_nets0noise,'-+r','LineWidth',2,'MarkerFaceColor','r','MarkerSize',6);
%hold on;
%plot(x,best_2layer_nets0_1noise,'-xb','LineWidth',2,'MarkerFaceColor','b','MarkerSize',6);
%hold on;
%plot(x,best_2layer_nets0_3noise,'-og','LineWidth',2,'MarkerFaceColor','g','MarkerSize',6);
%hold on;
%plot(x,BARC_results,'-dk','LineWidth',2,'MarkerFaceColor','k','MarkerSize',6);
%xlabel('Break Sizes (%)');
%ylabel('RMSE');
%legend('optimal 2-layer MLP1','optimal 2-layer MLP2','optimal 2-layer MLP3','BARC NN','Location','NW');
%xlabel('Break Sizes (%)','FontSize',16,'FontWeight','bold');
%ylabel('RMSE','FontSize',16,'FontWeight','bold');
%legend('2-hidden-layer MLP (transient data)','2-hidden-layer MLP (transient data with 0.1 noise)', '2-hidden-layer MLP (transient data with 0.3 noise)', 'BARC results','Location','NW');
%title('Break size vs Root Mean Squared Error','FontSize',14,'FontWeight','bold');
%hold off;
end
function figure3()
figure(3);
x = [0 20 60 100 120 200];
%best_single_layer_nets0noise=[0.06 1.39 2.01 3.37 3.38 3.16];%best single layer mlp with 18 hidden nodes trained on original data
best_single_layer_nets0_1noise=[0.75 4.03 2.02 2.83 3.4 2.33];%best single layer mlp with 15 hidden nodes trained on 0.1 noise data
best_2layer_nets0noise=[0.27 0.80 0.84 2.32 2.46 2.84];%best 2 layer mlp with 12+12 hidden nodes trained on original data
BARC_results = [0.2 2.4 2.8 3.7 3.6 4.8];%BARC results in paper
plot(x,best_single_layer_nets0_1noise,'-ob','LineWidth',2,'MarkerFaceColor','b','MarkerSize',6);
hold on;
plot(x,best_2layer_nets0noise,'-or','LineWidth',2,'MarkerFaceColor','r','MarkerSize',6);
hold on;
plot(x,BARC_results,'-dk','LineWidth',2,'MarkerFaceColor','k','MarkerSize',6);
xlabel('Break Sizes (%)','FontSize',16,'FontWeight','bold');
ylabel('RMSE','FontSize',16,'FontWeight','bold');
legend('Best 1-hidden layer MLP','Best 2-hidden layer MLP','BARC NN','Location','NW');
%legend('optimal 1-layer MLP','optimal 2-layer MLP','Location','NW');
%xlabel('Break Sizes (%)','FontSize',14,'FontWeight','bold');
%ylabel('RMSE','FontSize',14,'FontWeight','bold');
%title('Break size vs Root Mean Squared Error','FontSize',14,'FontWeight','bold');
hold off;
end
function figure4()
figure(4);
x = [0 20 60 100 120 200];
rmse_jiamei=[0.1348 0.6690 1.4907 1.2210 0.8018 1.5164];
plot(x,rmse_jiamei,'-or','LineWidth',2,'MarkerFaceColor','r','MarkerSize',8);
xlabel('Break Sizes (%)','FontSize',14,'FontWeight','bold');
ylabel('RMSE','FontSize',14,'FontWeight','bold');
end
function figure5()
figure(5);
x = [0 20 60 100 120 200];
best_2layer_nets0noise=[0.27 0.80 0.84 2.32 2.46 2.84];%best 2 layer mlp with 12x12 hidden nodes trained on original data
plot(x,best_2layer_nets0noise,'-+b','LineWidth',2,'MarkerFaceColor','r','MarkerSize',8);
hold on;
rmse_jiamei=[0.1348 0.6690 1.4907 1.2210 0.8018 1.5164];
plot(x,rmse_jiamei,'-or','LineWidth',2,'MarkerFaceColor','r','MarkerSize',8);
xlabel('Break Sizes (%)','FontSize',14,'FontWeight','bold');
ylabel('RMSE','FontSize',14,'FontWeight','bold');
legend('optimal mlp','optimal iterative mlp1','Location','NW');
%title('Break size vs Root Mean Squared Error','FontSize',14,'FontWeight','bold');
hold off;
end
function figure6()
figure(6);
%plot iterative training results of best 2-hidden layer mlp with 12 hidden nodes each layer
%x = [0 20 60 100 120 200];
%rmse_iter_ga_nn = [0.0171    0.4338    0.8751    0.7048    0.4132    0.5525];
%plot(x,rmse_iter_ga_nn,'-om','LineWidth',2,'MarkerFaceColor','r','MarkerSize',5);
%hold on;
%rmse_iter1=[0.1348 0.6690 1.4907 1.2210 0.8018 1.5164]; %jiamei's results
%plot(x,rmse_iter1,'-dg','LineWidth',2,'MarkerFaceColor','g','MarkerSize',5);
%hold on;
%rmse_iter1 = [0.0282   0.6695   0.9783  1.6329  1.0529  0.9179]; %netreg_iter_learn.mat
%plot(x,rmse_iter1,'-ok','LineWidth',2,'MarkerFaceColor','k','MarkerSize',5);
%hold on;
%rmse_iter2 = [0.0423    0.6700    0.8334    1.2581    0.4260    0.9759]; %netreg_iter_learn27feb.mat
%plot(x,rmse_iter2,'-or','LineWidth',2,'MarkerFaceColor','r','MarkerSize',5);
%hold on;
%rmse_iter3 = [0.0423    0.4744    0.8927    0.4695    0.4279    1.1496]; %netreg_iter_learn3.mat
%plot(x,rmse_iter3,'-ob','LineWidth',2,'MarkerFaceColor','b','MarkerSize',5); 
%hold on;
%rmse_iter4 = [0.0690    0.4758    0.7786    1.2590    0.2582    0.7125]; %netreg_iter_learn4.mat
%plot(x,rmse_iter4,'-oc','LineWidth',2,'MarkerFaceColor','c','MarkerSize',5);
%hold on;
%rmse_iter5 = [0.0690    0.3761    0.7344    0.4030    0.3436    0.6307]; %netreg_iter_learn5.mat (47th network)
%plot(x,rmse_iter5,'-or','LineWidth',2,'MarkerFaceColor','r','MarkerSize',5);
%hold on;
%rmse_iter6 = [0.0690    0.4191    0.8825    0.6922    0.3495    0.8055]; %netreg_iter_learn6.mat
%plot(x,rmse_iter6,'--or','LineWidth',2,'MarkerFaceColor','r','MarkerSize',5);
%hold on;
%rmse_iter7 = [0.2899    0.4794    0.6362    0.8925    0.3958    0.7013]; %netreg_iter_learn7.mat
%plot(x,rmse_iter7,'--ok','LineWidth',2,'MarkerFaceColor','k','MarkerSize',5);
%hold on;
%rmse_iter8 = [0.2899    0.4611    0.6088    1.1709    0.3904    0.7436]; %netreg_iter_learn8.mat
%plot(x,rmse_iter8,'--ob','LineWidth',2,'MarkerFaceColor','b','MarkerSize',5);
%hold on;
%rmse_iter9 = [0.1665    0.4810    0.8006    0.3406    0.3684    0.7934]; %netreg_iter_learn9.mat
%plot(x,rmse_iter9,'--oc','LineWidth',2,'MarkerFaceColor','c','MarkerSize',5);
%hold on;
%rmse_iter10 = [0.1372    0.4142    0.5928    0.3633    0.3842    0.7133]; %netreg_iter_learn10.mat
%plot(x,rmse_iter10,'--om','LineWidth',2,'MarkerFaceColor','m','MarkerSize',5);
%hold on;
%optimal_iter_mlp = [0.0270    0.6867    1.0140    0.5582    0.3699    0.5671];
%plot(x,optimal_iter_mlp,'--or','LineWidth',2,'MarkerFaceColor','r','MarkerSize',5);
%hold on;
%best_2layer_nets0noise=[0.27 0.80 0.84 2.32 2.46 2.84];%best 2 layer mlp with 12x12 hidden nodes trained on original data
%plot(x,best_2layer_nets0noise,'-+b','LineWidth',2,'MarkerFaceColor','b','MarkerSize',5);
%BARC_results = [0.2 2.4 2.8 3.7 3.6 4.8];%BARC results in paper
%plot(x,BARC_results,'-dk','LineWidth',2,'MarkerFaceColor','k','MarkerSize',6);
%hold on;
%diff = [0.1310    2.0239    2.0656    3.2970    3.2564    4.1693];%BARC_results - rmse_iter5
%opt_mlp_of_exhaustive_training = [0.0604    0.2831    0.5051    0.1521    0.2337    0.4159];
%plot(x,opt_mlp_of_exhaustive_training,'-dk','LineWidth',2,'MarkerFaceColor','k','MarkerSize',6);
%hold on;
%diff = [0.0086    0.0930    0.2293    0.2509    0.1099    0.2148];%rmse_iter5 - opt_mlp_of_exhaustive_training;
%plot(x,diff,'--m','LineWidth',2,'MarkerFaceColor','m','MarkerSize',6);
x=[0 20 40 50 60 75 100 120 160 200];
ga_nn=[0.0072	0.4736	0.5872	0.9633	1.0515	1.6342	2.1309	1.196	2.0576	1.4462];%GA-optimised2 network
plot(x,ga_nn,'-^r','LineWidth',2,'MarkerFaceColor','r','MarkerSize',6);
hold on
svr=[0.6604    0.8709    1.2255    1.7208    2.9513    3.7623    4.5681    4.5251    8.7220    5.5190];
plot(x,svr,'-sb','LineWidth',2,'MarkerFaceColor','b','MarkerSize',6);
hold on
diff=[0.6532    0.3973    0.6383    0.7575    1.8998    2.1281    2.4372 3.3291    6.6644    4.0728];%svr - ga_nn
plot(x,diff,'--m','LineWidth',2,'MarkerFaceColor','m','MarkerSize',6);
xlabel('Break Sizes (%)','FontSize',16,'FontWeight','bold');
ylabel('RMSE','FontSize',16,'FontWeight','bold');
legend('GA-optimised network2','SVR','difference','Location','NW');
%xlabel('Break Sizes (%)','FontSize',14,'FontWeight','bold');
%ylabel('RMSE','FontSize',14,'FontWeight','bold');
%legend('optimal iterative mlp1','optimal iterative mlp2','optimal iterative mlp3','optimal iterative mlp4','optimal iterative mlp5','optimal iterative mlp6','optimal iterative mlp7','optimal iterative mlp8','optimal iterative mlp9','optimal iterative mlp10','optimal 2-layer mlp1','Location','NW');
%legend('47th MLP','optimal 2-layer MLP1','Location','NW');
%legend('Optimal MLP (47th MLP)','Santhosh MLP','difference','Location','NW');
%legend('Optimal MLP (47th MLP)','Santhosh MLP','difference','Location','NW');
%legend('Optimal MLP (47th MLP)','Optimal MLP of exhaustive training','difference','Location','NW');
%legend('optimal iterative mlp1','optimal iterative mlp2','optimal iterative mlp3','optimal mlp','Location','NW');
%legend('iterative genetic mlp','optimal iterative mlp1','optimal iterative mlp2','optimal iterative mlp3','optimal mlp','Location','NW');
hold off;
end
function figure7(testoutputs,testtargets)
figure(7);
%network outputs vs targets for regression
%testoutputs, network outputs of the test set
%testtargets, targets of the test set
index0 = find(testtargets==0);
index20 = find(testtargets==20);
index60 = find(testtargets==60);
index100 = find(testtargets==100);
index120 = find(testtargets==120);
index200 = find(testtargets==200);
%o = [testoutputs(index0) testoutputs(index20) testoutputs(index60) testoutputs(index100) testoutputs(index120) testoutputs(index200)];
%t = [testtargets(index0) testtargets(index20) testtargets(index60) testtargets(index100) testtargets(index120) testtargets(index200)];
%instances = 1:length(o);
%plot(instances,t,'+b','LineWidth',2,'MarkerEdgeColor','b');
%hold on;
%plot(instances,o,'+r','LineWidth',2,'MarkerEdgeColor','r');
%xlabel('Instances','FontSize',16);
%ylabel('Break Sizes (%)','FontSize',16);
%legend('NN Outputs','Targets','Location','NW');
%title('Break sizes vs Instances','FontSize',14,'FontWeight','bold')
%hold off;
%%plot target break sizes vs means of calculated break sizes 
%mean of NN outputs of each break size
m0=mean(testoutputs(index0));
m20=mean(testoutputs(index20));
m60=mean(testoutputs(index60));
m100=mean(testoutputs(index100));
m120=mean(testoutputs(index120));
m200=mean(testoutputs(index200));
means = [m0 m20 m60 m100 m120 m200]
%std of NN outputs of each break size
%std0=std(testoutputs(index0));
%std20=std(testoutputs(index20));
%std60=std(testoutputs(index60));
%std100=std(testoutputs(index100));
%std120=std(testoutputs(index120));
%std200=std(testoutputs(index200));
%stds=[std0 std20 std60 std100 std120 std200]
t=[0 20 60 100 120 200];
o=[m0 m20 m60 m100 m120 m200];
plot(t,o,'--ob','LineWidth',2,'MarkerFaceColor','b','MarkerEdgeColor','b');
xlabel('Desired Break Sizes (%)','FontSize',16);
ylabel('Calculated Break Sizes (%)','FontSize',16);
end
function figure8(indices,outputs,targets)
figure(8);
%network outputs vs targets for classification
%inputs: indices of instances
%        outputs of NN
%        targets of instances
%outputs and targets are m x n vectors where m is no. of outputs and n is no. of instances 
outputs = outputs(:,indices);
targets = targets(:,indices);
%generate prediction labels
outputs = outputs';%transpose outputs so that rows are instances, columns are labels
targets = targets';%transpose targets so that rows are instances, columns are labels
break_sizes=[0 20 60 100 120 200];
t = zeros(length(indices),1);
for i=1:size(targets,1)
    instance = targets(i,:);
    for j=1:size(instance,2)
        v = instance(1,j);
        if v == 1
           t(i) = break_sizes(j);
           break;%target found, so exit for loop and check next instance
        end
    end
end
o = zeros(length(indices),1);
for i=1:size(outputs,1)
    instance = outputs(i,:);
    biggest_prob = -1;
    for j=1:size(instance,2)
        v = instance(1,j);
        if v > biggest_prob
           o(i) = break_sizes(j);
           biggest_prob = v;
        end
    end
end 
index0 = find(t==0);
index20 = find(t==20);
index60 = find(t==60);
index100 = find(t==100);
index120 = find(t==120);
index200 = find(t==200);
o = o';
t = t';
o = [o(index0) o(index20) o(index60) o(index100) o(index120) o(index200)];
t = [t(index0) t(index20) t(index60) t(index100) t(index120) t(index200)];
instances = 1:length(o);
plot(instances,t,'ob','LineWidth',2,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',4);
hold on;
plot(instances,o,'+r','LineWidth',1,'MarkerEdgeColor','r');
xlabel('Instances','FontSize',10);
ylabel('Break Sizes','FontSize',10);
legend('Break Size Targets','NN Outputs','Location','NW');
%title('Comparison of NN outputs and targets','FontSize',14,'FontWeight','bold')
hold off;
end
function figure9()
%NN classification rmse vs BARC rmse
figure(9);
x = [0 20 60 100 120 200];
nn = [0.2407  0.1667 0.1669 0.1782 0.1705 0.4669];
plot(x,nn,'--or','LineWidth',2,'MarkerFaceColor','r','MarkerSize',5);
hold on;
%BARC_results = [0.2 2.4 2.8 3.7 3.6 4.8];%BARC results in paper
%plot(x,BARC_results,'--ok','LineWidth',2,'MarkerFaceColor','k','MarkerSize',5);
xlabel('Break Sizes (%)');
%xlabel('Break Sizes (%)','FontSize',14,'FontWeight','bold');
ylabel('RMSE');
%ylabel('RMSE','FontSize',14,'FontWeight','bold');
%legend('Optimal Network','BARC Network','Location','NW');
%title('Break size vs Root Mean Squared Error');
hold off;
end
function figure10()
%accuracies vs nodes
figure(10);
%nodes = 8:1:20;
nodes = [8 9 10 11 12 13 14 15 16 17 18 19 20];
accuracies = [97.4 97.4 97.8 98.5 97.4 98.3 97.9 97.8 97.5 97.4 97.2 98.5 97.7];
plot(nodes,accuracies,'--+','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
xlabel('Nodes');
ylabel('Accuracy(%)');
%xlabel('Nodes','FontSize',14,'FontWeight','bold');
%ylabel('Accuracy(%)','FontSize',14,'FontWeight','bold');
end
function figure11()
%mean RMSEs of 100 mlps trained iteratively
figure(11);
load mean_rmses;
mlps = 1:1:100;
rmse_iter1 = [0.0282   0.6695   0.9783  1.6329  1.0529  0.9179]; %netreg_iter_learn.mat
rmse_iter2 = [0.0423    0.6700    0.8334    1.2581    0.4260    0.9759]; %netreg_iter_learn27feb.mat
rmse_iter3 = [0.0423    0.4744    0.8927    0.4695    0.4279    1.1496]; %netreg_iter_learn3.mat
rmse_iter4 = [0.0690    0.4758    0.7786    1.2590    0.2582    0.7125]; %netreg_iter_learn4.mat
rmse_iter5 = [0.0690    0.3761    0.7344    0.4030    0.3436    0.6307]; %netreg_iter_learn5.mat
rmse_iter6 = [0.0690    0.4191    0.8825    0.6922    0.3495    0.8055]; %netreg_iter_learn6.mat
rmse_iter7 = [0.2899    0.4794    0.6362    0.8925    0.3958    0.7013]; %netreg_iter_learn7.mat
rmse_iter8 = [0.2899    0.4611    0.6088    1.1709    0.3904    0.7436]; %netreg_iter_learn8.mat
rmse_iter9 = [0.1665    0.4810    0.8006    0.3406    0.3684    0.7934]; %netreg_iter_learn9.mat
rmse_iter10 = [0.1372    0.4142    0.5928    0.3633    0.3842    0.7133]; %netreg_iter_learn10.mat
m1 = mean(rmse_iter1);
m2 = mean(rmse_iter2);
m3 = mean(rmse_iter3);
m4 = mean(rmse_iter4);
m5 = mean(rmse_iter5);
m6 = mean(rmse_iter6);
m7 = mean(rmse_iter7);
m8 = mean(rmse_iter8);
m9 = mean(rmse_iter9);
m10 = mean(rmse_iter10);
mean_rmses(8)=m1;
mean_rmses(13)=m2;
mean_rmses(26)=m3;
mean_rmses(32)=m4;
mean_rmses(47)=m5;
mean_rmses(52)=m6;
mean_rmses(66)=m7;
mean_rmses(71)=m8;
mean_rmses(89)=m9;
mean_rmses(95)=m10;
plot(mlps,mean_rmses,'-+','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
hold on
x=[0 47];
y=[0.424 0.424];
plot(x,y,'--k','LineWidth',1);
hold on
x2=[47 47];
y2=[0  0.424];
plot(x2,y2,'--k','LineWidth',1);
hold off
xlabel('MLPs');
ylabel('Mean RMSEs');
end
function figure12()
%plot of standard deviation of RMSEs of optimal iterative mlps
figure(12);
mlps = 1:1:10;
std_rmses = [0.5383 0.4275 0.3893 0.4225 0.2342 0.311 0.2202 0.3179 0.2570 0.1996];
plot(mlps,std_rmses,'--+','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
xlabel('Optimal Iterative MLPs');
ylabel('Standard Deviation of RMSEs');
end
function figure13()
x=[2 4 6];
y=[3 6 9];
plot(x,y,'-s','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
hold on
x2=[4 4];
y2=[0 6];
plot(x2,y2,'--k','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
hold on
x3=[0 4];
y3=[6 6];
plot(x3,y3,'--k','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
hold on
x0=[0 2];
y0=[3 3];
plot(x0,y0,'-k','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
hold on
x00=[2 2];
y00=[0 3];
plot(x00,y00,'-k','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
hold on
x1=[6 6];
y1=[0 9];
plot(x1,y1,'-k','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
hold on
x11=[0 6];
y11=[9 9];
plot(x11,y11,'-k','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
hold off
xlabel('X');
ylabel('Y');
end
function figure14()%linear interpolation plot
x12=[0 1];
y12=[0 5];
plot(x12,y12,'-sb','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
hold on
x23=[1 2];
y23=[5 6];
plot(x23,y23,'-sb','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
hold on
x34=[2 3];
y34=[6 1];
hold on;
plot(x34,y34,'-sb','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
x45=[3 4];
y45=[1 -5];
plot(x45,y45,'-sb','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
x56=[4 5];
y56=[-5 -7];
plot(x56,y56,'-sb','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
x67=[5 6];
y67=[-7 -2];
plot(x67,y67,'-sb','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
xlabel('X');
ylabel('Y');
hold off
end
function plot_a_signal()
%plot break size data
load 'size20.csv';
%load 'size60.csv';
%load 'size100.csv';
%load 'size120.csv';
%load 'size200.csv';
n=size(size20,2);
figure(20)
i=6;
plot(size20(1:100,n),size20(1:100,i),'o','MarkerFaceColor','r');
hold on
x=[0.1 0.2];
y=[0 0];
plot(x,y,'-g','LineWidth',2);
hold on
x=[0.1 0.2];
y=[-15 -15];
plot(x,y,'-g','LineWidth',2);
hold on
x=[0.1 0.1];
y=[0 -15];
plot(x,y,'-g','LineWidth',2);
hold on
x=[0.2 0.2];
y=[0 -15];
plot(x,y,'-g','LineWidth',2);
hold off
xlabel('time(s)');
ylabel('signal value');
end
function plot_data()
%plot break size data
load 'size0.csv';
load 'size20.csv';
load 'size60.csv';
load 'size100.csv';
load 'size120.csv';
load 'size200.csv';
load 'Blind_Case2_Smart.csv';
load 'Blind_Case3_Smart.csv';
load 'Blind_Case4_Smart.csv';
load 'Blind_Case5_Smart.csv';
figure(1)
boxplot(size0');
hold off
title('break size 0%');
n=size(size20,2);
figure(20)
for i=1:37
    plot(size20(:,n),size20(:,i));
    hold on
end
title('break size 20%');
xlabel('time(s)');
ylabel('signals');
hold off;
figure(60)
for i=1:37
    plot(size60(:,n),size60(:,i));
    hold on
end
title('break size 60%');
xlabel('time(s)');
ylabel('signals');
hold off;
figure(100)
for i=1:37
    plot(size100(:,n),size100(:,i));
    hold on
end
title('break size 100%');
xlabel('time(s)');
ylabel('signals');
hold off;
figure(120)
for i=1:37
    plot(size120(:,n),size120(:,i));
    hold on
end
title('break size 120%');
xlabel('time(s)');
ylabel('signals');
hold off;
figure(200)
t=size120(:,n);
for i=1:37
    plot(t,size200(:,i));
    hold on
end
title('break size 200%');
xlabel('time(s)');
ylabel('signals');
hold off;
figure(999)
n=size(Blind_Case2_Smart,1);
for i=1:37
    plot(1:n,Blind_Case2_Smart(:,i));
    hold on
end
title('40% (Blind Case2)');
xlabel('time instants');
ylabel('signals');
hold off;
figure(666)
n=size(Blind_Case3_Smart,1);
for i=1:37
    plot(1:n,Blind_Case3_Smart(:,i));
    hold on
end
title('75% (Blind Case3)');
xlabel('time instants');
ylabel('signals');
hold off;
figure(667)
n=size(Blind_Case4_Smart,1);
for i=1:37
    plot(1:n,Blind_Case4_Smart(:,i));
    hold on
end
title('50% (Blind Case4)');
xlabel('time instants');
ylabel('signals');
hold off;
figure(668)
n=size(Blind_Case5_Smart,1);
for i=1:37
    plot(1:n,Blind_Case5_Smart(:,i));
    hold on
end
title('160% (Blind Case5)');
xlabel('time instants');
ylabel('signals');
hold off;
%plot 1 signal
figure(669)
plot(size60(:,41),size60(:,1));
title('60% South inlet header pressure');
xlabel('time (seconds)');
ylabel('signal');
hold off;
end
