local title = require("src/gui/title")
local gui = require("src/gui/gui")
local file = require("src/system/data")
local worldManagement = require("src/gameplay/worldmanager")
local story = require("src/gameplay/story")
local weapon = require("src/gameplay/weapons")
local settings = require("src/gui/settings")
local button = require("src/gui/button")
local preview = file.show()
function love.mousemoved(x, y)
    game.controlType = 0
    if title.state == 0 then
        if x > love.graphics.getWidth() / 2 - (100 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 - (72 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (50 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (88 * playerCamera.globalScale) then
            title.background.current = title.background.blue
            title.logo.anim = title.logo.animations.region2
            local iconImageData = love.image.newImageData("assets/textures/gui/title/logo1.png")
            love.window.setIcon(iconImageData)
        end
        if x > love.graphics.getWidth() / 2 - (12.5 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (12.5 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (50 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (88 * playerCamera.globalScale) then
            title.background.current = title.background.green
            title.logo.anim = title.logo.animations.region3
            local iconImageData = love.image.newImageData("assets/textures/gui/title/logo2.png")
            love.window.setIcon(iconImageData)
        end
        if x > love.graphics.getWidth() / 2 + (71 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (99 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (50 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (88 * playerCamera.globalScale) then
            title.background.current = title.background.storm
            title.logo.anim = title.logo.animations.region4
            local iconImageData = love.image.newImageData("assets/textures/gui/title/logo3.png")
            love.window.setIcon(iconImageData)
        end
    elseif title.state >= 1 and title.state <= 3 then
        if x > love.graphics.getWidth() / 2 + (108 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (128 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (70 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (90 * playerCamera.globalScale) then
        --     if title.delete.mode == false then
        --         title.icons.currentDelete = title.icons.delete1
        --     else
        --         title.icons.currentDelete = title.icons.delete2
        --     end
        -- else
        --     if title.delete.mode == false then
        --         title.icons.currentDelete = title.icons.delete1
        --     else
        --         title.icons.currentDelete = title.icons.delete2
        --     end
        end
        if x > love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 - (108 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (70 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (90 * playerCamera.globalScale) then
        --     if title.mainColor[3] == 1 then
        --         title.settings.anim = title.settings.animations.hover
        --     else
        --         title.settings.anim = title.settings.animations.hoverG
        --     end
        -- else
        --     title.settings.anim = title.settings.animations.normal
        end
    elseif title.state == 4 then
        if settings.isMouseOverKnob(x, y) then
            settings.slider.hover = true
        else
            settings.slider.hover = false
        end
        if settings.slider.dragging then
            settings.slider.value = (x - love.graphics.getWidth() / 2 - (settings.slider.x * playerCamera.globalScale)) / ((settings.slider.width * playerCamera.globalScale)) * (settings.slider.maxValue - settings.slider.minValue)
            if settings.slider.value < settings.slider.minValue then
                settings.slider.value = settings.slider.minValue
            end
            if settings.slider.value > settings.slider.maxValue then
                settings.slider.value = settings.slider.maxValue
            end
        end
    end
end
function love.mousepressed(x, y, buttonClicked, istouch)
    if title.state == 0 then
        if title.logo.y < 90 then
            title.logo.anim = title.logo.animations.region2
            title.logo.y = 90
        end
    elseif title.state == 4 then
        if buttonClicked == 1 and settings.isMouseOverKnob(x, y) then
            print("clicked")
            settings.slider.dragging = true
        end
    elseif title.state == 5 then
        if not player.isDead then
            if story.npc.interaction == true then
                if story.dialogue.length < story.dialogue.position then
                    story.data.current = story.data.current + 1
                    story.dialogue.position = 0
                    story.dialogue.update()
                    story.skiped = true
                elseif story.skiped == false then
                    story.dialogue.position = story.dialogue.length
                end
            end
            if buttonClicked == 1 and game.freeze == false then
                if weapon.equipment == 1 then
                    weapon.sword.use()
                elseif weapon.equipment == 2 then
                    weapon.bow.charge()
                end
            end
        end
    end
end

function love.mousereleased(x, y, buttonClicked, istouch, presses)
    game.controlType = 0
    if title.mikert.showed == false then
        title.mikert.showed = true
        button.loadAll()
    else
        if buttonClicked == 1 and title.state == 4 and settings.tab == "audio" then
        settings.slider.dragging = false
        savedSettings.masterVolume = settings.slider.value
        love.audio.setVolume(savedSettings.masterVolume / 100)
        file.settings.save()
        end
        if buttonClicked == 1 and weapon.equipment == 2 and weapon.bow.hold == true and not game.freeze then
            weapon.bow.use()
        end
    end
    story.skiped = false
end

function love.wheelmoved(x, y)
    game.controlType = 0
    settings.scroll = settings.scroll + (y * 10)
    if settings.scroll > 0 then
        settings.scroll = 0
    end
    -- if settings.scroll > 100 then
    --     settings.scroll = 100
    -- end
end