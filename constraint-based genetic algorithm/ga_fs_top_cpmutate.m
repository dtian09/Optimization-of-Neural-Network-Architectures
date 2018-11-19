%a constraint-based GA to select optimal features and find optimal 2-layer irregular NN architecture (each hidden layer has different no. of hidden nodes)   
%load 'mergeddata.csv';
%x = mergeddata(:,1:37)';%transpose the inputs so that rows are features, columns are instances
%x = mergeddata(:,[1:27,29:33,35:37])';%exclude 28th, 34th features from the dataset (both features are considered noise as they have different value ranges for Blind_Case1_Smart.csv and the break size datasets)
%t = mergeddata(:,38)';%transpose the last column (targets) to a row vector   
load 'merged_data_blindtests2_3_4_5.csv';%transient data set + blind cases 2 3 4 and 5
x=merged_data_blindtests2_3_4_5(:,1:37)';
t=merged_data_blindtests2_3_4_5(:,38)';
[setting,Chrom,Best,global_bestnet,global_bestnettr,global_bestnet_rmses,global_bestnet_obj,global_bestnet_top,global_bestnet_subset]=ga(x,t);
setting %display parameters setting
global_bestnet_rmses
global_bestnet_obj
global_bestnet_top
global_bestnet_subset
mean_rmse = mean(global_bestnet_rmses)
std_rmse = std(global_bestnet_rmses)
net = global_bestnet;
tr = global_bestnettr;
net_subset = global_bestnet_subset;
save('Best','Best');%save the best objective of each generation for plotting objectives vs generations 
save('Chrom','Chrom');%save the final population of the GA which can be used as the initial population in future experimentation of the GA
save('netreg_ga_fs_top','net');
save('netreg_ga_fs_top_tr','tr');
save('netreg_ga_fs_top_subset','net_subset');

function [setting,Chrom,Best,global_bestnet,global_bestnettr,global_bestnet_rmses,global_bestnet_obj,global_bestnet_top,global_bestnet_subset]=ga(x,t)
%NIND = 10;
NIND = 30;          % Number of individuals per subpopulations
%NIND = 50;
%NIND = 80;          % Number of individuals per subpopulations
%MAXGEN = 30;        % maximum Number of generations
%MAXGEN = 3;          %maximum Number of generations
%MAXGEN = 300;       %maximum Number of generations
MAXGEN = 100;       %maximum Number of generations
%MAXGEN = 50;
%MAXGEN = 20;
%MAXGEN=2;
%GGAP = .9;          %Generation gap, how many new individuals (as a fraction of the population size) are created
GGAP = 1;            %Generation gap, how many new individuals (as a fraction of the population size) are created
%NVAR = 45;          %length of a chromosome representing a feature subset (total number of features=37) and a NN topology (4 bits for each hidden layer)
%NVAR = 49;          %length of a chromosome representing a feature subset (total number of features=37) and a NN topology (6 bits for each hidden layer)
%bits_of_inputs = 37;
%bits_of_hidden_nodes = 6;

%info_gain2=zeros(size(info_gain,1),1);
%for i=1:size(info_gain,1)
%    info_gain2(info_gain(i,2))=info_gain(i,1);
%end
% Initialise population
   %Chrom = crtbp(NIND, NVAR);
   max_inputs=36;%break size dataset
   min_inputs=20;%break size dataset
   %min_inputs=10;%break size dataset
   Chrom = initial_pop(NIND,x',min_inputs,max_inputs);
   Best = NaN*ones(MAXGEN,1);	%the best objective of a population
   gen = 1;			% initialize generational counter to current geneation  
   gen
   % Evaluate initial population
   [ObjV, bestnet, bestnettr, bestnet_rmses, bestnet_obj, bestnet_top,bestnet_subset] = objfun_fs_top_rmse2(Chrom,x,t);
   disp('initial population created');
   % Track best individual and display convergence
   Best(gen)=bestnet_obj;
   %figure;
   plot(Best,'ro');xlabel('generation'); ylabel('objective');
   text(0.5,0.95,['Best = ', num2str(Best(gen))],'Units','normalized');   
   drawnow;        
   %initialize global best results 
   global_bestnet = bestnet;
   global_bestnettr = bestnettr;
   global_bestnet_rmses = bestnet_rmses;
   global_bestnet_top = bestnet_top;
   global_bestnet_subset = bestnet_subset;
   global_bestnet_obj = bestnet_obj;
   gen=gen+1;%Increment generational counter to count next generation
   frac=0.5; pc=0.8; pc2=0.8; pm=0.05; %xor, 2xor and mutation rates of feature subsets
   frac_prime=0.5; pc_prime=0.8; pc2_prime=0.8; pm_prime=0.05;%xor, 2xor and mutation rates of hidden layer architectures
   %e_rate=0.05; %elitism rate
   e_rate=0.1; %(done in paper)
   %e_rate=0.0125;
   %e_rate=0;
   setting='population size='+string(NIND)+' max_generations='+string(MAXGEN)+' e_rate='+string(e_rate)+' f='+string(frac)+' Pxor='+string(pc)+' P2xor='+string(pc2)+' Pm='+string(pm)+' f''='+string(frac_prime)+' P''xor='+string(pc_prime)+' P''2xor='+string(pc2_prime)+' P''m='+string(pm_prime); 
   if e_rate>0
      no_of_best_individuals=round(e_rate*NIND);%no. of best individuals to keep in the current population
      best_individuals=zeros(no_of_best_individuals,49);%37 bits for inputs, 6 bits for 1st hidden layer and 6 bits for 2nd hidden layer
      ObjV_best_individuals=zeros(no_of_best_individuals,1);
   end
   net = global_bestnet;
   tr = global_bestnettr;
   net_subset = global_bestnet_subset;
   save('Best','Best');%save the best objective of each generation for plotting objectives vs generations 
   save('Chrom','Chrom');%save the final population of the GA which can be used as the initial population in future experimentation of the GA
   save('netreg_ga_fs_top','net');
   save('netreg_ga_fs_top_tr','tr');
   save('netreg_ga_fs_top_subset','net_subset');
   savefig('ga_fs_topfig.fig');
   while gen <= MAXGEN
     gen
     %Assign fitness-value to entire population
       FitnV=ranking(ObjV);        
     %Select individuals for breeding
       SelCh=select('sus', Chrom, FitnV, GGAP);
     %1-point crossover of feature subsets.
       %frac=0.5;%fraction of feature subsets population to undergo 1-point crossover
       %pc=0.8;
       %pc=0.6;
       n=round(frac*size(SelCh,1));
       indx=randperm(size(SelCh,1),n);%these feature subsets are crossed over
       inputs_pop1=recombin('xovsp',SelCh(indx,1:size(x,1)),pc);%crossover is applied to the selected feature subsets
     %2-point crossover of feature subsets
       %pc2=0.8;
       indx2=setdiff(1:size(SelCh,1),indx);%the remaining feature subsets are crossed over by 2-point xoverr
       inputs_pop2=recombin('xovdp',SelCh(indx2,1:size(x,1)),pc2);
       inputs=[inputs_pop1;inputs_pop2];
       %inputs=[SelCh(indx2,1:37);inputs_xov];       
     %mutation of feature subsets
      %frac=0.8;%fraction of feature subsets population to undergo mutation
      frac=1;
      n=round(frac*size(inputs,1));
      indx=randperm(size(inputs,1),n);%these feature subsets are mutated 
      %pm=0.0583 %0.7/length of chromosome
      %pm=0.0875;
      %pm=0.05;
      inputs2=mut(inputs(indx,:),pm);
      indx2=setdiff(1:size(inputs,1),indx);%these feature subsets are not mutated
      inputs=[inputs2;inputs(indx2,:)];
     %1-point crossover of hidden nodes
      %pc=0.8;
      %frac=0.5;%fraction of hidden nodes to undergo 1-point crossover
      %pc=0.6;
      n=round(frac_prime*size(SelCh,1));
      indx=randperm(size(SelCh,1),n);%these hidden nodes are crossed over by 1-point crossover
      hidden_nodes_pop1=recombin('xovsp',SelCh(indx,size(x,1)+1:size(x,1)+12),pc_prime);%1-p crossover is applied to the hidden nodes only
      %2-point crossover of other hidden nodes
      %pc2=0.8;
      indx2=setdiff(1:size(SelCh,1),indx);%the remaining hidden nodes are crossed over by 2-point crossover 
      hidden_nodes_pop2=recombin('xovdp',SelCh(indx2,size(x,1)+1:size(x,1)+12),pc2_prime);%2-p crossover is applied to the hidden nodes only
      hidden_nodes_pop3=[hidden_nodes_pop1;hidden_nodes_pop2];
      %mutation of hidden nodes
      frac=0.9;%fraction of hidden nodes population to undergo mutation
      n=round(frac*size(hidden_nodes_pop3,1));
      indx=randperm(size(hidden_nodes_pop3,1),n);%these hidden nodes are mutated 
      %pm=0.0583 %0.7/length of chromosome (12)
      %pm=0.0875;
      %pm=0.05;
      hidden_nodes_pop4=mut(hidden_nodes_pop3(indx,:),pm_prime);
      indx2=setdiff(1:size(SelCh,1),indx);%these hidden nodes are not mutated 
      %constraint-based nearest neighbour search to find nearest neighbours to the offspring population satisfying the constraints on min_nodes and max_nodes
      max_nodes=40;
      min_nodes=5;
      nn1=cp_nearest_neighbours(hidden_nodes_pop3(indx2,:),min_nodes,max_nodes);
      nn2=cp_nearest_neighbours(hidden_nodes_pop4,min_nodes,max_nodes);
      hidden_nodes_pop5=[nn1;nn2];
      %Append the inputs offspring population to the front of the hidden nodes offspring population
      offspring_pop=[inputs hidden_nodes_pop5];
      [ObjV_offspring_pop,bestnet, bestnettr, bestnet_rmses, bestnet_obj, bestnet_top,bestnet_subset]=objfun_fs_top_rmse2(offspring_pop,x,t);     
      if bestnet_obj < global_bestnet_obj
           global_bestnet = bestnet;
           global_bestnettr = bestnettr;
           global_bestnet_rmses = bestnet_rmses;
           global_bestnet_top = bestnet_top;
           global_bestnet_subset = bestnet_subset;
           global_bestnet_obj = bestnet_obj;
      end
      %%%elitism: insert the fittest offspring into the current population replacing the
      %%%least-fit parents and keeping the fittest parents
      %insert_r=0.9; %insertion rate
      %[Chrom,ObjV]=reins(Chrom,offspring_pop,1,[1,insert_r],ObjV,ObjV_offspring_pop);
      %%%elitism
      if e_rate>0
          FitnV2=sort(FitnV,'descend');
          for i=1:no_of_best_individuals
             indx=find(FitnV==FitnV2(i));
             best_individuals(i,:)=Chrom(indx,:);
             ObjV_best_individuals(i)=ObjV(indx);
          end
          %%%insert the best individuals of previous generation back into the current population replacing the
          %%%least-fit individuals in the current population
          %insert_r=1; %insertion rate
          %[Chrom,ObjV]=reins(Chrom,best_individuals,1,[1,insert_r],ObjV_offspring_pop,ObjV_best_individuals);    
          [Chrom,ObjV]=my_reins(offspring_pop,best_individuals,ObjV_offspring_pop,ObjV_best_individuals);  
      else %no elitism
          Chrom=offspring_pop;%replace current population with the offspring population
          ObjV=ObjV_offspring_pop;
      end
      %Update display and record current best individual
      Best(gen) = global_bestnet_obj;     
      plot(Best,'ro'); xlabel('generation'); ylabel('objective');
      text(0.5,0.95,['Best = ', num2str(global_bestnet_obj)],'Units','normalized');
      drawnow;
      gen=gen+1;%Increment generational counter to count next generation
      net = global_bestnet;
      tr = global_bestnettr;
      net_subset = global_bestnet_subset;
      save('Best','Best');%save the best objective of each generation for plotting objectives vs generations 
      save('Chrom','Chrom');%save the final population of the GA which can be used as the initial population in future experimentation of the GA
      save('netreg_ga_fs_top','net');
      save('netreg_ga_fs_top_tr','tr');
      save('netreg_ga_fs_top_subset','net_subset');
      savefig('ga_fs_topfig.fig');
   end   
end
 %%==do constraint-based local search on offspring population=====
    %input offspring population in decimal format: [[5,10,15],[12,8,9],[20,16,15],[6,12,30],[28,23,23],[30,25,30]]
    %[ObjVSel,bestnet2, bestnettr2, bestnet_rmse2, bestnet_obj2, bestnet_top2,bestnet_subset2]=objfun_fs_top_rmse2(SelCh,x,t);
    %percentile=70;%percentile 
    %cut=prctile(ObjVSel,percentile);
    %fittest_offspring=SelCh(find(ObjVSel>cut),:);%get top K% fittest offspring (K=100-percentile)
    %all_ws=string('[');%weights of all offspring
    %k=size(fittest_offspring,1);
    %for i=1:k-1
    %    fs=fittest_offspring(i,1:37);
    %    fs=length(find(fs==1));
    %    h1=fittest_offspring(i,38:43);
    %    h2=fittest_offspring(i,44:49);
    %    h1=bin2dec(num2str(h1));
    %    h2=bin2dec(num2str(h2));
    %    ws=fs*h1+h1*h2+h2;
    %    all_ws=all_ws+string(ws)+string(',');
    %end
    %fs=fittest_offspring(k,1:37);
    %fs=length(find(fs==1));
    %h1=fittest_offspring(k,38:43);
    %h2=fittest_offspring(k,44:49);
    %h1=bin2dec(num2str(h1));
    %h2=bin2dec(num2str(h2));
    %ws=fs*h1+h1*h2+h2;
    %all_ws=all_ws+string(ws)+string(']');
    %wdd=0.6;%weights difference degree between an offspring to be found and its parent
    %max_wd=10;%maximum weights difference between an offspring and its parent. This defines the local search region.
    %cmd=char(string('java -cp eclipse.jar;. -Declipse.directory="C:\Program Files\ECLiPSe 6.1" CallCP2 ')+string(all_ws)+' '+string(wdd)+' '+string(max_wd)+string(' offspring_localsearch'));
    %disp(cmd);
    %[status,~] = system(cmd);
    %if status ~= 0
    %   disp('constraint-based local search failed');
    %end
    %load offspring_localsearch;
    %offspring_localsearch2=decPop2binPop2(offspring_localsearch);
    %[ObjV_offspring_localsearch2,bestnet3, bestnettr3, bestnet_rmse3, bestnet_obj3, bestnet_top3,bestnet_subset3]=objfun_fs_top_rmse2(offspring_localsearch2,x,t);    
    %if bestnet_obj3 < global_bestnet_obj && bestnet_obj3 < bestnet_obj2 
    %       global_bestnet = bestnet3;
    %       global_bestnettr = bestnettr3;
    %       global_bestnet_rmse = bestnet_rmse3;
    %       global_bestnet_top = bestnet_top3;
    %       global_bestnet_subset = bestnet_subset3;
    %       global_bestnet_obj = bestnet_obj3;
    %elseif bestnet_obj2 < global_bestnet_obj && bestnet_obj2 < bestnet_obj3 
    %       global_bestnet = bestnet2;
    %       global_bestnettr = bestnettr2;
    %       global_bestnet_rmse = bestnet_rmse2;
    %       global_bestnet_top = bestnet_top2;
    %       global_bestnet_subset = bestnet_subset2;
    %       global_bestnet_obj = bestnet_obj2;
    %else
    %end       
    %SelCh=[SelCh;offspring_localsearch2];%merge the offspring of mutation with those of contraint-based local search
    %ObjVSel=[ObjVSel;ObjV_offspring_localsearch2];
    %===constraint-based local search end ===
function [Chrom,ObjV_Chrom]=my_reins(Chrom,individuals,ObjV_Chrom,ObjV_individuals)
%insert the individuals into a population Chrom replacing the least fit
%individuals of Chrom
ObjV_Chrom2=sort(ObjV_Chrom,'descend');%best individual has the smallest objective and are at the bottom of the ranking
n=size(individuals,1);
ObjV_largest=ObjV_Chrom2(1:n);%get the largest objectives which are at the top of the ranking
for i=1:size(individuals,1)
    indx=find(ObjV_Chrom==ObjV_largest(i));
    Chrom(indx,:)=individuals(i,:);
    ObjV_Chrom(indx)=ObjV_individuals(i);
end
end
function networks_bin=initial_pop(NIND,x,min_inputs,max_inputs)
%use feature selection to select inputs, then use constraint programming to create hidden layers
%inputs=cfs(x,t,NIND);
inputs=random_fs(NIND,x,min_inputs,max_inputs);
%inputs
networks_dec=create_hidden_layers(inputs);
%networks_dec
networks_bin=decPop2binPop(networks_dec,inputs,x);
networks_bin
end
function inputs=random_fs(NIND,x,min_inputs,max_inputs)
%generate NIND random feature subsets of sizes between min_size and max_size
%inputs: NIND, size of population
%        inputs, a mxn matrix (m is # of instances, n is # of features)
subset_sizes=randi([min_inputs,max_inputs],NIND,1);
inputs=zeros(NIND,size(x,2));%for break size dataset, population of 37-bit chromosomes 
for i=1:NIND
    subset_size=subset_sizes(i);
    fs_indx=randperm(size(x,2),subset_size);
    inputs(i,fs_indx)=1;
    %inputs(i,fs_indx)
end
end
function nearest_neighbours=cp_nearest_neighbours(hidden_nodes_pop,min_nodes,max_nodes)
%Find the nearest neighbour architecture of each hidden layer architecture in a population
%The nearest neighbour architecture of a hidden layer architecture consists of the nearest neighbours of the hidden layers of the architecture 
%The nearest neighbour of a hidden layer is a hidden layer that 
%1) has the smallest hamming distance to the the hidden layer
%	and 
%2) encodes the closest decimal integer to the integer encoded by the hidden layer satisfying the constraints.
architectures=string('[');
for i=1:size(hidden_nodes_pop,1)-1
    h1=hidden_nodes_pop(i,1:6);
    h2=hidden_nodes_pop(i,7:12);
    layer1=string('[[');
    for j=1:length(h1)-1
        layer1=layer1+h1(j)+string(',');
    end
    layer1=layer1+h1(length(h1))+string('],');
    layer2=string('[');
    for k=1:length(h2)-1
        layer2=layer2+h2(k)+string(',');
    end
    layer2=layer2+h2(length(h2))+string(']]');
    architectures=architectures+layer1+layer2+string(',');
end
h1=hidden_nodes_pop(size(hidden_nodes_pop,1),1:6);
h2=hidden_nodes_pop(size(hidden_nodes_pop,1),7:12);
layer1=string('[[');
for j=1:length(h1)-1
    layer1=layer1+h1(j)+string(',');
end
layer1=layer1+h1(length(h1))+string('],');
layer2=string('[');
for k=1:length(h2)-1
    layer2=layer2+h2(k)+string(',');
end
layer2=layer2+h2(length(h2))+string(']]');
architectures=architectures+layer1+layer2+string(']');
architectures
%cmd=char(string('java -cp eclipse.jar;. -Declipse.directory="C:\Program Files\ECLiPSe 6.1" CallCP2 ')+string(architectures)+string(' ')+string(min_nodes)+string(' ')+string(max_nodes)+string(' nearest_neighbours'));
cmd=char(string('C:\Users\tian03\Downloads\jre1.8.0_102\bin\java -cp eclipse.jar;. -Declipse.directory="C:\Program Files\ECLiPSe 6.1" CallCP2 ')+string(architectures)+string(' ')+string(min_nodes)+string(' ')+string(max_nodes)+string(' nearest_neighbours'));
disp(cmd);
[status,~] = system(cmd);
if status ~= 0
   disp('CallCP2 ran unsuccessfully');
end
load nearest_neighbours;
end
%function inputs=cfs(x,t,NIND)%correlation-based feature selection
%data=[x' t'];
%c=corr(data);
%set p1, p2 to control sizes of feature subsets
%p1, p2 are set based on boxplots of features.
%p1=0.3;%the smaller p1, the more features selected
%p2=0.3;%the smaller p1, the less features selected
%p2=0.4;
%inputs=zeros(NIND,37);
%for i=1:NIND
%    f=randi(37);
%    while abs(c(f,38))<=p1 %select f if corr(f,38)>p1     
%        f=randi(37);
%    end
%    fs=zeros(1,37);%a feature subset bit string
%    considered = zeros(1,37);%features have been considered for selection
%    fs(f)=1;%select the first input f
%    considered(f)=1;
%    while length(find(considered==1))<37 %select other inputs until all are looked at
%        f2=randi(37);
%        if considered(f2)==0
%           considered(f2)=1;
%           if abs(c(f2,38))>p1 %check correlation of f2 with output > p1
%              select_f2=1;      
%              fsindx=find(fs==1);
%              for j=1:length(fsindx)%check correlation of f2 with each selected f
%               if abs(c(f2,fsindx(j)))>=p2%select f2 if correlation of f2 with each selected feature is < p2 and correlation of f2 with output > p1
%                    select_f2=0;
%                    break;
%                end
%              end
%              if select_f2==1
%                 fs(f2)=1;
%              end
%           end
%        end 
%    end
%    inputs(i,:)=fs;
%end
%end
function initialnetworks=create_hidden_layers(inputs)
  k=size(inputs,1);%no. of networks to create
  networks_inputs=string('[');
  for i=1:k-1
     no_of_inputs=length(find(inputs(i,:)==1));
     networks_inputs=networks_inputs+string(no_of_inputs)+string(',');
  end
  no_of_inputs=length(find(inputs(k,:)==1));
  networks_inputs=networks_inputs+string(no_of_inputs)+string(']');
  networks_inputs
  %cmd='java -cp eclipse.jar;. -Declipse.directory="C:\Program Files\ECLiPSe 6.1" CallCP [15,20,30,20,18,21,20,25] initialnetworkss';
  %cmd=char(string('java -cp eclipse.jar;. -Declipse.directory="C:\Program Files\ECLiPSe 6.1" CallCP ')+string(networks_inputs)+string(' initialnetworks'));
  cmd=char(string('C:\Users\tian03\Downloads\jre1.8.0_102\bin\java -cp eclipse.jar;. -Declipse.directory="C:\Program Files\ECLiPSe 6.1" CallCP ')+string(networks_inputs)+string(' initialnetworks'));
  disp(cmd);
  [status,~] = system(cmd);
  if status ~= 0
     disp('CallCP ran unsuccessfully');
  end
  load initialnetworks;
end
function [SelCh2,k]=remove_large_and_small_networks(SelCh,min_nodes,max_nodes,x)
[~,Chrom2_dec,~]=binPop2decPop(SelCh,x);
k=0;
valid_networks=zeros(1);
for i=1:size(Chrom2_dec,1)
    network = Chrom2_dec(i,:);
    if network(2) > min_nodes-1 && network(3) > min_nodes-1 && network(2) < max_nodes+1 && network(3) < max_nodes+1 %remove networks with h1 > max_nodes or h2 > max_nodes
       k=k+1;        
       valid_networks(k)=i;      
    end
end
if valid_networks(1)==0
    disp('all networks are removed by constraints');
    SelCh2=0;
else
    SelCh2=SelCh(valid_networks,:);
end
end
function [SelCh2,k]=remove_large_and_small_networks2(SelCh,min_ws,max_ws,x)
[~,Chrom2_dec,~]=binPop2decPop(SelCh,x);
k=0;
valid_networks=zeros(1);
for i=1:size(Chrom2_dec,1)
    network = Chrom2_dec(i,:);
    ws=network(1)*network(2)+network(2)*network(3)+network(3);
    if ws > min_ws-1 && ws < max_ws+1
       k=k+1;        
       valid_networks(k)=i;      
    end
end
if valid_networks(1)==0
    disp('all networks are removed by constraints');
    SelCh2=0;
else
    SelCh2=SelCh(valid_networks,:);
end
end
function binPop=decPop2binPop(decPop,inputsPop,x)
%decPop: nx3 matrix where n is number of networks. each row is a network and has format [no_of_inputs h1 h2]
%inputsPop: population of binary chromosomes representing inputs of networks
%x, inputs, a mxn matrix (m= #of instances,n= # of features)
%Convert the decimal numbers representing h1 and h2 to binary numbers. 
binPop=zeros(size(decPop,1),size(x,2)+12);
for i=1:size(decPop,1)
    h1=decPop(i,2);
    h1=dec2bin(h1,6);%Use 6 bits to represent h1 and h2 respectively
    h2=decPop(i,3);
    h2=dec2bin(h2,6);
    %h1=h1-'0';%convert a binary vector of length 1 to a binary vector of length 6 
    %h2=h2-'0';
    binPop(i,1:size(x,2))=inputsPop(i,1:size(x,2));%insert the binary chromosome representing the inputs
    binPop(i,size(x,2)+1:size(x,2)+6)=h1;
    binPop(i,size(x,2)+7:size(x,2)+12)=h2;
end
end
function [networks,networks2,n] = binPop2decPop(binPop,x)
networks=string('[');
networks2=zeros(size(binPop,1),3);
n=0;%number of networks excluding any networks with 0 inputs
for i=1:size(binPop,1)-1
    fs=binPop(i,1:size(x,1));
    fs=length(find(fs==1));
    h1=binPop(i,size(x,1):size(x,1)+5);
    h2=binPop(i,size(x,1)+6:size(x,1)+11);
    h1=bin2dec(num2str(h1));
    h2=bin2dec(num2str(h2));
    if fs>0 && h1>0 && h2>0
       network=string('[')+string(fs)+string(',')+string(h1)+string(',')+string(h2)+string('],');
       n=n+1;
       %disp(network);
       networks=networks+network;
       networks2(i,:)=[fs h1 h2];
       %disp(networks2);    
    else
       fs
       h1
       h2
    end
end
fs=binPop(size(binPop,1),1:size(x,1));%get feature subset
fs=length(find(fs==1));
h1=binPop(size(binPop,1),size(x,1):size(x,1)+5);%hidden layer 1 nodes
h2=binPop(size(binPop,1),size(x,1)+6:size(x,1)+11);%hidden layer 2 nodes
h1=bin2dec(num2str(h1));
h2=bin2dec(num2str(h2));
if fs>0 && h1>0 && h2>0
    network=string('[')+string(fs)+string(',')+string(h1)+string(',')+string(h2)+string(']]');
    networks=networks+network;
    networks2(size(binPop,1),:)=network;
    n=n+1;
else
    networks=networks+string('[9,9,9]]');
end
%disp(networks2);
end
%function [min_r,max_r]=get_max_min_inputs_to_hidden_nodes_ratios(decPop)
%rs=zeros(size(decPop,1),1);
%k=1;
%for i=1:size(decPop,1)
%    if decPop(i,1)>0 && decPop(i,2)>0 && decPop(i,3)>0 
%        rs(k)=decPop(i,1)/(decPop(i,2)+decPop(i,3));%ratio=inputs/(h1+h2)
%        k=k+1;
%    end
%end
%min_r=min(rs);
%max_r=max(rs);
%end
%function [min_w,max_w]=get_max_min_weights(decPop)
%ws=zeros(size(decPop,1),1);
%k=1;
%for i=1:size(decPop,1)
%    inputs=decPop(i,1);
%    h1=decPop(i,2);
%    h2=decPop(i,3);
%    if inputs>0 && h1>0 && h2>0
%        ws(k)=inputs*h1+h1*h2+h2;
%        k=k+1;
%    end
%end
%min_w=min(ws);
%max_w=max(ws);
%end

