function MDL(BN_model; debug = false)
    a = 0.0

    for i = 1:size(BN_model.data, 1)
        x = collect(BN_model.data[i, 1:end])
        p = P(x, BN_model)
        a -= log(p)
    end

    b = 0

    for v in vertices(BN_model.graphInverted)

        n = neighbors(BN_model.graphInverted, v)
        m = BN_model.attributeNumValues[v] - 1
        b +=  length(n) * m 
    end


    if debug
        return a, b
    end

    a + 0.5 * b * log(size(BN_model.data, 2))
end