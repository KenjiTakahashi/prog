connection(warszawa,krakow).
connection(warszawa,gubin).
connection(gubin,wloszczowa).
connection(warszawa,wloszczowa).
connection(krakow,lublin).
connection(lublin,zgorzelec).
connection(zgorzelec,krakow).
connection(zabrze,warszawa).
connection(gliwice,warszawa).
connection(siemianowice,wroclaw).

trip(P,K,L):-
	trip(P,K,[K],L).
trip(P,_,[P|L],[P|L]).
trip(P,K,[H|A],L):-
	connection(X,H),
	\+member(X,[H|A]),
	trip(P,K,[X,H|A],L).
