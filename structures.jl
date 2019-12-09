mutable struct BayesNet
	data::DataFrame
	attributes::Vector{Symbol}
	class::Symbol
	graph::SimpleDiGraph{Int}
	graphInverted::SimpleDiGraph{Int}
end

function BayesNet(;data=DataFrame(), graph=SimpleDiGraph(), class=:Class)
	attributes = names(data)
	cs = data[:, class]
	df = DataFrame( class => cs )
	select!(data, Not(class))
	data = hcat( data, df )
	deleteat!(attributes, findfirst(isequal(class), attributes))
	BayesNet(data, attributes, class, graph, reverse(graph))
end

# iris = dataset("datasets", "iris")

# BayesNet(iris, :SepalWidth)
