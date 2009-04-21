block = class:new()

block.red = 255
block.green = 255
block.blue = 255
block.x = 0
block.y = 0
block.resting = false
block.active = false

function block:init(r, g, b, x, y, active)
	self.red = r or self.red
	self.green = g or self.green
	self.blue = b or self.blue
	self.x = x or self.x
	self.y = y or self.y
	self.active = active or self.active
end

function block:draw()
	love.graphics.setColor(self.red, self.green, self.blue)
	love.graphics.rectangle(love.draw_fill, (self.x*50)-30, (self.y*50)-30, 50, 50)
end

