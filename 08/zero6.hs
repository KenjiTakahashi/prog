fib :: (Num a) => Int -> a
fib n=let fibs=1:1:[a+b|(a,b)<-zip fibs (tail fibs)] in fibs!!n
