reverse(X,Y):-
    reverse(X,[],Y,Y).
reverse([],L,L,[]).
reverse([H|T1],L,Y,[_|T2]):-
    reverse(T1,[H|L],Y,T2).
