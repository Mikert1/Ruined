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
local preview
local worldManagement
if love.joystick.getJoystickCount() > 0 then
    joystick = love.joystick.getJoysticks()[1]
end

function button.load()
    file = require("source/data")
    preview = file.show()
    settings = require("source/screens/settings")
    title = require("source/screens/title")
    gui = require("source/gui")
    worldManagement = require("source/worlds")
end

button.activeButtons = {}

function button.loadAll()
    button.activeButtons = {}
    settings.scroll = 0
    if title.state == 5 then
        if game.esc == true then
            button.new(-40, -25, "Title screen", {1, 0, 0}, 5) -- back from skin to settings
            button.new(-40, 0, "Settings", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 6) -- back from skin to settings
            button.new(-40, 25, "Resume", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 7) -- back from skin to settings
            button.first()
        end
    elseif title.state == 4 then
        button.specialNew(-127, -88, settings.mainButtons.game, {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 101, settings.button, settings.buttonOutline)
        button.specialNew(-84, -88, settings.mainButtons.video, {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 102, settings.button, settings.buttonOutline)
        button.specialNew(-41, -88, settings.mainButtons.controls, {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 103, settings.button, settings.buttonOutline)
        button.specialNew(2, -88, settings.mainButtons.customize, {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 104, settings.button, settings.buttonOutline)
        button.specialNew(45, -88, settings.mainButtons.audio, {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 105, settings.button, settings.buttonOutline)
        button.specialNew(88, -88, settings.mainButtons.a, {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 106, settings.button, settings.buttonOutline)
        if settings.tab == "game" then
            if savedSettings.devmode == true then
                if savedSettings.console == true then
                    button.new(-40, -53, "Enabled", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 16, "Auto Open Console") -- Console
                else
                    button.new(-40, -53, "Disabled", {1, 0, 0}, 16, "Auto Open Console") -- Console
                end
                button.new(-127, -53, "Enabled", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 1, "Developer Mode") -- devmode
            else
                button.new(-127, -53, "Disabled", {1, 0, 0}, 1, "Developer Mode") -- devmode
            end
            -- button.new(48, -53, "Customize", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 2, "Skin - Beta") -- skin
            -- 
            button.new(-40, 70, "Back", {1, 0, 0}, 3) -- back from settings to main menu or game
        elseif settings.tab == "video" then
            print(savedSettings.window)
            if savedSettings.window == 0 then
                button.new(-127, -53, "Windowed", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 20, "Window Type:") -- fullscreen
            elseif savedSettings.window == 1 then
                button.new(-127, -53, "Fullscreen", {1, 0, 0}, 20, "Window Type:") -- fullscreen
            elseif savedSettings.window == 2 then
                button.new(-127, -53, "Borderless", {1, 0, 0}, 20, "Window Type:") -- fullscreen
            end
            -- button.new(-128, -18, love.graphics.getWidth() .. "x" .. love.graphics.getHeight(), {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 21, "Resolution") -- resolution
            -- 
            button.new(-40, 70, "Back", {1, 0, 0}, 3) -- back from settings to main menu or game
        elseif settings.tab == "controls" then
            button.new(-127, -53, "Key: " .. string.upper(controls.keys.interact) .. " ", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 25, "Interact", true) -- reset controls
            button.new(-127, -18, "Key: " .. string.upper(controls.keys.map) .. " ", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 26, "Map", true) -- reset controls
            button.new(-127, 17, "Key: " .. string.upper(controls.keys.focus) .. " ", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 27, "Focus", true) -- reset controls
            button.new(-127, 52, "Key: " .. string.upper(controls.keys.switchWeapon) .. " ", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 28, "Switch Weapon", true) -- reset controls
            button.new(-124, 70, "Reset All", {1, 0, 0}, 24) -- remove saved skin
            button.new(-40, 70, "Back", {1, 0, 0}, 3) -- back from settings to main menu or game
        elseif settings.tab == "skin" then
            button.new(-124, 70, "Reset", {1, 0, 0}, 4) -- remove saved skin
            button.new(-40, 70, "Back", {1, 0, 0}, 3) -- back from skin to settings
        elseif settings.tab == "audio" then
            button.new(-40, 70, "Back", {1, 0, 0}, 3) -- back from settings to main menu or game
        elseif settings.tab == "stats" then
            button.new(-40, 70, "Back", {1, 0, 0}, 3) -- back from settings to main menu or game
        end
    elseif title.state == 1 or title.state == 2 or title.state == 3 then
        if title.delete.mode == false then
            if preview.file1.created == true then
                button.new(-128, 43, "Play", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 51) -- Button 1
            else
                button.new(-128, 43, "Create", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 51) -- Button 1
            end
            if preview.file2.created == true then
                button.new(-40, 43, "Play", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 52) -- Button 2
            else
                button.new(-40, 43, "Create", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 52) -- Button 2
            end
            if preview.file3.created == true then
                button.new(48, 43, "Play", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 53) -- Button 2
            else
                button.new(48, 43, "Create", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 53) -- Button 2
            end
        else
            if preview.file1.created == true then
                button.new(-128, 43, "Delete", {1, 0, 0}, 51) -- Button 1
            else
                button.new(-128, 43, "Empty", {0.15, 0.15, 0.15}, 51) -- Button 1
            end
            if preview.file2.created == true then
                button.new(-40, 43, "Delete", {1, 0, 0}, 52) -- Button 2
            else
                button.new(-40, 43, "Empty", {0.15, 0.15, 0.15}, 52) -- Button 2
            end
            if preview.file3.created == true then
                button.new(48, 43, "Delete", {1, 0, 0}, 53) -- Button 2
            else
                button.new(48, 43, "Empty", {0.15, 0.15, 0.15}, 53) -- Button 2
            end
        end
        button.new(-40, 70, "Back", {1, 0, 0}, 50) -- back to ruined
        button.first()
    end
end

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
    self.clicked = false
    self.scroll = scroll
    table.insert(button.activeButtons, self)
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
    self.clicked = false
    table.insert(button.activeButtons, self)
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
    elseif self.id == 50 then -- back to ruined
        title.state = 0
        button.loadAll()
    elseif self.id == 51 then -- play button
        if title.delete.mode == true then
            love.filesystem.remove("savegame1.json")
            love.filesystem.remove("previewcard1.json")
            file.show()
            title.rezet()
            button.loadAll()
        else
            file.filenumber = 1
            game.state = 0
            data = file.load()
            worldManagement.teleport("start")
            game.freeze = false
            title.state = 5
            game.esc = false
            data = file.save()
            player.noMove = false
            button.loadAll()
        end
    elseif self.id == 52 then -- play button
        if title.delete.mode == true then
            love.filesystem.remove("savegame2.json")
            love.filesystem.remove("previewcard2.json")
            file.show()
            title.rezet()
            button.loadAll()
        else
            file.filenumber = 2
            game.state = 0
            data = file.load()
            worldManagement.teleport("start")
            game.freeze = false
            title.state = 5
            game.esc = false
            data = file.save()
            player.noMove = false
            button.loadAll()
        end
    elseif self.id == 53 then -- play button
        if title.delete.mode == true then
            love.filesystem.remove("savegame3.json")
            love.filesystem.remove("previewcard3.json")
            file.show()
            title.rezet()
            button.loadAll()
        else
            file.filenumber = 3
            game.state = 0
            data = file.load()
            worldManagement.teleport("start")
            game.freeze = false
            title.state = 5
            game.esc = false
            data = file.save()
            player.noMove = false
            button.loadAll()
        end
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
                    self.clicked = true
                else
                    if self.clicked == true then
                        self.clicked = false
                        self:action(self.id)
                    end
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