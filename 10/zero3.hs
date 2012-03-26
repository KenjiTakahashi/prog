merge::Ord a=>[a]->[a]->[a]
merge [] x=x
merge x []=x
merge xs@(x:xs') ys@(y:ys')
	|x<=y=x:merge xs' ys
	|otherwise=y:merge xs ys'

sort::Ord a=>[a]->[a]
sort []=[]
sort [x]=[x]
sort xs=merge (sort ys) (sort zs)
	where (ys,zs)=splitAt (length xs `div` 2) xs
