piece = class:new()

piece.blockpositions = {}
piece.numblocks = 0
piece.color = "white"

function piece:init(blockpositions, numblocks, color)
	self.blockpositions = blockpositions or self.blockpositions
	self.numblocks = numblocks or self.numblocks
	self.color = color or self.color
end

function piece:create(blocks, gx, gy, status)
	for i = 1, self.numblocks do
		local x = self.blockpositions[i*2-1]
		local y = self.blockpositions[i*2]
		local color = colors[self.color]
		table.insert(blocks, block:new(color.r, color.g, color.b, x+gx-1, y+gy-1, status))
	end
end

function piece:rotate(blocks, active, rotation)
	local x = blocks[active[2]].x
	local y = blocks[active[2]].y
	local positions = {}
	positions[active[2]] = { x = x, y = y }
	if rotation == 90 then
		positions[active[1]] = { x = x + self.blockpositions[2]-self.blockpositions[4], y = y + self.blockpositions[1]-self.blockpositions[3] }
		positions[active[3]] = { x = x + self.blockpositions[6]-self.blockpositions[4], y = y + self.blockpositions[5]-self.blockpositions[3] }
		positions[active[4]] = { x = x + self.blockpositions[8]-self.blockpositions[4], y = y + self.blockpositions[7]-self.blockpositions[3] }
	elseif rotation == 180 then
		positions[active[1]] = { x = x + self.blockpositions[3]-self.blockpositions[1], y = y + self.blockpositions[4]-self.blockpositions[2] }
		positions[active[3]] = { x = x + self.blockpositions[3]-self.blockpositions[5], y = y + self.blockpositions[4]-self.blockpositions[6] }
		positions[active[4]] = { x = x + self.blockpositions[3]-self.blockpositions[7], y = y + self.blockpositions[4]-self.blockpositions[8] }
	elseif rotation == 270 then
		positions[active[1]] = { x = x + self.blockpositions[4]-self.blockpositions[2], y = y + self.blockpositions[3]-self.blockpositions[1] }
		positions[active[3]] = { x = x + self.blockpositions[4]-self.blockpositions[6], y = y + self.blockpositions[3]-self.blockpositions[5] }
		positions[active[4]] = { x = x + self.blockpositions[4]-self.blockpositions[8], y = y + self.blockpositions[3]-self.blockpositions[7] }
	else
		positions[active[1]] = { x = x + self.blockpositions[1]-self.blockpositions[3], y = y + self.blockpositions[2]-self.blockpositions[4] }
		positions[active[3]] = { x = x + self.blockpositions[5]-self.blockpositions[3], y = y + self.blockpositions[6]-self.blockpositions[4] }
		positions[active[4]] = { x = x + self.blockpositions[7]-self.blockpositions[3], y = y + self.blockpositions[8]-self.blockpositions[4] }
	end
	return positions
end

pieces = {}
pieces.I = piece:new({1, 1, 2, 1, 3, 1, 4, 1}, 4, "red")
pieces.J = piece:new({1, 1, 2, 1, 3, 1, 3, 2}, 4, "yellow")
pieces.L = piece:new({1, 1, 1, 2, 2, 1, 3, 1}, 4, "magenta")
pieces.O = piece:new({1, 1, 2, 1, 1, 2, 2, 2}, 4, "blue")
pieces.S = piece:new({1, 2, 2, 1, 2, 2, 3, 1}, 4, "cyan")
pieces.T = piece:new({1, 1, 2, 1, 2, 2, 3, 1}, 4, "green")
pieces.Z = piece:new({1, 1, 2, 1, 2, 2, 3, 2}, 4, "orange")

function pieces.J:rotate(blocks, active, rotation)
	local x = blocks[active[2]].x
	local y = blocks[active[2]].y
	local positions = {}
	positions[active[2]] = { x = x, y = y }
	if rotation == 90 then
		positions[active[1]] = { x = x, y = y - 1 }
		positions[active[3]] = { x = x, y = y + 1 }
		positions[active[4]] = { x = x - 1, y = y + 1 }
	elseif rotation == 180 then
		positions[active[1]] = { x = x + 1, y = y }
		positions[active[3]] = { x = x - 1, y = y }
		positions[active[4]] = { x = x - 1, y = y - 1 }
	elseif rotation == 270 then
		positions[active[1]] = { x = x, y = y + 1 }
		positions[active[3]] = { x = x, y = y - 1 }
		positions[active[4]] = { x = x + 1, y = y - 1 }
	else
		positions[active[1]] = { x = x - 1, y = y }
		positions[active[3]] = { x = x + 1, y = y }
		positions[active[4]] = { x = x - 1, y = y - 1 }
	end
	return positions
end

function pieces.L:rotate(blocks, active, rotation)
	local x = blocks[active[2]].x
	local y = blocks[active[2]].y
	local positions = {}
	positions[active[2]] = { x = x, y = y }
	if rotation == 90 then
		positions[active[1]] = { x = x, y = y - 1 }
		positions[active[3]] = { x = x, y = y + 1 }
		positions[active[4]] = { x = x + 1, y = y + 1 }
	elseif rotation == 180 then
		positions[active[1]] = { x = x + 1, y = y }
		positions[active[3]] = { x = x - 1, y = y }
		positions[active[4]] = { x = x + 1, y = y - 1 }
	elseif rotation == 270 then
		positions[active[1]] = { x = x, y = y + 1 }
		positions[active[3]] = { x = x, y = y - 1 }
		positions[active[4]] = { x = x - 1, y = y - 1 }
	else
		positions[active[1]] = { x = x - 1, y = y }
		positions[active[3]] = { x = x + 1, y = y }
		positions[active[4]] = { x = x + 1, y = y + 1 }
	end
	return positions
end

function pieces.S:rotate(blocks, active, rotation)
	local x = blocks[active[2]].x
	local y = blocks[active[2]].y
	local positions = {}
	positions[active[2]] = { x = x, y = y }
	if rotation == 90 then
		positions[active[1]] = { x = x, y = y - 1 }
		positions[active[3]] = { x = x + 1, y = y }
		positions[active[4]] = { x = x + 1, y = y + 1 }
	elseif rotation == 180 then
		positions[active[1]] = { x = x + 1, y = y }
		positions[active[3]] = { x = x, y = y + 1 }
		positions[active[4]] = { x = x - 1, y = y + 1 }
	elseif rotation == 270 then
		positions[active[1]] = { x = x, y = y + 1 }
		positions[active[3]] = { x = x - 1, y = y }
		positions[active[4]] = { x = x - 1, y = y - 1 }
	else
		positions[active[1]] = { x = x - 1, y = y }
		positions[active[3]] = { x = x, y = y - 1 }
		positions[active[4]] = { x = x + 1, y = y - 1 }
	end
	return positions
end


function pieces.Z:rotate(blocks, active, rotation)
	local x = blocks[active[2]].x
	local y = blocks[active[2]].y
	local positions = {}
	positions[active[2]] = { x = x, y = y }
	if rotation == 90 then
		positions[active[1]] = { x = x, y = y - 1 }
		positions[active[3]] = { x = x - 1, y = y }
		positions[active[4]] = { x = x - 1, y = y + 1 }
	elseif rotation == 180 then
		positions[active[1]] = { x = x + 1, y = y }
		positions[active[3]] = { x = x, y = y - 1 }
		positions[active[4]] = { x = x - 1, y = y - 1 }
	elseif rotation == 270 then
		positions[active[1]] = { x = x, y = y + 1 }
		positions[active[3]] = { x = x + 1, y = y }
		positions[active[4]] = { x = x + 1, y = y - 1 }
	else
		positions[active[1]] = { x = x - 1, y = y }
		positions[active[3]] = { x = x, y = y + 1 }
		positions[active[4]] = { x = x + 1, y = y + 1 }
	end
	return positions
end

pieceindexes = { "I", "J", "L", "O", "S", "T", "Z" }
