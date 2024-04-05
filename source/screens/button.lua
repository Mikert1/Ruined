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
    self.width = buttonImage:getWidth()
    self.height = buttonImage:getHeight()
    self.image = buttonImage
    self.animations = buttonAnimations.normal
    self.color = color
    self.text = text
    self.currentAnimation = self.animations.normal
    return self
end


function button:update(x, y)
    if self.x < x and x < self.x + self.width and self.y < y and y < self.y + self.height then
        self.currentAnimation = self.animations.hover
        if love.mouse.isDown(1) then
            --do whatever you want to do when the button is clicked
        end
    else
        self.currentAnimation = self.animations.normal
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