%compute rmse of a single output
function rmse_val = rmse(outputs,targets)
    %outputs: a nx1 vector
    %targets: a nx1 vector
    %sse = 0;
    %total = 0; %number of non-Nan in the targets vector
    indices = find(isnan(targets)==0);
    if isempty(indices)
        disp('indices is empty');
    end
    diff = outputs(indices)-targets(indices);
    sse = diff.^2;
    mse = sum(sse)/length(sse);
    rmse_val = sqrt(mse);
    if isnan(rmse_val)
        disp('sqrt(mse) is Nan');
    end
    %indices
    %sse
    %mse
    %for i=1:length(targets)
    %    t = targets(i,1); 
    %    if (isnan(t)==0)
    %        sse = sse + (outputs(i,1) - t)^2;
    %        total = total + 1;
    %    end
    %end
    %mse = sse/total;
    %rmse_val = sqrt(mse);    
end