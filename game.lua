table.insert(states, "game")

game = {}

function game:load()
	love.graphics.setFont(love.default_font, 12)
	blocks = {}
	activeblocks = false
	timer = 0
	time = 0
	score = 0
	speed = 1
	timer2 = 10
	localplayer = 0
	activeplayer = -1
	players = {}
	math.randomseed(os.time())
end

function game:activated()
	blocks = {}
	activeblocks = false
	timer = 0
	time = 0
	score = 0
	speed = 1
	timer2 = 10
	localplayer = 0
	activeplayer = -1
	players = {}
end

function game:update(dt)
	love.timer.sleep(100)
	local drop = love.keyboard.isDown(love.key_down)
	if drop then
		speed = 10
	else
		speed = 1
	end
	timer2 = timer2 + dt
	if timer2 >= 1/speed then
		local controlstopped = false
		for i, v in ipairs(blocks) do
			checkblock(v)
		end
		for i, v in ipairs(blocks) do
			checkblock(v)
		end
		for i, v in ipairs(blocks) do
			checkblock(v)
		end
		for i, v in ipairs(blocks) do
			if v.active and not v.resting then
				v.y = v.y + 1
			end
		end
		activeblocks = checkactive()
		if not activeblocks and activeplayer == localplayer then _G[curstate]:blockplaced() end
		if not activeblocks and activeplayer == localplayer then
			activepiece = pieceindexes[math.random(1, #pieceindexes)]
			activerotation = 0
			pieces[activepiece]:create(blocks, math.random(1, 8), 1, true)
			activeblocks = true
		end
		timer2 = 0
	end
	for i = 1, 12 do
		local lineblocks = {}
		for j, v in ipairs(blocks) do
			if v.y == i then table.insert(lineblocks, j) end
		end
		if #lineblocks == 12 then
			for j, v in ipairs(lineblocks) do
				table.remove(blocks, v+1-j)
			end
			dropblocks(i)
			_G[curstate]:lineremoved()
		end
	end
	for i, v in ipairs(blocks) do
		if v.y == 1 and not v.active then
			print("You lost!")
			love.system.exit()
		end
	end
	timer = timer + dt
	if timer > 1 then
		time = gettime()
		timer = 0
	end
	updateconn()
end

function game.drawgrid()
	love.graphics.line(20, 20, 20, 620)
	love.graphics.line(620, 20, 620, 620)
	love.graphics.line(20, 20, 620, 20)
	love.graphics.line(20, 620, 620, 620)
	love.graphics.line(70, 20, 70, 620)
	love.graphics.line(120, 20, 120, 620)
	love.graphics.line(170, 20, 170, 620)
	love.graphics.line(220, 20, 220, 620)
	love.graphics.line(270, 20, 270, 620)
	love.graphics.line(320, 20, 320, 620)
	love.graphics.line(370, 20, 370, 620)
	love.graphics.line(420, 20, 420, 620)
	love.graphics.line(470, 20, 470, 620)
	love.graphics.line(520, 20, 520, 620)
	love.graphics.line(570, 20, 570, 620)
	love.graphics.line(20, 70, 620, 70)
	love.graphics.line(20, 120, 620, 120)
	love.graphics.line(20, 170, 620, 170)
	love.graphics.line(20, 220, 620, 220)
	love.graphics.line(20, 270, 620, 270)
	love.graphics.line(20, 320, 620, 320)
	love.graphics.line(20, 370, 620, 370)
	love.graphics.line(20, 420, 620, 420)
	love.graphics.line(20, 470, 620, 470)
	love.graphics.line(20, 520, 620, 520)
	love.graphics.line(20, 570, 620, 570)
end

function game.drawblocks()
	for i, v in ipairs(blocks) do
		v:draw()
	end
end

function game.drawhud()
	love.graphics.draw("Time: @" .. time, 640, 50)
	love.graphics.draw("Score: " .. score, 640, 70)
	love.graphics.draw("Players:", 640, 100)
	local c = 0
	for i, v in pairs(players) do
		love.graphics.draw("    " .. v.name .. "    " .. v.score, 640, 120+20*c)
		if i == activeplayer then
			love.graphics.draw("*", 644, 120+20*c)
		end
		c = c + 1
	end
end

function game:draw()
	self.drawblocks()
	love.graphics.setColor(255, 255, 255)
	self.drawgrid()
	self.drawhud()
end

function game:keypressed(key)
	if key == love.key_q then
		love.system.exit()
	elseif key == love.key_left then
		if localplayer ~= activeplayer then return end
		local possible = true
		for i, v in ipairs(blocks) do
			if v.active and (v.x == 1 or collision(v, -1, 0, true)) then
				possible = false
				break
			end
		end
		if possible then
			for i, v in ipairs(blocks) do
				if v.active then
					v.x = v.x - 1
				end
			end
		end
	elseif key == love.key_right then
		if localplayer ~= activeplayer then return end
		local possible = true
		for i, v in ipairs(blocks) do
			if v.active and (v.x == 12 or collision(v, 1, 0, true)) then
				possible = false
				break
			end
		end
		if possible then
			for i, v in ipairs(blocks) do
				if v.active then
					v.x = v.x + 1
				end
			end
		end
	elseif key == love.key_up then
		if localplayer ~= activeplayer then return end
		local activeblocks = {}
		for i, v in ipairs(blocks) do
			if v.active then
				table.insert(activeblocks, i)
			end
		end
		local newrotation = activerotation + 90
		if newrotation >= 360 then newrotation = newrotation - 360 end
		local newpositions = pieces[activepiece]:rotate(blocks, activeblocks, newrotation)
		local possible = true
		for i, v in pairs(newpositions) do
			if not possible then break end
			if v.x < 1 or v.x > 12 or v.y < 1 or v.y > 12 then
				possible = false
				break
			end
			for j, w in ipairs(blocks) do
				if w.x == v.x and w.y == v.y and not w.active then
					possible = false
					break
				end
			end
		end
		if possible then
			for i, v in ipairs(activeblocks) do
				blocks[v].x = newpositions[v].x
				blocks[v].y = newpositions[v].y
			end
			activerotation = newrotation
		end
	end
end

function game:keyreleased(key)
end
