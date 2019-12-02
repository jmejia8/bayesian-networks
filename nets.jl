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

        for i = 1:length(nams)
            add_edge!(g, i, length(nams))
        end

    elseif id ==3

        for i = 1:length(nams)
            add_edge!(g, length(nams), i)
        end

    elseif id ==4
        for i = 1:length(nams)
            add_edge!(g, i+1, i)
        end
    end

    g
end