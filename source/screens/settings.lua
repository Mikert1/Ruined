local settings = {}
local anim8 = require("assets/library/animations")
local title = require("source/screens/title")
local button = require("source/screens/button")
settings.button = love.graphics.newImage("assets/textures/gui/settings/button.png")
settings.buttonOutline = love.graphics.newImage("assets/textures/gui/settings/buttonOutline.png")
settings.dropFileImage = love.graphics.newImage("assets/textures/gui/settings/drop.png")
settings.mainButtons = {}
settings.mainButtons.game = love.graphics.newImage("assets/textures/gui/settings/game.png")
settings.mainButtons.video = love.graphics.newImage("assets/textures/gui/settings/video.png")
settings.mainButtons.controls = love.graphics.newImage("assets/textures/gui/settings/controls.png")
settings.mainButtons.customize = love.graphics.newImage("assets/textures/gui/settings/customize.png")
settings.mainButtons.audio = love.graphics.newImage("assets/textures/gui/settings/sound.png")
settings.mainButtons.a = love.graphics.newImage("assets/textures/gui/settings/a.png")
settings.scroll = 0
settings.tab = "game"

function settings.load()
    local newButton
    button.activeButtons = {}
    newButton = button.specialNew(-127, -88, settings.mainButtons.game, {0, 1, 1}, 11, settings.button,
        settings.buttonOutline)
    table.insert(button.activeButtons, newButton)
    newButton = button.specialNew(-84, -88, settings.mainButtons.video, {0, 1, 1}, 12, settings.button,
        settings.buttonOutline)
    table.insert(button.activeButtons, newButton)
    newButton = button.specialNew(-41, -88, settings.mainButtons.controls, {0, 1, 1}, 13, settings.button,
        settings.buttonOutline)
    table.insert(button.activeButtons, newButton)
    newButton = button.specialNew(2, -88, settings.mainButtons.customize, {0, 1, 1}, 14, settings.button,
        settings.buttonOutline)
    table.insert(button.activeButtons, newButton)
    newButton = button.specialNew(45, -88, settings.mainButtons.audio, {0, 1, 1}, 15, settings.button,
        settings.buttonOutline)
    table.insert(button.activeButtons, newButton)
    newButton = button.specialNew(88, -88, settings.mainButtons.a, {0, 1, 1}, 16, settings.button,
        settings.buttonOutline)
    table.insert(button.activeButtons, newButton)
    if title.state == 4 then
        if settings.tab == "game" then
            if savedSettings.devmode == true then
                newButton = button.new(-127, -53, "True", {0, 1, 1}, 1, "Developer Mode") -- devmode
            else
                newButton = button.new(-127, -53, "False", {1, 0, 0}, 1, "Developer Mode") -- devmode
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
            newButton = button.new(-127, -53, "Key: " .. string.upper(controls.keys.interact) .. " ", {0, 1, 1}, 22, "Interact", true) -- reset controls
            table.insert(button.activeButtons, newButton)
            newButton = button.new(-40, 70, "Back", {1, 0, 0}, 3) -- back from settings to main menu or game
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
    love.graphics.draw(title.settingBackground,
        love.graphics.getWidth() / 2 - (title.settingBackground:getWidth() / 2) * playerCamera.globalScale,
        love.graphics.getHeight() / 2 - (title.settingBackground:getHeight() / 2) * playerCamera.globalScale, nil,
        playerCamera.globalScale)
    love.graphics.setColor(1, 1, 1)
    if settings.tab == "game" then
    elseif settings.tab == "video" then

    elseif settings.tab == "controls" then


    elseif settings.tab == "skin" then
        love.graphics.print("Preview", love.graphics.getWidth() / 2 - (127 * playerCamera.globalScale),
            love.graphics.getHeight() / 2 - (63 * playerCamera.globalScale), nil, playerCamera.globalScale * 0.5)
        love.graphics.draw(player.spriteSheet, love.graphics.getWidth() / 2 - (127 * playerCamera.globalScale),
            love.graphics.getHeight() / 2 - (52 * playerCamera.globalScale), nil, playerCamera.globalScale * 0.5)
        love.graphics.print("Drop your file here.", love.graphics.getWidth() / 2 - (127 * playerCamera.globalScale),
            love.graphics.getHeight() / 2 - (0 * playerCamera.globalScale), nil, playerCamera.globalScale * 0.2)
        love.graphics.print("image 95x105 pixels (19x21 for every animation frame)",
            love.graphics.getWidth() / 2 - (127 * playerCamera.globalScale),
            love.graphics.getHeight() / 2 + (3 * playerCamera.globalScale), nil, playerCamera.globalScale * 0.2)
        love.graphics.draw(settings.dropFileImage, love.graphics.getWidth() / 2 -
            (settings.dropFileImage:getWidth() / 2 * playerCamera.globalScale), love.graphics.getHeight() / 2 -
            (settings.dropFileImage:getHeight() / 2 * playerCamera.globalScale), nil, playerCamera.globalScale)
    end
    love.graphics.setColor(1, 1, 1)
end

return settings
