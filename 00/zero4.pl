connected(wroclaw,warszawa).
connected(wroclaw,krakow).
connected(wroclaw,szczecin).
connected(szczecin,lublin).
connected(szczecin,gniezno).
connected(warszawa,katowice).
connected(gniezno,gliwice).
connected(lublin,gliwice).

connection(X,Y):-connected(X,Y).
connection(X,Y):-connected(X,Z),connection(Z,Y).
