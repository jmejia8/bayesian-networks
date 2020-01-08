using RDatasets#, PyPlot
import Random: randperm
using Distributed, SharedArrays
import CSV: write, read
include("nets.jl")
include("structures.jl")
include("discretize.jl")
include("inference.jl")
include("score.jl")

# if nprocs() < Sys.CPU_THREADS - 1
#     addprocs(Sys.CPU_THREADS - 1)
# end


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
    @show MDL(bn)
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


function saveMDL(data; dataname="tmp")
    score_likely = Float64[]
    score_k = Float64[]

    n = length(names(data))

    dags = read("DAGS_$(n).csv")

    for i = dags.dag

        g = genAcyclicNet(i, n)
        if isnothing(g)
            continue
        end

        bn = BayesNet(;data = copy(data), graph = g)
        likely, k = MDL(bn; debug = true)
        println(i, " ", 100i/length(dags.dag), " ",likely, " ", k)
        
        push!(score_likely,  likely)
        push!(score_k, k)
    end

    write("MDL_$(dataname).csv", DataFrame(:likelyhood => Array(score_likely), :k => Array(score_k)))


end

function saveDAGS(nvertices)
    dags = getDAGS(nvertices)
    write("DAGS_$(nvertices).csv", DataFrame(:dag => Array(dags)))
end

function main()
    # iris = dataset("datasets", "iris")
    # data = discret_df(iris; nbins = 10)
    # n_instances = size(data, 1)

    data_tables = [
        "db1/caesarian4.csv",
        "db2/car4.csv",
        "db4/haberman4.csv",
        "db5/hayes-roth4.csv",
        "db6/transfusion4.csv",
        "db8/data-user-model4.csv",
        "db7/BM_10%6.csv",
        # "db3/balance-scale5.csv",
    ]


    for filename = data_tables
        println(filename)

        data_ = read(filename)
        data = discret_df(data_, nbins = 10)

        out_name = replace(filename, "/" => "-")
        saveMDL(data, dataname=out_name)

    end


    # saveMDL(data)
end

main()
