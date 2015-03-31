# Provides benchmarks for specific functions, allowing comparisons between
# versions.

function time1(f::Function, args...)
    z = @timed f(args...)
    return z[2:end]
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
