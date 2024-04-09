local settings = {}
local anim8 = require("assets/library/animations")
local title = require("source/screens/title")
local button = require("source/screens/button")
settings.dropFileImage = love.graphics.newImage("assets/textures/gui/settings/drop.png")
settings.mainButtons = {}
settings.mainButtons.game = love.graphics.newImage("assets/textures/gui/settings/game.png")
settings.mainButtons.video = love.graphics.newImage("assets/textures/gui/settings/video.png")
settings.mainButtons.controls = love.graphics.newImage("assets/textures/gui/settings/controls.png")
settings.mainButtons.audio = {}
settings.tab = "game"

function settings.load()
    print("settings button load")
    local newButton
    button.activeButtons = {}
    if title.state == 4 then
        if settings.tab == "game" then
            if savedSettings.devmode == true then
                newButton = button.new(-128, -55, "True", {0, 1, 1}, 1) -- devmode
            else
                newButton = button.new(-128, -55, "False", {1, 0, 0}, 1) -- devmode
            end
            table.insert(button.activeButtons, newButton)
            newButton = button.new(48, -55, "Customize", {0, 1, 1}, 2) -- skin
            table.insert(button.activeButtons, newButton)
            newButton = button.new(-40, 70, "Back", {1, 0, 0}, 3) -- back from settings
            table.insert(button.activeButtons, newButton)
        elseif settings.tab == "video" then
            newButton = button.new(-40, 70, "Back", {1, 0, 0}, 3) -- back from skin to settings
            table.insert(button.activeButtons, newButton)
        elseif settings.tab == "controls" then
            newButton = button.new(-40, 70, "Back", {1, 0, 0}, 3) -- back from skin to settings
            table.insert(button.activeButtons, newButton)
        elseif settings.tab == "skin" then
            newButton = button.new(-124, 70, "Reset", {1, 0, 0}, 4) -- remove saved skin
            table.insert(button.activeButtons, newButton)
            newButton = button.new(-40, 70, "Back", {1, 0, 0}, 3) -- back from skin to settings
            table.insert(button.activeButtons, newButton)
        end
    end
end


function settings.update()
end

function settings.draw()
    print("settings update")
    love.graphics.draw(title.settingBackground, love.graphics.getWidth() / 2 - (title.settingBackground:getWidth() / 2) * playerCamera.globalScale, love.graphics.getHeight() / 2 - (title.settingBackground:getHeight() / 2) * playerCamera.globalScale, nil, playerCamera.globalScale)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(settings.mainButtons.game, love.graphics.getWidth() / 2 - (126 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (88 * playerCamera.globalScale) , nil, playerCamera.globalScale * 0.9)
    love.graphics.draw(settings.mainButtons.video, love.graphics.getWidth() / 2 - (80 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (88 * playerCamera.globalScale) , nil, playerCamera.globalScale * 0.9)
    love.graphics.draw(settings.mainButtons.controls, love.graphics.getWidth() / 2 - (34 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (88 * playerCamera.globalScale) , nil, playerCamera.globalScale * 0.9)
    if settings.tab == "game" then
        love.graphics.print("Developer Mode", love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (66 * playerCamera.globalScale) , nil, playerCamera.globalScale * 0.5)

        love.graphics.print("Skin - beta", love.graphics.getWidth() / 2 + (48 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (66 * playerCamera.globalScale) , nil, playerCamera.globalScale * 0.5)
    elseif settings.tab == "video" then
        
    elseif settings.tab == "controls" then
        
    elseif settings.tab == "skin" then
        love.graphics.print("preview", love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (66 * playerCamera.globalScale) , nil, playerCamera.globalScale * 0.5)
        love.graphics.draw(player.spriteSheet, love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (55 * playerCamera.globalScale) , nil, playerCamera.globalScale * 0.5)
        love.graphics.print("Drop your file here.", love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (3 * playerCamera.globalScale), nil, playerCamera.globalScale * 0.2)
        love.graphics.print("image 95x105 pixels (19x21 for every animation frame)", love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (0 * playerCamera.globalScale) , nil, playerCamera.globalScale * 0.2)
        love.graphics.draw(settings.dropFileImage, love.graphics.getWidth() / 2 - (settings.dropFileImage:getWidth() / 2 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (settings.dropFileImage:getHeight() / 2 * playerCamera.globalScale) , nil, playerCamera.globalScale)
    end
    love.graphics.setColor(1, 1, 1)
end

return settings