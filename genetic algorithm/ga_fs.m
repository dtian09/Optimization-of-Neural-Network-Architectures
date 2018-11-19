%a GA to select optimal features and train regular NN architectures (same no. of nodes in each hidden layer) e.g. a 2-hidden layer mlp with 12 hidden nodes in each layer 
%load 'all_break_sizes_interpolated.csv';%all break sizes from 0% to 200% including interpolated data
%load 'all_break_sizes_interpolated_labels.csv';
%x = all_break_sizes_interpolated;
%t = all_break_sizes_interpolated_labels';
load 'mergeddata.csv';
x = mergeddata(:,1:37)';%transpose the inputs so that rows are features, columns are instances
t = mergeddata(:,38)';%transpose the last column (targets) to a row vector   
%all_ws = [600 590 580 570 560 550 540 530 520 510 500];
all_ws = [600];
global_bestnet_obj=100;
global_bestnet=-1;
global_bestnettr=-1;
global_bestnet_rmse=100;
global_bestnet_subset=-1;
for i=1:length(all_ws)
    all_ws(i)
    [bestnet,bestnettr,bestnet_subset,bestnet_rmse,bestnet_obj]=ga(x,t,all_ws(i));
    if bestnet_obj < global_bestnet_obj
        global_bestnet = bestnet;
        global_bestnettr = bestnettr;
        global_bestnet_rmse = bestnet_rmse;
        global_bestnet_subset = bestnet_subset;
        global_bestnet_obj = bestnet_obj;
    end
    global_bestnet_rmse
    global_bestnet_obj
end
net = global_bestnet;
tr = global_bestnettr;
net_subset = global_bestnet_subset;
global_bestnet_obj
global_bestnet_rmse
save('netreg_ga_fs','net');
save('netreg_ga_fs_tr','tr');
save('netreg_ga_fs_subset','net_subset');

function [global_bestnet,global_bestnettr,global_bestnet_subset,global_bestnet_rmse,global_bestnet_obj]=ga(x,t,ws)
%NIND = 40;           % Number of individuals per subpopulations
%MAXGEN = 30;        % maximum Number of generations
NIND = 30;           % Number of individuals per subpopulations
%MAXGEN = 3;        % maximum Number of generations
MAXGEN = 10;        % maximum Number of generations
GGAP = .9;           % Generation gap, how many new individuals are created
NVAR = 37;           % Number of variables

% Initialise population
   Chrom = crtbp(NIND, NVAR);

% Reset counters
   Best = NaN*ones(MAXGEN,1);	% best in current population
   gen = 0;			% generational counter
   
   % Evaluate initial population
  %[ObjV, bestnet, bestnettr, bestnet_rmse, bestnet_subset] = objfun_rmse(Chrom,x,t);
   %ws=600;
   [ObjV, bestnet, bestnettr, bestnet_rmse, bestnet_subset] = objfun_rmse_iter(Chrom,x,t,ws);
 
  % Track best individual and display convergence
   gen = gen +1;
   Best(gen) = min(ObjV);
   figure(ws);
   plot(Best,'ro');xlabel('generation'); ylabel('objective(mean rmse + std(rmses))');
   text(0.5,0.95,['Best = ', num2str(Best(gen))],'Units','normalized');   
   drawnow;        
   global_bestnet = bestnet;
   global_bestnettr = bestnettr;
   global_bestnet_rmse = bestnet_rmse;
   global_bestnet_subset = bestnet_subset;% feature subset (inputs) of best NN
   global_bestnet_obj = ObjV;
% Generational loop
   while gen < MAXGEN
     % Increment generational counter to count current generation
       gen = gen+1;
    % Assign fitness-value to entire population
       FitnV = ranking(ObjV);

    % Select individuals for breeding
       SelCh = select('sus', Chrom, FitnV, GGAP);

    % Recombine selected individuals (crossover)
       SelCh = recombin('xovsp',SelCh,0.7);

    % Perform mutation on offspring
       SelCh = mut(SelCh);

    % Evaluate offspring, call objective function
    %  [ObjVSel, bestnet, bestnettr, bestnet_rmse,bestnet_subset] = objfun_rmse(SelCh,x,t);
       [ObjVSel, bestnet, bestnettr, bestnet_rmse,bestnet_subset] = objfun_rmse_iter(SelCh,x,t,ws);
       if min(ObjVSel)< min(ObjV)
            global_bestnet = bestnet;
            global_bestnettr = bestnettr;
            global_bestnet_rmse = bestnet_rmse;
            global_bestnet_subset = bestnet_subset;
            global_bestnet_obj = min(ObjVSel);
        end
    % Reinsert offspring into current population
       [Chrom, ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);

    % Update display and record current best individual
       Best(gen) = min(ObjV);     
       plot(Best,'ro'); xlabel('generation'); ylabel('objective(mean rmse + std(rmses))');
       text(0.5,0.95,['Best = ', num2str(Best(gen))],'Units','normalized');
       drawnow;      
   end
   savefig('ga_fsfig.fig');
end