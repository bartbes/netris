table.insert(states, "server")
server = {}

function server:load()
	server_name = "UnnamedServer"
end

function server:activated()
	game:activated()
	startserver()
	localplayer = 1
	activeplayer = 1
	players[1] = player:new("LocalPlayer", 0)
	self.counter = 0
end

function server:deactivated()
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

function server:lineremoved()
	score = score + 100
	sendscore(score)
end

function server:blockplaced()
	activeplayer = activeplayer + 1
	if activeplayer > #players then activeplayer = 1 end
	sendactive(activeplayer)
end

function server:blockadded()
	self.counter = self.counter + 1
	if self.counter == 4 then
		self.counter = 0
		return self:blockplaced()
	end
end

