select :: [a] -> [(a,[a])] 
select [] = [] 
select xs = sel (reverse xs) [] [] where 
       sel [] _ ws = ws 
       sel (x:xs) ys ws = sel xs (x:ys)  $ (x,(foldl (\ x y -> y:x) ys xs)) : ws 

perms' :: [a] -> [[a]] 
perms' [] = [[]] 
perms' xs = concat $ map (\ (x,rx) -> let perm = perms' rx in map (\ y -> x:y) perm) $ select xs 

perms2' :: [a] -> [[a]] 
perms2' [] = [[]] 
perms2' xs = [ x:perm | (x,rx) <- select xs, perm <- perms2' rx] 

perms3' :: [a] -> [[a]] 
perms3' [] = [[]] 
perms3' xs = do 
        (x,rx) <- select xs 
        perm <- perms2' rx 
        return $ x:perm
