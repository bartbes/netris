table.insert(states, "config")
config = {}

function config:load()
	if love.filesystem.exists("configuration.lua") then
		love.filesystem.include("configuration.lua")
	end
	self.context = LoveUI.Context:new()
	self.inp_server_name = LoveUI.Textfield:new(LoveUI.Rect:new(200, 100, 400, 50))
	self.inp_server_name.cell.value = server_name
	self.btn_set_server_name = LoveUI.Button:new(LoveUI.Rect:new(200, 170, 400, 50))
	self.btn_set_server_name.value = "Set Server Name"
	self.btn_set_server_name:setAction(self.btnhandler)
	self.inp_player_name = LoveUI.Textfield:new(LoveUI.Rect:new(200, 260, 400, 50))
	self.inp_player_name.cell.value = player_name
	self.btn_set_player_name = LoveUI.Button:new(LoveUI.Rect:new(200, 330, 400, 50))
	self.btn_set_player_name.value = "Set Player Name"
	self.btn_set_player_name:setAction(self.btnhandler)
	self.btn_back = LoveUI.Button:new(LoveUI.Rect:new(200, 500, 400, 50))
	self.btn_back.value = "Back"
	self.btn_back:setAction(self.btnhandler)
	self.context:addSubview(self.inp_server_name, self.btn_set_server_name, self.inp_player_name, self.btn_set_player_name, self.btn_back)
end

function config:writeconfig()
	love.filesystem.write("configuration.lua", string.format([[
server_name = "%s"
player_name = "%s"
]], server_name, player_name))
end

function config.btnhandler(btn)
	if btn.value == "Set Server Name" then
		server_name = config.inp_server_name.cell.value
		config:writeconfig()
	elseif btn.value == "Set Player Name" then
		player_name = config.inp_player_name.cell.value
		config:writeconfig()
	elseif btn.value == "Back" then
		activatestate("menu")
	end
end

function config:activated()
end

function config:deactivated()
end

function config:update(dt)
	self.context:update(dt)
end

function config:draw()
	self.context:display()
end

function config:keypressed(key)
	self.context:keyEvent(key, self.context.keyDown)
end

function config:keyreleased(key)
	self.context:keyEvent(key, self.context.keyUp)
end

function config:mousepressed(x, y, button)
	self.context:mouseEvent(x, y, button, self.context.mouseDown)
end

function config:mousereleased(x, y, button)
	self.context:mouseEvent(x, y, button, self.context.mouseUp)
end
