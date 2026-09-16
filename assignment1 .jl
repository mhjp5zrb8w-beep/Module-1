### question 1

function factorial2(n)
    result = 1

    for i = 1:n
        result = result * i
    end

    return result
end

factorial2(5)

### question 2

function estimate_pi(n)
    count = 0

    for i = 1:n
        x = rand()
        y = rand()

        if x^2 + y^2 <= 1
            count = count + 1
        end
    end

    return 4 * count / n
end

estimate_pi(100000)

#= like putting a circle into a square 
   then random draw point in between
   using the ratio to estimate pi
  =#


### question 3

using Plots, Distributions

function simulate_ar1(alpha, n)
    x = zeros(n + 1)
    dist = Normal(0, 1)

    for t = 1:n
        epsilon = rand(dist)
        x[t + 1] = alpha * x[t] + epsilon
    end

    return x
end

n = 200

x0 = simulate_ar1(0.0, n)
x08 = simulate_ar1(0.8, n)
x09 = simulate_ar1(0.9, n)
x098 = simulate_ar1(0.98, n)

plot(0:n, x0, title = "alpha = 0")
plot(0:n, x08, title = "alpha = 0.8")
plot(0:n, x09, title = "alpha = 0.9")
plot(0:n, x098, title = "alpha = 0.98")

#=
       As alpha increases 
       the series becomes more persistent 
        and the unconditional volatility becomes larger.
=#

### question 4

N = 50



a = 0.1
b = 0.2
c = 0.5
d = 1.0



sigma = 0.1
dist = Normal(0, 1)
#  x1 and x2

x1 = rand(dist, N)
x2 = rand(dist, N)


x1_squared = x1.^2

#  X 
X = hcat(x1, x1_squared, x2, ones(N))

# number of simulations
simulations = 200

# store the estimates
a_estimates = zeros(simulations)
b_estimates = zeros(simulations)
c_estimates = zeros(simulations)
d_estimates = zeros(simulations)

for i = 1:simulations

    # draw new error term
    w = rand(dist, N)

    #  y
    y = a .* x1 .+
        b .* x1_squared .+
        c .* x2 .+
        d .+
        sigma .* w

    #  OLS
    beta_ols = inv(X' * X) * X' * y

    # save 
    a_estimates[i] = beta_ols[1]
    b_estimates[i] = beta_ols[2]
    c_estimates[i] = beta_ols[3]
    d_estimates[i] = beta_ols[4]

end

# plot 
histogram(a_estimates, title = "Estimates of a")
histogram(b_estimates, title = "Estimates of b")
histogram(c_estimates, title = "Estimates of c")
histogram(d_estimates, title = "Estimates of d")

### question 5


function newton_method(f, fprime, x0, tolerance, max_iterations)

    x = x0
    iteration = 0

    while iteration < max_iterations

        x_new = x - f(x) / fprime(x)

        if abs(x_new - x) < tolerance
            return x_new
        end

        x = x_new
        iteration = iteration + 1
    end

    return x
end


# test 1
f(x) = (x - 1)^3
fprime(x) = 3 * (x - 1)^2

root1 = newton_method(f, fprime, 2.0, 0.0001, 100)
root1


# test 2
g(x) = x^2 - 4
gprime(x) = 2 * x

root2 = newton_method(g, gprime, 3.0, 0.0001, 100)
root2







### question 6



firm_names = ["A", "B", "C", "D", "E"]
revenue_y1 = [200.0, 500.0, 80.0, 1000.0, 150.0]   # nominal revenue, year 1
revenue_y2 = [250.0, 520.0, 100.0, 1050.0, 200.0]  # nominal revenue, year 2
employees = [50, 200, 20, 500, 30]                 # headcount, year 1

cpi_y1 = 100.0  # CPI, year 1 (base year, by construction = 100)
cpi_y2 = 110.0  # CPI, year 2 (economy-wide inflation was 10% over the period)

function weighted_real_growth(revenue_y1, revenue_y2, employees, cpi_y1, cpi_y2)
    # STEP 1: convert nominal revenue to real (inflation-adjusted) dollars,
    # using each year's CPI (a CPI of 100 = the base year's price level)
    real_y1 = revenue_y1 ./ (cpi_y1 / 100)
    real_y2 = revenue_y2 ./ (cpi_y2 / 100)

        println("real_y1 = ", real_y1)
    println("real_y2 = ", real_y2)

    # STEP 2: each firm's individual real revenue growth rate
    growth = (real_y2 .- real_y1) ./ real_y1

        println("growth = ", growth)

    # STEP 3: employee-based weights, normalized to sum to 1
    weights = employees ./ sum(employees)

    println("weights = ", weights)
    println("sum of weights = ", sum(weights))

    # STEP 4: employee-weighted average growth rate across firms
    avg_growth = sum(weights .* growth)

        println("avg_growth = ", avg_growth)

    # STEP 5: express as a percentage, rounded to 2 decimal places
    return round(100 * avg_growth, digits=2)

        println("result = ", result)
end


result = weighted_real_growth(revenue_y1, revenue_y2, employees, cpi_y1, cpi_y2
)

println("\nFinal result: ", result, "%")
### Question 7

function merge_sort(arr)

    if length(arr) <= 1
        return arr
    end

    mid = length(arr) ÷ 2

    left = merge_sort(arr[1:mid])
    right = merge_sort(arr[mid+1:end])

    return merge(left, right)
end


function merge(left, right)

    result = []

    i = 1
    j = 1

    while i <= length(left) && j <= length(right)

        if left[i] <= right[j]

            push!(result, left[i])
            i = i + 1

        else

            push!(result, right[i])   # bug
            j = j + 1

        end
    end

    while i <= length(left)
        push!(result, left[i])
        i = i + 1
    end

    while j <= length(right)
        push!(result, right[j])
        j = j + 1
    end

    return result
end

merge_sort([3, 1, 4, 1, 5, 9, 2, 6])

### question 8

# 1. column_means
function column_means(A)
    n, m = size(A)
    means = zeros(m)

    for j in 1:m
        means[j] = sum(A[:, j]) / n
    end

    return means
end

# 2. factorial_r
function factorial_r(n)

    if n == 0 || n == 1
        return 1
    end

    return n * factorial_r(n - 1)
end

# 3. total_sum
function total_sum(xs)

    total = 0

    for x in xs
        total += x
    end

    return total
end

# 4. tag_budget
function tag_budget(amount)

    threshold_high = 1000

    if amount >= threshold_high
        return "high"
    elseif amount >= 100
        return "medium"
    else
        return "low"
    end
end

# 5. first_negative
function first_negative(xs)

    i = 1

    while i <= length(xs)

        if xs[i] < 0
            return i
        end

        i += 1
    end

    return 0
end

# 6. normalize_columns
function normalize_columns(X, means)

    return X .- means'

end

# 7. average
function average(xs)
    return sum(xs) / length(xs)
end

# 8. sort_ascending!
function sort_ascending!(xs)

    sort!(xs)

    return xs
end

# 9. unique_values
function unique_values(xs)

    result = eltype(xs)[]

    for i in 1:length(xs)

        if !(xs[i] in result)
            push!(result, xs[i])
        end

    end

    return result
end

### AI is just too good at dealing with coding staff. And that's all the bug.


### question 9
# perf_exercise.jl
#
# ECON 5010 — Performance Optimization Exercise
# ------------------------------------------------
# Every function below computes something simple and correct, but each
# one is written in a way that makes Julia run much slower than it
# needs to.
#
# YOUR TASK:
#   1. Run `main()` once and note the @time output (baseline).
#   2. Profile the code — use @time / @btime (BenchmarkTools.jl),
#      @code_warntype, and/or @allocated / --track-allocation — to find
#      the bottlenecks in each function.
#   3. Rewrite each function so it runs faster and allocates less
#      memory, WITHOUT changing what it computes. (Your output values
#      should match the originals.)
#   4. Be ready to explain, for each fix: what was slow, why, and how
#      you fixed it.
#
# Hints on what to look for (this is most of what you'll need to know
# about Julia performance):
#   - Non-constant global variables
#   - Containers that don't have a concrete element type
#   - Allocating memory inside a loop when you don't need to
#   - Copying data (e.g. via slicing) when a view would do
#   - Growing a plain array one element at a time
#   - Type instability (a variable that can hold more than one type)
#
# You will not need every hint for every function.

using Random
using Statistics

# --- Global state used directly inside the functions below ---
N = 2_000_000
data = rand(N)

# 1. 
function compute_stats(data)

    results = zeros(5)

    results[1] = sum(data)
    results[2] = mean(data)
    results[3] = maximum(data)
    results[4] = minimum(data)
    results[5] = std(data)

    return results
end


# 2. 
function monte_carlo_pi(n)

    count = 0

    for i in 1:n

        x = rand()
        y = rand()

        if x^2 + y^2 <= 1.0
            count += 1
        end

    end

    return 4 * count / n
end

# 3. 
function row_sums(A)

    n = size(A, 1)
    m = size(A, 2)

    sums = zeros(n)

    for i in 1:n

        for j in 1:m
            sums[i] += A[i, j]
        end

    end

    return sums
end

# 4.
function build_report(labels, values)
    report = ""
    for i in 1:length(labels)
        report = report * labels[i] * ": " * string(values[i]) * "\n"
    end
    return report
end

# 5. 
function unstable_sum(xs)

    total = 0.0

    for x in xs

        if x > 0.5
            total += x
        end

    end

    return total
end

function main()

    N = 2_000_000
    data = rand(N)

    println("Computing stats...")
    stats = compute_stats(data)
    println(stats)

    println("Estimating pi...")
    pi_est = monte_carlo_pi(1_000_000)
    println(pi_est)

    println("Computing row sums...")
    A = rand(2000, 2000)
    sums = row_sums(A)
    println(sums[1:5])

    println("Building report...")
    labels = ["sum", "mean", "max", "min", "std"]
    report = build_report(labels, stats)
    println(report)

    println("Summing with condition...")
    println(unstable_sum(data))

end


@time main()


### question 10

# AI is just too good at coding. First I can't read what it write, 
# then I don't know how to fix it but luckily the AI could do that for me.
# So I could let AI generate A visual way for me to check how good it is.
# Then I can focus on it can give more direction.
# Let's see what it can do

############################################################
# Question 1
############################################################

"""
    factorial2(n)

Compute n! using an explicit for-loop.
"""
function factorial2(n)

    if n < 0
        error("Factorial is only defined here for nonnegative integers.")
    end

    result = 1

    for i in 1:n
        result *= i
    end

    return result
end


println("Question 1:")
println("5! = ", factorial2(5))
println("0! = ", factorial2(0))

############################################################
# Question 2
############################################################

"""
    monte_carlo_pi(n)

Approximate pi using Monte Carlo simulation on the unit square.
"""
function monte_carlo_pi(n)

    inside_circle = 0

    for i in 1:n

        x = rand()
        y = rand()

        if x^2 + y^2 <= 1.0
            inside_circle += 1
        end
    end

    return 4.0 * inside_circle / n
end


Random.seed!(5010)

pi_estimate = monte_carlo_pi(1_000_000)

println("\nQuestion 2:")
println("Monte Carlo estimate of pi = ", pi_estimate)
println("Actual pi = ", π)
println("Absolute error = ", abs(pi_estimate - π))

#= The Monte Carlo estimate converges toward π as
 the number of random draws increases. 
The method works because the area of the quarter
 unit circle is π/4 while the area of the unit square is 1.

=#

############################################################
# Question 3
############################################################

"""
    simulate_ar1(alpha, n)

Simulate an AR(1) process:
    x[t+1] = alpha*x[t] + epsilon[t+1]
with x[0] = 0 and standard-normal innovations.
"""
function simulate_ar1(alpha, n)

    x = zeros(n + 1)

    for t in 1:n
        epsilon = rand(Normal(0, 1))
        x[t + 1] = alpha * x[t] + epsilon
    end

    return x
end


Random.seed!(5010)

n = 200

x_alpha0   = simulate_ar1(0.0, n)
x_alpha08  = simulate_ar1(0.8, n)
x_alpha09  = simulate_ar1(0.9, n)
x_alpha098 = simulate_ar1(0.98, n)


p1 = plot(
    0:n,
    x_alpha0,
    title = "AR(1): α = 0.00",
    xlabel = "Time",
    ylabel = "xₜ",
    legend = false
)

p2 = plot(
    0:n,
    x_alpha08,
    title = "AR(1): α = 0.80",
    xlabel = "Time",
    ylabel = "xₜ",
    legend = false
)

p3 = plot(
    0:n,
    x_alpha09,
    title = "AR(1): α = 0.90",
    xlabel = "Time",
    ylabel = "xₜ",
    legend = false
)

p4 = plot(
    0:n,
    x_alpha098,
    title = "AR(1): α = 0.98",
    xlabel = "Time",
    ylabel = "xₜ",
    legend = false
)

plot(p1, p2, p3, p4, layout = (2, 2))

#=
As α increases, the process becomes increasingly persistent. When α = 0, 
the series is simply white noise, 
so shocks have no effect on future observations. 
For larger values of α, shocks decay more slowly and therefore
 remain embedded in the process for longer periods. Consequently,
 the unconditional volatility rises as α approaches one.
=#

############################################################
# Question 4
############################################################

Random.seed!(5010)

N = 50
num_simulations = 200

a_true = 0.1
b_true = 0.2
c_true = 0.5
d_true = 1.0
sigma = 0.1

dist = Normal(0, 1)


# Draw explanatory variables once
x1 = rand(dist, N)
x2 = rand(dist, N)

x1_squared = x1.^2


# Design matrix:
# coefficient ordering is [a, b, c, d]
X = hcat(
    x1,
    x1_squared,
    x2,
    ones(N)
)


# Store parameter estimates
estimates = zeros(num_simulations, 4)


for s in 1:num_simulations

    # Draw a new disturbance vector
    w = rand(dist, N)

    # Generate dependent variable
    y = (
        a_true .* x1 .+
        b_true .* x1_squared .+
        c_true .* x2 .+
        d_true .+
        sigma .* w
    )

    # Manual OLS calculation
    beta_hat = inv(X' * X) * X' * y

    estimates[s, :] = beta_hat
end


a_estimates = estimates[:, 1]
b_estimates = estimates[:, 2]
c_estimates = estimates[:, 3]
d_estimates = estimates[:, 4]


println("\nQuestion 4:")
println("Average estimate of a = ", mean(a_estimates))
println("Average estimate of b = ", mean(b_estimates))
println("Average estimate of c = ", mean(c_estimates))
println("Average estimate of d = ", mean(d_estimates))
h1 = histogram(
    a_estimates,
    title = "Sampling Distribution of â",
    xlabel = "Estimate",
    ylabel = "Frequency",
    legend = false
)

vline!(h1, [a_true])


h2 = histogram(
    b_estimates,
    title = "Sampling Distribution of b̂",
    xlabel = "Estimate",
    ylabel = "Frequency",
    legend = false
)

vline!(h2, [b_true])


h3 = histogram(
    c_estimates,
    title = "Sampling Distribution of ĉ",
    xlabel = "Estimate",
    ylabel = "Frequency",
    legend = false
)

vline!(h3, [c_true])


h4 = histogram(
    d_estimates,
    title = "Sampling Distribution of d̂",
    xlabel = "Estimate",
    ylabel = "Frequency",
    legend = false
)

vline!(h4, [d_true])


plot(h1, h2, h3, h4, layout = (2, 2))

#=
The sampling distributions are centered approximately
 around the true parameter values. Across simulations,
  the explanatory variables remain fixed while the disturbance 
    vector changes. As a result, variation in the OLS estimates 
    reflects sampling variation generated by the random error term.
=#

############################################################
# Question 5
############################################################

"""
    newton_method(f, fprime, x0, tolerance, max_iterations)

Find a root of f using Newton's method.
"""
function newton_method(
    f,
    fprime,
    x0,
    tolerance,
    max_iterations
)

    x = x0

    for iteration in 1:max_iterations

        derivative = fprime(x)

        if derivative == 0
            error("Newton's method encountered a zero derivative.")
        end

        x_new = x - f(x) / derivative

        if abs(x_new - x) < tolerance
            return x_new
        end

        x = x_new
    end

    return x
end

f1(x) = (x - 1)^3
f1prime(x) = 3 * (x - 1)^2

root1 = newton_method(
    f1,
    f1prime,
    2.0,
    1e-8,
    1000
)

println("\nQuestion 5:")
println("Root of (x - 1)^3 = ", root1)

f2(x) = x^2 - 4
f2prime(x) = 2 * x

root2 = newton_method(
    f2,
    f2prime,
    3.0,
    1e-8,
    100
)

println("Root of x^2 - 4 = ", root2)

#=
Both examples converge to analytically known roots.
 The first example converges to 1, while the second 
 converges to 2 when initialized at x₀ = 3.
=#


############################################################
# Question 6
############################################################

firm_names = ["A", "B", "C", "D", "E"]

revenue_y1 = [
    200.0,
    500.0,
    80.0,
    1000.0,
    150.0
]

revenue_y2 = [
    250.0,
    520.0,
    100.0,
    1050.0,
    200.0
]

employees = [
    50,
    200,
    20,
    500,
    30
]

cpi_y1 = 100.0
cpi_y2 = 110.0


function weighted_real_growth(
    revenue_y1,
    revenue_y2,
    employees,
    cpi_y1,
    cpi_y2
)

    # Step 1
    real_y1 = revenue_y1 ./ (cpi_y1 / 100)
    real_y2 = revenue_y2 ./ (cpi_y2 / 100)

    println("Step 1:")
    println("real_y1 = ", real_y1)
    println("real_y2 = ", real_y2)


    # Step 2
    growth = (real_y2 .- real_y1) ./ real_y1

    println("\nStep 2:")
    println("growth = ", growth)


    # Step 3
    weights = employees ./ sum(employees)

    println("\nStep 3:")
    println("weights = ", weights)
    println("sum(weights) = ", sum(weights))


    # Step 4
    avg_growth = sum(weights .* growth)

    println("\nStep 4:")
    println("avg_growth = ", avg_growth)


    # Step 5
    result = round(
        100 * avg_growth,
        digits = 2
    )

    println("\nStep 5:")
    println("result = ", result)

    return result
end


result_q6 = weighted_real_growth(
    revenue_y1,
    revenue_y2,
    employees,
    cpi_y1,
    cpi_y2
)

println("\nFinal result: ", result_q6, "%")

#=
Print-statement debugging revealed that the employee
 weights did not sum to one. The problem occurred in
  Step 3: the code divided each firm's employment by
   total revenue rather than total employment.
    Replacing sum(revenue_y1) with sum(employees)
     corrected the normalization and produced the
      expected result of approximately -2.22%.
=#

############################################################
# Question 7
############################################################

function merge_sort(arr)

    if length(arr) <= 1
        return arr
    end

    mid = length(arr) ÷ 2

    left = merge_sort(arr[1:mid])
    right = merge_sort(arr[mid + 1:end])

    return merge_arrays(left, right)
end


function merge_arrays(left, right)

    result = eltype(left)[]

    i = 1
    j = 1

    while (
        i <= length(left) &&
        j <= length(right)
    )

        if left[i] <= right[j]

            push!(result, left[i])
            i += 1

        else

            push!(result, right[j])
            j += 1

        end
    end


    while i <= length(left)
        push!(result, left[i])
        i += 1
    end


    while j <= length(right)
        push!(result, right[j])
        j += 1
    end

    return result
end


test_vector = [
    3,
    1,
    4,
    1,
    5,
    9,
    2,
    6
]

sorted_vector = merge_sort(test_vector)

println("\nQuestion 7:")
println(sorted_vector)

#=
I placed a breakpoint inside the merge function
     and stepped through the two index variables.
      The error occurred when the algorithm selected 
      an element from the right-hand vector. The branch
       incremented j, but selected right[i]. Replacing
        this with right[j] corrected the merge operation.

=#

############################################################
# Question 8
############################################################


function column_means(A)

    n, m = size(A)

    means = zeros(m)

    for j in 1:m
        means[j] = sum(A[:, j]) / n
    end

    return means
end


function factorial_r(n)

    if n == 0 || n == 1
        return 1
    end

    return n * factorial_r(n - 1)
end


function total_sum(xs)

    total = 0

    for x in xs
        total += x
    end

    return total
end


function tag_budget(amount)

    threshold_high = 1000

    if amount >= threshold_high

        return "high"

    elseif amount >= 100

        return "medium"

    else

        return "low"

    end
end


function first_negative(xs)

    for i in 1:length(xs)

        if xs[i] < 0
            return i
        end

    end

    return 0
end


function normalize_columns(X, means)

    return X .- means'

end


function average(xs)

    return sum(xs) / length(xs)

end


function sort_ascending!(xs)

    sort!(xs)

    return xs
end


function unique_values(xs)

    result = eltype(xs)[]

    for x in xs

        if !(x in result)
            push!(result, x)
        end

    end

    return result
end


function sample_std(xs)

    xbar = sum(xs) / length(xs)

    squared_deviations = 0.0

    for x in xs
        squared_deviations += (x - xbar)^2
    end

    return sqrt(
        squared_deviations /
        (length(xs) - 1)
    )
end


function growth_rate(
    new_value,
    old_value
)

    return (
        (new_value - old_value) /
        old_value
    ) * 100
end


function has_converged(
    x_new,
    x_old,
    tolerance
)

    return abs(x_new - x_old) < tolerance
end


#=
AI was highly effective for interpreting explicit
     Julia error messages, especially bounds errors,
      type mismatches, and recursive functions without
       stopping conditions. It was also useful for explaining
        silent logical bugs such as integer division or failure
         to modify an array in place. However, the most reliable
          debugging procedure remained comparing the code's behavior 
          with the stated purpose of each function and confirming the
             proposed fix using the supplied test cases.
=#

############################################################
# Question 9
############################################################

using Random
using Statistics


function compute_stats(data)

    results = zeros(5)

    results[1] = sum(data)
    results[2] = mean(data)
    results[3] = maximum(data)
    results[4] = minimum(data)
    results[5] = std(data)

    return results
end


function monte_carlo_pi_fast(n)

    count = 0

    for i in 1:n

        x = rand()
        y = rand()

        if x^2 + y^2 <= 1.0
            count += 1
        end

    end

    return 4.0 * count / n
end


function row_sums_fast(A)

    n = size(A, 1)
    m = size(A, 2)

    sums = zeros(n)

    for i in 1:n

        total = 0.0

        for j in 1:m
            total += A[i, j]
        end

        sums[i] = total
    end

    return sums
end


function build_report_fast(
    labels,
    values
)

    lines = Vector{String}(
        undef,
        length(labels)
    )

    for i in 1:length(labels)

        lines[i] = (
            labels[i]
            * ": "
            * string(values[i])
        )

    end

    return join(lines, "\n") * "\n"
end


function stable_sum(xs)

    total = 0.0

    for x in xs

        if x > 0.5
            total += x
        end

    end

    return total
end


function main_fast()

    N = 2_000_000
    data = rand(N)

    println("Computing stats...")
    stats = compute_stats(data)
    println(stats)


    println("Estimating pi...")
    pi_est = monte_carlo_pi_fast(
        1_000_000
    )
    println(pi_est)


    println("Computing row sums...")

    A = rand(2000, 2000)

    sums = row_sums_fast(A)

    println(sums[1:5])


    println("Building report...")

    labels = [
        "sum",
        "mean",
        "max",
        "min",
        "std"
    ]

    report = build_report_fast(
        labels,
        stats
    )

    println(report)


    println(
        "Summing with condition..."
    )

    println(
        stable_sum(data)
    )
end


println("\nQuestion 9 performance:")
@time main_fast()


#=
Several performance problems were removed.
 First, large non-constant global variables
  were moved inside main_fast() and explicitly
   passed to functions. Second, untyped arrays
    such as [] were replaced with concretely typed
     preallocated arrays. Third, the Monte Carlo routine
      no longer constructs a new two-element vector during
       every iteration. Fourth, the row-sum routine avoids 
       repeatedly copying matrix rows. Finally, the conditional
        accumulator is initialized as a floating-point value, 
        avoiding type instability.

=#

### question 10


#=
Not only better, but also best.
=#