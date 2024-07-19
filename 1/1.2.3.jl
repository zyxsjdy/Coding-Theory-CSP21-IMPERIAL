
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
        return "p is not a prime number. Please input a prime number."
    end
end


fx = [1 0 2 0 1]
p = 3
is_irreducible(fx,p)


































