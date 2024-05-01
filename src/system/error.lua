love.graphics.setDefaultFilter("nearest", "nearest")
local utf8 = require("utf8")
local anim8 = require("src/library/animations")
local errorm = {}
local scaleX = 6 / 1200 * love.graphics.getWidth()
local scaleY = 6 / 1200 * love.graphics.getHeight()
errorm.background = love.graphics.newImage("assets/textures/gui/title/backgroundBlue.png")
local buttonImage = love.graphics.newImage("assets/textures/gui/title/buttons/button.png")
local buttonImageOutline = love.graphics.newImage("assets/textures/gui/title/buttons/buttonOutline.png")
errorm.button = {
	{
		image = buttonImage,
		outline = buttonImageOutline,
		text = "Hold to copy",
		color = {0, 1, 1},
		currentColor = {0.15, 0.15, 0.15}
	},
	{
		image = buttonImage,
		outline = buttonImageOutline,
		text = "Hold to Quit",
		color = {1, 0.5, 0},
		currentColor = {0.15, 0.15, 0.15}
	}
}


errorm.image = love.graphics.newImage("assets/textures/gui/title/brokenRune.png")
errorm.copied = false

function update()
	dt = love.timer.getDelta()
    local x, y = love.mouse.getPosition()
    if x > love.graphics.getWidth() / 3 - (30 * scaleX) and x < love.graphics.getWidth() / 3 + (30 * scaleX) and y > love.graphics.getHeight() / 2 + (49 * scaleY) and y < love.graphics.getHeight() / 2 + (69 * scaleY) then
			for i = 1, 3 do
				local colorDifference = math.abs(errorm.button[1].currentColor[i] - errorm.button[1].color[i])
				local transitionSpeed = dt * 20 * colorDifference
				if errorm.button[1].currentColor[i] < errorm.button[1].color[i] then
					errorm.button[1].currentColor[i] = math.min(errorm.button[1].currentColor[i] + transitionSpeed, errorm.button[1].color[i])
				elseif errorm.button[1].currentColor[i] > errorm.button[1].color[i] then
					errorm.button[1].currentColor[i] = math.max(errorm.button[1].currentColor[i] - transitionSpeed, errorm.button[1].color[i])
				end
			end
        if love.mouse.isDown(1) == true then
            errorm.copied = true
            errorm.button[1].text = "Copied"
        end
    else
			for i = 1, 3 do
				local colorDifference = math.abs(errorm.button[1].currentColor[i] - 0.15)
				local transitionSpeed = dt * 10 * colorDifference
				if errorm.button[1].currentColor[i] < 0.15 then
					errorm.button[1].currentColor[i] = math.min(errorm.button[1].currentColor[i] + transitionSpeed, 0.15)
				elseif errorm.button[1].currentColor[i] > 0.15 then
					errorm.button[1].currentColor[i] = math.max(errorm.button[1].currentColor[i] - transitionSpeed, 0.15)
				end
			end
    end
	if x > love.graphics.getWidth() / 3 - (30 * scaleX) and x < love.graphics.getWidth() / 3 + (30 * scaleX) and y > love.graphics.getHeight() / 2 + (73 * scaleY) and y < love.graphics.getHeight() / 2 + (93 * scaleY) then
			for i = 1, 3 do
				local colorDifference = math.abs(errorm.button[2].currentColor[i] - errorm.button[2].color[i])
				local transitionSpeed = dt * 20 * colorDifference
				if errorm.button[2].currentColor[i] < errorm.button[2].color[i] then
					errorm.button[2].currentColor[i] = math.min(errorm.button[2].currentColor[i] + transitionSpeed, errorm.button[2].color[i])
				elseif errorm.button[2].currentColor[i] > errorm.button[2].color[i] then
					errorm.button[2].currentColor[i] = math.max(errorm.button[2].currentColor[i] - transitionSpeed, errorm.button[2].color[i])
				end
			end
        if love.mouse.isDown(1) == true then
            love.event.quit()
        end
    else
			for i = 1, 3 do
				local colorDifference = math.abs(errorm.button[2].currentColor[i] - 0.15)
				local transitionSpeed = dt * 10 * colorDifference
				if errorm.button[2].currentColor[i] < 0.15 then
					errorm.button[2].currentColor[i] = math.min(errorm.button[2].currentColor[i] + transitionSpeed, 0.15)
				elseif errorm.button[2].currentColor[i] > 0.15 then
					errorm.button[2].currentColor[i] = math.max(errorm.button[2].currentColor[i] - transitionSpeed, 0.15)
				end
			end
    end
end

local function error_printer(msg, layer)
	print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
end

function love.errorhandler(msg)
	msg = tostring(msg)

	error_printer(msg, 2)
    love.window.setTitle("Ruined | Error")
    errorm.title = "We are sorry, it looks like we run in to a error."

	if not love.window or not love.graphics or not love.event then
		return
	end

	if not love.graphics.isCreated() or not love.window.isOpen() then
		local success, status = pcall(love.window.setMode, 800, 600, {resizable = false})
		if not success or not status then
			return
		end
	end

	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
		love.mouse.setRelativeMode(false)
		if love.mouse.isCursorSupported() then
			love.mouse.setCursor()
		end
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end

	love.graphics.reset()
	local font = love.graphics.setNewFont(14)
	font:setFilter("nearest", "nearest")

	love.graphics.setColor(1, 1, 1, 1)

	local trace = debug.traceback()

	love.graphics.origin()

	local sanitizedmsg = {}
	for char in msg:gmatch(utf8.charpattern) do
		table.insert(sanitizedmsg, char)
	end
	sanitizedmsg = table.concat(sanitizedmsg)

	local err = {}

	table.insert(err, sanitizedmsg)

	if #sanitizedmsg ~= #msg then
		table.insert(err, "Invalid UTF-8 string in error message.")
	end

	table.insert(err, "\n")

	for l in trace:gmatch("(.-)\n") do
		if not l:match("boot.lua") then
			l = l:gsub("stack traceback:", "Traceback\n")
			table.insert(err, l)
		end
	end

	local p = table.concat(err, "\n")

	p = p:gsub("\t", "")
	p = p:gsub("%[string \"(.-)\"%]", "%1")

	local function draw()
        update(dt)
		local pos = 70
        scaleX = 6 / 1200 * love.graphics.getWidth()
        scaleY = 6 / 1200 * love.graphics.getHeight()
        love.graphics.draw(errorm.background, 0, 0, nil, scaleX, scaleY)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(errorm.title, love.graphics.getWidth() / 2 - font:getWidth(p) / 2, pos, nil, 1.5)
        love.graphics.setColor(0.5, 0.5, 0.5)
		love.graphics.printf(p, love.graphics.getWidth() / 2 - font:getWidth(p) / 2, pos + 40, love.graphics.getWidth() - pos)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(errorm.help, love.graphics.getWidth() / 2 - font:getWidth(p) / 2, pos + 200)
		love.graphics.draw(errorm.image, love.graphics.getWidth() - (errorm.image:getWidth() * scaleX), love.graphics.getHeight() - (errorm.image:getHeight() * scaleY), nil, scaleY, scaleY)
		love.graphics.draw(errorm.button[1].image, love.graphics.getWidth() / 3 - (30 * scaleX), love.graphics.getHeight() / 2 + (49 * scaleY), nil, 3)
        love.graphics.setColor(errorm.button[1].currentColor)
		love.graphics.draw(errorm.button[1].outline, love.graphics.getWidth() / 3 - (30 * scaleX), love.graphics.getHeight() / 2 + (49 * scaleY), nil, 3)
        love.graphics.print(errorm.button[1].text, love.graphics.getWidth() / 3 - (30 * scaleX), love.graphics.getHeight() / 2 + (51 * scaleY))
		love.graphics.setColor(1, 1, 1)
		love.graphics.draw(errorm.button[2].image, love.graphics.getWidth() / 3 - (30 * scaleX), love.graphics.getHeight() / 2 + (73 * scaleY), nil, 3)
        love.graphics.setColor(errorm.button[2].currentColor)
		love.graphics.draw(errorm.button[2].outline, love.graphics.getWidth() / 3 - (30 * scaleX), love.graphics.getHeight() / 2 + (73 * scaleY), nil, 3)
        love.graphics.print(errorm.button[2].text, love.graphics.getWidth() / 3 - (30 * scaleX), love.graphics.getHeight() / 2 + (75 * scaleY))
        love.graphics.setColor(1, 1, 1)
		love.graphics.present()
	end

	local fullErrorText = p
	local function copyToClipboard()
		if not love.system then return end
		love.system.setClipboardText(fullErrorText)
        errorm.help = "\nCopied to clipboard! please send it to Mikert."
        print("[Info  ] Added to clipboard")
		draw()
	end

	if love.system then
        errorm.help = "\n\nDo you want to help the Developer solve this bug?\nPlease use Ctrl+C or click button to copy this error and send it to Mikert."
	end

	return function()
		love.event.pump()
        if errorm.copied == true then -- temp button copy
            errorm.copied = false
            copyToClipboard()
        end

		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return 1
			elseif e == "keypressed" and a == "escape" then
				return 1
			elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
				copyToClipboard()
			elseif e == "touchpressed" then
				local name = love.window.getTitle()
				if #name == 0 or name == "Untitled" then name = "Game" end
				local buttons = {"OK", "Cancel"}
				if love.system then
					buttons[3] = "Copy to clipboard"
				end
				local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
				if pressed == 1 then
					return 1
				elseif pressed == 3 then
					copyToClipboard()
				end
			end
		end

		draw()

		if love.timer then
			love.timer.sleep(0.1)
		end
	end

end