bin([0]).
bin(X):-
	bin2(1,[],X,1).
bin2(0,X,X,_).
bin2(0,X,X,G):-
	GG is G+1,
	bin2(GG,[],X,GG).
bin2(A,Z,X,G):-
	AA is A // 2,
	B is A mod 2,
	bin2(AA,[B|Z],X,G).
