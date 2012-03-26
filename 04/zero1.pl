revall(X,Y):-
    revall(X,[],Y).
revall([],L,L):-!.
revall([H|T],L,Y):-
	var(H),!,
	revall(H,[H|L],Y).
revall([H|T],L,Y):-
	atomic(H),!,
    revall(T,[H|L],Y).
revall([H|T],L,Y):-	
	revall(H,[],S),
	revall(T,[S|L],Y).
