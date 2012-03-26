prod xs = if wynik == Nothing then 0 else let Just n = wynik in n  where 
     wynik = prod2 (Just 1) xs 
     prod2 = foldr (\ p n  -> 
           if n /= Nothing 
           then 
                let Just m = n 
                in if m == 0 
                   then Nothing 
                   else Just (m*p) 
           else n)
