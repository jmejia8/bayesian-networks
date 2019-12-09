using RDatasets
import Random: randperm
include("nets.jl")
include("structures.jl")
include("discretize.jl")
include("inference.jl")


function classification()
    iris = dataset("datasets", "iris")
    data = discret_df(iris; nbins = 10)
    n_instances = size(data, 1)

    I = randperm(n_instances)

    n_train = round(Int, 0.5*n_instances)

    data_train = data[I[1:n_train],:]
    data_test = data[I[n_train+1:end],:]

    g = getNet(3, data_train)

    bn = BayesNet(;data = data_train, graph = g, class = :Species)

    C = collect(Set(bn.data[:, bn.class]))

    s = 0
    for i = 1:size(data_test, 1)
        x = collect(data_test[i, 1:end-1])
        L = map( c -> P_post(c, x, bn), C )
        c = argmax(L)
        if C[c] == data_test[i, end]
            s += 1
        else
            # println( c, "  >>>>  ",  data_test[i, end])
        end
    end

    accuracy = s / size(data_test, 1)
    # println(accuracy)
    accuracy



end

@time classification()

