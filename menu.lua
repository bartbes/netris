table.insert(states, "menu")
menu = {}

function menu:load()
	self.context = LoveUI.Context:new()
	self.btn_single = LoveUI.Button:new(LoveUI.Rect:new(200, 50, 400, 50))
	self.btn_single.title = "Single Player"
	self.btn_single.value = "singleplayer"
	self.btn_single:setAction(self.btnhandler)
	self.btn_multi = LoveUI.Button:new(LoveUI.Rect:new(200, 120, 400, 50))
	self.btn_multi.title = "Multi Player"
	self.btn_multi.value = "browser"
	self.btn_multi:setAction(self.btnhandler)
	self.btn_server = LoveUI.Button:new(LoveUI.Rect:new(200, 190, 400, 50))
	self.btn_server.title = "Start a server"
	self.btn_server.value = "modeselect"
	self.btn_server:setAction(self.btnhandler)
	self.btn_config = LoveUI.Button:new(LoveUI.Rect:new(200, 260, 400, 50))
	self.btn_config.title = "Configure"
	self.btn_config.value = "config"
	self.btn_config:setAction(self.btnhandler)
	self.btn_exit = LoveUI.Button:new(LoveUI.Rect:new(200, 500, 400, 50))
	self.btn_exit.title = "Exit game"
	self.btn_exit:setAction(self.exit)
	self.context:addSubview(self.btn_single, self.btn_multi, self.btn_server, self.btn_config, self.btn_exit)
--	self.context:plugin()
end

function menu.btnhandler(btn)
	activatestate(btn.value)
end

function menu.exit()
	love.system.exit()
end

function menu:activated()
end

function menu:deactivated()
end

function menu:update(dt)
	self.context:update(dt)
end

function menu:draw()
	if lost then love.graphics.draw("You lost!", 350, 306) end
	love.graphics.draw("Credits:\nBartbes - Netris\nappleide - LoveUI\n\n(see LICENSE file)", 610, 540)
	self.context:display()
end

function menu:keypressed(key)
	self.context:keyEvent(key, self.context.keyDown)
end

function menu:keyreleased(key)
	self.context:keyEvent(key, self.context.keyUp)
end

function menu:mousepressed(x, y, button)
	self.context:mouseEvent(x, y, button, self.context.mouseDown)
end

function menu:mousereleased(x, y, button)
	self.context:mouseEvent(x, y, button, self.context.mouseUp)
end

