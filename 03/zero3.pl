sbin(0).
sbin(1).

rbin([0]).
rbin(X):-
	rbin([Z|X]),
	sbin(Z).
	
rbin([0]).
rbin(X):-
    rbin(Z),
    rbin(Z,X).
rbin([],[1]).
rbin([0|T],[1|T]).
rbin([1|T],[0|S]):-
    rbin(T,S).
