merge([],[],[]).
merge(X,[],X):-!.
merge([],X,X):-!.
merge([H|T],[I|S],[H|R]):-
	H=<I,!,
	merge(T,[I|S],R).
merge([H|T],[I|S],[I|R]):-
	H>I,!,
	merge([H|T],S,R).

mergesort([],[]).
mergesort([A],[A]):-!.
mergesort(X,Y):-
	halve(X,A,B),
	mergesort(A,I),
	mergesort(B,J),
	merge(I,J,Y).
