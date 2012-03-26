fib n=let fibs=1:1:[a+b|(a,b)<-zip fibs (tail fibs)] in fibs!!n
suma :: Integer
suma=let suma' i=if n>=4000000 then 0 else if n `mod` 2==0 then n+suma'(i+1) else suma'(i+1) where n=fib i in suma' 0

