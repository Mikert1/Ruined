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

function button.new(x, y, text, color, id)
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
    self.hover = false
    self.clicked = true
    return self
end

function button.specialNew(x, y, text, color, id, image, outline)
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
    self.text = text
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
    end
end

function button:update(dt)
    local x = love.mouse.getX()
    local y = love.mouse.getY()
    if x > love.graphics.getWidth() / 2 + (self.x * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + ((self.x + self.width) * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (self.y * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + ((self.y + self.height) * playerCamera.globalScale) then
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

function button:draw(image, x, y)
    love.graphics.draw(self.image, love.graphics.getWidth() / 2 + (x * playerCamera.globalScale), love.graphics.getHeight() / 2 + (y * playerCamera.globalScale) , nil, playerCamera.globalScale)
    love.graphics.setColor(self.currentColor[1], self.currentColor[2], self.currentColor[3])
    love.graphics.draw(self.imageOutline, love.graphics.getWidth() / 2 + (x * playerCamera.globalScale), love.graphics.getHeight() / 2 + (y * playerCamera.globalScale) , nil, playerCamera.globalScale)
    love.graphics.print(self.text, love.graphics.getWidth() / 2 + ((x + 40) * playerCamera.globalScale) - (font:getWidth(self.text) * playerCamera.globalScale) / 2, love.graphics.getHeight() / 2 + ((y + 10) * playerCamera.globalScale) - (font:getHeight(self.text) * playerCamera.globalScale) / 2, nil, playerCamera.globalScale)
    love.graphics.setColor(1, 1, 1)
end

function button:UpdateAll(dt)
    for _, button in ipairs(button.activeButtons) do
        button:update(dt)
    end
end

function button:drawAll()
    for _, button in ipairs(button.activeButtons) do
        button:draw(button.image, button.x, button.y)
    end
end

return button