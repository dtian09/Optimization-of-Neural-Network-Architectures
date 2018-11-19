%ECLiPSe program to create random MLP architectures
%ECLiPSe website: http://eclipseclp.org/
:-lib(fd).
%:-lib(fd_prop_test_util).
:-lib(random).
%:-lib(ic).

hiddenlayers(NetworksInputs,File):-
	%NetworksInputs, a list of number of inputs of networks e.g. [15,20,19] (3 networks with 15, 20 and 19 inputs respectively)
	%File, output file
	(createhiddenlayers(NetworksInputs,Networks)
	;
	writeln('createhiddenlayers failed'),
	true),
	open(File,write,S),
	%writeln(Networks),
	sort(0,<,Networks,Networks2),%remove duplicate networks
	(foreach(Network,Networks2),param(S)
	do
	  %Network=[Inputs,H1,H2],%H1, hidden nodes in layer 1, H2, hidden nodes in layer 2
	  %Network=[Inputs,H1,H2,H3],
	  Network=[Inputs,H1,H2,H3,H4],
	  write(Inputs),
	  write(' '),
	  write(H1),
	  write(' '),
	  %writeln(H2),
	  write(H2),
	  write(' '),
	  %writeln(H3),
	  write(H3),
	  write(' '),
	  writeln(H4),
	  write(S,Inputs),
	  write(S,' '),
	  write(S,H1),
	  write(S,' '),
	  %writeln(S,H2),
	  write(S,H2),
	  write(S,' '),
	  %writeln(S,H3)
  	  write(S,H3),
  	  write(S,' '),
  	  writeln(S,H4)
	),
	close(S),				
	writeln(File+" created").

createhiddenlayers(NetworksInputs,Networks):-
		%Min_W is 1350,%break size data
		%Max_W is 1370,%break size data
		%Min_W is 1374,%break size data
		%Max_W is 1374+10,%break size data
		%Min_W is 1400,%break size data
		Min_W is 1500,%break size data
		%Max_W is 1500,%break size data
		%Min_W is 1600,%break size data
		Max_W is 1800,%break size data
		%Min_W is 500-10,%example CSP1 in GA paper
		%Max_W is 500+10,%example CSP1 in GA paper
		%Min_W is 1000, %skillcraft dataset
		%Max_W is 2600, %skillcraft dataset
		%Min_W is 1000, %CBM dataset
		%Max_W is 2000, %CBM dataset		
		%Min_W is 500,  %SML2010 dataset
		%Max_W is 1000, %SML2010 dataset
		%Min_nodes=1,
		%Max_nodes=60,
		Min_nodes=5,
		Max_nodes=40,
		%(foreach(NetworkInputs,NetworksInputs),foreach([NetworkInputs,H1,H2],Networks),param(Min_nodes,Max_nodes,Min_W,Max_W)
		%(foreach(NetworkInputs,NetworksInputs),foreach([NetworkInputs,H1,H2,H3],Networks),param(Min_nodes,Max_nodes,Min_W,Max_W)
		(foreach(NetworkInputs,NetworksInputs),foreach([NetworkInputs,H1,H2,H3,H4],Networks),param(Min_nodes,Max_nodes,Min_W,Max_W)
		do
			fd:(H1 #::Min_nodes..Max_nodes),%break size dataset, CBM dataset, SML2010  
			fd:(H2 #::Min_nodes..Max_nodes),%break size dataset
			fd:(H3 #::Min_nodes..Max_nodes),%break size dataset
			fd:(H4 #::Min_nodes..Max_nodes),%break size dataset
			%H1 #> H2,
			%fd:(H1 #::20..45),%skillcraft dataset
			%fd:(H2 #::20..45),%skillcraft dataset
			%fd:(Min_W #<= NetworkInputs*H1+H1*H2+H2),%2-hidden layer networks
			%fd:(NetworkInputs*H1+H1*H2+H2 #<= Max_W)%2-hidden layer networks
			%fd:(Min_W #<= NetworkInputs*H1+H1*H2+H2*H3+H3),%3-hidden layer networks
			%fd:(NetworkInputs*H1+H1*H2+H2*H3+H3 #<= Max_W) %3-hidden layer networks
			fd:(Min_W #<= NetworkInputs*H1+H1*H2+H2*H3+H3*H4+H4),%4-hidden layer networks
			fd:(NetworkInputs*H1+H1*H2+H2*H3+H3*H4+H4 #<= Max_W) %4-hidden layer networks
		),
		(foreach(Network,Networks),param(Min_nodes,Max_nodes)
		do
			%Network=[_,H1,H2],
			%Network=[_,H1,H2,H3],
			Network=[_,H1,H2,H3,H4],
			%%label H1
			%(for(I,10,40),fromto([],In,Out,L)%break size dataset, CBM dataset
			(for(I,Min_nodes,Max_nodes),fromto([],In,Out,L)%break size dataset
			%(for(I,30,45),fromto([],In,Out,L)%skillcraft dataset
			do
			  Out=[I|In]
			),
			sort(0,>,L,L2),
			rand_perm(L2,X),%random permutation of values
			member(V,X),%label H1 with a random value
			H1=V,
			%%label H2
			(for(I,Min_nodes,Max_nodes),fromto([],In,Out,L3)%break size dataset
			%(for(I,10,40),fromto([],In,Out,L3)%break size dataset, CBM dataset
			%(for(I,30,45),fromto([],In,Out,L3)%skillcraft dataset
			do
			  Out=[I|In]
			),
			sort(0,>,L3,L4),
			rand_perm(L4,Y),%random permutation of values
			member(V2,Y),%label H2 with a random value
			H2=V2,
			%%label H3
			(for(I,Min_nodes,Max_nodes),fromto([],In,Out,L5)%break size dataset
			do
			  Out=[I|In]
			),
			sort(0,>,L5,L6),
			rand_perm(L6,Z),%random permutation of values
			member(V3,Z),
			H3=V3,
			%%label H4
			(for(I,Min_nodes,Max_nodes),fromto([],In,Out,L7)%break size dataset
			do
			  Out=[I|In]
			),
			sort(0,>,L7,L8),
			rand_perm(L8,U),%random permutation of values
			member(V4,U),
			H4=V4
		).