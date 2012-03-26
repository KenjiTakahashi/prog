halve([],[],[]).
halve(X,Y,Z):-
	halve(X,X,Y,Z).
halve(X,[],[],X):-!.
halve(X,[_],[],X):-!.
halve([H|T],[_,_|S],[H|Y],Z):-
	halve(T,S,Y,Z).
