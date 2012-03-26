head(H,[H|_]).

tsal([H],H).
tsal([_|T],H):-
	tsal(T,H).

tail(T,[_|T]).

init([_],[]).
init([H|T1],[H|T2]):-
	init(T1,T2).
	
prefix([],[]).
prefix([],[_|_]).
prefix([H|T1],[H|T2]):-
	prefix(T1,T2).

suffix(T,T).
suffix([_|T],S):-
	suffix(T,S).
