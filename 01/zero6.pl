perm([],[]).
perm([H|T],L):-
	perm(T,R),
	select(H,L,R).
