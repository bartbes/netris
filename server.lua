table.insert(states, "server")
server = {}

function server:load()
end

function server:activated()
	startserver()
	localplayer = 1
	activeplayer = 1
	players[1] = player:new("LocalPlayer", 0)
end

function server:deactived()
	disconnect()
end

function server:update(dt)
	updateconn(dt)
	game:update(dt)
end

function server:draw()
	game:draw()
end

function server:keypressed(key)
	game:keypressed(key)
end

function server:keyreleased(key)
	game:keyreleased(key)
end

function server:mousepressed()
	return
end

function server:mousereleased()
	return
end

