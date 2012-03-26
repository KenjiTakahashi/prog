permi :: [a] -> [[a]] 
permi [] = [[]] 
permi (x:xs) = concatMap (Main.insert x) $ permi xs 

permi2 :: [a] -> [[a]] 
permi2 [] = [[]] 
permi2 (x:xs) = [zs | ys <-permi2 xs, zs <- Main.insert x ys] 

permi3 :: [a] -> [[a]] 
permi3 [] = [[]] 
permi3 (x:xs) = do 
      ys <- permi3 xs 
      zs <- Main.insert x ys 
      return zs 

insert x [] = [[x]] 
insert x xs = ins x (reverse xs) [] [] where 
       ins x [] ys ws = (x:ys):ws 
       ins x (z:zs) ys ws = ins x zs (z:ys) $ (foldl (\ x y -> y:x) (z:x:ys) zs) : ws
