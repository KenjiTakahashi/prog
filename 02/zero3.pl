minimum([H|T],M):-
    minimum(T,H,M).
minimum([],M,M).
minimum([H|T],K,M):-
    H>=K,
    minimum(T,K,M).
minimum([H|T],K,M):-
    H<K,
    minimum(T,H,M).

select_min(L,E,R):-
    minimum(L,E),
    select(E,L,R).
    
sel_sort(L,R):-
    sel_sort(L,[],R).
sel_sort([],L,W):-
	reverse(L,W).
sel_sort([H|T],L,W):-
    select_min([H|T],M,R),!,
    sel_sort(R,[M|L],W).
