newtype FSet a = FSet (a->Bool)

empty :: FSet a
empty = FSet (\x -> False)

singleton :: Ord a => a -> FSet a
singleton x = FSet (\y ->x==y)

fromList :: Ord a => [a] -> FSet a
fromList ls = FSet (\x -> elem x ls)

union :: Ord a => FSet a -> FSet a -> FSet a
union (FSet f) (FSet g) = FSet (\x -> (f x) || (g x))

intersection :: Ord a => FSet a -> FSet a -> FSet a
intersection (FSet f) (FSet g) = FSet (\x -> (f x) && (g x))

member :: Ord a => a -> FSet a -> Bool
member x (FSet f) = f x
