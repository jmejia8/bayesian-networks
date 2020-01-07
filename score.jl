function MDL(BN_model)
    fLogScore = 0.0

    for i = 1:size(BN_model.data, 1)
        x = collect(BN_model.data[i, 1:end])
        p = P(x, BN_model)
        fLogScore -= log(p)
    end


    for v in vertices(BN_model.graphInverted)

        n = neighbors(BN_model.graphInverted, v)
        m = BN_model.attributeNumValues[v] - 1
        fLogScore += 0.5 * length(n) * m * log(size(BN_model.data, 2))
    end

    fLogScore
end