table.insert(states, "singleplayer")
singleplayer = {}

function singleplayer:load()
	return
end

function singleplayer:activated()
	localplayer = 1
	activeplayer = 1
	players[1] = player:new("LocalPlayer", 0)
end

function singleplayer:update(dt)
	game:update(dt)
end

function singleplayer:draw()
	game:draw()
end

function singleplayer:keypressed(key)
	game:keypressed(key)
end

function singleplayer:keyreleased(key)
	game:keyreleased(key)
end

function singleplayer:mousepressed()
	return
end

function singleplayer:mousereleased()
	return
end
