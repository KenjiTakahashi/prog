factorial(N,M):-
    factorial(N,1,M).
factorial(0,M,M):-!.
factorial(N,R,M):-
    N1 is N-1,
    R1 is R*N,
    factorial(N1,R1,M).

concat_number(D,N):-
    concat_number(D,0,N).
concat_number([],N,N).
concat_number([H|T],X,N):-
    M is X*10+H,
    concat_number(T,M,N).

decimal(0,[0]).
decimal(N,D):-
    N>0,
    decimal(N,[],D).
decimal(0,D,D):-!.
decimal(0,_,_):-!,fail.
decimal(N,L,D):-
    CC is N // 10,
    RD is N mod 10,
    decimal(CC,[RD|L],D).
