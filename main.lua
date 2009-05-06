love.filesystem.require("libs/LUBE.lua")
love.filesystem.require("libs/class.lua")
love.filesystem.require("libs/serverbrowser.lua")
love.filesystem.require("libs/Updater.lua")
love.filesystem.require("libs/LoveUI/LoveUI.lua")
LoveUI.requireall()
love.filesystem.require("gettime.lua")
love.filesystem.require("block.lua")
love.filesystem.require("colors.lua")
love.filesystem.require("pieces.lua")
love.filesystem.require("player.lua")
love.filesystem.require("protocol.lua")

--states
states = {}
love.filesystem.require("game.lua")
love.filesystem.require("singleplayer.lua")
love.filesystem.require("multiplayer.lua")
love.filesystem.require("server.lua")
love.filesystem.require("menu.lua")
love.filesystem.require("browser.lua")
love.filesystem.require("config.lua")
love.filesystem.require("manualconnect.lua")
love.filesystem.require("modeselect.lua")
love.filesystem.require("update.lua")
curstate = "menu"

version = "0.01"
masterserver = "bartbes.ath.cx"
masterport = 8189

function load()
	for i, v in ipairs(states) do
		_G[v]:load()
	end
	_G[curstate]:activated()
end

function update(dt)
	_G[curstate]:update(dt)
end

function draw()
	_G[curstate]:draw()
end

function keypressed(key)
	if key == love.key_d and love.keyboard.isDown(love.key_rctrl) then debug.debug() end
	if key == love.key_escape then activatestate("menu") end
	_G[curstate]:keypressed(key)
end

function keyreleased(key)
	_G[curstate]:keyreleased(key)
end

function mousepressed(x, y, button)
	_G[curstate]:mousepressed(x, y, button)
end

function mousereleased(x, y, button)
	_G[curstate]:mousereleased(x, y, button)
end

function activatestate(state)
	_G[curstate]:deactivated()
	curstate = state
	_G[state]:activated()
end

function collision(block, x, y, exclude_active)
	local dx, dy = block.x + x, block.y + y
	for i, v in ipairs(blocks) do
		if v.x == dx and v.y == dy then
			if not exclude_active or not v.active then
				return true
			end
		end
	end
	return false
end

function checkblock(block)
	if block.y == 12 then
		block.resting = true
		if block.active then
			for i, v in ipairs(blocks) do
				if v.active then
					v.resting = true
					v.active = false
					reportback(v)
				end
			end
			activeblocks = false
		end
	end
	for i, v in ipairs(blocks) do
		if v.x == block.x and v.y == block.y + 1 and v.resting then
			block.resting = true
			if block.active then
				for j, w in ipairs(blocks) do
					if w.active then
						w.resting = true
						w.active = false
						reportback(w)
					end
				end
				activeblocks = false
				return true
			end
			return false
		end
	end
end

function dropblocks(line)
	for i, v in pairs(blocks) do
		if v.y < line then v.y = v.y + 1 end
	end
end

function checkactive()
	for i, v in pairs(blocks) do
		if v.active then return true end
	end
	return false
end

function msg(...)
	print(...)
end

