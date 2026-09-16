###show off compilation
function f(a, b)
    y = (a + 8b)^2
    return 7y
end
f(1, 2)
@code_native f(1, 2)  #view machine code generate by Julia

###globals vs not
a = 3.0 #bad global variable
@elapsed for i = 1:1000000
    global a
    a+=i
end

##
function timetest()
    a = 3.0 #good function-contained variable
    for i = 1:1000000
        a+=i
    end
    return a
end

@elapsed timetest() #much faster!

#####showing off profiler
using Profile

function test(x::Float64)
    for i = 1:10000000
        x+=i #do a bunch of things to x
        x-=i
        x*=i
        x/=i
        x = abs(x)
        x = log(x)
    end
    x
end

Profile.clear() #empty the profile
@profile test(2.0) #profile a call of test function
Profile.print() #print profile



####parallelization example
using Distributed

#add processes
workers()
addprocs(3)

@everywhere using Distributions, Statistics, SharedArrays

@everywhere function draw(σ::Int64, n::Int64)
    dist = Normal(0, σ)
    draws = rand(dist, n)
    v1, v2 = mean(draws), std(draws)
    v1, v2
end

temp = zeros(12,2)
@elapsed for i = 1:12
    mean, sd = draw(i, 100000000)
    temp[i,1] = mean
    temp[i,2] = sd
end

##faster when distributing!
temp = SharedArray{Float64}(12,2)
@elapsed @sync @distributed for i = 1:12
    mean, sd = draw(i, 100000000)
    temp[i,1] = mean
    temp[i,2] = sd
end


#####what level to distribute at?

function test_parallel()
    temp = SharedArray{Float64}(12, 2)
    mean_grid = SharedArray{Float64}(10000)        
    sd_grid = SharedArray{Float64}(10000) 
    
    @sync @distributed for i = 1:12 #can distribute at this level     
        for i = 1:10000 #or this one!
            mean_grid[i], sd_grid[i] = draw(i, 10000)
        end
        temp[i, 1] = mean(mean_grid)
        temp[i, 2] = mean(sd_grid)
    end
end

@elapsed test_parallel()



###
