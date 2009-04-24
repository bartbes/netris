love.filesystem.require("libs/LUBE.lua")
love.filesystem.require("libs/SECS.lua")
love.filesystem.require("libs/serverbrowser.lua")
love.filesystem.require("libs/gettime.lua")
love.filesystem.require("block.lua")
love.filesystem.require("colors.lua")
love.filesystem.require("pieces.lua")
love.filesystem.require("protocol.lua")

function load()
	love.graphics.setFont(love.default_font, 12)
	blocks = {}
	activeblocks = false
	timer = 0
	time = 0
	score = 0
	speed = 1
	timer2 = 10
	player = 0
	activeplayer = 0
	math.randomseed(os.time())
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
					end
				end
				activeblocks = false
				return true
			end
			return false
		end
	end
end

function update(dt)
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
		if not activeblocks and activeplayer == player then
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
			score = score + 100
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

function drawgrid()
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

function drawblocks()
	for i, v in ipairs(blocks) do
		v:draw()
	end
end

function draw()
	drawblocks()
	love.graphics.setColor(255, 255, 255)
	drawgrid()
	love.graphics.draw("Time: @" .. time, 640, 50)
	love.graphics.draw("Score: " .. score, 640, 70)
end

function keypressed(key)
	if key == love.key_q then
		love.system.exit()
	elseif key == love.key_left then
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

function keyreleased(key)
end
