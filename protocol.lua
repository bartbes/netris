connected = false
defport = 8188
is_server = false

function rcvCallback(data)
	local it = data:gmatch("([^ \n]*)[ \n]?")
	local command = it()
	if command == "activePlayer" then
		activeplayer = tonumber(it())
	elseif command == "setPlayer" then
		localplayer = tonumber(it())
	elseif command == "addblock" then
		local x = tonumber(it())
		local y = tonumber(it())
		local r = tonumber(it())
		local g = tonumber(it())
		local b = tonumber(it())
		table.insert(blocks, block:new(r, g, b, x, y, false))
		blocks[#blocks].resting = true
		_G[curstate]:blockadded()
	elseif command == "playerScore" then
		local player = tonumber(it())
		local score = tonumber(it())
		players[player].score = score
	elseif command == "addPlayer" then
		local num = tonumber(it())
		local name = it()
		local score = tonumber(it())
		players[num] = player:new(name, score)
	elseif command == "removePlayer" then
		local num = tonumber(it())
		local msg = it()
		msg(players[num].name .. " left: " .. msg)
		players[num] = nil
	elseif command == "gameScore" then
		local sc = tonumber(it())
		score = sc
	elseif command == "playerName" then
		local num = tonumber(it())
		local name = it()
		players[num].name = name
	elseif command == "yourNumber" then
		local num = tonumber(it())
		localplayer = num
	end
	if is_server then conn:send(data) end
end

function connCallback(ip, port)
	conn:send("addPlayer " .. #players+1 .. " UnnamedPlayer 0\n")
	for i, v in pairs(players) do
		conn:send("addPlayer " .. i .. " " .. v.name .. " " .. v.score .. "\n", ip)
	end
	for i, v in pairs(blocks) do
		if not v.active and v.resting then
			conn:send(string.format("addblock %d %d %d %d %d", v.x, v.y, v.red, v.green, v.blue))
		end
	end
	conn:send("activePlayer " .. activeplayer .. "\n", ip)
	conn:send("yourNumber " .. #players+1 .. "\n", ip)
	players[#players+1] = player:new("UnnamedPlayer", 0)
end

function disconnCallback(ip, port)
end

function connect(ip, port)
	if connected then
		disconnect()
	end
	port = port or defport
	conn = lube.client()
	conn:setHandshake("Netris rules!")
	conn:setPing(true, 5, "NetrisPing")
	conn:setCallback(rcvCallback)
	conn:connect(ip, port)
	connected = true
	is_server = false
end

function reportback(block)
	if connected then
		conn:send(string.format("addblock %i %i %i %i %i\n", block.x, block.y, block.red, block.green, block.blue))
	end
end

function reportback_multiple(blocks)
	if connected then
		for i, v in pairs(blocks) do
			conn:send(string.format("addblock %i %i %i %i %i\n", v.x, v.y, v.red, v.green, v.blue))
		end
	end
end

function updateconn(dt)
	if connected then
		conn:update()
--[[		if not is_server then conn:doPing(dt)
		else conn:checkPing(dt)
		end]]
	end
end

function disconnect()
	if connected then
		conn:disconnect()
		conn = nil
		is_server = false
	end
end

function startserver(port)
	port = port or 8188
	if connected then
		disconnect()
	end
	conn = lube.server(port)
	conn:setHandshake("Netris rules!")
	conn:setPing(true, 3, "NetrisPing")
	conn:setCallback(rcvCallback, connCallback, disconnCallback)
	connected = true
	is_server = true
end

function sendscore(score, player)
	if player then
		conn:send("playerScore " .. player .. " " .. score .. "\n")
	else
		conn:send("gameScore " .. score .. "\n")
	end
end

function sendactive(activeplayer)
	conn:send("activePlayer " .. activeplayer .. "\n")
end

