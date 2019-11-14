using JuMP, Gurobi

#the list of matrix that includes all the possibilities of the pattern
A = [ 8 0 2 4 4 0 0
      0 4 1 2 0 2 1
      0 0 1 0 1 1 2]


function solver(d1, d2, d3)
    m = Model(solver = GurobiSolver(OutputFlag = 0))
    @variable(m, x[1:7] >= 0, Int) #x is the number of times we use pattern

    @constraint(m, A*x .>= [d1;d2;d3]) #make sure that the overall products satisfies the demand

    @objective(m, Min, sum(x)) #get the least number of pattern that should be used

    solve(m)

    return(getvalue(A*x), getvalue(x), getvalue(sum(x)))
end

println("the sum of products each pattern to be used, and usage of space pattern: ", solver(100, 75, 50))
println("the sum of products each pattern to be used, and usage of space pattern: ", solver(75, 50, 25))
println("the sum of products each pattern to be used, and usage of space pattern: ", solver(50, 20, 10))
println("the sum of products each pattern to be used, and usage of space pattern: ", solver(20, 10, 5))
println("the sum of products each pattern to be used, and usage of space pattern: ", solver(10, 5, 2))
