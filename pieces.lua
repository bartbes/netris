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

pieces = {}
pieces.I = piece:new({1, 1, 2, 1, 3, 1, 4, 1}, 4, "red")
pieces.J = piece:new({1, 1, 2, 1, 3, 1, 3, 2}, 4, "yellow")
pieces.L = piece:new({1, 1, 1, 2, 2, 1, 3, 1}, 4, "magenta")
pieces.O = piece:new({1, 1, 2, 1, 1, 2, 2, 2}, 4, "blue")
pieces.S = piece:new({1, 2, 2, 1, 2, 2, 3, 1}, 4, "cyan")
pieces.T = piece:new({1, 1, 2, 1, 2, 2, 3, 1}, 4, "green")
pieces.Z = piece:new({1, 1, 2, 1, 2, 2, 3, 2}, 4, "orange")

pieceindexes = { "I", "J", "L", "O", "S", "T", "Z" }
