insert(N,leaf,node(leaf,N,leaf)):-!.
insert(N,node(L,N,R),node(L,N,R)):-!.
insert(N,node(L,E,R),node(L,E,R1)):-
    N<E,!,
    insert(N,R,R1).
insert(N,node(L,E,R),node(L1,E,R)):-
    insert(N,L,L1).

find(N,node(leaf,N,leaf)):-!.
find(N,node(_,E,R)):-
	N>E,!,
	find(N,R).
find(N,node(L,_,_)):-
	find(N,L).	
	
findMax(node(_,N,leaf),N):-!.
findMax(node(_,_,R),N):-
	findMax(R,N).
	
delMax(node(L,E,node(LL,N,leaf)),N,node(L,E,LL)):-!.
delMax(node(_,_,R),N,W):-
	delMax(R,N,W).
		
delete(E,node(L,E,leaf),L):-!.
delete(E,node(leaf,E,R),R):-!.
delete(E,node(L,E,R),node(P,N,R)):-!,
	delaux(L,N,P).
delete(E,node(L,K,R),node(LL,K,R)):-
	E<K,!,
	delete(E,L,LL).
delete(E,node(L,K,R),node(L,K,RR)):-
	delete(E,R,RR).
delaux(node(L,E,leaf),E,L):-!.
delaux(node(L,E,R),N,node(L,E,RR)):-
	delaux(R,N,RR).

empty(leaf).
