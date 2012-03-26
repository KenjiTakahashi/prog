perm([],[]).
perm(L,[H|T]):-
	select(H,L,R),
	perm(R,T).
