"""Computes the maximum flow between the source and target vertices in a flow
graph using Edmong Karp's algorithm. Returns the value of the maximum flow as
well as a matrix containing the flows in all links.
"""

function maximum_flow{T<:Number}(
    flow_graph::LightGraphs.DiGraph,# the input graph
    source::Int,# the source vertex
    target::Int,# the target vertex
    flow_matrix::AbstractArray{T,2}# edge flow capacity
    )
    n = size(flow_graph)[1]
    f = 0
    F = zeros(n,n)

    return (f,F)
end
