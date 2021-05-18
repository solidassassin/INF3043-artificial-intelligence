function parse_text(name::String)
    text = readlines(name)
    data = split.(text, r"(?:(?<=[A-Z])\s|(?<=[A-Z]\s\d)\s|\t+)")
    [
        [n[1], parse(Int, i), parse.(Int, split(pa)), parse.(Float32, split(p))]
        for (n, i, pa, p) in data
    ]
end

function solution(data::Vector{Vector{Any}}, cond::String, n::Int)
    f, s = split(strip(cond, ('P', '(', ')')), r"\s?\|\s?")
    fn, tail = .!startswith.((f, s), '¬')
    fe, se = f[end], s[end]
    nodes = Dict(getindex.(data, 1) .=> 1:length(data))

    valid = 0
    total = 0

	for _ in 1:n
        temp = BitArray([])
        weight = 1
        for (n, i, pa, p) in data
            prob = i == 0 ? 
            p[1] :
            p[reverse(getindex.((temp,), pa .+ 1)).chunks[1] + 1]
            if n == se
                weight *= (1 - prob)
                push!(temp, tail)
            else
                push!(temp, rand() <= prob)
            end
        end
        if temp[nodes[fe]] == fn
            valid += weight
        end
        total += weight
    end

    valid / total
end

opts = parse_text(ARGS[1]), ARGS[2], parse(Int, ARGS[3])
solution(opts...) |> println
