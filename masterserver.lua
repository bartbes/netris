require "socket"

debug = ( arg[1] and arg[1] == "debug" )

if debug then print("DEBUG: Debug mode enabled") end

searchstring = "SERVBROWSER_MASTERSEARCH"
responsestring = "MASTERSERVER_RESULT"
identifystring = "MASTERSERVER_IDENTIFY"
checkstring = "MASTERSERVER_CHECK"
checkpassstring = "MASTERSERVER_CHECKPASS"

servers = {}

sock = socket.udp()
sock:settimeout(0)
sock:setsockname("*", 8189)
while true do
	local data, ip, port = sock:receivefrom()
	if data == searchstring then
		if debug then print("DEBUG: " .. ip .. " searched for servers") end
		for i, v in pairs(servers) do
			local sip, sport = i:gmatch("([0-9%.]*):([0-9]*)")()
			sock:sendto(string.format("%s %s %s\n", responsestring, sip, sport), ip, port)
		end
	elseif data == identifystring then
		if debug then print("DEBUG: " .. ip .. " tried to identify") end
		sock:sendto(checkstring, ip, port)
	elseif data == checkpassstring then
		if debug then print("DEBUG: " .. ip .. " confirmed a connection") end
		servers[ip .. ":" .. port] = os.time()
	elseif not data then
		local t = os.time()
		for i, v in pairs(servers) do
			local dt = os.difftime(t, v)
			if dt > 60 then
				if debug then print("DEBUG: " .. i .. " removed from the server list") end
				servers[i] = nil
			elseif dt > 30 then
				if debug then print("DEBUG: " .. i .. " is requested to respond") end
				local ip, port = i:gmatch("([0-9%.]*):([0-9]*)")()
				sock:sendto(checkstring, ip, port)
			end
		end
	end
	socket.sleep(0.1)
end

