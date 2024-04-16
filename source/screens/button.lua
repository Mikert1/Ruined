local button = {}
button.__index = button
local buttonImage = love.graphics.newImage("assets/textures/gui/title/button.png")
local buttonImageOutline = love.graphics.newImage("assets/textures/gui/title/buttonOutline.png")

local file
local settings
local title
local gui
local joystick
local closestButtonId = nil
local moving = false
if love.joystick.getJoystickCount() > 0 then
    joystick = love.joystick.getJoysticks()[1]
end

function button.load()
    file = require("source/data")
    settings = require("source/screens/settings")
    title = require("source/screens/title")
    gui = require("source/gui")
end

function button.loadAll()
    button.activeButtons = {}
    if title.state == 5 then
        if game.esc == true then
            local newButton
            newButton = button.new(-40, -25, "Title screen", {1, 0, 0}, 5) -- back from skin to settings
            table.insert(button.activeButtons, newButton)
            newButton = button.new(-40, 0, "Settings", {0, 1, 1}, 6) -- back from skin to settings\
            table.insert(button.activeButtons, newButton)
            newButton = button.new(-40, 25, "Resume", {0, 1, 1}, 7) -- back from skin to settings
            table.insert(button.activeButtons, newButton)
            button.first()
        end
    elseif title.state == 4 then
        local newButton
        newButton = button.specialNew(-127, -88, settings.mainButtons.game, {0, 1, 1}, 101, settings.button,
            settings.buttonOutline)
        table.insert(button.activeButtons, newButton)
        newButton = button.specialNew(-84, -88, settings.mainButtons.video, {0, 1, 1}, 102, settings.button,
            settings.buttonOutline)
        table.insert(button.activeButtons, newButton)
        newButton = button.specialNew(-41, -88, settings.mainButtons.controls, {0, 1, 1}, 103, settings.button,
            settings.buttonOutline)
        table.insert(button.activeButtons, newButton)
        newButton = button.specialNew(2, -88, settings.mainButtons.customize, {0, 1, 1}, 104, settings.button,
            settings.buttonOutline)
        table.insert(button.activeButtons, newButton)
        newButton = button.specialNew(45, -88, settings.mainButtons.audio, {0, 1, 1}, 105, settings.button,
            settings.buttonOutline)
        table.insert(button.activeButtons, newButton)
        newButton = button.specialNew(88, -88, settings.mainButtons.a, {0, 1, 1}, 106, settings.button,
            settings.buttonOutline)
        table.insert(button.activeButtons, newButton)
        if title.state == 4 then
            if settings.tab == "game" then
                if savedSettings.devmode == true then
                    if savedSettings.console == true then
                        newButton = button.new(-40, -53, "Enabled", {0, 1, 1}, 16, "Auto Open Console") -- Console
                    else
                        newButton = button.new(-40, -53, "Disabled", {1, 0, 0}, 16, "Auto Open Console") -- Console
                    end
                    table.insert(button.activeButtons, newButton)
                    newButton = button.new(-127, -53, "Enabled", {0, 1, 1}, 1, "Developer Mode") -- devmode
                else
                    newButton = button.new(-127, -53, "Disabled", {1, 0, 0}, 1, "Developer Mode") -- devmode
                end
                table.insert(button.activeButtons, newButton)
                -- newButton = button.new(48, -53, "Customize", {0, 1, 1}, 2, "Skin - Beta") -- skin
                -- table.insert(button.activeButtons, newButton)
                newButton = button.new(-40, 70, "Back", {1, 0, 0}, 3) -- back from settings to main menu or game
                table.insert(button.activeButtons, newButton)
            elseif settings.tab == "video" then
                print(savedSettings.window)
                if savedSettings.window == 0 then
                    newButton = button.new(-127, -53, "Windowed", {0, 1, 1}, 20, "Window Type:") -- fullscreen
                elseif savedSettings.window == 1 then
                    newButton = button.new(-127, -53, "Fullscreen", {1, 0, 0}, 20, "Window Type:") -- fullscreen
                elseif savedSettings.window == 2 then
                    newButton = button.new(-127, -53, "Borderless", {1, 0, 0}, 20, "Window Type:") -- fullscreen
                end
                table.insert(button.activeButtons, newButton)
                -- newButton = button.new(-128, -18, love.graphics.getWidth() .. "x" .. love.graphics.getHeight(), {0, 1, 1}, 21, "Resolution") -- resolution
                -- table.insert(button.activeButtons, newButton)
                newButton = button.new(-40, 70, "Back", {1, 0, 0}, 3) -- back from settings to main menu or game
                table.insert(button.activeButtons, newButton)
            elseif settings.tab == "controls" then
                newButton = button.new(-127, -53, "Key: " .. string.upper(controls.keys.interact) .. " ", {0, 1, 1}, 25, "Interact", true) -- reset controls
                table.insert(button.activeButtons, newButton)
                newButton = button.new(-127, -18, "Key: " .. string.upper(controls.keys.map) .. " ", {0, 1, 1}, 26, "Map", true) -- reset controls
                table.insert(button.activeButtons, newButton)
                newButton = button.new(-127, 17, "Key: " .. string.upper(controls.keys.focus) .. " ", {0, 1, 1}, 27, "Focus", true) -- reset controls
                table.insert(button.activeButtons, newButton)
                newButton = button.new(-127, 52, "Key: " .. string.upper(controls.keys.switchWeapon) .. " ", {0, 1, 1}, 28, "Switch Weapon", true) -- reset controls
                table.insert(button.activeButtons, newButton)
                newButton = button.new(-124, 70, "Reset All", {1, 0, 0}, 24) -- remove saved skin
                table.insert(button.activeButtons, newButton)
                newButton = button.new(-40, 70, "Back", {1, 0, 0}, 3) -- back from settings to main menu or game
                table.insert(button.activeButtons, newButton)
            elseif settings.tab == "skin" then
                newButton = button.new(-124, 70, "Reset", {1, 0, 0}, 4) -- remove saved skin
                table.insert(button.activeButtons, newButton)
                newButton = button.new(-40, 70, "Back", {1, 0, 0}, 3) -- back from skin to settings
                table.insert(button.activeButtons, newButton)
            elseif settings.tab == "audio" then
                newButton = button.new(-40, 70, "Back", {1, 0, 0}, 3) -- back from settings to main menu or game
                table.insert(button.activeButtons, newButton)
            elseif settings.tab == "stats" then
                newButton = button.new(-40, 70, "Back", {1, 0, 0}, 3) -- back from settings to main menu or game
                table.insert(button.activeButtons, newButton)
            end
        end
        button.first()
    end
end

button.activeButtons = {}

function button.first()
    if game.controlType == 1 then
        local closestDistance = math.huge

        for _, btn in ipairs(button.activeButtons) do
            local distance = math.abs(btn.id - 0)
            if distance < closestDistance then
                closestButtonId = btn.id
                closestDistance = distance
            end
        end

        if closestButtonId then
            print("Closest button id:", closestButtonId)
        else
            print("No buttons found")
        end
    end
end

function button.new(x, y, text, color, id, info, scroll)
    local self = setmetatable({}, button)
    self.x = x
    self.y = y
    self.id = id
    self.image = buttonImage
    self.width = buttonImage:getWidth()
    self.height = buttonImage:getHeight()
    self.imageOutline = buttonImageOutline
    self.color = color
    self.currentColor = {0.15, 0.15, 0.15}
    self.text = text
    self.info = info
    self.hover = false
    self.clicked = true
    self.scroll = scroll
    return self
end

function button.specialNew(x, y, imageOnButton, color, id, image, outline)
    local self = setmetatable({}, button)
    self.x = x
    self.y = y
    self.id = id
    self.image = image
    self.width = image:getWidth()
    self.height = image:getHeight()
    self.imageOutline = outline
    self.color = color
    self.currentColor = {0.15, 0.15, 0.15}
    self.imageOnButton = imageOnButton
    self.hover = false
    self.clicked = true
    return self
end

function button:action()
    if self.id == 1 then -- disables or enables devmode
        if savedSettings.devmode == false then
            savedSettings.devmode = true
            button.loadAll()
        else
            savedSettings.devmode = false
            button.loadAll()
        end
        file.settings.save()
    elseif self.id == 16 then -- auto open console
        if savedSettings.console == false then
            savedSettings.console = true
            button.loadAll()
        else
            savedSettings.console = false
            button.loadAll()
        end
        file.settings.save()
    elseif self.id == 2 then -- opens skin change setting menu
        settings.tab = "skin"
        button.loadAll()
    elseif self.id == 3 then -- back button on settings screen
        if settings.tab == "skin" then
            settings.tab = "game"
            button.loadAll()
        else
            if game.esc == true then
                title.state = 5
                button.loadAll()
            else
                love.window.setTitle("Ruined | Title Screen")
                if title.mainColor[3] == 0 then
                    title.state = 2
                else
                    title.state = 1
                    --fix there will be the finaly (3)
                end
                button.loadAll()
                button.loadAll()
            end
        end
    elseif self.id == 4 then -- removes texture pack
        file.settings.removeTexturePack()
    elseif self.id == 5 then -- back to title screen
        game.esc = false
        love.window.setTitle("Ruined | Title Screen")
        game.freeze = false
        --data = file.save()
        title.rezet()
        enemymanager:load()
        game.state = 1
        if title.mainColor[3] == 0 then
            title.state = 2
        else
            title.state = 1
            --fix there will be the finaly (3)
        end
        button.loadAll()
    elseif self.id == 6 then -- settings button
        title.settings.anim = title.settings.animations.normal
        love.window.setTitle("Ruined | Settings")
        title.state = 4
        button.loadAll()
    elseif self.id == 7 then -- resume button
        game.esc = false
        game.freeze = false
        player.noMove = false
        button.loadAll()
    elseif self.id == 101 then -- quit button
        settings.tab = "game"
        settings.scroll = 0
        button.loadAll()
    elseif self.id == 102 then -- video button
        settings.tab = "video"
        settings.scroll = 0
        button.loadAll()
    elseif self.id == 103 then -- controls button
        settings.tab = "controls"
        settings.scroll = 0
        button.loadAll()
    elseif self.id == 104 then -- skin button
        settings.tab = "skin"
        settings.scroll = 0
        button.loadAll()
    elseif self.id == 105 then -- audio button
        settings.tab = "audio"
        settings.scroll = 0
        button.loadAll()
    elseif self.id == 106 then -- stats button
        settings.tab = "stats"
        settings.scroll = 0
        button.loadAll()
    elseif self.id == 20 then -- fullscreen button
        if savedSettings.window == 0 then
            love.window.setFullscreen(true)
            savedSettings.window = 1
            self.text = "Fullscreen"
        elseif savedSettings.window == 1 then
            love.window.setFullscreen(false)
            love.window.setMode(love.graphics.getWidth(), love.graphics.getHeight(), {borderless = true, resizable = true})
            savedSettings.window = 2
            self.text = "Borderless"
        elseif savedSettings.window == 2 then
            love.window.setMode(love.graphics.getWidth(), love.graphics.getHeight(), {borderless = false, resizable = true}) 
            savedSettings.window = 0
            self.text = "Windowed"
        end
        file.settings.save()
    elseif self.id == 21 then -- resolution button

    elseif self.id == 22 then -- vsync button
        if savedSettings.vsync == false then
            savedSettings.vsync = true
            self.text = "Enabled"
        else
            savedSettings.vsync = false
            self.text = "Disabled"
        end
        file.settings.save()
    elseif self.id == 23 then -- fps button

    elseif self.id == 24 then -- Rezet all Keybind button
        controls.keys = controls.default
        controls.save()
        button.loadAll()
    elseif self.id == 25 then -- keybind button
        controls.searchForKey = "interact"
        self.text = "Press key"
    elseif self.id == 26 then -- keybind button
        controls.searchForKey = "map"
        self.text = "Press key"
    elseif self.id == 27 then -- keybind button
        controls.searchForKey = "focus"
        self.text = "Press key"
    elseif self.id == 28 then -- keybind button
        controls.searchForKey = "switchWeapon"
        self.text = "Press key"
    end
end

function button:update(dt)
    if game.controlType == 0 then
        local x = love.mouse.getX()
        local y = love.mouse.getY()
        local modifiedY = self.y
        if self.scroll then
            modifiedY = self.y + settings.scroll
        end
        if not self.scroll or (
            x > love.graphics.getWidth() / 2 + (-127 * playerCamera.globalScale) and
            x < love.graphics.getWidth() / 2 + (127 * playerCamera.globalScale) and
            y > love.graphics.getHeight() / 2 + (-61 * playerCamera.globalScale) and
            y < love.graphics.getHeight() / 2 + (69 * playerCamera.globalScale)
        ) then
            if 
                x > love.graphics.getWidth() / 2 + (self.x * playerCamera.globalScale) and
                x < love.graphics.getWidth() / 2 + ((self.x + self.width) * playerCamera.globalScale) and
                y > love.graphics.getHeight() / 2 + (modifiedY * playerCamera.globalScale) and
                y < love.graphics.getHeight() / 2 + ((modifiedY + self.height) * playerCamera.globalScale)
            then
                self.hover = true
                if love.mouse.isDown(1) then
                    if self.clicked == false then
                        self.clicked = true
                        self:action(self.id)
                    end
                else
                    self.clicked = false
                end
            else
                self.hover = false
            end
        else
            self.hover = false
        end
    end
    if self.hover then
        for i = 1, 3 do
            if self.currentColor[i] < self.color[i] then
                self.currentColor[i] = self.currentColor[i] + (dt * 4)
                if self.currentColor[i] > self.color[i] then
                    self.currentColor[i] = self.color[i]
                end
            elseif self.currentColor[i] > self.color[i] then
                self.currentColor[i] = self.currentColor[i] - (dt * 4)
                if self.currentColor[i] < self.color[i] then
                    self.currentColor[i] = self.color[i]
                end
            end
        end
    else
        for i = 1, 3 do
            if self.currentColor[i] < 0.15 then
                self.currentColor[i] = self.currentColor[i] + (dt * 2)
                if self.currentColor[i] > 0.15 then
                    self.currentColor[i] = 0.15
                end
            elseif self.currentColor[i] > 0.15 then
                self.currentColor[i] = self.currentColor[i] - (dt * 2)
                if self.currentColor[i] < 0.15 then
                    self.currentColor[i] = 0.15
                end
            end
        end
    end
end

function button:handleJoystickInput()
    local dx = joystick:getGamepadAxis("leftx")
    local dy = joystick:getGamepadAxis("lefty")
    
    if closestButtonId then
        local btn
        for i, button in ipairs(button.activeButtons) do
            if button.id == closestButtonId then
                button.hover = true
                btn = button
            else
                button.hover = false
            end
        end
        if btn then
            if joystick:isGamepadDown("a") then
                if btn.clicked == false then
                    btn.clicked = true
                    btn:action(btn.id)
                end
            else
                btn.clicked = false
            end
        end
    end
    if math.abs(dx) > 0.5 or math.abs(dy) > 0.5 then
        if not moving then
            moving = true
            local closestDistance = math.huge
            local closestButtonIdCapture = closestButtonId
            for _, btn in ipairs(button.activeButtons) do
                local distanceX = math.abs(btn.x - dx)
                local distanceY = math.abs(btn.y - dy)
                local distance = math.sqrt(distanceX^2 + distanceY^2) -- Euclidean distance
                if btn.id ~= closestButtonIdCapture and distance < closestDistance then
                    -- Check if the closest button is in the direction of the current button
                    local directionX = dx - btn.x
                    local directionY = dy - btn.y
                    local dotProduct = directionX * btn.x + directionY * btn.y
                    print("Dot product:", dotProduct)
                    if dotProduct < 0 then
                        closestButtonId = btn.id
                        closestDistance = distance
                    end
                end
            end
    
            if closestButtonId then
                print("Closest button id:", closestButtonId)
            else
                print("No buttons found")
            end
        end
    else
        moving = false
    end
end


function button:draw()
    love.graphics.stencil(function()
        love.graphics.rectangle(
            "fill", 
            love.graphics.getWidth() / 2 + (-127 * playerCamera.globalScale), 
            love.graphics.getHeight() / 2 + (-61 * playerCamera.globalScale), 
            254 * playerCamera.globalScale,
            130 * playerCamera.globalScale
        )
    end, "replace", 1)
    local y = self.y
    if self.scroll then
        y = self.y + settings.scroll
        love.graphics.setStencilTest("greater", 0)
    end
    if self.info then
        love.graphics.setColor(0.1, 0.1, 0.1)
        love.graphics.print(
            self.info, 
            love.graphics.getWidth() / 2 + (self.x * playerCamera.globalScale), 
            love.graphics.getHeight() / 2 + (y * playerCamera.globalScale) - (self.image:getHeight() * playerCamera.globalScale * 0.5), 
            nil, 
            playerCamera.globalScale * 0.5
        )
        love.graphics.setColor(1, 1, 1)
    end
    love.graphics.draw(
        self.image, 
        love.graphics.getWidth() / 2 + (self.x * playerCamera.globalScale), 
        love.graphics.getHeight() / 2 + (y * playerCamera.globalScale), 
        nil, 
        playerCamera.globalScale
    )
    love.graphics.setColor(
        self.currentColor[1], 
        self.currentColor[2], 
        self.currentColor[3]
    )
    love.graphics.draw(
        self.imageOutline, 
        love.graphics.getWidth() / 2 + (self.x * playerCamera.globalScale), 
        love.graphics.getHeight() / 2 + (y * playerCamera.globalScale), 
        nil, 
        playerCamera.globalScale
    )
    if self.text then
        love.graphics.print(
            self.text, 
            love.graphics.getWidth() / 2 + ((self.x + 40) * playerCamera.globalScale) - (font:getWidth(self.text) * playerCamera.globalScale) / 2, 
            love.graphics.getHeight() / 2 + ((y + 10) * playerCamera.globalScale) - (font:getHeight(self.text) * playerCamera.globalScale) / 2, 
            nil, 
            playerCamera.globalScale
        )
    else
        love.graphics.draw(
            self.imageOnButton,
            love.graphics.getWidth() / 2 + (self.x * playerCamera.globalScale) + (self.width * playerCamera.globalScale) / 2 - (self.imageOnButton:getWidth() * playerCamera.globalScale) / 2, 
            love.graphics.getHeight() / 2 + (y * playerCamera.globalScale) + (self.height * playerCamera.globalScale) / 2 - (self.imageOnButton:getHeight() * playerCamera.globalScale) / 2, 
            nil, 
            playerCamera.globalScale
        )
    end
    love.graphics.setStencilTest()
    love.graphics.setColor(1, 1, 1)
end

function button:UpdateAll(dt)
    for _, button in ipairs(button.activeButtons) do
        button:update(dt)
    end
    if game.controlType == 1 then
        button:handleJoystickInput()
    end
end

function button:drawAll()
    for _, button in ipairs(button.activeButtons) do
        button:draw()
    end
end

return button