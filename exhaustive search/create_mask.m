%create a mask (a nx1 vector) to extract those elements with the specified target from another matrix
function mask = create_mask(targets,target)
    %targets is a nx1 vector of targets
    %A target is a break size target
    mask = zeros(length(targets),1);
    for j=1:length(mask)
        if target==0 && targets(j,1)==0 
            mask(j,1) = 1;
        elseif (targets(j,1) == target)
            mask(j,1) = 1;
        else
            mask(j,1) = nan;%a instance with a different break size to the target break size
        end
    end
end