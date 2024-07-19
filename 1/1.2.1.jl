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

# Determine the degree of polynomial A. On the right is the coefficient of the largest term
# 3x^2+2x+1 then input A = [1 2 3]
function getdeg(A)
    n = length(A)

    for i in 1:length(A)
        if A[n] == 0 # Determine whether the last bit is 0, if yes, reduce 1 to the length of A
            n -= 1; # Judge the next one in the next loop
            if n == 0 # if all of A equal to 0, then return degree 0
                return 0
            end
        else
            return n-1 # degree starts from 0, and the number of items starts from 1, so return n-1
        end
    end
end

# Fraction modulation 
function fractionmod(molecular,denominator,p) # input the molecular and denominator of the fraction, then get the mod
    n=0 
    judgement = true #make judgement whether jump out the loop
    while judgement
        n += 1
        judgement = (mod(molecular,p) != mod(denominator*n,p)) 
        #Judge how many n can make the polynomial hold, they molecular%p equal to denominator module p, return n
    end
    return n
end

# get the modulus of each number in a matrix
function arraymod(array,p) #input the matrix
    for i = 1:length(array)  
        array[i]=mod(array[i],p) # Modulo each item in the matrix
    end
    return array
end

# show the matrix in the form of polynomial, e.g. [1 2 3] -> 1 + 2*x + 3*x^2
function show_poly(ax)
    L = length(ax)
    if getdeg(ax) == 0 # if degree of ax is 0, output its first element
        print(ax[1])
        print("\n")
    else # if ax has more than 1 element
        flag = 0 # this flag is used to make sure the sign " + " is correctly demonstrated
        for i = 1:L
            b = ax[i]
            if b != 0 # if b = 0, do not output, print if b != 0
                if flag == 1 # if there is a output before this output, output " + ". This is used to avoid this kind of output: " + 2*x + 3*x^2"
                    print(" + ")
                end
                if i == 1 # output the element that x has 0 degree, hence only output b, rather than b*x^0
                    print("$b")
                elseif i == 2 # output the element that x has 1 degree, hence only output bx, rather than b*x^1
                    if b == 1 # check whether b = 1, if true, only output x, rather than 1*x
                        print("x")
                    else
                        print("$b*x") # output bx
                    end
                else
                    if b == 1
                        print("x^$(i-1)") # check whether b = 1, if true, only output x^(i-1), rather than 1*x^(i-1)
                    else
                        print("$b*x^$(i-1)") # output b*x^(i-1)
                    end
                end
                flag = 1
            end
        end
        print("\n") # add a final linefeed to the output
    end
end

# Polynomial division, Find the remainder and quotient of fx/gx in p-domain
function polydiv(fx,gx,p) 
    if isprime(p) # decide it's prime or not, if not, then return error
        fx = arraymod(fx,p) # Take the modulus of fx to ensure that coefficients of fx is in Fp
        gx = arraymod(gx,p) # Take the modulus of gx to ensure that coefficients of gx is in Fp
        deg_fx = getdeg(fx) # get the degree of fx and gx
        deg_gx = getdeg(gx)
        fx = fx[1,1:deg_fx+1]' # Discard the extra 0 in fx, e.g. [1 2 1 0 0] -> [1 2 1]
        gx = gx[1,1:deg_gx+1]' # Discard the extra 0 in gx

        if gx == [0]'
            println("Warning, cannot divide 0!")
            return (rem=[],quo=[])
        elseif deg_gx > deg_fx # If the order of gx is higher than fx, the remainder is gx, the quotient is 0
            rx = convert(Matrix{Int64},fx)
            qx = [0]
            return (rem=rx,quo=qx)
        else
            deg_diff = deg_fx - deg_gx # degree different between fx and gx
            qx = zeros(1,deg_diff+1) # Initialize qx and rx
            rx = zeros(Int64,1,deg_gx+1)

            for i in 0:deg_diff
                # Add 0 to the gx matrix to make gx and fx the same length
                # With the change of degree quotient, the position of gx is different each time
                zero_highdeg = zeros(Int64,1,i) 
                zero_lowdeg = zeros(Int64,1,deg_diff-i)
                gx_addzero = [zero_lowdeg gx zero_highdeg]

                # Calculate the quotient of each step
                # eg: Divide the highest order coefficient of fx by the highest order coefficient of gx for the first time
                qx[deg_diff+1-i] = fx[deg_fx+1-i]/gx[deg_gx+1]

                # Modulo qx
                if !isinteger(qx[deg_diff+1-i]) # Fraction modulo if qx is not a integer
                    qx[deg_diff+1-i] = fractionmod(fx[deg_fx+1-i],gx[deg_gx+1],p)
                else # integer mod
                    qx[deg_diff+1-i] = mod(qx[deg_diff+1-i],p) 
                end

                # Calculate the remainder, the remainder is the next divider
                fx = fx-gx_addzero*qx[deg_diff+1-i]
            end

            # Remove the 0 in rx and gx, and convert them into Int
            rx = convert(Matrix{Int64},arraymod(fx,p)) # the newest fx is the remainder, do modulation
            rx = rx[1,1:getdeg(rx)+1]' # Discard extra 0s
            qx = convert(Matrix{Int64},arraymod(qx,p))
            qx = qx[1,1:getdeg(qx)+1]' # Discard extra 0s

            return (rem=rx,quo=qx)
        end
    else
        return "p is not a prime number. Please change the value of p." # p is not a prime
    end
end

function matrix_conv(a, b) # our own convolution function
    M = length(a)          # the multiplication of polynomials is actually the convolution
    N = length(b)
    c = zeros(Int64,1,M+N-1)
    for i = 1:M
        for j = 1:N
            c[i+j-1] += a[i]*b[j] # find each element
        end
    end
    return c
end

# Find the GCD and bezout's identity (x,y) of fx and gx
function gcdx_poly(fx,gx,p)
    result = polydiv(fx,gx,p) # Polynomial division, Find the remainder and quotient of fx/gx in p-domain
    remainder = result.rem
    quotient = result.quo
    if getdeg(remainder) == 0 && remainder[1] == 0 # when the remainder is 0, gcd = 0*fx + 1*gx
        gcd = convert(Matrix{Int64},arraymod(gx,p))
        gcd = gcd[1,1:getdeg(gcd)+1]' # Discard extra 0s

        L_gcd = length(gcd)
        y = ones(Int64,1,1)
        if gcd[L_gcd] !=1 # make the coefficient of the highest degree x equals to 1
            y[1] = fractionmod(y[1],gcd[L_gcd],p)
            for j = 1:L_gcd
                gcd[j] = fractionmod(gcd[j],gcd[L_gcd],p)
            end
        end
        return (gcd, x = zeros(Int64,1,1), y)
    else
        prev = gcdx_poly(gx,remainder,p) # iteration, untill the remainder is 0
        a = matrix_conv(prev.y, quotient)  # calculate prev.y*quotient (generally, quotient is not the same for every iteration)

        # because the length of a and prev.x are not the same, this is used to calculate (prev.x - a), which is actually (prev.x - prev.y*quotient)
        if length(a) > length(prev.x)
            y = -a
            for i = 1:length(prev.x)
                y[i] += prev.x[i]
            end
        else
            y = prev.x
            for i = 1:length(a)
                y[i] -= a[i]
            end
        end

        # gcd is always the same, x = prev.y, y = prev.x - prev.y*quotient
        y = convert(Matrix{Int64},arraymod(y,p))
        y = y[1,1:getdeg(y)+1]'
        return (gcd = prev.gcd, x= prev.y, y)
    end
end

function show_result_1(p,fx,gx,result)
    print("In the polynomial ring F$p[x]\n")
    print("Input fx:  ")
    show_poly(fx)
    print("Input gx:  ")
    show_poly(gx)
    print("The quotient is:  ")
    show_poly(result.quo)
    print("The Remainder is:  ")
    show_poly(result.rem)
    print("\n")
end

# The right hand side of the input matrix has the highest degree, e.g. [1 2 3] -> 1 + 2*x + 3*x^2
fx = [1 2 2 3 1]
gx = [1 2 4]
p = 3
result = polydiv(fx,gx,p)
show_result_1(p,fx,gx,result)

fx = [2 3 5 4 1]
gx = [3 3 2]
p = 5
result = polydiv(fx,gx,p)
show_result_1(p,fx,gx,result)

fx = [1 0 0]
gx = [0 0 0]
p = 5
result = polydiv(fx,gx,p)
show_result_1(p,fx,gx,result)




