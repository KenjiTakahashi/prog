sublist([],[]).
sublist([H|T1],[H|T2]):-
	sublist(T1,T2).
sublist([_|T1],T2):-
	sublist(T1,T2).
