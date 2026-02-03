using Graphs

# Função que lê um arquivo no formato edge-list (u v por linha), já normalizado
function read_simple_graph(filename::String)::SimpleGraph
    edges = Tuple{Int,Int}[] # Cria um vetor vazio, guarda as arestas como pares (u,v)
    vertices = Set{Int}() # Guarda valores únicos (ids dos vertices)

    for line in eachline(filename) # Lê o arquivo linha por linha
        s = strip(line) # Limpa espaços
        isempty(s) && continue # Ignora linha vazia

        # Se não tiver exatamente 2 números, apresenta o erro
        parts = split(s)
        length(parts) == 2 || error("Linha inválida no edge-list: '$s'")

        u = parse(Int, parts[1])
        v = parse(Int, parts[2])

        # Guarda arestas e coleta ids para remapeamento 1..n
        push!(edges, (u, v))
        push!(vertices, u, v)
    end

    isempty(edges) && error("Arquivo sem arestas válidas: $filename")

    # Graphs.jl usa vértices 1..n; cria-se um mapa id_original -> id_reindexado
    vertex_map = Dict{Int,Int}()
    for (i, v) in enumerate(sort!(collect(vertices)))
        vertex_map[v] = i
    end

    g = SimpleGraph(length(vertices))
    for (u, v) in edges
        uu = vertex_map[u]
        vv = vertex_map[v]
        uu != vv && add_edge!(g, uu, vv)  # ignora laço se existir
    end

    return g
end

# ----- Main -----

include("greedy_l321.jl")

instance = "data/CUBIC/cubic_100.txt"

# Carrega o grafo
g = read_simple_graph(instance)
println("Instância: ", instance)
println("v = ", nv(g), "  e = ", ne(g))

# Pré-cálculo das vizinhanças a distância 1,2,3 (uma vez por grafo)
distsets = precompute_distsets(g)

# Define a ordem dentro do main, grau decrescente
degs = degree(g)
sequence = sortperm(1:nv(g); by = v -> degs[v], rev = true)

# Executa o guloso L(3,2,1)
t0 = time()
labels, span = greedy_l321(g, sequence, distsets)
elapsed = time() - t0

println("Span = ", span)
println("tempo(s) = ", elapsed)