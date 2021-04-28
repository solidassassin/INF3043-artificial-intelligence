using BenchmarkTools

const Term = Vector{String}

@inline function resolution(exp1::Term, exp2::Term)
    for (a, b) = Iterators.product(exp1, exp2)
        if ('¬' * b == a) || ('¬' * a == b)
            temp = filter(i -> i ∉ [a, b], vcat(exp1, exp2)) |> unique
            if length(temp) != length(unique(lstrip.(temp, '¬')))
                return Term()
            end
            return isempty(temp) ? nothing : temp
        end
    end
    Term()
end

function evaluate!(db::Vector{Term})
    len = db |> length
    indexes = collect(2:len)
    for i in indexes
        for j in 1:i
            @inbounds contender = resolution(db[i], db[j])
            if contender === nothing
                return
            end
            if !isempty(contender) && !any(db .⊆ (contender,))
                println(join(contender, " ⊻ "), " ", (i, j))
                push!(db, contender)
                push!(indexes, len += 1)
            end
        end
    end
end


statements = [String.(i) for i = split.(readlines("input2.txt"), " ⊻ ")]

@btime evaluate!(statements)

