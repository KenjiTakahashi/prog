import List
merge::Ord a=>[a]->[a]->[a]
merge [] x=x
merge x []=x
merge xs@(x:xs') ys@(y:ys')
	|x<y=		x:merge xs' ys
	|x>y=		y:merge xs ys'
	|otherwise=	x:merge xs' ys'

d235::[Integer]
d235=1:map (2*) d235 `merge` map (3*) d235 `merge` map (5*) d235

--Nieposortowane!!
d2351::[Integer]
d2351=nub $ 1:[y|x<-d2351,y<-[2*x,3*x,5*x]]


d2352::[Integer]
d2352=1:[y|x<-d2352,y<-[2*x,3*x,5*x]]


d2353=1:2:[x|(a,b)<-d2353,x<-(\a-> \b->if a<b then [a,b] else [b,a]) a b]
