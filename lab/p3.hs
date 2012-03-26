-- Kompilujemy i uruchamiamy przez <nazwa_binarki> <nazwa_pliku_z_danymi>

import System.Environment(getArgs)
import Control.Monad
import List((\\),delete)

-- Silnik.
-- Zwraca mozliwe ruchy z pola (xp,yp). Przyjmujemy tutaj, ze pola lezace obok siebie moga byc polaczone "z miejsca".
pathStepFinder::(Num a,Num b)=>(a,b)->[(a,b)]->[(a,b)]
pathStepFinder (xp,yp) xs=do
    s<-xs
    guard $ (xp,yp+1)==s||(xp,yp-1)==s||(xp+1,yp)==s||(xp-1,yp)==s
    return s

-- Zwraca mozliwe trasy z pola (xp,yp) na (xk,yk).
pathFinder::(Num a,Num b)=>((a,b),(a,b))->[(a,b)]->[(a,b)]->[[(a,b)]]
pathFinder (p,k) xs result=do
    t<-pathStepFinder p $ k:xs
    if t==k then return $ result++[p,k] else pathFinder (t,k) (t `delete` xs) $ result++[p]

-- Zwraca wszystkie mozliwe rozwiazania dla zadanych danych.
solver::(Num a,Num b)=>[((a,b),(a,b))]->[(a,b)]->[[(a,b)]]->[[[(a,b)]]]
solver [] _ result=return result
solver (xy:xys) xs result=do
    w<-pathFinder xy xs []
    solver xys (xs\\w) $ result++[w]

-- Zwraca True, jesli wartosc z nie wystepuje na liscie xs.
containsNo::(Eq a)=>[(a,a)]->a->Bool
containsNo [] _=True
containsNo ((x,y):xs) z=if z==x||z==y then False else containsNo xs z

-- Zwraca liste wolnych pol na planszy.
boardBuilder::(Num a,Enum a,Num b,Enum b)=>[((a,b),(a,b))]->a->b->[(a,b)]
boardBuilder xs m n=[(a,b)|a<-[1..m],b<-[1..n],xs `containsNo` (a,b)]

-- Main.
-- Usuwanie kropki.
remDot::String->String 
remDot s=init s 

type Board=[((Integer,Integer),(Integer,Integer))] 

-- Przetwarzanie zawartosci pliku.
parse::String->(Integer,Integer,Board)
parse s=(read m,read n,read list)
    where linijki=map remDot $ lines s
          [m,n,list]=linijki

-- Zwraca rozlozenie liczb na planszy w formacie (x,y,n).
numbersOnBoard::(Num a)=>[((b,c),(b,c))]->a->[(b,c,a)]
numbersOnBoard [] _=[]
numbersOnBoard (((a,b),(c,d)):xs) n=(a,b,n):(c,d,n):(numbersOnBoard xs (n+1))

-- Zwraca odpowiedni znak do rysowania sciezki.
pathSign::(Num a,Num b)=>[[(a,b)]]->(a,b)->[Char]
pathSign [] _=" "
pathSign ([_,_]:xs) z=pathSign xs z
pathSign ((a:b:c:xs):ys) (x,y)
    |(x,y)==b&&(((x,y+1)==a||(x,y-1)==a)&&((x,y+1)==c||(x,y-1)==c))="─"
    |(x,y)==b&&(((x+1,y)==a||(x-1,y)==a)&&((x+1,y)==c||(x-1,y)==c))="│"
    |(x,y)==b&&(((x+1,y)==a&&(x,y+1)==c)||((x,y+1)==a&&(x+1,y)==c))="┌"
    |(x,y)==b&&(((x+1,y)==a&&(x,y-1)==c)||((x,y-1)==a&&(x+1,y)==c))="┐"
    |(x,y)==b&&(((x-1,y)==a&&(x,y+1)==c)||((x,y+1)==a&&(x-1,y)==c))="└"
    |(x,y)==b&&(((x-1,y)==a&&(x,y-1)==c)||((x,y-1)==a&&(x-1,y)==c))="┘"
    |otherwise=pathSign ((b:c:xs):ys) (x,y)

-- Zwraca liczbe, jesli na polu (c,d) znajduje sie liczba, znak sciezki w przeciwnym wypadku.
art::(Num a,Num b,Num c)=>[(a,b,c)]->(a,b)->[[(a,b)]]->[Char]
art [] z zs=pathSign zs z
art ((a,b,n):xs) (c,d) zs=if a==c&&b==d then show n else art xs (c,d) zs

-- Zwraca plansze wypelniona liczbami i drogami miedzy nimi. 
asciiBoard::(Num a,Enum a,Num b,Enum b)=>a->b->[((a,b),(a,b))]->[[(a,b)]]->[[[Char]]]
asciiBoard m n l xs=[[art r (a,b) xs|a<-[1..m],b<-[1..n],a==c]|c<-[1..m]]
    where r=numbersOnBoard l 1

-- Zwraca gotowy do wyswietlenia string z plansza.
asciiArt::[[[Char]]]->[Char]
asciiArt []=""
asciiArt (x:xs)=xr++asciiArt xs where xr=asciiArtAux x
asciiArtAux []="\n"
asciiArtAux (x:xs)=x++asciiArtAux xs

-- Wczytywanie danych z pliku, uruchamianie parsera i wypisywanie wyniku.
main::IO ()
main=do 
    [file]<-getArgs
    s<-readFile file
    (m,n,l)<-return $ parse s
    let r=solver l (boardBuilder l m n) []
    mapM_ putStr (map asciiArt (map (asciiBoard m n l) r))
    mapM_ print r
