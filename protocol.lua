connected = false

function rcvCallback(data)
	local it = data:gmatch("([^ \n]*)")
	local command = it()
	if command == "activePlayer" then
		activeplayer = tonumber(it())
	elseif command == "setPlayer" then
		player = tonumber(it())
	elseif command == "addblock" then
		local x = tonumber(it())
		local y = tonumber(it())
		local r = tonumber(it())
		local g = tonumber(it())
		local b = tonumber(it())
		table.insert(blocks, block:new(r, g, b, x, y, false))
		blocks[#blocks].resting = true
	end
end

function connect(ip, port)
	if connected then
		disconnect()
	end
	conn = lube.client()
	conn:setHandshake("Netris rules!")
	conn:setPing(5)
	conn:setCallback(rcvCallback)
	conn:connect(ip, port)
	connected = true
end

function reportback(blocks)
	if connected then
		for i, v in pairs(blocks) do
			conn:send(string.format("addblock %i %i %i %i %i\n", v.x, v.y, v.red, v.green, v.blue))
		end
	end
end

function updateconn(dt)
	if connected then
		conn:update()
		conn:doPing(dt)
	end
end

function disconnect()
	if connected then
		conn:disconnect()
		conn = nil
	end
end
