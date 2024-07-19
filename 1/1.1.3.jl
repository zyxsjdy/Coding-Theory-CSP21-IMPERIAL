#recursion
function m(x,n,p)
    if n > 1
        return mod((m(x,n-1,p)*mod(3,p)),p)
    else
        return mod(3,p)
    end
end
m(3,789,811)