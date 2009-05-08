table.insert(states, "browser")
browser = {}

function browser:load()
	self.context = LoveUI.Context:new()
	self.br = servbrowser:new(defport)
	self.servs = 0
	--data object (as copied from the demo of LoveUI, credits to appleide)
	local data={};
	function data:viewForRow(aListView, rowIndex)
		local newView=LoveUI.View:new(LoveUI.rectZero);
		function newView:display()
			LoveUI.graphics.setColor(0,0,0);
			LoveUI.graphics.draw((browser.br.servers[rowIndex].name or browser.br.servers[rowIndex].ip), 10, 20);
		end
		return newView;
	end
	function data:numberOfRows(aListView)
		return table.getn(browser.br.servers)
	end
	function data:columnWidth(aListView)
		return 200
	end
	self.list = LoveUI.ListView:new(LoveUI.Rect:new(50, 50, 700, 400), data)
	self.btn_connect = LoveUI.Button:new(LoveUI.Rect:new(50, 500, 100, 20))
	self.btn_connect.value = "Connect"
	self.btn_connect.tabAccessible = true
	self.btn_refresh = LoveUI.Button:new(LoveUI.Rect:new(350, 500, 100, 20))
	self.btn_refresh.value = "Refresh"
	self.btn_refresh.tabAccessible = true
	self.btn_server = LoveUI.Button:new(LoveUI.Rect:new(650, 500, 100, 20))
	self.btn_server.value = "Host"
	self.btn_server.tabAccessible = true
	self.btn_manual = LoveUI.Button:new(LoveUI.Rect:new(50, 550, 100, 20))
	self.btn_manual.value = "Manual"
	self.btn_manual.tabAccessible = true
	self.btn_back = LoveUI.Button:new(LoveUI.Rect:new(350, 550, 100, 20))
	self.btn_back.value = "Back"
	self.btn_connect:setAction(self.btnhandler)
	self.btn_refresh:setAction(self.btnhandler)
	self.btn_server:setAction(self.btnhandler)
	self.btn_back:setAction(self.btnhandler)
	self.btn_manual:setAction(self.btnhandler)
	self.context:addSubview(self.list, self.btn_connect, self.btn_refresh, self.btn_server, self.btn_manual, self.btn_back)
end

function browser:activated()
	self.br.servers = {}
	self.servs = 0	self.br:search()
	self.br:searchmaster(masterserver, masterport)
end

function browser.btnhandler(btn, mouseEvent)
	if btn.value == "Connect" and browser.list.selectedIndex then
		local serv = browser.br.servers[browser.list.selectedIndex]
		if not serv then return end
		host = serv.ip
		port = serv.port
		activatestate("multiplayer")
	elseif btn.value == "Refresh" then
		activatestate("browser")
	elseif btn.value == "Host" then
		activatestate("modeselect")
	elseif btn.value == "Back" then
		activatestate("menu")
	elseif btn.value == "Manual" then
		activatestate("manualconnect")
	end
end

function browser:deactivated()
end

function browser:update(dt)
	local servs = self.br:receive()
	if servs and servs > self.servs then
		self.br:pollserver(servs)
		self.list:reloadData()
		self.servs = servs
	end
	self.context:update(dt)
end

function browser:draw()
	self.context:display()
end

function browser:keypressed(key)
	self.context:keyEvent(key, self.context.keyDown)
end

function browser:keyreleased(key)
	self.context:keyEvent(key, self.context.keyUp)
end

function browser:mousepressed(x, y, button)
	self.context:mouseEvent(x, y, button, self.context.mouseDown)
end

function browser:mousereleased(x, y, button)
	self.context:mouseEvent(x, y, button, self.context.mouseUp)
end
