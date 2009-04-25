player = class:new()

player.name = "NoName"
player.score = 0

function player:init(name, score)
	name = name or self.name
	score = score or self.score
	self.name = self.name
	self.score = self.score
end

function player:setName(n)
	self.name = n
end

function player:addScore(s)
	self.score = self.score + s
end

