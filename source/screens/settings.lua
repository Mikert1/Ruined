local settings = {}
local anim8 = require("assets/library/animations")
local title = require("source/screens/title")
local button = require("source/screens/button")
local time = require("source/timer")
settings.button = love.graphics.newImage("assets/textures/gui/settings/button.png")
settings.buttonOutline = love.graphics.newImage("assets/textures/gui/settings/buttonOutline.png")
settings.dropFileImage = love.graphics.newImage("assets/textures/gui/settings/drop.png")
settings.mainButtons = {}
settings.mainButtons.game = love.graphics.newImage("assets/textures/gui/settings/game.png")
settings.mainButtons.video = love.graphics.newImage("assets/textures/gui/settings/video.png")
settings.mainButtons.controls = love.graphics.newImage("assets/textures/gui/settings/controls.png")
settings.mainButtons.customize = love.graphics.newImage("assets/textures/gui/settings/customize.png")
settings.mainButtons.audio = love.graphics.newImage("assets/textures/gui/settings/sound.png")
settings.mainButtons.a = love.graphics.newImage("assets/textures/gui/settings/stats.png")
settings.scroll = 0
settings.tab = "game"
settings.fadeImage = love.graphics.newImage("assets/textures/gui/settings/fade.png")

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
                newButton = button.new(-127, -53, "Enabled", {0, 1, 1}, 1, "Developer Mode") -- devmode
            else
                newButton = button.new(-127, -53, "Disabled", {1, 0, 0}, 1, "Developer Mode") -- devmode
            end
            table.insert(button.activeButtons, newButton)
            if savedSettings.console == true then
                newButton = button.new(-40, -53, "Enabled", {0, 1, 1}, 16, "Auto Open Console") -- Console
            else
                newButton = button.new(-40, -53, "Disabled", {1, 0, 0}, 16, "Auto Open Console") -- Console
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

function settings.update()

end

function settings.draw()
    if title.state == 4 then
        love.graphics.draw(title.settingBackground,
            love.graphics.getWidth() / 2 - (title.settingBackground:getWidth() / 2) * playerCamera.globalScale,
            love.graphics.getHeight() / 2 - (title.settingBackground:getHeight() / 2) * playerCamera.globalScale, nil,
            playerCamera.globalScale
        )
        love.graphics.setColor(1, 1, 1)
        if settings.tab == "game" then
        elseif settings.tab == "video" then

        elseif settings.tab == "controls" then


        elseif settings.tab == "skin" then
            love.graphics.setColor(0.1, 0.1, 0.1)
            love.graphics.print("Preview", love.graphics.getWidth() / 2 - (127 * playerCamera.globalScale),
                love.graphics.getHeight() / 2 - (63 * playerCamera.globalScale), nil, playerCamera.globalScale * 0.5)
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(player.spriteSheet, love.graphics.getWidth() / 2 - (127 * playerCamera.globalScale),
                love.graphics.getHeight() / 2 - (52 * playerCamera.globalScale), nil, playerCamera.globalScale * 0.5)
            love.graphics.setColor(0.1, 0.1, 0.1)
            love.graphics.print("Drop your file here.", love.graphics.getWidth() / 2 - (127 * playerCamera.globalScale),
                love.graphics.getHeight() / 2 - (0 * playerCamera.globalScale), nil, playerCamera.globalScale * 0.2)
            love.graphics.print("image 95x105 pixels (19x21 for every animation frame)",
                love.graphics.getWidth() / 2 - (127 * playerCamera.globalScale),
                love.graphics.getHeight() / 2 + (3 * playerCamera.globalScale), nil, playerCamera.globalScale * 0.2)
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(settings.dropFileImage, love.graphics.getWidth() / 2 -
                (settings.dropFileImage:getWidth() / 2 * playerCamera.globalScale), love.graphics.getHeight() / 2 -
                (settings.dropFileImage:getHeight() / 2 * playerCamera.globalScale), nil, playerCamera.globalScale)
        elseif settings.tab == "audio" then

        elseif settings.tab == "stats" then
            love.graphics.setColor(0.1, 0.1, 0.1)
            if time.seconds < 10 then
                love.graphics.print("Playtime: " .. string.sub(time.seconds, 0, 1) .. "sec ".. time.minutes .. "min " .. time.hours .. "hours", love.graphics.getWidth() / 2 - (127 * playerCamera.globalScale),
                love.graphics.getHeight() / 2 - (63 * playerCamera.globalScale), nil, playerCamera.globalScale * 0.5)
            else
                love.graphics.print("Playtime: " .. string.sub(time.seconds, 0, 2) .. "sec ".. time.minutes .. "min " .. time.hours .. "hours", love.graphics.getWidth() / 2 - (127 * playerCamera.globalScale),
                love.graphics.getHeight() / 2 - (63 * playerCamera.globalScale), nil, playerCamera.globalScale * 0.5)
            end
            love.graphics.print("Deaths: ", love.graphics.getWidth() / 2 - (127 * playerCamera.globalScale),
                love.graphics.getHeight() / 2 - (53 * playerCamera.globalScale), nil, playerCamera.globalScale * 0.5)
            love.graphics.print("Enemies Killed: ", love.graphics.getWidth() / 2 - (127 * playerCamera.globalScale),
                love.graphics.getHeight() / 2 - (43 * playerCamera.globalScale), nil, playerCamera.globalScale * 0.5)
        end
        love.graphics.setColor(1, 1, 1)
    end
end

function settings.draw2Layer()
    if title.state == 4 then
        if settings.scroll < 0 then
            love.graphics.draw(
                settings.fadeImage,
                love.graphics.getWidth() / 2 - (settings.fadeImage:getWidth() / 2) * playerCamera.globalScale,
                love.graphics.getHeight() / 2 - 61 * playerCamera.globalScale, 
                nil,
                -playerCamera.globalScale, -playerCamera.globalScale,
                settings.fadeImage:getWidth(), settings.fadeImage:getHeight()
            )
        end
        love.graphics.draw(
            settings.fadeImage,
            love.graphics.getWidth() / 2 - (settings.fadeImage:getWidth() / 2) * playerCamera.globalScale,
            love.graphics.getHeight() / 2 + 64 * playerCamera.globalScale, nil,
            playerCamera.globalScale
        )
    end
end

return settings