data Tree a=Node (Tree a) a (Tree a)|Leaf deriving Show

insert::Ord a=>a->Tree a->Tree a
insert a Leaf=Node (Leaf) a (Leaf)
insert a t@(Node l v r)
	|a<v=Node (insert a l) v r
	|a>v=Node l v (insert a r)
	|otherwise=t

flatten::Tree a->[a]
flatten Leaf=[]
flatten (Node l v r)=flatten l++[v]++flatten r

treeSort::Ord a=>[a]->[a]
treeSort=flatten.foldr insert Leaf
