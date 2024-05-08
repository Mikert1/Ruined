local settings = {}
local anim8 = require("src/library/animations")
local title = require("src/gui/title")
local button = require("src/gui/button")
local time = require("src/system/timer")

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
settings.slider = {
    x = -127,
    y = -45,
    width = 80,
    height = 2,
    knobRadius = 10,
    minValue = 0,
    maxValue = 100,
    value = savedSettings.masterVolume,
    dragging = false,
    hover = false
}
function settings.isMouseOverKnob(mx, my)
    return mx > love.graphics.getWidth() / 2 + (settings.slider.x * playerCamera.globalScale) + (settings.slider.width * playerCamera.globalScale) * settings.slider.value / (settings.slider.maxValue - settings.slider.minValue) - (settings.slider.knobRadius * playerCamera.globalScale) and
           mx < love.graphics.getWidth() / 2 + (settings.slider.x * playerCamera.globalScale) + (settings.slider.width * playerCamera.globalScale) * settings.slider.value / (settings.slider.maxValue - settings.slider.minValue) + (settings.slider.knobRadius * playerCamera.globalScale) and
           my > love.graphics.getHeight() / 2 + (settings.slider.y * playerCamera.globalScale) and
           my < love.graphics.getHeight() / 2 + (settings.slider.y * playerCamera.globalScale) + (settings.slider.height * playerCamera.globalScale)
end

function settings.update()
    print(settings.slider.value)
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
            love.graphics.setColor(0.1, 0.1, 0.1)
            love.graphics.print("Master Volume", love.graphics.getWidth() / 2 - (127 * playerCamera.globalScale),
                love.graphics.getHeight() / 2 - (63 * playerCamera.globalScale), nil, playerCamera.globalScale * 0.5)
            love.graphics.rectangle(
                "fill",
                love.graphics.getWidth() / 2 + (settings.slider.x * playerCamera.globalScale), 
                love.graphics.getHeight() / 2 + (settings.slider.y * playerCamera.globalScale), 
                settings.slider.width * playerCamera.globalScale, 
                settings.slider.height * playerCamera.globalScale
            )
            if settings.slider.dragging then
                love.graphics.setColor(0, 1, 1)
            else
                love.graphics.setColor(0.15, 0.15, 0.15)
            end
            love.graphics.circle(
                "fill",
                love.graphics.getWidth() / 2 + ((settings.slider.x * playerCamera.globalScale) + ((settings.slider.width * playerCamera.globalScale) * settings.slider.value / (settings.slider.maxValue - settings.slider.minValue))),
                love.graphics.getHeight() / 2 + ((settings.slider.y * playerCamera.globalScale)  + (settings.slider.height * playerCamera.globalScale) / 2),
                settings.slider.knobRadius / 4 * playerCamera.globalScale
            )
            love.graphics.setColor(1, 1, 1)
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