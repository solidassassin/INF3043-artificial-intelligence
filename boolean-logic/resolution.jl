const Term = Vector{String}

function resolution(exp1::Term, exp2::Term)
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
    i = 1
    parents = fill((0, 0), length(db))

    while (i += 1) <= length(db)
        for j in 1:i
            contender = resolution(db[i], db[j])
            if contender === nothing
                return parents
            end
            if !isempty(contender) && !any(db .⊆ (contender,))
                push!(db, contender)
                push!(parents, (i, j))
            end
        end
    end
    parents
end

statements = [String.(i) for i = split.(readlines(ARGS[1]), " ⊻ ")]
parents = @time evaluate!(statements)

println.(1:length(parents), " | ", join.(statements, " ⊻ "), " ", parents)

