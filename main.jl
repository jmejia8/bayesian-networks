using RDatasets
import Random: randperm
include("discretize.jl")
include("nets.jl")
include("inference.jl")


function classification()
    iris = dataset("datasets", "iris")
    data = discret_df(iris)
    n_instances = size(data, 1)

    I = randperm(n_instances)

    n_train = round(Int, 0.6*n_instances)

    data_train = data[I[1:n_train],:]
    data_test = data[I[n_train+1:end],:]

    nams = names(iris)

    g = getNet(2, data_train)

    C = collect(Set(data[:, :Species]))
    display(C)

    s = 0
    for i = 1:size(data_test, 1)
        x = collect(data_test[i, 1:end-1])
        L = map( c -> P_post(c, x, g, data_train), C )
        c = argmax(L)
        if C[c] == data_test[i, end]
            s += 1
        else
            println( c, "  >>>>  ",  data_test[i, end])
        end
    end

    println(s / size(data_test, 1))



end

@time classification()

