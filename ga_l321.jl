#Algoritmo Genético para rotulação L(3,2,1)
using Graphs
using Random

include("greedy_l321.jl")

# Parametros do GA
struct GA_Parameters
    popsize::Int
    generations::Int
    elitism::Float64
    selection::Int
    crossover::Float64
    mutation::Float64
end

# População Inicial
function init_population(n::Int, popsize::Int, rng::AbstractRNG)::Vector{Vector{Int}}
    base = collect(1:n)
    pop = Vector{Vector{Int}}(undef, popsize)
    for i in 1:popsize
        pop[i] = shuffle(rng, base)
    end
    return pop
end

# Função de Avaliação
function evaluate!(fitness::Vector{Int}, population::Vector{Vector{Int}}, g::AbstractGraph, distsets)
    for i in eachindex(population)
        _, span = greedy_l321(g, population[i], distsets)  
        fitness[i] = span                        
    end
      
    return nothing 
end                                    

# Função de Seleção (torneio k=2)
function select(fitness::Vector{Int}, rng::AbstractRNG)::Int
    n = length(fitness)           
    a = rand(rng, 1:n)             
    b = rand(rng, 1:n) 

    println("A: ", a)
    println("B: ", b)

    return (fitness[a] <= fitness[b]) ? a : b   

end

# cruzamento (POP)

# mutação (swap por vizinhança)

# elitismo



g = path_graph(8)
println("V = ", nv(g), " | E = ", ne(g))

distsets = precompute_distsets(g)

seed = 1234
rng = MersenneTwister(seed)
println("seed = ", seed)

popsize = 3
population = init_population(nv(g), popsize, rng)

println("popsize = ", length(population))
println("indivíduo[1] = ", population[1])
println("indivíduo[2] = ", population[2])
println("indivíduo[3] = ", population[3])

fitness = fill(typemax(Int), popsize)
evaluate!(fitness, population, g, distsets)

for i in 1:popsize
    println("  i=", i, " | fitness=", fitness[i], " | seq=", population[i])
end

best_idx = argmin(fitness)
println("  best_idx = ", best_idx)
println("  best_fitness = ", fitness[best_idx])
println("  best_seq = ", population[best_idx])

vencedor = select(fitness, rng)

println("Vencedor: ", vencedor)


