table.insert(states, "menu")
menu = {}

function menu:load()
	self.context = LoveUI.Context:new()
	self.btn_single = LoveUI.Button:new(LoveUI.Rect:new(200, 50, 400, 50))
	self.btn_single.value = "Single Player"
	self.btn_single.internal = "singleplayer"
	self.btn_single.tabAccessible = true
	self.btn_single:setAction(self.btnhandler)
	self.btn_multi = LoveUI.Button:new(LoveUI.Rect:new(200, 120, 400, 50))
	self.btn_multi.value = "Multi Player"
	self.btn_multi.internal = "browser"
	self.btn_multi.tabAccessible = true
	self.btn_multi:setAction(self.btnhandler)
	self.btn_server = LoveUI.Button:new(LoveUI.Rect:new(200, 190, 400, 50))
	self.btn_server.value = "Start a server"
	self.btn_server.internal = "modeselect"
	self.btn_server.tabAccessible = true
	self.btn_server:setAction(self.btnhandler)
	self.btn_config = LoveUI.Button:new(LoveUI.Rect:new(200, 260, 400, 50))
	self.btn_config.value = "Configure"
	self.btn_config.internal = "config"
	self.btn_config.tabAccessible = true
	self.btn_config:setAction(self.btnhandler)
	self.btn_update = LoveUI.Button:new(LoveUI.Rect:new(200, 330, 400, 50))
	self.btn_update.value = "Update"
	self.btn_update.internal = "updater"
	self.btn_update.tabAccessible = true
	self.btn_update:setAction(self.btnhandler)
	self.btn_exit = LoveUI.Button:new(LoveUI.Rect:new(200, 500, 400, 50))
	self.btn_exit.value = "Exit game"
	self.btn_exit:setAction(self.exit)
	self.context:addSubview(self.btn_single, self.btn_multi, self.btn_server, self.btn_config, self.btn_update, self.btn_exit)
--	self.context:plugin()
end

function menu.btnhandler(btn)
	activatestate(btn.internal)
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
	love.graphics.draw("Credits:\nBartbes - Netris\nappleide - LoveUI\nvs-hs - Master Server Hosting\n(see LICENSE file)", 610, 540)
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

