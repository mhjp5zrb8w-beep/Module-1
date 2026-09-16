#show off how crazy autocomplete is in Julia

#function to compute the present value of a perpetuity paying C forever at rate r
function present_value_perpetuity(C, r)
    return C / r
end

#function to compute the volume of a sphere given its radius
function volume_of_sphere(r)
    return (4/3) * π * r^3
end

celsius_to_fahrenheit = (c) -> c * 9/5 + 32
fahrenheit_to_celsius = (f) -> (f - 32) * 5/9

using Distributions
dist = Normal(0,1)  # this will autocomplete to Distributions.Normal  


function average_savings_rate(income, consumption)
    rates = (income .- consumption) ./ income
    return mean(rates)
end

####Begin debugging stufff
function price_at_quantile(prices, pct)
    sorted = sort(prices)
    n = length(sorted)
    idx = round(Int, pct * n) + 1   ###the plus one is the bug!
    return sorted[idx]
end

# Uncomment and run to trigger the error:
price_at_quantile([10.0, 12.0, 9.0, 15.0], 1.0)

#

function simulate_solow(k0, s, alpha, delta, T)
    k = zeros(T + 1)
    y = zeros(T + 1)
    k[1] = k0
    y[1] = k[1]^alpha
    for t in 1:T
        k[t+1] = s * y[t] + (1 - delta) * k[t]
        y[t+1] = k[t+1]^alpha
    end
    return k, y
end

#####