%stack
put(E,S,[E|S]).
get([E|S],E,S).
empty([]).
addall(E,G,S,R):-
	work(E,G),
	gather(S,R).

work(E,G):-
	call(G),
	assertz(queue(E)),
	fail.
work(_,_).

gather(S,R):-
	retract(queue(E)),
	gather([E|S],R),!.
gather(S,S).

%queue
qput(E,S-[E|R],S-R).
qget([E|S]-R,E,S-R):-
	\+qempty([E|S]-R).
qempty(S-S).
qaddall(E,G,S-Y,S-R):-
	qwork(E,G),
	qgather(S-Y,S-R).
	
qwork(E,G):-
	call(G),
	assertz(queue(E)),
	fail.
qwork(_,_).

qgather(S-[E|Y],S-R):-
	retract(queue(E)),
	qgather(S-Y,S-R),!.
qgather(X-Y,X-Y).
