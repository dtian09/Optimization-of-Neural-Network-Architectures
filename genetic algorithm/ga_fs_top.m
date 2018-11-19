%a GA to select optimal features and find optimal 2-layer irregular NN architecture (each hidden layer has different no. of hidden nodes)   
%load 'all_break_sizes_interpolated.csv';%all break sizes from 0% to 200% including interpolated data
%load 'all_break_sizes_interpolated_labels.csv';
%x = all_break_sizes_interpolated;
%t = all_break_sizes_interpolated_labels';
load 'mergeddata.csv';
%x = mergeddata(:,1:37)';%transpose the inputs so that rows are features, columns are instances
x = mergeddata(:,[1:27,29:33,35:37])';%exclude 28th, 34th features from the dataset (both features are considered noise as they have different value ranges for Blind_Case1_Smart.csv and the break size datasets)
t = mergeddata(:,38)';%transpose the last column (targets) to a row vector   
global_bestnet_obj=100;
global_bestnet=-1;
global_bestnettr=-1;
global_bestnet_rmse=100;
global_bestnet_top=-1;
global_bestnet_subset=-1;
[bestnet,bestnettr,bestnet_rmse,bestnet_obj,bestnet_top,bestnet_subset]=ga(x,t);
if bestnet_obj < global_bestnet_obj
   global_bestnet = bestnet;
   global_bestnettr = bestnettr;
   global_bestnet_rmse = bestnet_rmse;
   global_bestnet_obj = bestnet_obj;
   global_bestnet_top = bestnet_top;
   global_bestnet_subset = bestnet_subset;
end
global_bestnet_rmse
global_bestnet_obj
global_bestnet_top
global_bestnet_subset
mean_rmses = mean(global_bestnet_rmse)
std_rmses = std(global_bestnet_rmse)
net = global_bestnet;
tr = global_bestnettr;
net_subset = global_bestnet_subset;
save('netreg_ga_fs_top','net');
save('netreg_ga_fs_top_tr','tr');
save('netreg_ga_fs_top_subset','net_subset');

function [global_bestnet,global_bestnettr,global_bestnet_rmse,global_bestnet_obj,global_bestnet_top,global_bestnet_subset]=ga(x,t)
NIND = 40;           % Number of individuals per subpopulations
%MAXGEN = 30;        % maximum Number of generations
%NIND = 30;          % Number of individuals per subpopulations
MAXGEN = 3;         %maximum Number of generations
%MAXGEN = 100;       %maximum Number of generations
%MAXGEN = 300;       %maximum Number of generations
%MAXGEN = 50;
GGAP = .9;           %Generation gap, how many new individuals are created
%NVAR = 45;          %length of a chromosome representing a feature subset (total number of features=37) and a NN topology (4 bits for each hidden layer)
NVAR = 43;           %length of a chromosome representing a feature subset (total number of features=35) and a NN topology (4 bits for each hidden layer)

% Initialise population
   Chrom = crtbp(NIND, NVAR);

% Reset counters
   Best = NaN*ones(MAXGEN,1);	% best in current population
   gen = 0;			% generational counter
   
   % Evaluate initial population

   [ObjV, bestnet, bestnettr, bestnet_rmse, bestnet_top,bestnet_subset] = objfun_fs_top_rmse_iter(Chrom,x,t);
 
  % Track best individual and display convergence
   gen = gen +1;
   Best(gen) = min(ObjV);
   figure;
   plot(Best,'ro');xlabel('generation'); ylabel('objective(mean rmse + std(rmses))');
   text(0.5,0.95,['Best = ', num2str(Best(gen))],'Units','normalized');   
   drawnow;        
   %initialize global best results 
   global_bestnet = bestnet;
   global_bestnettr = bestnettr;
   global_bestnet_rmse = bestnet_rmse;
   global_bestnet_top = bestnet_top;
   global_bestnet_subset = bestnet_subset;
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
       pc = 0.7;
       SelCh = recombin('xovsp',SelCh,pc);

    % Perform mutation on offspring
       pm = 0.033;
       SelCh = mut(SelCh,pm);
    
    % Evaluate offspring, call objective function
       [ObjVSel, bestnet, bestnettr, bestnet_rmse,bestnet_top,bestnet_subset] = objfun_fs_top_rmse_iter(SelCh,x,t);
       if min(ObjVSel)< min(ObjV)
            global_bestnet = bestnet;
            global_bestnettr = bestnettr;
            global_bestnet_rmse = bestnet_rmse;
            global_bestnet_top = bestnet_top;
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
   savefig('ga_fs_topfig.fig');
end