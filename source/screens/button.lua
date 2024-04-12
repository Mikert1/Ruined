local button = {}
button.__index = button
local buttonImage = love.graphics.newImage("assets/textures/gui/title/button.png")
local buttonImageOutline = love.graphics.newImage("assets/textures/gui/title/buttonOutline.png")

local file
local settings
local title
local gui

function button.load()
    file = require("source/data")
    settings = require("source/screens/settings")
    title = require("source/screens/title")
    gui = require("source/gui")
end

button.activeButtons = {}

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
            print("Console is active")
            self.color = {0, 1, 1}
            self.text = "True"
        else
            savedSettings.devmode = false
            print("Console is deactivated --restart game to take effect")
            self.color = {1, 0, 0}
            self.text = "False"
        end
        file.settings.save()
    elseif self.id == 2 then -- opens skin change setting menu
        settings.tab = "skin"
        settings.load()
    elseif self.id == 3 then -- back button on settings screen
        if settings.tab == "skin" then
            settings.tab = "game"
            settings.load()
        else
            if game.esc == true then
                title.state = 5
                gui.buttonLoad()
            else
                love.window.setTitle("Ruined | Title Screen")
                if title.mainColor[3] == 0 then
                    title.state = 2
                else
                    title.state = 1
                    --fix there will be the finaly (3)
                end
                settings.load()
                gui.buttonLoad()
            end
        end
    elseif self.id == 4 then -- removes texture pack
        file.settings.removeTexturePack()
    elseif self.id == 5 then -- back to title screen
        game.esc = false
        love.window.setTitle("Ruined | Title Screen")
        keys.esc = false
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
        gui.buttonLoad()
    elseif self.id == 6 then -- settings button
        title.settings.anim = title.settings.animations.normal
        love.window.setTitle("Ruined | Settings")
        title.state = 4
        settings.load()
    elseif self.id == 7 then -- resume button
        game.esc = false
        game.freeze = false
        keys.esc = false
        player.noMove = false
        gui.buttonLoad()
    elseif self.id == 11 then -- quit button
        settings.tab = "game"
        settings.load()
    elseif self.id == 12 then -- video button
        settings.tab = "video"
        settings.load()
    elseif self.id == 13 then -- controls button
        settings.tab = "controls"
        settings.load()
        settings.scroll = 0
    elseif self.id == 14 then -- controls button
        settings.tab = "skin"
        settings.load()
    elseif self.id == 15 then -- controls button
        settings.tab = "audio"
        settings.load()
    elseif self.id == 16 then -- controls button
        settings.tab = "stats"
        settings.load()
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

    elseif self.id == 24 then -- antialiasing button

    elseif self.id == 25 then -- texture pack button
        settings.tab = "texture"
        settings.load()
    elseif self.id == 26 then -- reset controls button
        controls.searchForKey = "map"
        self.text = "Search for key"
    end
end

function button:update(dt)
    local x = love.mouse.getX()
    local y = love.mouse.getY()
    local modifiedY = self.y
    if self.scroll then
        modifiedY = self.y + settings.scroll
    end
    if not self.scroll or (x > love.graphics.getWidth() / 2 + (-127 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (127 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (-61 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (64 * playerCamera.globalScale)) then
        if x > love.graphics.getWidth() / 2 + (self.x * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + ((self.x + self.width) * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (modifiedY * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + ((modifiedY + self.height) * playerCamera.globalScale) then
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

function button:draw()
    love.graphics.stencil(function() 
        love.graphics.rectangle(
            "fill", 
            love.graphics.getWidth() / 2 + (-127 * playerCamera.globalScale), 
            love.graphics.getHeight() / 2 + (-61 * playerCamera.globalScale), 
            254 * playerCamera.globalScale,
            125 * playerCamera.globalScale
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
end

function button:drawAll()
    for _, button in ipairs(button.activeButtons) do
        button:draw()
    end
end

return button