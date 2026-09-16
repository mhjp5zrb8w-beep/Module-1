# debug_exercise.jl
#
# ECON 5010 — Debugging Exercise
# ------------------------------------------------
# Every function below is supposed to do something simple, described in
# its comment. Every function has exactly one bug. Some bugs make Julia
# throw an error — read the error type and stack trace, they tell you a
# lot. Other bugs are quieter: the code runs to completion without
# complaint but returns the wrong answer, so you have to compare what
# it did against what its comment says it *should* do.
#
# HOW TO USE THIS FILE
#   1. Run this script. `run_tests()` (called at the bottom) will report
#      PASS, FAIL, or ERROR for each function.
#   2. For an ERROR: read the exception type and message. Where in the
#      function does that kind of error come from? What input causes it?
#   3. For a FAIL: the function ran fine but the result doesn't match
#      what's expected. Re-read the function's comment — what should it
#      compute? — then trace through the logic by hand on a small
#      example.
#   4. Fix the bug WITHOUT changing the function's name, arguments, or
#      what it's supposed to compute. Re-run `run_tests()` until
#      everything PASSes.
#
# You will not need any packages beyond Base Julia.

# =====================================================================
# Part 1: these throw errors
# =====================================================================

# Return a vector containing the mean of each column of matrix A.
function column_means(A)
    n, m = size(A)
    means = zeros(m)
    for j in 1:m+1
        means[j] = sum(A[:, j]) / n
    end
    return means
end

# Recursive factorial: n! = n * (n-1) * ... * 1, with 0! = 1 and 1! = 1.
function factorial_r(n)
    return n * factorial_r(n - 1)
end

# Return the sum of all elements in xs.
function total_sum(xs)
    for x in xs
        total = 0
        total += x
    end
    return total
end

# Classify a spending amount as "low" (< 100), "medium" (100-999),
# or "high" (>= 1000).
function tag_budget(amount)
    threshold_high = "1000"
    if amount >= threshold_high
        return "high"
    elseif amount >= 100
        return "medium"
    else
        return "low"
    end
end

# Return the index of the first negative number in xs,
# or 0 if xs contains no negative numbers.
function first_negative(xs)
    i = 1
    while xs[i] >= 0
        i += 1
    end
    return i
end

# Center each column of data matrix X by subtracting that column's mean.
# `means` has one entry per column of X. Returns a matrix the same
# shape as X.
function normalize_columns(X, means)
    return X .- means
end

# =====================================================================
# Part 2: these run without error, but don't do what the comment says
# =====================================================================

# Compute the arithmetic mean of a list of numbers.
function average(xs)
    return sum(xs) ÷ length(xs)
end

# Sort a vector in place, in ascending order.
function sort_ascending!(xs)
    sort(xs)
    return xs
end

# Return the unique values in xs, preserving the order in which they
# first appear.
function unique_values(xs)
    result = eltype(xs)[]
    for i in 1:length(xs)
        if i == 1 || xs[i] != xs[i-1]
            push!(result, xs[i])
        end
    end
    return result
end

# =====================================================================
# Test harness — do not need to edit below this line
# =====================================================================

function run_tests()
    println("Running tests...\n")

    print(rpad("column_means", 22))
    try
        result = column_means([1.0 2.0; 3.0 4.0; 5.0 6.0])
        expected = [3.0, 4.0]
        println(isapprox(result, expected) ? "PASS" : "FAIL  (got $result, expected $expected)")
    catch e
        println("ERROR  ($(typeof(e)))")
    end

    print(rpad("factorial_r", 22))
    try
        result = factorial_r(5)
        println(result == 120 ? "PASS" : "FAIL  (got $result, expected 120)")
    catch e
        println("ERROR  ($(typeof(e)))")
    end

    print(rpad("total_sum", 22))
    try
        result = total_sum([1, 2, 3, 4])
        println(result == 10 ? "PASS" : "FAIL  (got $result, expected 10)")
    catch e
        println("ERROR  ($(typeof(e)))")
    end

    print(rpad("tag_budget", 22))
    try
        result = tag_budget(500)
        println(result == "medium" ? "PASS" : "FAIL  (got $result, expected \"medium\")")
    catch e
        println("ERROR  ($(typeof(e)))")
    end

    print(rpad("first_negative (a)", 22))
    try
        result = first_negative([1, 2, 3, -4, 5])
        println(result == 4 ? "PASS" : "FAIL  (got $result, expected 4)")
    catch e
        println("ERROR  ($(typeof(e)))")
    end

    print(rpad("first_negative (b)", 22))
    try
        result = first_negative([1, 2, 3])
        println(result == 0 ? "PASS" : "FAIL  (got $result, expected 0)")
    catch e
        println("ERROR  ($(typeof(e)))")
    end

    print(rpad("normalize_columns", 22))
    try
        X = [1.0 10.0; 2.0 20.0; 3.0 30.0; 4.0 40.0]
        result = normalize_columns(X, [2.5, 25.0])
        expected = [-1.5 -15.0; -0.5 -5.0; 0.5 5.0; 1.5 15.0]
        println(isapprox(result, expected) ? "PASS" : "FAIL  (got $result, expected $expected)")
    catch e
        println("ERROR  ($(typeof(e)))")
    end

    print(rpad("average", 22))
    try
        result = average([1, 2, 3, 4])
        println(isapprox(result, 2.5) ? "PASS" : "FAIL  (got $result, expected 2.5)")
    catch e
        println("ERROR  ($(typeof(e)))")
    end

    print(rpad("sort_ascending!", 22))
    try
        data = [3, 1, 4, 1, 5, 9, 2, 6]
        sort_ascending!(data)
        expected = [1, 1, 2, 3, 4, 5, 6, 9]
        println(data == expected ? "PASS" : "FAIL  (data is now $data, expected $expected)")
    catch e
        println("ERROR  ($(typeof(e)))")
    end

    print(rpad("sample_std", 22))
    try
        result = sample_std([2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0])
        expected = 2.13809
        println(isapprox(result, expected; atol=1e-4) ? "PASS" : "FAIL  (got $result, expected $expected)")
    catch e
        println("ERROR  ($(typeof(e)))")
    end

    print(rpad("growth_rate", 22))
    try
        result = growth_rate(110.0, 100.0)
        if result === nothing
            println("FAIL  (function returned `nothing` instead of a number)")
        elseif isapprox(result, 10.0)
            println("PASS")
        else
            println("FAIL  (got $result, expected 10.0)")
        end
    catch e
        println("ERROR  ($(typeof(e)))")
    end

    print(rpad("has_converged", 22))
    try
        result = has_converged(0.1 + 0.2, 0.3, 1e-8)
        println(result == true ? "PASS" : "FAIL  (got $result, expected true)")
    catch e
        println("ERROR  ($(typeof(e)))")
    end

    print(rpad("unique_values", 22))
    try
        result = unique_values([1, 2, 2, 3, 1, 4, 3])
        expected = [1, 2, 3, 4]
        println(result == expected ? "PASS" : "FAIL  (got $result, expected $expected)")
    catch e
        println("ERROR  ($(typeof(e)))")
    end
end

run_tests()
