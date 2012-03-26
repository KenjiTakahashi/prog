import Control.Monad
nieszachuje :: Integer -> [Integer] -> Bool 
nieszachuje x xs = aux 1 xs where 
         aux _ [] = True 
         aux n (y:ys) = 
             y /= x && 
             y + n /= x && 
             y - n /= x && 
             aux (n+1) ys 

queens n = q n n [] where 
       q _ 0 xs = return xs 
       q size column board = do 
              c <- [1..size] 
              guard $ nieszachuje c board 
              q size (column-1) (c:board)
