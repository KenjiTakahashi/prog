data Roots=No|One Double|Two (Double,Double) deriving Show
roots::(Double,Double,Double)->Roots
roots (a,b,c)
    |a==0       =No
    |comp==LT   =No
    |comp==EQ   =One $ -b/(2*a)
    |otherwise  =Two ((-b+pierw)/(2*a),(-b-pierw)/(2*a))
    where delta=b*b-4*a*c
          comp=compare delta 0
          pierw=sqrt delta
          
{-Wiemy ile mamy pierwiastkow :), za to jest troche wiecej kombinacji
  ale programisci funkcyjni tak lubia.-}
  
{-Pierwsza funkcja jest analogiczna, podajemy po prostu trzy argumenty
  zamiast krotki trzyelementowej.-}
  
{-Druga funkcja jest niefajna, bo musimy pobierac elementy listy
  Dla 3 elementow to nic nie zrobi, ale jakby bylo duzo to by bylo
  gorzej ;).-}
