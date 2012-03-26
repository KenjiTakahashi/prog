/* Uwaga ogolna na poczatek: Podobno program ma podawac rowniez
 * wyniki z zaznaczonymi polami, ktorych zaznaczac nie trzeba,
 * jednak wypacza to nieco idee algorytmu, poniewaz najlepiej
 * jest od razu odrzucic takie pola i znaczaco zmniejszyc
 * dzieki temu liczbe kombinacji (taka technike stosuje sie
 * rowniez rozwiazujac "na papierze").
 */
/* Wczytujemy dane z pliku, odpalamy predykat rozwiazujacy
 * nasza lamiglowke, po czym zbieramy wyniki i  wyswietlamy
 * je na stdout.
 * Tryb: main(+).
 * Wywolanie: main(A).
 * Gdzie:
 * A - Sciezka do pliku z danymi.
 */
main(F):-
    open(F,read,S),
    read(S,L),
    read(S,B),
    close(S),
    findall(E,engine(B,L,E),Z),
    sort(Z,R),
    output(B,R).
/* Wyswietlamy wyniki lamiglowki na stdout.
 * Tryb: output(+,+).
 * Wywolanie: output(A,B).
 * Gdzie:
 * A - Lista opisujaca plansze.
 * B - Lista wspolrzednych do "zaczernienia".
 */
output(_,[]).
output(B,[H|T]):-
    output(B,H,1),
    output(B,T).
output([],_,_):-!.
output([H|T],R,X):-nl,
    XX is X+1,
    output(H,R,S,(X,1)),
    output(T,S,XX).
output([],R,R,_):-!.
output([_|T],[(X,Y)|S],A,(X,Y)):-!,
    write('  * '),
    YY is Y+1,
    output(T,S,A,(X,YY)).
output([H|T],S,A,(X,Y)):-
    (H<10->write('  ');write(' ')),
    write(H),
    write(' '),
    YY is Y+1,
    output(T,S,A,(X,YY)).
/* Glowny predykat rozwiazujacy, odpalamy po kolei poszczegolne
 * etapy rozwiazywania: 
 * - zbieramy wspolrzedne wszystkich wystapien kazdej z liczb,
 * - wybieramy z nich listy cykli "kolidujacych" ze soba,
 * - wybieramy z kazdego cyklu po jednej wspolrzednej, ktora ma
 * pozostac niezaczerniona,
 * - sprawdzamy, czy dana kombinacja spelnia warunki zadania.
 * Tryb: engine(+,+,-).
 * Wywolanie: engine(A,B,C).
 * Gdzie:
 * A - Lista z opisem planszy.
 * B - Rozmiar planszy.
 * C - Lista wspolrzednych rozwiazujacych dana plansze.
 */
engine(L,N,R):-
    gather(L,S),
    chooser(S,I),
    choose(I,R,N),
    checkSquareCuts(R,R,N).
/* Sprawdzamy, czy zadne z pol nie leza obok siebie.
 * Tryb: check(+).
 * Wywolanie: check(A).
 * Gdzie:
 * A - Lista wspolrzednych do sprawdzenia.
 */
check([]).
check([H|T]):-
    check(H,T),
    check(T).
check(_,[]):-!.
check((X,Y),[(X,YY)|T]):-!,
    YY=\=Y+1,
    YY=\=Y-1,
    check((X,Y),T).
check((X,Y),[(XX,Y)|T]):-!,
    XX=\=X+1,
    XX=\=X-1,
    check((X,Y),T).
check(L,[_|T]):-
    check(L,T).
/* Sprawdzamy, czy nie odcielismy zadnej czesci diagramu linia
 * (rowniez lamana).
 * Tryb: checkLinearCuts(+,+,+).
 * Wywolanie: checkLinearCuts(A,A,B).
 * Gdzie:
 * A - Lista wspolrzednych do sprawdzenia.
 * B - Rozmiar planszy.
 */
checkLinearCuts([],_,_):-!.
checkLinearCuts([(X,1)|T],L,N):-!,
    delete(L,(X,1),M),
    \+checkCutsaux((X,1),M,N,0),
    checkLinearCuts(T,L,N).
checkLinearCuts([(X,N)|T],L,N):-!,
    delete(L,(X,N),M),
    \+checkCutsaux((X,N),M,N,0),
    checkLinearCuts(T,L,N).
checkLinearCuts([(1,Y)|T],L,N):-!,
    delete(L,(1,Y),M),
    \+checkCutsaux((1,Y),M,N,0),
    checkLinearCuts(T,L,N).
checkLinearCuts([(N,Y)|T],L,N):-!,
    delete(L,(N,Y),M),
    \+checkCutsaux((N,Y),M,N,0),
    checkLinearCuts(T,L,N).
checkLinearCuts([_|T],L,N):-
    checkLinearCuts(T,L,N).
checkCutsaux((_,N),_,N,1):-!.
checkCutsaux((N,_),_,N,1):-!.
checkCutsaux((_,1),_,_,1):-!.
checkCutsaux((1,_),_,_,1):-!.
checkCutsaux((X,Y),L,N,_):-
    (
        XX is X+1,YY is Y+1,select((XX,YY),L,T);
        XX is X-1,YY is Y+1,select((XX,YY),L,T);
        XX is X+1,YY is Y-1,select((XX,YY),L,T);
        XX is X-1,YY is Y-1,select((XX,YY),L,T)
    ),
    checkCutsaux((XX,YY),T,N,1).
/* Sprawdzmy, czy nie odcielismy zadnej czesci diagramu w prostokacie.
 * Tryb: checkSquareCuts(+,+,+).
 * Wywolanie: checkSquareCuts(A,A,B).
 * Gdzie:
 * A - Lista wspolrzednych do sprawdzenia.
 * B - Rozmiar planszy.
 */
checkSquareCuts([],_,_):-!.
checkSquareCuts([H|T],L,N):-
    delete(L,H,M),
    \+checkSquareCuts(H,[H|M],H,H,0),
    checkSquareCuts(T,L,N).
checkSquareCuts((X,Y),_,(X,Y),_,1):-!.
checkSquareCuts((X,Y),L,N,(XXX,YYY),_):-
    (
        XX is X+1,YY is Y+1;
        XX is X-1,YY is Y+1;
        XX is X+1,YY is Y-1;
        XX is X-1,YY is Y-1
    ),
    (XX=\=XXX;YY=\=YYY),
    select((XX,YY),L,T),
    checkSquareCuts((XX,YY),T,N,(X,Y),1).
/* Zbieramy wszystkie mozliwosci wyjecia z kazdej podlisty po jednym
 * elemencie (tj. tym wystapieniu danej liczby, ktore ma pozostac na
 * planszy) spelniajace zalozenia zadania.
 * Tryb: choose(+,-,+).
 * Wywolanie: choose(A,B,C).
 * Gdzie:
 * A - Lista wejsciowa.
 * B - Lista wyjsciowa.
 * C - Rozmiar planszy.
 */
choose(L,R,N):-
    choose(L,[],R,N).
choose([],R,R,_).
choose([H|T],A,R,N):-
    chooaux(H,[],I),
    append(I,A,F),
    check(F),
    checkLinearCuts(F,F,N),
    sort(F,G),
    choose(T,G,R,N).
chooaux([],R,R).
chooaux([H|T],A,R):-
    select(_,H,I),
    append(I,A,B),
    chooaux(T,B,R).
/* Usuwamy listy jednoelementowe, tj. zawierajace wspolrzedne liczb
 * niekolidujacych z zadnymi innymi.
 * Tryb: filter(+,-).
 * Wywolanie: filter(A,B).
 * Gdzie:
 * A - Lista wejsciowa.
 * B - Lista wyjsciowa.
 */
filter(L,R):-
    filter(L,R,[]).
filter([],R,R):-!.
filter([[_]|T],A,R):-!,
    filter(T,A,R).
filter([H|T],[H|A],R):-
    filter(T,A,R).  
/* Rozbijamy liste dla kazdej z liczb na liste list z ktorych kazda
 * zawiera wspolrzedne kolidujace albo w danej kolumnie albo w danym
 * rzedzie. Wspolrzedne nie kolidujace na bierzaco odfiltrowujemy.
 * Tryb: chooser(+,-).
 * Wywolanie: chooser(A,B).
 * Gdzie:
 * A - Lista wejsciowa.
 * B - Lista wyjsciowa.
 */
chooser(L,R):-
    chooser(L,R,[]).
chooser([],R,R):-!.
chooser([H|T],[W|A],R):-
    choocol(H,I,[]),
    choover(H,J,[]),
    filter(I,Q),
    filter(J,U),
    append(Q,U,W),
    chooser(T,A,R).
choocol([],R,R).
choocol([H|T],[I|A],R):-
    choocol(H,[H|T],I,[],S,[]),
    choocol(S,A,R).
choocol(_,[],R,R,S,S):-!.
choocol((X,Y),[(X,YY)|T],[(X,YY)|A],R,S,U):-!,
    choocol((X,Y),T,A,R,S,U).
choocol(L,[H|T],A,R,[H|S],U):-
    choocol(L,T,A,R,S,U).
choover([],R,R).
choover([H|T],[I|A],R):-
    choover(H,[H|T],I,[],S,[]),
    choover(S,A,R).
choover(_,[],R,R,S,S):-!.
choover((X,Y),[(XX,Y)|T],[(XX,Y)|A],R,S,U):-!,
    choover((X,Y),T,A,R,S,U).
choover(L,[H|T],A,R,[H|S],U):-
    choover(L,T,A,R,S,U).
/* Zbieramy liste list krotek, gdzie kazda lista zawiera wspolrzedne
 * wszystkich wystapien jednej z liczb.
 * Tryb: gather(+,-).
 * Wywolanie: gather(A,B).
 * Gdzie:
 * A - Przeszukiwana lista list.
 * B - Lista wynikowa.
 */
gather(L,R):-
    gather(L,0,1,[],R,[]).
gather([],_,_,_,R,R):-!.
gather([[]|T],_,X,E,A,R):-
    XX is X+1,!,
    gather(T,0,XX,E,A,R).
gather([[H|S]|T],Y,X,E,A,R):-
    YY is Y+1,
    member(H,E),!,
    gather([S|T],YY,X,E,A,R).
gather([[H|S]|T],Y,X,E,[I|A],R):-
    YY is Y+1,
    gataux(H,[S|T],YY,X,[(X,YY)],I),
    gather([S|T],YY,X,[H|E],A,R).
gataux(_,[],_,_,R,R):-!.
gataux(L,[H|T],Y,X,A,R):-
    XX is X+1,
    gatherer(L,H,Y,X,I),
    append(A,I,J),
    gataux(L,T,0,XX,J,R).
/* Zbieramy wszystkie wystapienia danej liczby w liscie.
 * Zwracamy liste krotek w postaci (X,Y), gdzie X i Y oznaczaja
 * odp. kolumne i rzad, w ktorym znajduje sie dane wystapienie.
 * Liczymy od 1!
 * Tryb: gatherer(+,+,+,+,-).
 * Wywolanie: gatherer(A,B,C,D,E).
 * Gdzie:
 * A - Szukana liczba.
 * B - Przeszukiwana lista.
 * C - Aktualna kolumna.
 * D - Aktualny rzad.
 * E - Lista wynikowa.
 */
gatherer(N,L,Y,X,R):-
    gatherer(N,L,Y,X,R,[]).
gatherer(_,[],_,_,A,A):-!.
gatherer(H,[H|T],Y,X,[(X,YY)|A],R):-
    YY is Y+1,!,
    gatherer(H,T,YY,X,A,R).
gatherer(L,[_|T],Y,X,A,R):-
    YY is Y+1,
    gatherer(L,T,YY,X,A,R).
