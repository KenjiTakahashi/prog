iter :: (a->a)->a->Integer->a
iter f x n=if n==0 then x else iter f (f x) (n-1)
