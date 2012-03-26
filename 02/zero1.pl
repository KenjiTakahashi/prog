filter(X,Y):- 
    filter(X,[],Y).    
filter([],A,Y):-
    reverse(A,Y).
filter([X|T],A,Y):-
    X>=0,!,
    filter(T,[X|A],Y).
filter([_|T],A,Y):-
    filter(T,A,Y).

count(X,L,N):-
    count(X,L,0,N).
count([],_,Z,Z).
count([H|T1],[H|T2],A,Z):-
    A1 is A+1,!,
    count(T1,T2,A1,Z).
count([_|T1],[_|T2],A,Z):-
    count(T1,T2,A,Z).

exp(X,N,R):-
    exp(X,N,1,R).
exp(_,0,Z,Z):-!.
exp(_,0,_,_):-!,fail.
exp(X,Y,A,Z):-
    A1 is A*X,
    Y1 is Y-1,
    exp(X,Y1,A1,Z).
