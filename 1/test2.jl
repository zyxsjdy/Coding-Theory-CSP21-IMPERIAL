using Polynomials

function show_poly(ax) #input the matrix
    L = length(ax)
    if L == 1
        print(ax[1])
    else
        flag = 0
        for i = 1:L
            b = ax[i]
            if b != 0
                if flag == 1
                    print(" + ")
                end
                if i == 1
                    print("$b")
                elseif i == 2
                    if b == 1
                        print("x")
                    else
                        print("$b*x")
                    end
                else
                    if b == 1
                        print("x^$(i-1)")
                    else
                        print("$b*x^$(i-1)")
                    end
                end
                if i == L
                    print("\n")
                end
                flag = 1
            end
        end
    end
end

f = [0 1 0 4]
@show Polynomial(vec(f))
show_poly(f)












