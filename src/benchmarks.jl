# Provides benchmarks for specific functions, allowing comparisons between
# versions.

type BMTest
    desc::AbstractString
    init::Function
    fn::Function
    args::Tuple
end


type Benchmark
    dt::DateTime
    index::Integer
    desc::AbstractString
    timeelapsed::Float64
    bytesalloc::Int64
    timegc::Float64
end

==(b1::Benchmark, b2::Benchmark) =
  b1.dt == b2.dt &&
  b1.index == b2.index &&
  b1.desc == b2.desc &&
  b1.timeelapsed == b2.timeelapsed &&
  b1.bytesalloc == b2.bytesalloc &&
  b1.timegc == b2.timegc
  
Benchmark(
    a::AbstractString, b::AbstractString,
    c::AbstractString, d::AbstractString,
    e::AbstractString, f::AbstractString
) = Benchmark(
    DateTime(a), parse(Int, b),
    c, parse(Float64, d),
    parse(Int64, e), parse(Float64, f)
)


function read_benchmarks(
    fn::AbstractString=joinpath(Pkg.dir("LightGraphs"),"testdata","benchmarks.csv")
)
    bms = Vector{Benchmark}()
    f = open(fn,"r")
    for l in eachline(f)
        v = split(l,",")
        push!(bms, Benchmark(v...))
    end
    close(f)
    return bms
end

function write_benchmarks(
    fn::AbstractString=joinpath(Pkg.dir("LightGraphs"),"testdata","benchmarks.csv"),
    bms :: Vector{Benchmark} = []
)
    f = open(fn,"w")
    for bm in bms
        bmv = []
        push!(bmv, string(bm.dt))
        push!(bmv, string(bm.index))
        push!(bmv, string(bm.desc))
        push!(bmv, string(bm.timeelapsed))
        push!(bmv, string(bm.bytesalloc))
        push!(bmv, string(bm.timegc))

        write(f,join(bmv, ","))
    end
    close(f)
    return length(bms)
end

function run_benchmarks(indices::Vector{Int}, tests::Vector{BMTest}=benchmarks)
    bms = Vector{Benchmark}()
    for i in indices

        test = tests[i]
        info("running benchmark $i: $(test.desc)")
        _ = test.init(test.args...)
        results = Vector{String}()
        push!(results, string(now()))
        push!(results, string(i))
        push!(results, test.desc)
        z = time1(test.fn, test.args)
        push!(results, z...)


        bm = Benchmark(results...)
        push!(bms, bm)
        info("results: $results")
    end
    return bms
end

run_benchmarks(i::Int, tests::Vector{BMTest}=benchmarks) = run_benchmarks([i;], tests)
run_benchmarks(tests::Vector{BMTest}=benchmarks) = run_benchmarks([1:length(tests);], tests)

function time1(f::Function, args...)
    z = @timed f(args...)
    r = Vector{String}()
    for i = 2:4
        push!(r, string(z[i]))
    end

    return r
end

function timen(n::Integer, s::Symbol, args...)
    elapsed = Float64[]
    mem = Int[]
    gc = Float64[]
    for i = 1:n
        (e, m, g) = time1(eval(s), args...)
        push!(elapsed, e)
        push!(mem, m)
        push!(gc, g/e)
    end
    return s, n, mean(elapsed), floor(Int,mean(mem)), mean(gc)
end


benchmarks = Vector{BMTest}()

function bm_astar_init(a...)
    g = Graph(10,2)
    z = a_star(g,1,4)
end

function bm_astar(a...)
    g = readgraph(Pkg.dir("LightGraphs","test","testdata", "pgp2.jgz"))
    z = a_star(g,3,5845)
end


function bm_dijkstra_shortest_paths_init(a...)
    g = Graph(10,2)
    z = dijkstra_shortest_paths(g,2)
end

function bm_dijkstra_shortest_paths(a...)
    g = readgraph(Pkg.dir("LightGraphs","test","testdata", "pgp2.jgz"))
    z = dijkstra_shortest_paths(g,5845)
end

function bm_betweenness_centrality_init(a...)
    g = Graph(10,2)
    z = betweenness_centrality(g)
end

function bm_betweenness_centrality(a...)
    g = readgraph(Pkg.dir("LightGraphs","test","testdata", "pgp2.jgz"))
    z = betweenness_centrality(g)
end

push!(benchmarks, BMTest("A*", bm_astar_init, bm_astar, ()))
push!(benchmarks, BMTest("dijkstra_shortest_paths",
    bm_dijkstra_shortest_paths_init,
    bm_dijkstra_shortest_paths,
    ())
)

push!(benchmarks, BMTest("betweenness_centrality",
    bm_betweenness_centrality_init,
    bm_betweenness_centrality,
    ())
)

export benchmarks
