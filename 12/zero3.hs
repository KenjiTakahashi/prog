sublists :: [a] -> [[a]] 
sublists [] = [[]] 
sublists (x:xs) = let sub = sublists(xs) in concat $ map (\y -> [x:y, y]) sub 


sublists2 :: [a] -> [[a]] 
sublists2 [] = [[]] 
sublists2 (x:xs) = [ret | zs <- sublists2 xs, ret <- [x:zs, zs]] 

sublists3 :: [a] -> [[a]] 
sublists3 [] = [[]] 
sublists3 (x:xs) = do 
         zs <- sublists3 xs 
         rs <- [x:zs, zs] 
         return rs
