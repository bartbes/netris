table.insert(states, "singleplayer")
singleplayer = {}

function singleplayer:load()
	return
end

function singleplayer:activated()
	game:activated()
	localplayer = 1
	activeplayer = 1
	players[1] = player:new(player_name, 0)
	is_server = true
	is_local = true
end

function singleplayer:deactivated()
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

function singleplayer:lineremoved()
	score = score + 100
end

function singleplayer:blockplaced()
	return
end

function singleplayer:blockadded()
	return
end
