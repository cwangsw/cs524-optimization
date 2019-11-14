using JuMP, Gurobi, NamedArrays

m = Model(solver = GurobiSolver(OutputFlag= 0))

#the list of matrix that includes all the possibilities of the pattern
A  = [8 0 2 4 4 0 0
      0 4 1 2 0 2 1
      0 0 1 0 1 1 2]

#the matrix of weight for each pattern that can be fit in each transportation
PW = [240 240 240 240 240 240 240 240
        60 60 60 60 60 60 60 60
        85 85 85 85 85 85 85 85
      150 150 150 150 150 150 150 150
      130 130 130 130 130 130 130 130
        40 40 40 40 40 40 40 40
        35 35 35 35 35 35 35 35]

T = [:t1, :t2, :t3, :t4, :t5, :t6, :t7, :t8]#the list of the transportations
P = [ :p1, :p2, :p3, :p4, :p5, :p6, :p7]#the list of the patterns
wa = NamedArray(PW, (P, T), ("Patterns", "Transportations"))#setting the array as column as patterns, and row as transportations

@variable(m, x[1:7] >= 0, Int)#x is the number of times we use pattern
@variable(m, b[1:8], Bin)#setting the binary decision number for the use of transportations
@variable(m, w[P, T] >= 0, Int)#the use of patterns in each transportation

useT = Dict(zip(T, b))#the use of tranportations
supP = Dict(zip(P, x))#the supply of products
demT = Dict(zip(T,[16, 16, 16, 16, 16, 16, 16, 16]))#each transportation has 16 distinct spaces
demW = Dict(zip(T,[1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000]))#the limitation of tranportation's weight


@constraint(m, A * x .>= [50, 20, 10]) #constraint of the product demand
@constraint(m, [i in P], sum(w[i,j] for j in T) == supP[i]) #constraint of the product supply
@constraint(m, [j in T], sum(w[i,j] for i in P) == useT[j] * demT[j]) # constraint of the pattern numbers
@constraint(m, [j in T], sum(w[i,j] * wa[i,j] for i in P) <= demW[j]) # constraint of the transportation's weight


@objective(m, Min, sum(b))#the object is to get minimized number for using the tranportation

solve(m)

#the plot for the patterns and transportations
println(NamedArray(Int[getvalue(w[i,j]) for i in P, j in T], (P, T), ("Patterns", "Transportations")))
