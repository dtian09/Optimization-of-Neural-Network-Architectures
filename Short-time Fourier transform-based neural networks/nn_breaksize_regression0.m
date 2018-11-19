load mergeddata.csv;
load net_subset2;
%load reduced_mergeddata.csv;
%load mergeddatalabels.csv;
%mergeddata = addnoise(mergeddata,0.1,3);%add gaussian noise to original data and merge the noise data with original data before training, validation and testing
%mergeddata = addnoise(mergeddata,0.3,3);%add gaussian noise to original data and merge the noise data with original data before training, validation and testing
x = mergeddata(:,1:37)';%transpose the inputs so that rows are features, columns are instances
t = mergeddata(:,38)';%transpose the last column (targets) to a row vector
%x = reduced_mergeddata';
%t = mergeddatalabels';
x = x(net_subset2,:);
% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.

%Create a single hidden layer network
%hiddenLayerSize = 5;
%hiddenLayerSize = 6;
%hiddenLayerSize = 8;
%hiddenLayerSize = 10;
%hiddenLayerSize = 12;
%hiddenLayerSize = 15;
%hiddenLayerSize = 16;
%hiddenLayerSize = 17;
%hiddenLayerSize = 18;
%hiddenLayerSize = 20;
%hiddenLayerSize = 22;
%hiddenLayerSize = 25;
%net = feedforwardnet(hiddenLayerSize,trainFcn);
%net = feedforwardnet([5,5],trainFcn);
%net = feedforwardnet([6,6],trainFcn);
%net = feedforwardnet([7,7],trainFcn);
%net = feedforwardnet([8,8],trainFcn);
%net = feedforwardnet([10,10],trainFcn);
%net = feedforwardnet([11,11],trainFcn);
%net = feedforwardnet([12,12],trainFcn);
%net = feedforwardnet([13,13],trainFcn);
%net = feedforwardnet([14,14],trainFcn);
%net = feedforwardnet([15,15],trainFcn);
%net = feedforwardnet([20,25],trainFcn);
%net = feedforwardnet([25,25],trainFcn);
net = feedforwardnet([14,5],trainFcn);
%===initialize weight to random numbers between -0.5,0.5
%net = set_weights(net);
%ws = getx(net)
%Set training parameters
net.trainParam.epochs= 1000;
% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

%net.input.processFcns = {'removeconstantrows','mapstd'};
%net.output.processFcns = {'removeconstantrows','mapstd'};

% Setup Division of Data for Training, Validation, Testing
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 50/100;
net.divideParam.valRatio = 25/100;
net.divideParam.testRatio = 25/100;

%net.divideFcn = 'divideint';%divide data into interleaved training, validation, test sets (percentages of the datasets must add up to 100%) up
%net.divideParam.trainRatio = 50/100;
%net.divideParam.valRatio = 25/100;
%net.divideParam.testRatio = 25/100;

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
%net.performFcn = 'mse';  % Mean Squared Error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
%net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
%    'plotregression', 'plotfit'};

%load 'netreg21nov0noise2layers.mat';%load a network and continue training it

% Train the Network
%net.trainParam.epochs = 2000;
%net.trainParam.max_fail = 6;
[net,tr] = train(net,x,t);%rows of x are features, columns of x are instances
                          %rows of t are class variables, columns of t are classes of the instances
% Test the Network
y = net(x);

%calculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};

trainOutputs = y .* tr.trainMask{1};
valOutputs = y .* tr.valMask{1};
testOutputs = y .* tr.testMask{1};

trainError = perform(net,trainTargets,trainOutputs);
valError = perform(net,valTargets,valOutputs);
testError = perform(net,testTargets,testOutputs);

rmse_train = sqrt(trainError)
rmse_test = sqrt(testError)
rmse_val = sqrt(valError)

%Compute rmse of each break size
%Generate masks of break sizes in training set
trainTargets = trainTargets';%transpose row vector to a column vector
mask0 = create_mask(trainTargets,0);
mask20 =  create_mask(trainTargets,20);
mask60 = create_mask(trainTargets,60);
mask100 = create_mask(trainTargets,100);
mask120 = create_mask(trainTargets,120);
mask200 = create_mask(trainTargets,200);
%Get network outputs of training set
y = y';%transpose y to a column vector
t = t';%transpose t to a column vector
trainOutputs0 = y .* mask0;
trainOutputs20 = y .* mask20;
trainOutputs60 = y .* mask60;
trainOutputs100 = y .* mask100;
trainOutputs120 = y .* mask120;
trainOutputs200 = y .* mask200;
trainTargets0 = t .* mask0;
trainTargets20 = t .* mask20;
trainTargets60 = t .* mask60;
trainTargets100 = t .* mask100;
trainTargets120 = t .* mask120;
trainTargets200 = t .* mask200;

%Generate masks of break sizes in test set
testTargets = testTargets';%transpose row vector to a column vector
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

%Generate masks of break sizes in validation set
valTargets = valTargets';%transpose row vector to a column vector
mask0_val =  create_mask(valTargets,0);
mask20_val =  create_mask(valTargets,20);
mask60_val = create_mask(valTargets,60);
mask100_val = create_mask(valTargets,100);
mask120_val = create_mask(valTargets,120);
mask200_val = create_mask(valTargets,200);
%Get network outputs of validation set
valOutputs0 = y .* mask0_val;
valOutputs20 = y .* mask20_val;
valOutputs60 = y .* mask60_val;
valOutputs100 = y .* mask100_val;
valOutputs120 = y .* mask120_val;
valOutputs200 = y .* mask200_val;
valTargets0 = t .* mask0_val;
valTargets20 = t .* mask20_val;
valTargets60 = t .* mask60_val;
valTargets100 = t .* mask100_val;
valTargets120 = t .* mask120_val;
valTargets200 = t .* mask200_val;

%compute rmse of each break size
rmse0_train = rmse(trainOutputs0,trainTargets0);
rmse20_train = rmse(trainOutputs20,trainTargets20);
rmse60_train = rmse(trainOutputs60,trainTargets60);
rmse100_train = rmse(trainOutputs100,trainTargets100);
rmse120_train = rmse(trainOutputs120,trainTargets120);
rmse200_train = rmse(trainOutputs200,trainTargets200);

rmse0_test = rmse(testOutputs0,testTargets0);
rmse20_test = rmse(testOutputs20,testTargets20);
rmse60_test = rmse(testOutputs60,testTargets60);
rmse100_test = rmse(testOutputs100,testTargets100);
rmse120_test = rmse(testOutputs120,testTargets120);
rmse200_test = rmse(testOutputs200,testTargets200);

percent_error0_test = percent_error(testOutputs0,testTargets0);
percent_error20_test = percent_error(testOutputs20,testTargets20);
percent_error60_test = percent_error(testOutputs60,testTargets60);
percent_error100_test = percent_error(testOutputs100,testTargets100);
percent_error120_test = percent_error(testOutputs120,testTargets120);
percent_error200_test = percent_error(testOutputs200,testTargets200);

rmse0_val = rmse(valOutputs0,valTargets0);
rmse20_val = rmse(valOutputs20,valTargets20);
rmse60_val = rmse(valOutputs60,valTargets60);
rmse100_val = rmse(valOutputs100,valTargets100);
rmse120_val = rmse(valOutputs120,valTargets120);
rmse200_val = rmse(valOutputs200,valTargets200);

rmse0_test
rmse20_test
rmse60_test
rmse100_test
rmse120_test
rmse200_test

%percent_error0_test
%percent_error20_test
%percent_error60_test
%percent_error100_test
%percent_error120_test
%percent_error200_test

%rmse0_val
%rmse20_val
%rmse60_val
%rmse100_val
%rmse120_val
%rmse200_val
save('netreg','net');