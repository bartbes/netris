table.insert(states, "multiplayer")
multiplayer = {}

function multiplayer:load()
	host = "127.0.0.1"
	port = defport
end

function multiplayer:activated()
	connect(host, port)
end

function multiplayer:deactived()
	disconnect()
end

function multiplayer:update(dt)
	updateconn(dt)
	game:update(dt)
end

function multiplayer:draw()
	game:draw()
end

function multiplayer:keypressed(key)
	game:keypressed(key)
end

function multiplayer:keyreleased(key)
	game:keyreleased(key)
end

function multiplayer:mousepressed()
	return
end

function multiplayer:mousereleased()
	return
end

