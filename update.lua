table.insert(states, "updater")
updater = {}

function updater:load()
	self.context = LoveUI.Context:new()
	self.found = false
	self.btn_update = LoveUI.Button:new(LoveUI.Rect:new(200, 190, 400, 50))
	self.btn_update.title = "Update"
	self.btn_update:setAction(self.btnhandler)
	self.btn_back = LoveUI.Button:new(LoveUI.Rect:new(200, 500, 400, 50))
	self.btn_back.title = "Back"
	self.btn_back:setAction(self.btnhandler)
	self.context:addSubview(self.btn_back)
end

function updater.btnhandler(btn)
	if btn.title == "Update" then
		Updater.update()
	elseif btn.title == "Back" then
		activatestate("menu")
	end
end

function updater:activated()
	self.found = Updater.checkforupdates()
	if self.found then
		self.context:addSubview(self.btn_update)
	end
end

function updater:deactivated()
	self.context.contentView:removeSubview(self.btn_update)
end

function updater:update(dt)
	self.context:update(dt)
end

function updater:draw()
	self.context:display()
	if not self.found then love.graphics.draw("No updates found", 200, 240) end
end

function updater:keypressed(key)
	self.context:keyEvent(key, self.context.keyDown)
end

function updater:keyreleased(key)
	self.context:keyEvent(key, self.context.keyUp)
end

function updater:mousepressed(x, y, button)
	self.context:mouseEvent(x, y, button, self.context.mouseDown)
end

function updater:mousereleased(x, y, button)
	self.context:mouseEvent(x, y, button, self.context.mouseUp)
end


