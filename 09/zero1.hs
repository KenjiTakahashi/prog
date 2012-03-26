roots :: (Double,Double,Double)->[Double]
roots (a,b,c)
    |a==0      =[]
    |comp==LT  =[]
    |comp==EQ  =[-b/(2*a)]
    |otherwise =[(-b+pierw)/(2*a),(-b-pierw)/(2*a)]
    where delta=b*b-4*a*c
          comp=compare delta 0
          pierw=sqrt delta
