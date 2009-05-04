table.insert(states, "modeselect")
modeselect = {}

function modeselect:load()
	self.context = LoveUI.Context:new()
	self.btn_coop = LoveUI.Button:new(LoveUI.Rect:new(200, 50, 400, 50))
	self.btn_coop.title = "Co-Op"
	self.btn_coop.value = "coop"
	self.btn_coop:setAction(self.btnhandler)
	self.btn_versus = LoveUI.Button:new(LoveUI.Rect:new(200, 120, 400, 50))
	self.btn_versus.title = "Versus"
	self.btn_versus.value = "versus"
	self.btn_versus:setAction(self.btnhandler)
	self.btn_control = LoveUI.Button:new(LoveUI.Rect:new(200, 190, 400, 50))
	self.btn_control.title = "Controller"
	self.btn_control.value = "controller"
	self.btn_control:setAction(self.btnhandler)
	self.btn_back = LoveUI.Button:new(LoveUI.Rect:new(200, 500, 400, 50))
	self.btn_back.title = "Back"
	self.btn_back:setAction(self.btnhandler)
	self.context:addSubview(self.btn_coop, self.btn_versus--[[, self.btn_control]], self.btn_back)
end

function modeselect.btnhandler(btn)
	if btn.title == "Back" then
		return activatestate("menu")
	end
	gamemode = btn.value
	activatestate("server")
end

function modeselect:activated()
end

function modeselect:deactivated()
end

function modeselect:update(dt)
	self.context:update(dt)
end

function modeselect:draw()
	self.context:display()
end

function modeselect:keypressed(key)
	self.context:keyEvent(key, self.context.keyDown)
end

function modeselect:keyreleased(key)
	self.context:keyEvent(key, self.context.keyUp)
end

function modeselect:mousepressed(x, y, button)
	self.context:mouseEvent(x, y, button, self.context.mouseDown)
end

function modeselect:mousereleased(x, y, button)
	self.context:mouseEvent(x, y, button, self.context.mouseUp)
end

