module PocketCube

export Cube, solved, u, f, r

const Cube = Array{Array{Int,2},1}

xf = (2, :, 1, :)
yf = (:, 1, :, 2)

function u(cc::Cube)::Cube
	c = deepcopy(cc)

	c[1] = rotr90(c[1])

	temp = getindex.(circshift(c[2:end - 1], -1), 1, :)
	setindex!.(c[2:end - 1], temp, 1, :)
	c
end

function f(cc::Cube)::Cube
	c = deepcopy(cc)
	walls = [c[1], c[3], c[6], c[5]]
	temp = getindex.(circshift(rotr90.(walls), 1), xf, yf)

	c[2] = rotr90(c[2])
	setindex!.(walls, temp, xf, yf)
	c
end

function r(cc::Cube)::Cube
    c = deepcopy(cc)

    c[3] = rotr90(c[3])

    c[1][:, 2], c[4][:, 1], c[6][:, 2], c[2][:, 2] = 
	c[2][:, 2], rot180(c[1])[:, 1], rot180(c[4])[:, 2], c[6][:, 2]
	c
end

function solved(c::Cube)::Bool
	all(all(x -> i[1, 1] == x, i) for i = c)
end

end
