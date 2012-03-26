prime(X,Y):-
	prime(2,X,[]-Y).
	%isPrime(X,Y).
prime(X,X,Y-Y).
prime(X,N,Z-[X|Y]):-
	(var(N)->true;X<N),
	XX is X+1,
	prime(XX,N,Z-Y).
/*prime(X,N,Y-Z):-
	XX is X+1,
	prime(XX,N,Y-Z).*/

isPrime(_,[]):-!.
isPrime(X,[Y|Z]):-
	\+0 is X mod Y,
	isPrime(X,Z).
/*isPrime(_,G-G):-!.
isPrime(X,G-[Y|Z]):-
	\+0 is X mod Y,
	isPrime(X,G-Z).*/
