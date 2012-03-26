import List
import Char

integerToString::Integer->String
integerToString=reverse.unfoldr (\i->if i==0 then Nothing else Just(intToDigit.fromEnum $ i`mod`10,i`div`10))
