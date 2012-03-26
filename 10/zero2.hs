qsort::Ord a=>[a]->[a]
qsort []=[]
qsort (s:xs)=qsort [x|x<-xs,x<s]++[s]++qsort[x|x<-xs,x>=s]
