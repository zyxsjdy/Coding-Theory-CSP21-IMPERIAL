function my_gcdx(A::Int64,B::Int64)
        Divider = max(A,B)
        Remainder = min(A,B)
        RemainderNext = 1
        i = 0
        n = 0
    
        largeLast::Int64 = 1
        large::Int64 = 0 
        small::Int64 = 0
        largeNext = 0 
       
        while RemainderNext != 0
            i += 1
            RemainderNext = Divider % Remainder
            Multiplier = div(Divider,Remainder)
            Divider = Remainder
            Remainder = RemainderNext
            largeNext = largeLast - large * Multiplier
            largeLast = large 
            large = largeNext
            small = largeLast
        end
    
        if (A >= B)
            return(Divider,small,large)
        else
            return(Divider,large,small)
        end
        
    end
    my_gcdx(5,13)