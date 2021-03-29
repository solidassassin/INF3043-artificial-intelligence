include("cube.jl")

using .PocketCube

# Initialize cube (solved state)
cube = fill.(1:6, ((2, 2),))
solution_states = []
# Will be treated as node children
moves = (u, f, r, u∘u∘u, f∘f∘f, r∘r∘r)

# Shuffle cube
function scramble(cb, amount)
    for _ = 1:amount
        cb = rand(moves)(cb)
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
    for state = states
        if solved(state)
            return true
        end
        sts = [i(state) for i in moves]
        has_result = dfs(sts, depth - 1)
        if has_result
            pushfirst!(solution_states, state)
            return true
        end
    end
    false
end

"Solution found: $(loop(cube |> u |> r |> f, 3))" |> println
solution_states .|> println
