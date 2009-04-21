color = class:new()

color.r = 255
color.g = 255
color.b = 255
color.name = "white"

function color:init(name, r, g, b)
	self.name = name or self.name
	self.r = r or self.r
	self.g = g or self.g
	self.b = b or self.b
end

colors = {}
colors.white = 		color:new("white", 	255, 255, 255)
colors.red = 		color:new("red", 	255, 000, 000)
colors.yellow = 	color:new("yellow", 	255, 255, 000)
colors.magenta = 	color:new("magenta", 	255, 000, 255)
colors.blue = 		color:new("blue", 	000, 000, 255)
colors.cyan =		color:new("cyan",	100, 100, 255)
colors.green =		color:new("green",	000, 255, 000)
colors.orange =		color:new("orange",	255, 100, 100)
