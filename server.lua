table.insert(states, "server")
server = {}

function server:load()
	gamemode = "coop"
	server_name = "UnnamedServer"
end

function server:activated()
	game:activated()
	startserver()
	localplayer = 1
	activeplayer = 1
	controlplayer = 1
	players[1] = player:new(player_name, 0)
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

function server:lineremoved(l)
	server[gamemode]:lineremoved(l)
end

function server:blockplaced()
	server[gamemode]:blockplaced()
end

server.coop = {}

function server.coop:lineremoved(l)
	score = score + 100
	sendscore(score)
	removeline(l)
end

function server.coop:blockplaced()
	activeplayer = activeplayer + 1
	if activeplayer > #players then activeplayer = 1 end
	sendactive(activeplayer)
	placed_block = false
end

server.versus = {}

function server.versus:lineremoved(l)
	local prevplayer = activeplayer - 1
	if prevplayer < 1 then prevplayer = #players end
	players[prevplayer].score = players[prevplayer].score + 100
	sendscore(players[prevplayer].score, prevplayer)
	removeline(l)
end

function server.versus:blockplaced()
	activeplayer = activeplayer + 1
	if activeplayer > #players then activeplayer = 1 end
	sendactive(activeplayer)
	placed_block = false
end

server.control = {}

function server.control:lineremoved(l)
	score = score + 100
	sendscore(score)
	removeline(l)
end

function server.control:blockplaced()
	activeplayer = activeplayer + 1
	if activeplayer == controlplayer then activeplayer = activeplayer + 1 end
	if activeplayer > #players then activeplayer = 1 end
	sendactive(activeplayer)
	placed_block = false
end

function server:blockadded()
end

