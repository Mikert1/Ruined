local title = require("source/screens/title")
local gui = require("source/gui")
local file = require("source/data")
local worldManagement = require("source/worlds")
local story = require("source/story/story")
local weapon = require("source/weapons")
local settings = require("source/screens/settings")
local buttonVar = require("source/screens/button")
local preview = file.show()
function love.mousemoved(x, y)
    if title.state == 0 then
        if title.logo.y >= 90 then
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
        end
    elseif title.state >= 1 and title.state <= 3 then
        if x > love.graphics.getWidth() / 2 + (108 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (128 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (70 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (90 * playerCamera.globalScale) then
            if title.delete.mode == false then
                title.delete.anim = title.delete.animations.hoverDelete
            else
                if title.mainColor[3] == 1 then
                    title.delete.anim = title.delete.animations.hoverPlay
                else
                    title.delete.anim = title.delete.animations.hoverPlayG
                end
            end
        else
            if title.delete.mode == false then
                title.delete.anim = title.delete.animations.delete
            else
                title.delete.anim = title.delete.animations.play
            end
        end
        if x > love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 - (108 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (70 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (90 * playerCamera.globalScale) then
            if title.mainColor[3] == 1 then
                title.settings.anim = title.settings.animations.hover
            else
                title.settings.anim = title.settings.animations.hoverG
            end
        else
            title.settings.anim = title.settings.animations.normal
        end
    elseif title.state == 4 then
        -- setting buttons
        if x > love.graphics.getWidth() / 2 - (40 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (40 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (70 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (90 * playerCamera.globalScale) then
            title.button.red.menu.button1 = title.button.red.animations.active
        else
            title.button.red.menu.button1 = title.button.red.animations.normal
        end
        if not settings.tab == "skin" then
            if x > love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 - (48 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 - (55 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 - (35 * playerCamera.globalScale) then
                if savedSettings.devmode == true then
                    if title.mainColor[3] == 1 then
                        title.button.normal.menu.button2 = title.button.normal.animations.activeBlue
                    else
                        title.button.normal.menu.button2 = title.button.normal.animations.activeGreen
                    end
                else
                    if title.mainColor[3] == 1 then
                        title.button.red.menu.button2 = title.button.red.animations.active
                    else
                        title.button.red.menu.button2 = title.button.red.animations.active
                    end
                end
            else
                title.button.red.menu.button2 = title.button.red.animations.normal
                title.button.normal.menu.button2 = title.button.normal.animations.normal
            end
            if x > love.graphics.getWidth() / 2 + (48 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (128 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 - (55 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 - (35 * playerCamera.globalScale) then
                if title.mainColor[3] == 1 then
                    title.button.normal.menu.button3 = title.button.normal.animations.activeBlue
                else
                    title.button.normal.menu.button3 = title.button.normal.animations.activeGreen
                end
            else
                title.button.normal.menu.button3 = title.button.normal.animations.normal
            end
        end
    end
end
function love.mousepressed(x, y, button, istouch)
    if title.mikert.showed == false then
        title.mikert.showed = true
        buttonVar.loadAll()
    else
        if title.state == 0 then
            if not (title.logo.y < 90) then
                title.logo.anim = title.logo.animations.region2
                title.logo.y = 90
            end
        elseif title.state >= 1 and title.state <= 3 then
            if button == 1 and x > love.graphics.getWidth() / 2 + (108 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (128 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (70 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (90 * playerCamera.globalScale) then
                if title.delete.mode == false then
                    title.delete.mode = true
                    buttonVar.loadAll()
                    if title.state == 1 then
                        title.delete.anim = title.delete.animations.hoverPlay
                    else
                        title.delete.anim = title.delete.animations.hoverPlayG
                    end
                else
                    title.delete.mode = false
                    buttonVar.loadAll()
                    title.delete.anim = title.delete.animations.hoverDelete
                end
                title.rezet()
            end
            if button == 1 and x > love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 - (108 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (70 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (90 * playerCamera.globalScale) then
                -- settings
                title.settings.anim = title.settings.animations.normal
                love.window.setTitle("Ruined | Settings")
                title.state = 4
                buttonVar.loadAll()
            end
        elseif title.state == 4 then
-- normaly this would be settings but moved it to button.lua
        elseif title.state == 5 then
            if not player.isDead then
                if story.npc.interaction == true then
                    if story.dialogue.length < story.dialogue.position then
                        story.data.current = story.data.current + 1
                        story.dialogue.position = 0
                        story.dialogue.update()
                    end
                end
                if button == 1 and game.freeze == false then
                    if weapon.equipment == 1 then
                        weapon.sword.use()
                    elseif weapon.equipment == 2 then
                        weapon.bow.charge()
                    end
                end
            end
        end
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 and weapon.equipment == 2 and weapon.bow.hold == true then
        weapon.bow.use()
    end
end

function love.wheelmoved(x, y)
    settings.scroll = settings.scroll + (y * 5)
    -- if settings.scroll < 0 then
    --     settings.scroll = 0
    -- end
    -- if settings.scroll > 100 then
    --     settings.scroll = 100
    -- end
end