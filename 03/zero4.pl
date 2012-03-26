mirror(leaf,leaf).
mirror(node(R,E,L),node(L1,E,R1)):-
    mirror(R,R1), 
    mirror(L,L1).
    
flatten(leaf,[]).
flatten(node(R,E,L),X):-
    flatten(R,T),
    flatten(L,S),
    append(T,[E|S],X).
