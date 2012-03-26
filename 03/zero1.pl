length2(X,Y):-
	length2(X,0,Y).
length2([],A,A).
length2([_|T],A,Y):-
	\+A==Y,
	AA is A+1,
	length2(T,AA,Y).
