using RDatasets

include("dicretize.jl")
include("nets.jl")
include("inference.jl")


function classification()
    iris = dataset("datasets", "iris")
    data = discret_df(iris)

    nams = names(iris)

    g = getNet(1, data)

    C = [1,2,3]

    s = 0
    for i = 1:size(data, 1)
        x = collect(data[i, 1:end-1])
        L = map( c -> P_post(c, x, g, data), C )
        c = argmax(L)
        if c == data[i, end]
            s += 1
        else
            println( c, "  >>>>  ",  data[i, end])
        end
    end

    println(s / size(data, 1))



end

classification()

