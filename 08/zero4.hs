silnia n=if n==0 then 1 else n*silnia(n-1)

sumup :: Integer
sumup=let sumup' bn s=if bn==0 then s else sumup' (bn `div` 10) ((bn `mod` 10)+s) in sumup' (silnia 100) 0
