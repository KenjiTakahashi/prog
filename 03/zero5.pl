insert(N,leaf,node(leaf,N,leaf)).
insert(N,node(R,E,L),node(R1,E,L)):-
    N=<E,
    insert(N,R,R1).
insert(N,node(R,E,L),node(R,E,L1)):-
    N>E, 
    insert(N,L,L1).

treesort(X,R):-
    treesort(X,leaf,R).
treesort([],Tr,R):-
    flatten(Tr,R).
treesort([H|T],Tr,R):-
    insert(H,Tr,Tr1),
    treesort(T,Tr1,R).
