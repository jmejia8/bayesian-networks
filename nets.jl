using LightGraphs
# import TikzGraphs

function getNet(id, data)
    nams = names(data)
    g  = SimpleDiGraph(length(nams))


    if id == 1        
        for i = 1:div(length(nams), 2)
            add_edge!(g, i, length(nams))
            add_edge!(g, length(nams)-i, i)
        end

    elseif id ==2

        for i = 1:length(nams)-1
            add_edge!(g, i, length(nams))
        end

    elseif id ==3

        for i = 1:length(nams)-1
            add_edge!(g, length(nams), i)
        end

    elseif id ==4
        for i = 1:length(nams)
            add_edge!(g, i+1, i)
        end
    end

    g
end

function genAcyclicNet(i, nvertices; debug=false)
    x = parse.(Int, collect(bitstring(i)), base=10)
    n =  nvertices^2 -1

    # @show x

    @assert 0 < i < 2^(n+1)

    A = reshape(x[end-n:end], nvertices, nvertices)

    for k = 1:nvertices
        if A[k,k] != 0
            debug && @warn "Cyclic graph"
            return nothing
        end
    end

    g = SimpleDiGraph(A)

    if is_cyclic(g)
        debug && @warn "Cyclic graph"
        return nothing
    end
    return g
end

# for i = 1:30
#     if !isnothing(genAcyclicNet(i, 5))
#         println(i)
#     end
# end

