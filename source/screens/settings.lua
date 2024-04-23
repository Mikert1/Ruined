local settings = {}
local anim8 = require("assets/library/animations")
local title = require("source/screens/title")
local button = require("source/screens/button")
local time = require("source/timer")
settings.button = love.graphics.newImage("assets/textures/gui/settings/buttons/button.png")
settings.buttonOutline = love.graphics.newImage("assets/textures/gui/settings/buttons/buttonOutline.png")
settings.dropFileImage = love.graphics.newImage("assets/textures/gui/settings/drop.png")
settings.mainButtons = {}
settings.mainButtons.game = love.graphics.newImage("assets/textures/gui/settings/buttons/game.png")
settings.mainButtons.video = love.graphics.newImage("assets/textures/gui/settings/buttons/video.png")
settings.mainButtons.controls = love.graphics.newImage("assets/textures/gui/settings/buttons/controls.png")
settings.mainButtons.customize = love.graphics.newImage("assets/textures/gui/settings/buttons/customize.png")
settings.mainButtons.audio = love.graphics.newImage("assets/textures/gui/settings/buttons/sound.png")
settings.mainButtons.a = love.graphics.newImage("assets/textures/gui/settings/buttons/stats.png")
settings.scroll = 0
settings.tab = "game"
settings.fadeImage = love.graphics.newImage("assets/textures/gui/settings/fade.png")

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