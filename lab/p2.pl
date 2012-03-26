/* Uwagi na (nie)dobry poczatek:
 * 1. Lexer i parser jest w pelni sprawny, odpalany przez run_parser(F,R), gdzie
 * F i R to odpowiednio plik wejsciowy z kodem programu i zmienna wyjsciowa z drzewem
 * rozbioru.
 * 2. Interpreter dziala (niestety) tylko dla prostych wyrazen, nie zawierajacych
 * definicji funkcji, odpalany przez run(F), gdzie F to plik wejsciowy z kodem programu.
 * 3. Jest obsluga pamieci i kawalek kodu odnosnie dalszego ciagu interpretera,
 * wykomentowany ze wzgledu na nie dzialanie (w obecnej formie). ;)
 */

/* Lexer! */

lexer(Tokens)-->
	white,
    (
		(   "\\",!,{Token=backslash};
        	"->",!,{Token=application};
        	"(",!,{Token=openingBracket};
        	")",!,{Token=closingBracket};
        	"[",!,{Token=openingSquareB};
        	"]",!,{Token=closingSquareB};
        	",",!,{Token=comma};
        	";",!,{Token=semicolon};
        	"<=",!,{Token=smallerEqual};
        	">=",!,{Token=largerEqual};
			"<",!,{Token=smaller};
        	">",!,{Token=larger};
        	"=",!,{Token=equal};
        	"/=",!,{Token=different};
			"++",!,{Token=concatenation};
        	"+",!,{Token=addition};
        	"-",!,{Token=subtraction};
        	"*",!,{Token=multiplication};
        	":",!,{Token=compound};
			isNumber(N),!,{number_chars(R,N),Token=number(R)};
			isIdent(I),!,
			{
				atom_codes(R,I),
				(
					member(R,[let,if,then,else,and,or,not,div,mod,null,head,tail]),
					Token=R,!;
					Token=ident(R)
				)
			};
			[Un],{Token=unknown,throw((unrecognized_token,Un))}
    	),!,{Tokens=[Token|TokenList]},lexer(TokenList);
		[],{Tokens=[]}
	).

commentStart-->
	"--",!,commentEnd.
commentStart-->[].

commentEnd-->
	[C],{code_type(C,end_of_line)},!,
	white.
commentEnd-->
	[_],commentEnd.

white-->
	[C],{code_type(C,space)},!,
	white.
white-->
	commentStart,!.
white-->[].

isDigit(D)-->
    [D],{code_type(D,digit)}.
    
isNumber([D|T])-->
    isDigit(D),
    isNumber(T).
isNumber([D])-->
    isDigit(D).

isIdent([I|T])-->
	[I],{code_type(I,alpha)},
	isIdentAux(T).
isIdentAux([I|T])-->
	[I],{code_type(I,csym);memberchk(I,"'")},
	isIdentAux(T).
isIdentAux([])-->[].

/* Parser! */

program(A)-->
	wyrazenie(A).

wyrazenie(A)-->
	[let,ident(I),equal],wyrazenie(B),[semicolon],wyrazenie(C),
	{A=let(I,B,C)}.

wyrazenie(A)-->
	[if],wyrazenie(B),[then],wyrazenie(C),[else],wyrazenie(D),
	{A=if(B,C,D)}.

wyrazenie(A)-->
	[backslash,ident(I),application],wyrazenie(B),
	{A=fun(I,B)}.

wyrazenie(A)-->
	wyrazenie_proste(A).

wyrazenie_proste(A)-->
	proste1(B),!,{A=B}.
proste0(A)-->
	proste1(B),!,
	proste0tail(B,A).
proste0tail(A,B)-->
	op0(O),!,
	proste0(D),!,{C=..[O,A,D]},
	proste0tail(C,B).
proste0tail(A,A)-->{true}.
proste1(A)-->
	proste2(B),!,
	proste1tail(B,A).
proste1tail(A,B)-->
	opn(O),!,
	proste2(D),!,{B=..[O,A,D]}.
proste1tail(A,A)-->{true}.
proste2(A)-->
	proste3(B),!,
	proste2tail(B,A).
proste2tail(A,B)-->
	op1(O),!,
	proste2(D),!,{C=..[O,A,D]},
	proste2tail(C,B).
proste2tail(A,A)-->{true}.
proste3(A)-->
	proste4(B),!,
	proste3tail(B,A).
proste3tail(A,B)-->
	op2(O),!,
	proste3(D),!,{C=..[O,A,D]},
	proste2tail(C,B).
proste3tail(A,A)-->{true}.
proste4(A)-->
	proste5(B),!,
	proste4tail(B,A).
proste4tail(A,B)-->
	op3(O),!,
	proste4(D),!,{C=..[O,A,D]},
	proste4tail(C,B).
proste4tail(A,A)-->{true}.
proste5(A)-->aplikacja(A),!.

aplikacja(A)-->
	wyrazenie_atomowe(B),!,
	aplikacjatail(B,A).
aplikacjatail(A,B)-->
	wyrazenie_atomowe(D),!,{C=app(A,D)},
	aplikacjatail(C,B).
aplikacjatail(A,A)-->{true}.

wyrazenie_atomowe(A)-->
	[openingBracket],!,wyrazenie(A),[closingBracket].
wyrazenie_atomowe(A)-->
	(
		[null],!,{A=null};
		[head],!,{A=head};
		[tail],!,{A=tail};
		[not],!,{A=not};
		[ident(A)],!;
		[number(A)],!
	).
wyrazenie_atomowe(A)-->
	[openingSquareB],[closingSquareB],!,
	{A=[]}.
wyrazenie_atomowe(A)-->
	[openingSquareB],!,ciag_wyrazen(A),[closingSquareB].	

ciag_wyrazen(A)-->
	wyrazenie(B),[comma],!,ciag_wyrazen(C),
	{A=B:C}.
ciag_wyrazen(A)-->
	wyrazenie(B),
	{A=B:[]}.

/* Operatory. */
op0(and)-->
	[and].
op0(or)-->
	[or].

op3(*)-->
	[multiplication].
op3(mod)-->
	[mod].
op3(div)-->
	[div].

op2(+)-->
	[addition].
op2(-)-->
	[subtraction].

op1(:)-->
	[compound].
op1(++)-->
	[concatenation].

opn(<)-->
	[smaller].
opn(>)-->
	[larger].
opn(<=)-->
	[smallerEqual].
opn(>=)-->
	[largerEqual].
opn(=)-->
	[equal].
opn(/=)-->
	[different].

/* Interpreter! */

/* Drobny predykat pomocniczy. */
is_bool(true).
is_bool(false).

/* Pamiec. */
lookup(M,X,V):-
	member((X,V),M).
update([],X,V,[(X,V)]).
update([(X,_)|T],X,V,[(X,V)|T]):-!.
update([H|T],X,V,[H|S]):-
	update(T,X,V,S).
remove(M,X,MM):-
	delete(M,(X,_),MM).

/* Operacje arytmetyczne. */
eval(A,A,B,B):-
	is_list(A),!;integer(A),!;is_bool(A),!.
eval(+(A,C),E,B,[]):- 
  	(
		eval(A,D,B,_),
		eval(C,F,B,_),
		integer(D),
		integer(F)->!,E is D+F;!,write("error")
	).
eval(-(A,C),E,B,[]):-
	(
		eval(A,D,B,_),
		eval(C,F,B,_),
		integer(D),
		integer(F)->!,E is D-F;!,write("error")
	).
eval(*(A,C),E,B,[]):-
	(
		eval(A,D,B,_),
		eval(C,F,B,_),
		integer(D),
		integer(F)->!,E is D*F;!,write("error")
	).
eval(div(A,C),E,B,[]):-
	(
		eval(A,D,B,_),
		eval(C,F,B,_),
		integer(D),
		integer(F)->
		(F=\=0->!,E is D/F;write('Division by zero.'));!,write('error')
	).
eval(mod(A,C),E,B,[]):-
	(
		eval(A,D,B,_),
		eval(C,F,B,_),
		integer(D),
		integer(F)->
		(F=\=0->!,E is D mod F;write('Division by zero.'));!,write('error')
	).

/* Operacje na listach. */
eval(:(A,C),E,B,[]):-
	eval(A,D,B,_),
	eval(C,F,B,_),
	E=[D|F].
eval(++(A,C),E,B,[]):-
	(
		eval(A,D,B,_),
		eval(C,F,B,_),
		is_list(D),
		is_list(F)->append(D,F,E);write('Concatenation error, arguments should be lists.')
	).
eval(head(A),E,B,[]):-
	(
		eval(A,D,B,_),
		is_list(D)->D=[E|_];write('Error getting head, arguments should be lists.')
	).
eval(tail(A),E,B,[]):-
	(
		eval(A,D,B,_),
		is_list(D)->D=[_|E];write('Error getting tail, arguments should be lists.')
	).

/* Operacje relacyjne. */
eval(<(A,C),E,B,[]):-
	(
		eval(A,D,B,_),
		eval(C,F,B,_),
		integer(D),
		integer(F)->(D<F->E=true;E=false);write('Comparison error, arguments should be integers.')
	).
eval(>(A,C),E,B,[]):-
	(
		eval(A,D,B,_),
		eval(C,F,B,_),
		integer(D),
		integer(F)->(D>F->E=true;E=false);write('Comparison error, arguments should be integers.')
	).
eval(<=(A,C),E,B,[]):-
	(
		eval(A,D,B,_),
		eval(C,F,B,_),
		integer(D),
		integer(F)->(D=<F->E=true;E=false);write('Comparison error, arguments should be integers.')
	).
eval(>=(A,C),E,B,[]):-
	(
		eval(A,D,B,_),
		eval(C,F,B,_),
		integer(D),
		integer(F)->(D>=F->E=true;E=false);write('Comparison error, arguments should be integers.')
	).
eval(=(A,C),E,B,[]):-
	(
		eval(A,D,B,_),
		eval(C,F,B,_),
		integer(D),
		integer(F)->(D=:=F->E=true;E=false);write('Comparison error, arguments should be integers.')
	).
eval(/=(A,C),E,B,[]):-
	(
		eval(A,D,B,_),
		eval(C,F,B,_),
		integer(D),
		integer(F)->(D=\=F->E=true;E=false);write('Comparison error, arguments should be integers.')
	).
eval(and(A,C),E,B,[]):-
	(
		eval(A,D,B,_),
		eval(C,F,B,_),
		is_bool(D),
		is_bool(F)->(D,F->E=true;E=false);write('and operator error, should have boolen arguments.')
	).
eval(or(A,C),E,B,[]):-
	(
		eval(A,D,B,_),
		eval(C,F,B,_),
		is_bool(D),
		is_bool(F)->(D;F->E=true;E=false);write('or operator error, should have boolen arguments.')
	).
eval(not(A),E,B,[]):-
	(
		eval(A,D,B,_),
		is_bool(D)->(D=true->E=false;E=true);write('not operator error, should have boolen arguments.')
	).

/* Operacja warunkowa. */
eval(if(A,C,G),E,B,[]):-
	(
		eval(A,D,B,_),
		is_bool(D)->(D->eval(C,E,B,_);eval(G,E,B,_));write('Conditional expr error, expr should be bool.')
	).

/* Let ;). 
eval(let(A,C,G),E,M,[]):-
	update(M,A,C,MM),
	eval(C,F,MM,_),
	eval(G,E,MM,_).

eval(fun(A,C),E,M,[]):-
	update(M,A,C,MM).
*/
/* Aplikacja. */
eval(app(A,C),E,M,[]):-
	(
		eval(C,F,M,_),
		Z=..[A,F],
		eval(Z,E,M,_)
	).

run_parser(F,R):-
	phrase_from_file(lexer(Tokens),F),
	phrase(program(R),Tokens),!.

run(F):-
	run_parser(F,G),!,
	eval(G,R,[],[]),
	write(R).
