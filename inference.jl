function P(A, B, dataset) # = P(A | B; dataset)
    PB = size(dataset, 1)
    if !isempty(B)
        PB  = size(filter( row -> sum(map(b -> row[b[1]] == b[2], B)) == length(B), dataset ), 1)
    end
    C = B
    
    push!(C, A)
    df = filter( row -> sum(map(c -> row[c[1]] == c[2], C)) == length(C), dataset )
    PC  = size(df, 1)

    if PB == 0
        return 0.0
    end
    
    PC / PB
end

function P(x, G::SimpleDiGraph, data) # = P(A | B; dataset)
    nms = names(data)
    p  = 1
    for v in vertices(G) 
        n = neighbors(G, v)
        A = (nms[v] => x[v])
        B = map( i -> (nms[i] => x[i]), n )
        
        p *= P(A, B, data)
    end
    p
end

function P_post(c, x, G::SimpleDiGraph, data)
    y = vcat(x, c)
    return P(y, G, data)
end

