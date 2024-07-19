function isprime(n)

    # exclude 1
    if n == 1 
        return "$(n) is not a prime number"
        
    # exclude 2
    elseif n == 2
        return "$(n) is a prime number"
    end
    
    # Start to exam from 3
    for i = 2:floor(sqrt(n)+1)
        if (n % i) == 0
            return "$(n) is not a prime number"
        end
    end
    
    # None of the above, hence n is a prime number
    return "$(n) is a prime number"
end


isprime(5)