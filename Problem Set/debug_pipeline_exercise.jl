# debug_pipeline_exercise.jl
#
# ECON 5010 — Debugging Exercise: Print-Statement Debugging
# ------------------------------------------------------------
# The function below computes a single number in five sequential
# steps. It runs to completion without throwing any error — but the
# final answer is wrong. There is exactly one bug, in exactly one step.
#
# Because everything happens inside one function and nothing crashes,
# you can't just read a stack trace to find the problem this time —
# you have to go looking for it. The standard tool for this is the
# humble print statement: insert a `println(...)` (or Julia's `@show`
# macro, which conveniently prints both a variable's name and its
# value, e.g. `@show real_y1`) after each step, rerun, and inspect the
# intermediate values. Ask of each one:
#   - Do the UNITS look right (dollars? a rate? a percentage?)
#   - Do any values that should sum to something specific (like 1)
#     actually do?
#   - Is the ORDER OF MAGNITUDE sensible given the inputs?
#
# Work forward from Step 1. The step where a printed value stops
# matching what its comment says it should be is where the bug lives.
#
# HOW TO USE THIS FILE
#   1. Add print statements after each of the five steps inside
#      weighted_real_growth (edit the function directly).
#   2. Run the script and read what gets printed at each stage.
#   3. Find the first step whose output doesn't match its comment.
#   4. Fix the bug. The check at the bottom will stop complaining once
#      the output is correct.

# ---------------------------------------------------------------
# Data: five firms, revenue in $1,000s (nominal — not yet adjusted
# for inflation), plus each firm's headcount in year 1.
# ---------------------------------------------------------------
firm_names = ["A", "B", "C", "D", "E"]
revenue_y1 = [200.0, 500.0, 80.0, 1000.0, 150.0]   # nominal revenue, year 1
revenue_y2 = [250.0, 520.0, 100.0, 1050.0, 200.0]  # nominal revenue, year 2
employees = [50, 200, 20, 500, 30]                 # headcount, year 1

cpi_y1 = 100.0  # CPI, year 1 (base year, by construction = 100)
cpi_y2 = 110.0  # CPI, year 2 (economy-wide inflation was 10% over the period)

# ---------------------------------------------------------------
# Computes the employee-weighted average REAL (inflation-adjusted)
# revenue growth rate across firms, as a percentage.
#
# "Employee-weighted" means each firm's growth rate counts toward the
# average in proportion to its share of total headcount — a firm with
# 500 employees should move the average much more than one with 20.
# ---------------------------------------------------------------
function weighted_real_growth(revenue_y1, revenue_y2, employees, cpi_y1, cpi_y2)
    # STEP 1: convert nominal revenue to real (inflation-adjusted) dollars,
    # using each year's CPI (a CPI of 100 = the base year's price level)
    real_y1 = revenue_y1 ./ (cpi_y1 / 100)
    real_y2 = revenue_y2 ./ (cpi_y2 / 100)

    # STEP 2: each firm's individual real revenue growth rate
    growth = (real_y2 .- real_y1) ./ real_y1

    # STEP 3: employee-based weights, normalized to sum to 1
    weights = employees ./ sum(revenue_y1)

    # STEP 4: employee-weighted average growth rate across firms
    avg_growth = sum(weights .* growth)

    # STEP 5: express as a percentage, rounded to 2 decimal places
    return round(100 * avg_growth, digits=2)
end

result = weighted_real_growth(revenue_y1, revenue_y2, employees, cpi_y1, cpi_y2)
println("\nFinal result: ", result, "%")

@assert isapprox(result, -2.22; atol=0.01) "Not quite — expected about -2.22%, got $(result)%. Keep tracing through the steps."
println("Correct!")
