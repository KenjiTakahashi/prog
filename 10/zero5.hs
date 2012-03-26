merge::Ord a=>[a]->[a]->[a]
merge [] x=x
merge x []=x
merge xs@(x:xs') ys@(y:ys')
	|x<=y=		x:merge xs' ys
	|otherwise=	y:merge xs ys'

msort::Ord a=>Int->[a]->[a]
msort 0 _=[]
msort 1 (x:_)=[x]
msort n xs=merge (msort nn xs) $ msort (n-nn) $ drop nn xs
	where nn=n`div`2

sort::Ord a=>[a]->[a]
sort xs=msort (length xs) xs
