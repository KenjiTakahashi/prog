select::Ord a=>a->[a]->[a]
select x []=[]
select x (y:ys)
    |x==y       =ys
    |otherwise  =y:select x ys

sort::Ord a=>[a]->[a]
sort []=[]
sort xs=[s]++sort (select s xs)
    where s=foldl1 min xs --TWI nie zezwalal na min, trzeba samemu naklepac, mnie sie nie chce ;-)
