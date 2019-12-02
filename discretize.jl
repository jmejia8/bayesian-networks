using Discretizers

function discret_df(data_; nbins = 10)
    data = copy(data_)
    for name in names(data)

        if typeof(data[1, name]) <: CategoricalString || typeof(data[1, name]) <: String
            data[!,name] = encode(CategoricalDiscretizer(data[!,name]), data[!,name])
            continue
        end
        edges = binedges(DiscretizeUniformWidth(nbins), data[!,name])
        data[!,name] = encode(LinearDiscretizer(edges), data[!,name])
    end
    data
end