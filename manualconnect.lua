table.insert(states, "manualconnect")
manualconnect = {}

function manualconnect:load()
	self.context = LoveUI.Context:new()
	self.inp_ip = LoveUI.Textfield:new(LoveUI.Rect:new(200, 260, 350, 50))
	self.inp_ip.cell.value = "Enter ip/hostname"
	self.inp_port = LoveUI.Textfield:new(LoveUI.Rect:new(550, 260, 50, 50))
	self.inp_port.cell.value = "port"
	self.btn_connect = LoveUI.Button:new(LoveUI.Rect:new(200, 330, 100, 20))
	self.btn_connect.value = "Connect"
	self.btn_connect.tabAccessible = true
	self.btn_cancel = LoveUI.Button:new(LoveUI.Rect:new(500, 330, 100, 20))
	self.btn_cancel.value = "Cancel"
	self.btn_cancel.tabAccessible = true
	self.btn_connect:setAction(self.btnhandler)
	self.btn_cancel:setAction(self.btnhandler)
	self.context:addSubview(self.inp_ip, self.inp_port, self.btn_connect, self.btn_cancel)
end

function manualconnect.btnhandler(btn)
	if btn.value == "Connect" then
		host = manualconnect.inp_ip.cell.value
		port = tonumber(manualconnect.inp_port.cell.value) or 8188
		activatestate("multiplayer")
	elseif btn.value == "Cancel" then
		activatestate("browser")
	end
end

function manualconnect:activated()
end

function manualconnect:deactivated()
end

function manualconnect:update(dt)
	self.context:update(dt)
end

function manualconnect:draw()
	self.context:display()
end

function manualconnect:keypressed(key)
	self.context:keyEvent(key, self.context.keyDown)
end

function manualconnect:keyreleased(key)
	self.context:keyEvent(key, self.context.keyUp)
end

function manualconnect:mousepressed(x, y, button)
	self.context:mouseEvent(x, y, button, self.context.mouseDown)
end

function manualconnect:mousereleased(x, y, button)
	self.context:mouseEvent(x, y, button, self.context.mouseUp)
end

