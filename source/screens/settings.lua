local settings = {}
local anim8 = require("assets/library/animations")
local title = require("source/screens/title")
local button = require("source/screens/button")
settings.mainButtons = {}
settings.mainButtons.game = love.graphics.newImage("assets/textures/gui/settings/game.png")
settings.mainButtons.video = love.graphics.newImage("assets/textures/gui/settings/video.png")
settings.mainButtons.controls = love.graphics.newImage("assets/textures/gui/settings/controls.png")
settings.mainButtons.audio = {}
settings.settings = "game"

function settings.load()
    button.activeButtons = {}
    local newButton = button.new(-128, -55, title.button.normal.animations, "True", font)
    table.insert(button.activeButtons, newButton)
    local newButton = button.new(48, -55, title.button.red.animations, "False", font)
    table.insert(button.activeButtons, newButton)
    local newButton = button.new(-40, 70, title.button.normal.animations, "Customize", font)
    table.insert(button.activeButtons, newButton)
end


function settings.update()

end

function settings.draw()
    love.graphics.draw(title.settingBackground, love.graphics.getWidth() / 2 - (title.settingBackground:getWidth() / 2) * playerCamera.globalScale, love.graphics.getHeight() / 2 - (title.settingBackground:getHeight() / 2) * playerCamera.globalScale, nil, playerCamera.globalScale)
    title.button.red.menu.button1:draw(title.button.red.image, love.graphics.getWidth() / 2 - (40 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (70 * playerCamera.globalScale) , nil, playerCamera.globalScale)
    if title.button.red.menu.button1 == title.button.red.animations.normal then
        love.graphics.setColor(0.15, 0.15, 0.15)
    else
        love.graphics.setColor(1, 0, 0)
    end
    love.graphics.print("Back",
        love.graphics.getWidth() / 2 - (font:getWidth("Back") / 2 * playerCamera.globalScale),
        love.graphics.getHeight() / 2 + (59 * playerCamera.globalScale) + (font:getHeight("Back") / 2 * playerCamera.globalScale),
        nil, playerCamera.globalScale
    )
    love.graphics.setColor(1, 1, 1)
    if title.texture == false then
        love.graphics.draw(settings.mainButtons.game, love.graphics.getWidth() / 2 - (126 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (88 * playerCamera.globalScale) , nil, playerCamera.globalScale * 0.9)
        love.graphics.draw(settings.mainButtons.video, love.graphics.getWidth() / 2 - (80 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (88 * playerCamera.globalScale) , nil, playerCamera.globalScale * 0.9)
        love.graphics.draw(settings.mainButtons.controls, love.graphics.getWidth() / 2 - (34 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (88 * playerCamera.globalScale) , nil, playerCamera.globalScale * 0.9)
        if settings.settings == "game" then
            love.graphics.print("Developer Mode", love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (66 * playerCamera.globalScale) , nil, playerCamera.globalScale * 0.5)
            if savedSettings.devmode == true then
                title.button.normal.menu.button2:draw(title.button.normal.image, love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (55 * playerCamera.globalScale) , nil, playerCamera.globalScale)
                if not(title.button.normal.menu.button2 == title.button.normal.animations.normal) then
                    love.graphics.setColor(title.mainColor)
                else
                    love.graphics.setColor(0.15, 0.15, 0.15)
                end
                love.graphics.print("True", love.graphics.getWidth() / 2 - (102 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (55 * playerCamera.globalScale), nil, playerCamera.globalScale)
            else
                title.button.red.menu.button2:draw(title.button.red.image, love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (55 * playerCamera.globalScale) , nil, playerCamera.globalScale)
                if not(title.button.red.menu.button2 == title.button.red.animations.normal) then
                    love.graphics.setColor(1, 0, 0)
                else
                    love.graphics.setColor(0.15, 0.15, 0.15)
                end
                love.graphics.print("False", love.graphics.getWidth() / 2 - (104 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (55 * playerCamera.globalScale), nil, playerCamera.globalScale)
            end
            love.graphics.setColor(1, 1, 1)
    
            love.graphics.print("Skin - beta", love.graphics.getWidth() / 2 + (48 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (66 * playerCamera.globalScale) , nil, playerCamera.globalScale * 0.5)
            title.button.normal.menu.button3:draw(title.button.normal.image, love.graphics.getWidth() / 2 + (48 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (55 * playerCamera.globalScale) , nil, playerCamera.globalScale)
            if not(title.button.normal.menu.button3 == title.button.normal.animations.normal) then
                love.graphics.setColor(title.mainColor)
            else
                love.graphics.setColor(0.15, 0.15, 0.15)
            end
            love.graphics.print("Customize", love.graphics.getWidth() / 2 + (58 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (55 * playerCamera.globalScale), nil, playerCamera.globalScale)
        elseif settings.settings == "video" then
            
        elseif settings.settings == "controls" then
            
        end
    else
        love.graphics.draw(player.spriteSheet, love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (75 * playerCamera.globalScale) , nil, playerCamera.globalScale * 0.9)
        love.graphics.draw(player.spriteSheetfocus, love.graphics.getWidth() / 2 + (48 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (75 * playerCamera.globalScale) , nil, playerCamera.globalScale * 0.9)
        love.graphics.print("Drop your file here.", love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (85 * playerCamera.globalScale))
        love.graphics.print("image 95x105 pixels (19x21 for every animation frame)", love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (80 * playerCamera.globalScale))
    end
    love.graphics.setColor(1, 1, 1)
end

return settings