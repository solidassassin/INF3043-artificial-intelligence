include("cube.jl")

using .PocketCube

# Initialize cube (solved state)
cube = fill.(1:6, ((2, 2),))
solution_states = Array{String,1}()
# Will be treated as node children
moves = (u, f, r, u ∘ u ∘ u, f ∘ f ∘ f, r ∘ r ∘ r)
names = ("u", "f", "r", "up", "fp", "rp")

# Shuffle cube
function scramble(cb, amount)
    for _ = 1:amount
        cb = rand(moves)(cb)
        println(cb)
    end
    cb
end

function loop(root, max_depth)
    if solved(root)
        return true
    end
    for i = 1:max_depth
        found = dfs([x(root) for x = moves], i)
        if found
            return true
        end
    end
end

function dfs(states, depth)
    if depth == 0
        return false
    end
    for (state, name) = zip(states, names)
        if solved(state)
            return true
        end
        sts = [i(state) for i in moves]
        has_result = dfs(sts, depth - 1)
        if has_result
            pushfirst!(solution_states, "$name $state")
            return true
        end
    end
    false
end

"Solution found: $(loop(scramble(cube, 4), 4))" |> println
solution_states .|> println
