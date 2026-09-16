#####broadcasting
x = collect(1:1:100)
x.+=1
y = log.(x)

typeof(x)

####Structs 
struct Point
    x::Float64
    y::Float64
end

p = Point(1.0, 2.0)
p.x
p.y
p.x + p.y

using Parameters
@with_kw struct point_2
    x::Float64 = 1.0
    y::Float64 = 2.0
end

q1= point_2()
q2 = point_2(x = 1.5)

using Plots, Distributions, Random
dist = Normal(0,1)
Random.seed!(1234)
n = 1000
ϵ = rand(dist, n)
plot(1:n, ϵ)
histogram(ϵ)


#####begin debugging
function price_at_quantile(prices, pct)
    sorted = sort(prices)
    n = length(sorted)
    idx = round(Int, pct*n) 
    return sorted[idx]
end
price_at_quantile([10.0, 12.0, 9.0, 15.0], 0.5)


#####multi-layered stack trace
function pct_change(x0, x1)
    return(x1-x0)/x0
end

function average_growth(prices)
    changes=Float64[]
    for i in 1:length(prices) - 1
        push!(changes, pct_change(prices[i], prices[i+1]))
    end
    return sum(changes)/length(changes)
end

function summarize_growth(prices)
    g = average_growth(prices)
    return "Average growth: $(round(g*100; digits=1))%"
end

summarize_growth(["100.0", 110.0, 105.0])


###household savings example
income = [45.0, 62.0, 38.0, 0.0, 51.0, 70.0, 29.0, 55.0]
consumption = [30.0, 40.0, 25.0, 5.0, 33.0, 50.0, 20.0, 35.0]

# A household's savings rate: the fraction of income not consumed.
function savings_rate(income, consumption)
    return (income - consumption) / income
end

using Infiltrator
#using Logging
function average_savings_rate(income, consumption)
    rates = Float64[]
    for i in eachindex(income)
        r = savings_rate(income[i], consumption[i])
        #@debug "household $i" income = income[i] consumption=consumption[i] rate = r
        if !isfinite(r)
            #@warn "household $i" income = income[i] consumption=consumption[i] rate = r
            @infiltrate
        end    
        push!(rates, r)
    end
    return sum(rates) / length(rates)
end
#ENV["JULIA_DEBUG"] = "Main"  #set this to turn debug statements off or on

println("Average savings rate: ", average_savings_rate(income, consumption))



####end of file