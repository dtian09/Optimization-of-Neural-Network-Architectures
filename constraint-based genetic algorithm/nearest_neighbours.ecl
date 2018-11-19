%Find the nearest neighbour architecture of each hidden layer architecture
%The nearest neighbour architecture of a hidden layer architecture consists of the nearest neighbours of the hidden layers of the architecture 
%The nearest neighbour of a hidden layer is a hidden layer that 
%1) has the smallest hamming distance to the the hidden layer
%	and 
%2) encodes the closest decimal integer to the integer encoded by the hidden layer satisfying the constraints.

:-lib(ic).
%:-lib(random).
:-lib(branch_and_bound).

nearest_neighbours(Hidden_Layer_Architectures,Min_nodes,Max_nodes,File):-
%input: Hidden_Layer_Architectures, 2-hidden layer network architectures e.g. list of 3 networks is [[[1,0,1,1,1,1],[0,1,1,1,1,1]],[[1,1,1,1,1,1],[0,0,1,1,1,1]],[[1,0,0,1,0,1],[0,1,1,0,0,0]]] 
%	Min_nodes,
%	Max_nodes,
%	File, output file
	(find_nearest_neighbours(Hidden_Layer_Architectures,Min_nodes,Max_nodes,NearestNeighbours)	
	;
	writeln('find_nearest_neighbours failed'),
	true),
	open(File,write,S),
	writeln(NearestNeighbours),
	(foreach(NN,NearestNeighbours),param(S)
	do
	  (foreach(B,NN),param(S)
	  do
	    write(S,B),
	    write(S,' '),
	    write(B),
	    write(' ')
	  ),
	  writeln(S,''),
	  writeln('')
	),
	close(S),				
	writeln(File+" created").

find_nearest_neighbours(Hidden_Layer_Architectures,Min_nodes,Max_nodes,NearestNeighbours):-
	(foreach(Hidden_Layer_Architecture,Hidden_Layer_Architectures),foreach(L,NearestNeighbours),param(Min_nodes,Max_nodes)
	do
		ic:([B1,B2,B3,B4,B5,B6]#::0..1),%hidden layer 1
		ic:([C1,C2,C3,C4,C5,C6]#::0..1),%hidden layer 2
		Hidden_Layer_Architecture=[H1,H2],
		B1*32+B2*16+B3*8+B4*4+B5*2+B6*1 $>=Min_nodes,
		B1*32+B2*16+B3*8+B4*4+B5*2+B6*1 $=<Max_nodes,
		C1*32+C2*16+C3*8+C4*4+C5*2+C6*1 $>=Min_nodes,
		C1*32+C2*16+C3*8+C4*4+C5*2+C6*1 $=<Max_nodes,
		B1*32+B2*16+B3*8+B4*4+B5*2+B6*1 $>=C1*32+C2*16+C3*8+C4*4+C5*2+C6*1,%nodes of 1st layer >= nodes of 2nd layer		
		hamm_dist([B1,B2,B3,B4,B5,B6],H1,Hamm_dist1),
		hamm_dist([C1,C2,C3,C4,C5,C6],H2,Hamm_dist2),
		decimal_dist([B1,B2,B3,B4,B5,B6],H1,Min_nodes,Max_nodes,Decimal_dist1),
		decimal_dist([C1,C2,C3,C4,C5,C6],H2,Min_nodes,Max_nodes,Decimal_dist2),
		ic:(Obj $= eval(Hamm_dist1)+eval(Hamm_dist2)+eval(Decimal_dist1)+eval(Decimal_dist2)),
		L=[B1,B2,B3,B4,B5,B6,C1,C2,C3,C4,C5,C6],
		%rand_perm(L,L2),
		branch_and_bound:(minimize(search(L,0,first_fail,indomain_random,complete,[]),Obj))  		
		%writeln([B1,B2,B3,B4,B5,B6]),
		%writeln([C1,C2,C3,C4,C5,C6]),
		%X is eval(Hamm_dist1),
		%writeln(X),
		%X2 is eval(Hamm_dist2),
		%writeln(X2),
		%X3 is eval(Decimal_dist1),
		%writeln(X3),
		%X4 is eval(Decimal_dist2),
		%writeln(X4)
	).
	%open(File,write,S),
	%(foreach(B,L),param(S)
	%do
	%  write(S,B),
	%  write(S,' ')
	%),
	%close(S),				
	%writeln(File+" created").

hamm_dist(L1,L2,Dist):-
	(foreach(E1,L1),foreach(E2,L2),fromto(0,In,Out,Dist)
	do
		Out=In+(E1-E2)^2
	).

decimal_dist([B1,B2,B3,B4,B5,B6],[V1,V2,V3,V4,V5,V6],Min_nodes,Max_nodes,Decimal_dist):-
	Chrom=V1*32+V2*16+V3*8+V4*4+V5*2+V6*1,
	(Chrom > Max_nodes
	->
	Decimal_dist=Chrom-(B1*32+B2*16+B3*8+B4*4+B5*2+B6*1)
	;
	(Chrom < Min_nodes
	->
	Decimal_dist=B1*32+B2*16+B3*8+B4*4+B5*2+B6*1-Chrom
	;
	Decimal_dist=0
	)).
	