love.filesystem.require("libs/LUBE.lua")
love.filesystem.require("libs/SECS.lua")
love.filesystem.require("libs/serverbrowser.lua")
love.filesystem.require("libs/gettime.lua")
love.filesystem.require("block.lua")
love.filesystem.require("colors.lua")
love.filesystem.require("pieces.lua")

function load()
	love.graphics.setFont(love.default_font, 12)
	blocks = {}
	blocks[1] = block:new(255, 255, 255, 1, 12)
	blocks[2] = block:new(255, 255, 255, 2, 12)
	blocks[3] = block:new(255, 255, 255, 3, 12)
	blocks[4] = block:new(255, 255, 255, 4, 12)
	blocks[5] = block:new(255, 255, 255, 5, 12)
	blocks[6] = block:new(255, 255, 255, 6, 12)
	blocks[7] = block:new(255, 255, 255, 7, 12)
	blocks[8] = block:new(255, 255, 255, 8, 12)
	blocks[9] = block:new(255, 255, 255, 9, 12)
	blocks[10] = block:new(255, 255, 255, 10, 12)
	blocks[11] = block:new(255, 255, 255, 11, 12)
	blocks[12] = block:new(255, 255, 255, 12, 12)
	pieces.O:create(blocks, 1, 1)
	timer = 0
	time = 0
	score = 0
	speed = 1
	timer2 = 0
end

function checkblock(block)
	if block.y == 12 then block.resting = true end
	for i, v in ipairs(blocks) do
		if v.x == block.x and v.y == block.y + 1 and v.resting then
			block.resting = true
			return
		end
	end
end

function update(dt)
	love.timer.sleep(100)
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
	local drop = love.keyboard.isDown(love.key_down)
	if drop then
		speed = 10
	else
		speed = 1
	end
	timer2 = timer2 + dt
	if timer2 >= 1/speed then
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
			if not v.resting then
				v.y = v.y + 1
			end
		end
		timer2 = 0
	end
	timer = timer + dt
	if timer > 1 then
		time = gettime()
		timer = 0
	end
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
	end
end

function keyreleased(key)
end
