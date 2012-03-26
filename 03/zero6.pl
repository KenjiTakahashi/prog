concat_number(D, N) :- 
    concat_number(D, 0, N). 
concat_number([], N, N). 
concat_number([H|T], X, N) :- 
    M is X*10 + H, 
    concat_number(T, M, N). 

suffix(X,X). 
suffix([_|T],Y) :- 
    suffix(T,Y). 

sublist(_,[]). 
sublist(L,[H|T]) :- 
    suffix(L, [H|S]), 
    sublist(S, T). 

query(A,C,E,P,R,S,U):-
    sublist([0,1,2,3,4,5,6,7,8,9],Ls),
    length(Ls,7),
    permutation([A,C,E,P,R,S,U],Ls),
    U\=0,
    P\=0,
    concat_number([U,S,A],USA),
    concat_number([U,S,S,R],USSR),
    concat_number([P,E,A,C,E],PEACE),
    PEACE is USA+USSR.
