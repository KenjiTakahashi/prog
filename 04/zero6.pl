split([],_,[],[]):-!.
split([H|T],X,[H|S],Z):-
	H<X,!,
	split(T,X,S,Z).
split([H|T],X,S,[H|Z]):-
	H>=X,!,
	split(T,X,S,Z).
	
qsort([],[]).
qsort(L,R):-
	qsort(L,[],R).
qsort([],A,A).
qsort([H|T],A,R):-
	split(T,H,I,J),
	qsort(J,A,S),
	qsort(I,[H|S],R).
