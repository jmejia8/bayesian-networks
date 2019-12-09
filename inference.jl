function P(A, B, dataset) # = P(A | B; dataset)
    PB = size(dataset, 1)
    if !isempty(B)
        len_B = length(B)
        PB  = size(filter( row -> count(map(b -> row[b[1]] == b[2], B)) == len_B, dataset ), 1)
    end
    C = B
    
    push!(C, A)
    len_C = length(C)
    PC  = size(filter( row -> count(map(c -> row[c[1]] == c[2], C)) == len_C, dataset ), 1)

    if PB == 0
        return 0.0
    end
    
    PC / PB
end

function P(x, BN) # = P(A | B; dataset)
    nms = names(BN.data)
    G = BN.graphInverted
    p  = 1
    for v in vertices(G) 
        n = neighbors(G, v)
        A = (nms[v] => x[v])
        B = map( i -> (nms[i] => x[i]), n )
        
        p *= P(A, B, BN.data)
    end
    p
end

function P_post(c, x, BN) #(c, x, G::SimpleDiGraph, data)
    y = vcat(x, c)
    return P(y, BN)
end

