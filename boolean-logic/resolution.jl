const Term = Vector{String}

function evaluate(exp1::Term, exp2::Term)
    for (a, b) = Iterators.product(exp1, exp2)
        if ('¬' * b == a) || ('¬' * a == b)
            temp = filter(i -> i ∉ [a, b], vcat(exp1, exp2)) |> unique
            if length(temp) != length(unique(strip.(temp, '¬')))
                return Term()
            end
            return temp
        end
    end
    Term()
end

function resolution!(db::Vector{Term})
    len = db |> length
    indexes = collect(2:len)
    for i in indexes
        for j in 1:i
            contender = evaluate(db[i], db[j])
            if !isempty(contender) && !any(db .⊆ (contender,))
                println(join(contender, " ⊻ "), " ", (i, j))
                push!(db, contender)
                push!(indexes, len += 1)
            end
        end
    end
end


statements = [String.(i) for i = split.(readlines("input2.txt"), " ⊻ ")]

resolution!(statements)
#@. println(join(statements, " ⊻ "))

