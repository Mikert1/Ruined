local button = {}
button.__index = button
local anim8 = require("assets/library/animations")
local buttonImage = love.graphics.newImage("assets/textures/gui/title/button.png")
local buttonGrid = anim8.newGrid( 80, 20, buttonImage:getWidth(), buttonImage:getHeight() )
local buttonAnimations = {}
buttonAnimations.normal = anim8.newAnimation( buttonGrid('1-1', 1), 1 )
buttonAnimations.hover = anim8.newAnimation( buttonGrid('1-1', 2), 1 )

button.activeButtons = {}

function button.new(x, y, text, color, id)
    local self = setmetatable({}, button)
    self.x = x
    self.y = y
    self.id = id
    self.width = 80
    self.height = 20
    self.image = buttonImage
    self.animations = buttonAnimations.normal
    self.color = color
    self.text = text
    return self
end

local function action(id)
    print("Button clicked")
    --do whatever you want to do when the button is clicked
    if id == 1 then
        print("Button 1 clicked")
    elseif id == 2 then
        print("Button 2 clicked")
    end
end

function button:update()
    local x = love.mouse.getX()
    local y = love.mouse.getY()
    if x > love.graphics.getWidth() / 2 + (self.x * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + ((self.x + self.width) * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (self.y * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + ((self.y + self.height) * playerCamera.globalScale) then
        self.animations = buttonAnimations.hover
        if love.mouse.isDown(1) then
            print("Button clicked")
            action(self.id)
        end
    else
        self.animations = buttonAnimations.normal
    end
end

function button:draw(image, x, y)
    self.animations:draw(self.image, love.graphics.getWidth() / 2 + (x * playerCamera.globalScale), love.graphics.getHeight() / 2 + (y * playerCamera.globalScale) , nil, playerCamera.globalScale)
    love.graphics.setColor(self.color[1], self.color[2], self.color[3])
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