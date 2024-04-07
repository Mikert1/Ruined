local button = {}
button.__index = button
local buttonImage = love.graphics.newImage("assets/textures/gui/title/button.png")
local buttonImageOutline = love.graphics.newImage("assets/textures/gui/title/buttonOutline.png")

local file
local settings
local title

function button.load()
    file = require("source/data")
    settings = require("source/screens/settings")
    title = require("source/screens/title")
end

button.activeButtons = {}

function button.new(x, y, text, color, id)
    local self = setmetatable({}, button)
    self.x = x
    self.y = y
    self.id = id
    self.width = 80
    self.height = 20
    self.image = buttonImage
    self.imageOutline = buttonImageOutline
    self.color = color
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
        print("Button 3 clicked")
        print(settings.tab)
        if settings.tab == "skin" then
            settings.tab = "game"
        else
            if game.esc == true then
                title.state = 5
            else
                love.window.setTitle("Ruined | Title Screen")
                if title.mainColor[3] == 0 then
                    title.state = 2
                else
                    title.state = 1
                    --fix there will be the finaly (3)
                end
            end
        end
        settings.load()
    elseif self.id == 4 then -- removes texture pack
        file.settings.removeTexturePack()
    end
end

function button:update()
    local x = love.mouse.getX()
    local y = love.mouse.getY()
    if x > love.graphics.getWidth() / 2 + (self.x * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + ((self.x + self.width) * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (self.y * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + ((self.y + self.height) * playerCamera.globalScale) then
        self.hover = true
        if love.mouse.isDown(1) then
            if self.clicked == false then
                self.clicked = true
                print("Button clicked")
                self:action(self.id)
            end
        else
            self.clicked = false
        end
    else
        self.hover = false
    end
end

function button:draw(image, x, y)
    love.graphics.draw(self.image, love.graphics.getWidth() / 2 + (x * playerCamera.globalScale), love.graphics.getHeight() / 2 + (y * playerCamera.globalScale) , nil, playerCamera.globalScale)
    if self.hover then
        love.graphics.setColor(self.color[1], self.color[2], self.color[3])
    else
        love.graphics.setColor(0.15, 0.15, 0.15)
    end
    love.graphics.draw(self.imageOutline, love.graphics.getWidth() / 2 + (x * playerCamera.globalScale), love.graphics.getHeight() / 2 + (y * playerCamera.globalScale) , nil, playerCamera.globalScale)
    love.graphics.print(self.text, love.graphics.getWidth() / 2 + ((x + 40) * playerCamera.globalScale) - (font:getWidth(self.text) * playerCamera.globalScale) / 2, love.graphics.getHeight() / 2 + ((y + 10) * playerCamera.globalScale) - (font:getHeight(self.text) * playerCamera.globalScale) / 2, nil, playerCamera.globalScale)
    love.graphics.setColor(1, 1, 1)
end

function button:UpdateAll()
    for _, button in ipairs(button.activeButtons) do
        button:update(love.mouse.getX(), love.mouse.getY())
    end
end

function button:drawAll()
    for _, button in ipairs(button.activeButtons) do
        button:draw(button.image, button.x, button.y)
    end
end

return button