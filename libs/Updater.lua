--[[
Copyright (c) 2009 Bart Bes <bart.bes+projects@gmail.com>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
]]

require "socket"

Updater = {}
Updater.versioninfo = {}
Updater.versioninfo.changedFiles = {}
Updater.versioninfo.removedFiles = {}

love.filesystem.include("Updater.conf")
if love.filesystem.exists("Updater.version") then
	love.filesystem.include("Updater.version")
end

Updater.currentversion = Updater.currentversion or 0

function Updater.checkforupdates()
	Updater.serverip = socket.dns.toip(Updater.server)
	if not Updater.serverip then
		return false
	end
	Updater.socket = socket.tcp()
	if not Updater.socket:connect(Updater.serverip, 80) then
		return false
	end
	Updater.socket:send("GET " .. Updater.path .. " HTTP/1.1\nHost: " .. Updater.server .. "\nConnection: close\n\n")
	Updater.result = assert(Updater.socket:receive("*a"), "Updater: No data received")
	Updater.data = assert(Updater.result:sub(Updater.result:find("\r\n\r\n")+4), "Updater: Incorrect data received from server")
	Updater.script = loadstring(Updater.data)
	setfenv(Updater.script, Updater.versioninfo)
	Updater.versioninfo.currentversion = Updater.currentversion
	Updater.script()
	Updater.updatesavailable = (Updater.versioninfo.version > Updater.currentversion)
	return Updater.updatesavailable
end

function Updater.update()
	if Updater.updatesavailable then
		love.filesystem.write("temp-mkdir", "a")
		love.filesystem.remove("temp-mkdir")
		Updater.versioninfo.dirs = Updater.versioninfo.dirs or {}
		for i, v in ipairs(Updater.versioninfo.dirs) do
			love.filesystem.mkdir(v)
		end
		local changedFiles = {}
		for a = Updater.currentversion+1, Updater.versioninfo.version do
			Updater.versioninfo.changedFiles[a] = Updater.versioninfo.changedFiles[a] or {}
			for i, v in ipairs(Updater.versioninfo.changedFiles[a]) do
				changedFiles[v] = true
			end
		end
		for i, v in pairs(changedFiles) do
			Updater.socket = socket.tcp()
			assert(Updater.socket:connect(Updater.versioninfo.host or Updater.serverip, 80), "Updater: Couldn't connect to server")
			Updater.socket:send("GET " .. Updater.versioninfo.dir .. i .. " HTTP/1.1\nHost: " .. (Updater.versioninfo.host or Updater.server) .. "\nConnection: close\n\n")
			Updater.result = assert(Updater.socket:receive("*a"), "Updater: No data received")
			Updater.data = assert(Updater.result:sub(Updater.result:find("\r\n\r\n")+4), "Updater: Incorrect data received from server")
			Updater.savefile(i, Updater.data)
		end
		local removedFiles = {}
		for a = Updater.currentversion+1, Updater.versioninfo.version do
			Updater.versioninfo.removedFiles[a] = Updater.versioninfo.removedFiles[a] or {}
			for i, v in ipairs(Updater.versioninfo.removedFiles[a]) do
				removedFiles[v] = true
			end
		end
		for i, v in ipairs(removedFiles) do
			love.filesystem.remove(i)
		end
		Updater.savefile("Updater.version", "Updater.currentversion = " .. Updater.versioninfo.version)
		love.system.restart()
		return true
	else
		return false
	end
end

function Updater.savefile(filename, data, mode)
	mode = mode or "w+b"
	local f = io.open(love.filesystem.getSaveDirectory() .. "/" .. filename, mode)
	f:write(data)
	f:flush()
	f:close()
end

function Updater.loadgame(fromsession)
	love.filesystem.include("game.orig.conf")
	love.graphics.setCaption(title or "")
	love.graphics.setMode(width or 800, height or 600, fullscreen or false, vsync or true, fsaa or 0)
	love.filesystem.include("main.orig.lua")
	if fromsession then load() end
end

function Updater.defineemptycallbacks()
	local callbacks = { "load", "update", "draw", "keypressed", "keyreleased", "mousepressed", "mousereleased", "joystickpressed", "joystickreleased" }
	for i, v in ipairs(callbacks) do
		_G[v] = function() end
	end
end

Updater.dialog = {}

function Updater.dialog.load()
	love.graphics.setMode(800, 600, false, true, 0)
	love.graphics.setCaption("Update found")
	Updater.font = love.graphics.newFont(love.default_font)
	love.graphics.setFont(Updater.font)
end

function Updater.dialog.draw()
	local text = "Update Available"
	love.graphics.draw(text, 400-Updater.font:getWidth(text)/2, 280)
	text = "Current version: " .. Updater.currentversion
	love.graphics.draw(text, 400-Updater.font:getWidth(text)/2, 300)
	text = "New version: " .. Updater.versioninfo.version
	love.graphics.draw(text, 400-Updater.font:getWidth(text)/2, 312)
	text = "Description: " .. (Updater.versioninfo.description or "None")
	love.graphics.draw(text, 400-Updater.font:getWidth(text)/2, 330)
	text = "[Y]es/[N]o/[S]top updating"
	love.graphics.draw(text, 400-Updater.font:getWidth(text)/2, 350)
	text = "Remember: This can take a few minutes"
	love.graphics.draw(text, 400-Updater.font:getWidth(text)/2, 400)
	text = "During this time the screen will not be updated"
	love.graphics.draw(text, 400-Updater.font:getWidth(text)/2, 420)
end

function Updater.dialog.keypressed(key)
	if key == love.key_y then
		Updater.update()
	elseif key == love.key_n then
		Updater.defineemptycallbacks()
		Updater.LoadGame(true)
	elseif key == love.key_s then
		Updater.savefile("Updater.version", "\nUpdater.neverupdate = true", "a")
		Updater.defineemptycallbacks()
		Updater.loadgame(true)
	end
end

if love.filesystem.exists("Updater.patch") then
	love.filesystem.include("Updater.patch")
end

if not Updater.applicationmanaged and not Updater.neverupdate and Updater.checkforupdates() then
	if Updater.autoupdate and 1 == 2 then Updater.update()
	else Updater.defineemptycallbacks(); load = Updater.dialog.load; draw = Updater.dialog.draw; keypressed = Updater.dialog.keypressed
	end
--elseif Updater.currentversion > 0 then
--	Updater.loadgame()
--else
	--error("No version of game present, please update!\nIf you haven't received an update warning, check you internet connection.\nIf you have a working internet connection, contact the maintainer.")
--We don't need this, version 0 is distributed.
end
