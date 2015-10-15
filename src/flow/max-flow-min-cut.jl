"""Computes the maximum flow between the source and target vertices in a flow
graph using Edmong Karp's algorithm. Returns the value of the maximum flow as
well as a matrix containing the flows in all links.
"""

function maximum_flow{T<:Number}(
    flow_graph::LightGraphs.DiGraph,       # the input graph
    source::Int,                           # the source vertex
    target::Int,                           # the target vertex
    capacity_matrix::AbstractArray{T,2}    # edge flow capacities
    )
    n = size(flow_graph)[1]
    flow = 0
    flow_matrix = zeros(T,n,n)

    while true
        m, P = fetch_path(flow_graph,source,target,flow_matrix,capacity_matrix)
        if m == 0
            break
        else
            flow += m
            v = target
            while v != source
                u = P[v]
                flow_matrix[u,v] += m
                flow_matrix[v,u] -= m
                v = u
            end
        end
    end

    return (flow,flow_matrix)
end

"""Uses BFS to look for augmentable-paths. Returns the capacity of the path found
and the parent table(trace of the path)"""

function fetch_path{T<:Number}(
    flow_graph::LightGraphs.DiGraph,       # the input graph
    source::Int,                           # the source vertex
    target::Int,                           # the target vertex
    flow_matrix::AbstractArray{T,2},       # the current flow matrix
    capacity_matrix::AbstractArray{T,2}    # edge flow capacities
    )
    n = size(flow_graph)[1]
    M = Array(T,n)                         # capacity of path traced
    M[source] = typemax(T)
    P = [-1 for u in 1:n]                  # Parent table to trace the path
    P[source] = -2

    Q = Set{Int}()
    push!(Q,source)

    while length(Q) > 0
        u = pop!(Q)
        for v in fadj(flow_graph,u)
            if capacity_matrix[u,v] - flow_matrix[u,v] > 0 && P[v] == -1
                P[v] = u
                M[v] = min(M[u], capacity_matrix[u,v] - flow_matrix[u,v])
                if v != target
                    push!(Q,v)
                else
                    return M[target], P
                end
            end
        end
    end

    return 0,P
end
