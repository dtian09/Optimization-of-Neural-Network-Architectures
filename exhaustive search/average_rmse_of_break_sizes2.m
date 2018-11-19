function [average_rmse,rmses] = average_rmse_of_break_sizes2(y,testTargets)
%y, a row vector of ouputs of a network
%testTargets, a row vector of targets
y = y';%transpose y (a row vector) to a column vector
%Generate masks of break sizes in test set
testTargets = testTargets';%transpose testTargets (a row vector) to a column vector
indices = find(isnan(testTargets)==0);
if length(indices)==0
    disp('testTargets is all Nan');
end
mask0_test=create_mask(testTargets,0);
indices = find(isnan(mask0_test)==0);
if length(indices)==0
   disp('mask0 is all Nan');
end
mask20_test = create_mask(testTargets,20);
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
average_rmse = 0;
if (isnan(rmse0_test)==0)
  average_rmse = average_rmse + rmse0_test;
else
    disp('rmse0_test is Nan'); 
end
if (isnan(rmse20_test)==0)
  average_rmse = average_rmse + rmse20_test;
else
    disp('rmse20_test is Nan');  
end
if (isnan(rmse60_test)==0)
  average_rmse = average_rmse + rmse60_test;
else
    disp('rmse60_test is Nan');
end
if (isnan(rmse100_test)==0)
  average_rmse = average_rmse + rmse100_test;
else
    disp('rmse100_test is Nan');
end
if (isnan(rmse120_test)==0)
  average_rmse = average_rmse + rmse120_test;
else
    disp('rmse120_test is Nan');
end
if (isnan(rmse200_test)==0)
  average_rmse = average_rmse + rmse200_test;
else
    disp('rmse200_test is Nan');
end
if average_rmse == 0
    average_rmse = -999;%all rmse are Nan.
    disp('all rmses are Nan');
else
    average_rmse = average_rmse/6;
end
rmses = [rmse0_test rmse20_test rmse60_test rmse100_test rmse120_test rmse200_test];
