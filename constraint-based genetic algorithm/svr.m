%train SVR to detect break sizes
%load 'merged_data_blindtests3_4_5.csv';
% x=merged_data_blindtests3_4_5(:,1:37)';
% t=merged_data_blindtests3_4_5(:,38)';
% subset=[3,15,16,24,25,26,27,28,30,37]; %feature subset output by cfssubseteval of weka
% x=x(subset,:);
load 'all_break_sizes_interpolated3.csv';%all break sizes from 0% to 200% including interpolated data, BARC data and blind cases 2 3 4 5
load 'all_break_sizes_interpolated3_labels.csv';
x=all_break_sizes_interpolated3;
t=all_break_sizes_interpolated3_labels;

% load SkillCraft1_Dataset_no_missing.csv;
% x=SkillCraft1_Dataset_no_missing(:,2:19)';
% t=SkillCraft1_Dataset_no_missing(:,1)';
 trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.
 net = feedforwardnet(5,trainFcn);%set initial weights to random values and create a NN
 net.trainParam.epochs=1;
 net.divideFcn = 'dividerand';
 net.divideMode = 'sample'; 
 net.divideParam.trainRatio = 0.75;
 net.divideParam.valRatio = 0;
 net.divideParam.testRatio= 0.25;
 [net,tr]=train(net,x,t);
 trainset=x(:,tr.trainInd);
 traintargets=t(tr.trainInd);
 testset=x(:,tr.testInd);
 testtargets=t(tr.testInd);
 %===select training data, validation data and test data uniformally at
 %random
 %[indxtrain,indxval,indxtest]=select_patterns_uniformly_at_random(t);
 %trainset=x(:,[indxtrain,indxval]);%use 75% for training
 %traintargets=t([indxtrain,indxval]);
 %testset=x(:,indxtest);%use 25% for testing
 %testtargets=t(indxtest);
 %==z-score normalization==
 %[trainset,s1]=mapstd(trainset);%z-score normalization
 %testset=mapstd('apply',testset,s1);
 %[traintargets,s2]=mapstd(traintargets);
 %testtargets=mapstd('apply',testtargets,s2); 
 %==mini-max normalization==
 %==use normalization setting of training set to normalize test set==
 %[trainset,s1]=mapminmax(trainset,-1,1);
 %[traintargets,s2]=mapminmax(traintargets,-1,1);
 %[trainset,s1]=mapminmax(trainset,0,1);
 %[traintargets,s2]=mapminmax(traintargets,0,1);
 %testset=mapminmax('apply',testset,s1);
 %testtargets=mapminmax('apply',testtargets,s2);
 %==end==
 %==normalize training set and testset independently
 [trainset,~]=mapminmax(trainset,-1,1);
 [traintargets,~]=mapminmax(traintargets,-1,1);
 [testset,~]=mapminmax(testset,-1,1);
 [testtargets,s2]=mapminmax(testtargets,-1,1);
 %==end=== 
 %==convert to libsvm data format
 mat2svm([traintargets' trainset'],'train.libsvm');
 mat2svm([testtargets' testset'],'test.libsvm');
 disp('converted to libsvm format');
 %==SVM training and testing using libsvm Matlab functions===
 %svmtrain not working; it does not return a model
 %[trainlabels,traindata]=libsvmread('train.libsvm');
 %model = svmtrain(trainlabels,traindata,'-s 3 -h 0 -c 200 -g 1.5');
 %model = svmtrain(trainlabels,traindata,'-s 3 -v 10 -h 0 -c 200 -g 1.5');
 %[testlabels,testdata]=libsvmread('test.libsvm');
 %[y] = svmpredict(testlabels,testdata, model);
 %==rbf kernel==
 %cost=[2^-5, 2^-3, 2^-1, 2, 2^3, 2^5, 2^7, 2^9, 2^11, 2^13, 2^15];
 %gamma=[2^-15,2^-13,2^-11,2^-9,2^-7,2^-5,2^-3,2^-1,2,2^2,2^3];
 %cost=[2^-5, 2^-3];
 %gamma=[2^-15,2^-13];
 %==fine grid region of best cost==
 %bestcost=2^-5
 %grid region: [2^-7,2^-6.75,...,2^-2.75,2^-3]
 %cost=zeros(1,4/0.25);
 %cost(1,1)=2^-7;
 %d=-7;
 %j=2;
 %while (d < -3)
 %    d=d+0.25;
 %    cost(1,j)=2^d;
 %    j=j+1;     
 %end
 %==end of fine grid region of best cost==
 %==fine grid region of best gamma==
 %=best gamma=2^-15
 %grid region: [2^-17,...,2^-13]
 %gamma=zeros(1,4/0.25);
 %gamma(1,1)=2^-17;
 %d=-17;
 %==end
 %best gamma=1.5 i.e. 2^0.6
 %grid region:[2^0.10,2^0.35,2^0.6,2^0.85,2^1.1,2^1.35]
 %j=2;
 %while (d < -13)
 %    d=d+0.25;
 %    gamma(1,j)=2^d;
 %    j=j+1;
 %end
 %===end of fine grid region of best gamma==
 %cost=[200,300,400,500];
 %gamma=[2^0.10,2^0.35,2^0.6,2^0.85,2^1.1,2^1.35];
 %gamma=[1,1.5,2,2.5];
 cost=[0.0025,0.005,0.05,0.1,0.5,1,5,10,15,25,50,75,100,125,150,175,200,225,250];
 gamma=[0.0025,0.005,0.075,0.1,0.125,0.25,0.5,0.75,1,1.25,1.5,1.75,2,2.25,2.5];
 k=1;
 best_average_rmse=100;%break size data
 %best_rmse=100;%skillcraft
 rmses_matrix=zeros(length(cost)*length(gamma),13);%for break size data. format: cost, gamma, average rmse, rmse of each of 10 break sizes
 %rmses_matrix=zeros(length(cost)*length(gamma),12);%for break size data. format: cost, gamma, average rmse, rmse of each of 9 break sizes
 %rmses_matrix=zeros(length(cost)*length(gamma),3);%for skillcraft. format: cost, gamma, rmse
 for i=1:length(cost)
     for j=1:length(gamma)
        %==linear kernel
        %cmd=char(string('"C:\Users\tiand\Downloads\libsvm-3.22\windows\svm-train" -s 3 -t 0 -v 10 -c 200 -p 0.001 -e 0.002 train.libsvm'));
        %==rbf kernel
        cmd=char('"C:\Users\tian03\Downloads\libsvm-3.22\windows\svm-train" -s 3 -h 0 -c '+string(cost(i))+' -g '+string(gamma(j))+' -p 0.0001 -e 0.002 train.libsvm');% -e is tolerance of termination criterion of SMO e.g. e=0.002
        %cmd=char('"C:\Users\tiand\Downloads\libsvm-3.22\windows\svm-train" -s 3 -h 0 -v 10 -c '+string(cost(i))+' -g '+string(gamma(j))+' -p 0.001 -e 0.002 train.libsvm');% -e is tolerance of termination criterion of SMO e.g. e=0.002
        %cmd=char('"C:\Users\tian03\Downloads\libsvm-3.22\libsvm-3.22\windows\svm-train" -s 3 -v 10 -c '+string(cost(i))+' -g '+string(gamma(j))+' -p 0.001 -e 0.001 train.libsvm');% -e is tolerance of termination criterion of SMO e.g. e=0.002
        %cmd=char(string('"C:\Users\tian03\Downloads\libsvm-3.22\libsvm-3.22\windows\svm-train" -s 3 -v 10 -c 200 -g 1.5 "P:\Nuclear Power Plant Safety Monitoring (Leeds Beckett)\project\train.libsvm" "P:\Nuclear Power Plant Safety Monitoring (Leeds Beckett)\project\svr_model"'));
        %cmd=char(string('"C:\Users\tian03\Downloads\libsvm-3.22\libsvm-3.22\windows\svm-train" -s 3 -v 10 -c 200 -g 1.5 -p 0.00001 train.libsvm'));% -p is epsilon in epsilon-insensitive loss function 
        %cmd=char(string('"C:\Users\tian03\Downloads\libsvm-3.22\libsvm-3.22\windows\svm-train" -s 3 -v 2 -c 200 -g 1.5 -p 0.001 train.libsvm'));
        %cmd=char(string('"C:\Users\tian03\Downloads\libsvm-3.22\libsvm-3.22\windows\svm-train" -s 3 -v 2 -c 200 -g 1.0 -p 0.00001 train.libsvm'));
        [status,~] = system(cmd);
        if status ~= 0
            disp('svm-train ran unsuccessfully');
        end
        %cmd=char(string('"C:\Users\tian03\Downloads\libsvm-3.22\libsvm-3.22\windows\svm-predict" test.libsvm train.libsvm.model output"'));  
        cmd=char(string('"C:\Users\tian03\Downloads\libsvm-3.22\windows\svm-predict" test.libsvm train.libsvm.model output"'));  
        [status,~] = system(cmd);
        if status ~= 0
             disp('svm-predict ran unsuccessfully');
        end
        load output
        %===convert normalized predictions to the original target range
        y=mapminmax('reverse',output',s2);
        %y=mapstd('reverse',output',s2);
        %===compute rmse
        %y=outputs';
        testtargets=t(tr.testInd);
        %testtargets=t(indxtest);
        %===break size data===
        %[average_rmse,rmses]=average_rmse_of_break_sizes3(y,testtargets);
        [average_rmse,rmses]=average_rmse_of_break_sizes2(y,testtargets);
        if average_rmse < best_average_rmse
            best_average_rmse=average_rmse;
            cmd=char(string('copy /y train.libsvm.model train.libsvm.best_model'));
            [status,~] = system(cmd);
            if status ~= 0
                 disp('rename ran unsuccessfully');
            end
        end
        %===end===
        %rmse=sqrt(perform(net,testtargets,y));%skillcraft
        %if rmse < best_rmse
        %    best_rmse=rmse;
        %    cmd=char(string('copy /y train.libsvm.model train.libsvm.best_model'));
        %    [status,~] = system(cmd);
        %    if status ~= 0
        %         disp('rename ran unsuccessfully');
        %    end
        %end
        %==end===
        rmses_matrix(k,:)=[cost(i),gamma(j),average_rmse,rmses];%break size data
        %rmses_matrix(k,:)=[cost(i),gamma(j),rmse];%skillcraft
        k=k+1;
        cost(i)
        gamma(j)
        %==break size data==
        best_average_rmse
        average_rmse
        rmses
        %===end===
        %best_rmse
        %rmse
     end
 end
 %===break size data===
 sorted_rmses=sortrows(rmses_matrix,3);%sort results in ascending order of average rmse 
 bestcost=sorted_rmses(1,1)
 bestgamma=sorted_rmses(1,2)
 best_average_rmse=sorted_rmses(1,3)
 best_rmses=sorted_rmses(1,4:13)
 save('sorted_rmses','sorted_rmses');
 save('rmses_matrix','rmses_matrix');%unsorted rmses
 plot_average_rmses(sorted_rmses);
 %===end===
 %===skillcraft===
 %sorted_rmses=sortrows(rmses_matrix,3);%sort results in ascending order of average rmse 
 %bestcost=sorted_rmses(1,1)
 %bestgamma=sorted_rmses(1,2)
 %best_rmse=sorted_rmses(1,3)
 %save('sorted_rmses','sorted_rmses');
 %save('rmses_matrix','rmses_matrix');%unsorted rmses
 %plot_average_rmses(rmses_matrix);
 %===end====
 %==linear kernel==
%cmd=char(string('"C:\Users\tian03\Downloads\libsvm-3.22\libsvm-3.22\windows\svm-train" -s 3 -t 0 -v 10 -c 200 -p 0.00001 train.libsvm'));
%==poly kernel==
%cmd=char(string('"C:\Users\tian03\Downloads\libsvm-3.22\libsvm-3.22\windows\svm-train" -s 3 -t 1 -v 10 -c 200 -d 2 -p 0.00001 train.libsvm'));
%cmd=char(string('"C:\Users\tian03\Downloads\libsvm-3.22\libsvm-3.22\windows\svm-train" -s 3 -t 1 -v 10 -c 200 -d 3 -p 0.00001 train.libsvm'));
%cmd=char(string('"C:\Users\tian03\Downloads\libsvm-3.22\libsvm-3.22\windows\svm-train" -s 3 -t 1 -v 10 -c 200 -d 4 -p 0.00001 train.libsvm'));
%cmd=char(string('"C:\Users\tian03\Downloads\libsvm-3.22\libsvm-3.22\windows\svm-train" -s 3 -t 1 -v 10 -c 200 -d 5 -p 0.00001 train.libsvm'));
function plot_average_rmses(rmses_matrix)
%scatter3(rmses_matrix(:,1),rmses_matrix(:,2),rmses_matrix(:,3),'filled');
scatter3(rmses_matrix(:,1),rmses_matrix(:,2),rmses_matrix(:,3));
xlabel('Cost','FontSize',14,'FontWeight','bold');
ylabel('Gamma','FontSize',14,'FontWeight','bold');
zlabel('Mean RMSE','FontSize',14,'FontWeight','bold');
end
function [indxtrain,indxval,indxtest]=select_patterns_uniformly_at_random(t)
%select uniformlly at random 50% data for training, 25% for validation and 25% for testing
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
end
 