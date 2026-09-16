println("hello world!")

####Variable 
#different types
x = 2
y = 4.0
z = "foo"
typeof(x)
typeof(y)
typeof(z)

#basic operations
x*y
x^2
x+y

#=

everything inside this hash-equals
area is now a comment and will not be run.

=#

###Arrays and vectors 
#horizontal and vertical vectors 
vec_vert = [1, 1.0, "foo"]
vec_vert[2]

vec_vert_2 = [1,1,1,1,1]
vec_ones = ones(50)

vec_horiz = [1 1.0 "foo"]

#simple matrix
array = [1 1.0; "foo" "bar"]
array[1, 2]


#tuples
tuple_example = ("foo", "bar", 1)
tuple_example[3]

###ranges, fancier indexing
range_100 = collect(1:1.5:100)
range_100_2 = collect(range(1, length=99, stop=100))

###for loops
for i in range_100
    println(i)
end

for i = 1:100
    println(i)
end

##while loop 
val = 1.0
tol = 0.002
while val > tol
    global val 
    #val = val/2
    val /=2
end
val

######Conditionals
x = 1
x == 1
x==2

x==1 && x==2
x == 1 || x == 2
x!=2

####writing a function in Julia 
function foo(x; a=2)
    y = x^2 * a 
    return y
end

####reading in functions from a different file.
####works the best if files are in same directory
include("function_storage.jl")




f(x) = x^2
f(4)

#broadcasting
x = collect(1:1:100)
x.+=1
y = log.(x)



####structs. Take your time here -- this one is important!
struct Point 
    x::Float64
    y::Float64
end

p = Point(1.0, 2.0)
p.x 
p.y 
p.x + p.y


function struct_func(thingy::Point)
    return thingy.x + thingy.y
end

struct_func(p)


using Parameters
@with_kw struct point_2
    x::Float64 = 1.0
    y::Float64 = 2.0
end

q1 = point_2()
q1.x 

q2 = point_2(x = 3.0)
q2.x
q2.y

######Example 1: White Noise. Show off plotting here.
using Plots, Distributions

dist = Normal(0,1)
n = 1000
ϵ = rand(d, n)
plot(1:n, ϵ)
histogram(ϵ)


#######Example 2: OLS
β_0 = 1.0
β_1 = 2.0
β_2 = 3.0
n = 10000
x = rand(n).*10
x2 = x.^2
ϵ = rand(dist, n)
Y = β_0 .+ β_1.*x + β_2.*x2 .+ ϵ
X = hcat(ones(n), x, x2)
β_ols = inv(X' * X) * X' * Y



























































































#######
temp1 = foo(5; a = 3)

#########