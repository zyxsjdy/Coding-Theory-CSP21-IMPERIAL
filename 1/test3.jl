# Determine the degree of polynomial A. On the right is the coefficient of the largest term
# 3x^2+2x+1 then input A = [1 2 3]
function getdeg(A)
    n = length(A)

    for i in 1:length(A)
        if A[n] == 0 # Determine whether the last bit is 0, if yes, reduce 1 to the length of A
            n -= 1; # Judge the next one in the next loop
            if n == 0 # if all of A equal to 0, then return it's 0
                return 0
            end
        else
            return n-1 # degree starts from 0, and the number of items starts from 1, so return n-1
        end
    end
end

# Used to determine whether the input is a prime number 
# Return 'true' if it is a prime number, return 'false' if not
function isprime(n) 
        # exclude 1
        if n == 1 
            return false     
        # exclude 2
        elseif n == 2
            return true 
        end     
        # Start to exam from 3,determine whether it can be divisible by numbers form 2-(√n+1)
        for i = 2:floor(sqrt(n)+1) 
            if (n % i) == 0
                return  false
            end
        end        
        # None of the above, hence n is a prime number
        return true 
end

# Determine whether the polynomial is separable
function is_irreducible(fx,p) 
    
    if isprime(p) # if p is not a prime, then return error 
        if getdeg(fx) > 1 # if degree of x smaller than 1, that meand it must irreducible
            judgement = 0
            # take each number in modlue p filed into the polynomial
            # if we get 0, means the polynomial have integer root, means is not irreducible
            for n = 0:p-1 
                
                Result = 0
                for i = 1:length(fx)
                    Result = fx[i]*n^(i-1) + Result
                end
                
                if mod(Result,p) == 0
                    judgement += 1
                end
            end

            # If every number in the field brought into the polynomial is not 0, It's irreducible
            if judgement == 0 
                return "irreducible"
            else 
                return "not irreducible"
            end
        else
            return "irreducible"
        end
    else
        return "p is not a prime number. It's not a filed"
    end
end

# The right hand side of the input matrix has the highest degree, e.g. [1 2 3] -> 1 + 2*x + 3*x^2
fx = [1 0 2 0 1]
p = 3
is_irreducible(fx,p)






