using DSP

a = [1]
b = [1]

M = length(a)
N = length(b)
 
c = zeros(M+N-1)


for i = 1:M
    for j = 1:N
        c[i+j-1]=a[i]*b[j]+c[i+j-1]
    end
end


@show c
conv(a,b)














