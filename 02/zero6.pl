sameLength([],[]). 
sameLength([_|T1],[_|T2]) :- sameLength(T1,T2). 

perm(X,Y):- 
        perm(X,[],Y,Y). 
perm([],A,A,[]). 
perm(L,A,Y,S):- 
        sameLength(L,S), 
        select(X,L,L1), 
        perm(L1,[X|A],Y,T).
