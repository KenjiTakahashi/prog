filter([],[]).
filter([H|T],[H|T1]):-
	H>=0,!,
	filter(T,T1).
filter([H|T],T1):-
	H<0,filter(T,T1).
