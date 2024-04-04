local title = require("source/screens/title")
local gui = require("source/gui")
local file = require("source/data")
local worldManagement = require("source/worlds")
local story = require("source/story/story")
local weapon = require("source/weapons")
local settings = require("source/screens/settings")
local preview = file.show()
function love.mousemoved(x, y)
    if title.state == 0 then
        if title.logo.y >= 90 then
            if x > love.graphics.getWidth() / 2 - (100 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 - (72 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (50 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (88 * playerCamera.globalScale) then
                title.icons.start.image = title.icons.start.active
                title.background.current = title.background.blue
                title.logo.anim = title.logo.animations.region2
                local iconImageData = love.image.newImageData("assets/textures/gui/title/logo1.png")
                love.window.setIcon(iconImageData)
            else
                title.icons.start.image = title.icons.start.inactive
            end
            if x > love.graphics.getWidth() / 2 - (12.5 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (12.5 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (50 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (88 * playerCamera.globalScale) then
                title.icons.past.image = title.icons.past.active
                title.background.current = title.background.green
                title.logo.anim = title.logo.animations.region3
                local iconImageData = love.image.newImageData("assets/textures/gui/title/logo2.png")
                love.window.setIcon(iconImageData)
            else
                title.icons.past.image = title.icons.past.inactive
            end
            if x > love.graphics.getWidth() / 2 + (71 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (99 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (50 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (88 * playerCamera.globalScale) then
                title.icons.final.image = title.icons.final.active
                title.background.current = title.background.blue
                title.logo.anim = title.logo.animations.region4
                local iconImageData = love.image.newImageData("assets/textures/gui/title/logo3.png")
                love.window.setIcon(iconImageData)
            else
                title.icons.final.image = title.icons.final.inactive
            end
        end
    elseif title.state >= 1 and title.state <= 3 then
        if x > love.graphics.getWidth() / 2 - (40 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (40 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (43 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (63 * playerCamera.globalScale) then
            if title.mainColor[3] == 1 then
                title.button.normal.menu.button2 = title.button.normal.animations.activeBlue
            else
                title.button.normal.menu.button2 = title.button.normal.animations.activeGreen
            end
            if preview.file2.created == true then
                title.button.red.menu.button3 = title.button.red.animations.active
            end
        else
            title.button.normal.menu.button2 = title.button.normal.animations.normal
            title.button.red.menu.button3 = title.button.red.animations.normal
        end
        if x > love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 - (48 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (43 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (63 * playerCamera.globalScale) then
            if title.mainColor[3] == 1 then
                title.button.normal.menu.button1 = title.button.normal.animations.activeBlue
            else
                title.button.normal.menu.button1 = title.button.normal.animations.activeGreen
            end
            if preview.file1.created == true then
                title.button.red.menu.button2 = title.button.red.animations.active
            end
        else
            title.button.normal.menu.button1 = title.button.normal.animations.normal
            title.button.red.menu.button2 = title.button.red.animations.normal
        end
        if x > love.graphics.getWidth() / 2 + (48 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (128 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (43 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (63 * playerCamera.globalScale) then
            if title.mainColor[3] == 1 then
                title.button.normal.menu.button3 = title.button.normal.animations.activeBlue
            else
                title.button.normal.menu.button3 = title.button.normal.animations.activeGreen
            end
            if preview.file3.created == true then
                title.button.red.menu.button4 = title.button.red.animations.active
            end
        else
            title.button.normal.menu.button3 = title.button.normal.animations.normal
            title.button.red.menu.button4 = title.button.red.animations.normal
        end
        if x > love.graphics.getWidth() / 2 - (40 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (40 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (70 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (90 * playerCamera.globalScale) then
            title.button.red.menu.button1 = title.button.red.animations.active
        else
            title.button.red.menu.button1 = title.button.red.animations.normal
        end
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
        if title.texture == false then
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
    if title.state == 5 then
        if gui.esc == true then
            if x > love.graphics.getWidth() / 2 - (40 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (40 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 - (25 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 - (5 * playerCamera.globalScale) then
                title.button.red.menu.button1 = title.button.red.animations.active
            else
                title.button.red.menu.button1 = title.button.red.animations.normal
            end
            if x > love.graphics.getWidth() / 2 - (40 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (40 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 - (0 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (20 * playerCamera.globalScale) then
                if title.mainColor[3] == 1 then
                    title.button.normal.menu.button2 = title.button.normal.animations.activeBlue
                else
                    title.button.normal.menu.button2 = title.button.normal.animations.activeGreen
                end
            else
                title.button.normal.menu.button2 = title.button.normal.animations.normal
            end
            if x > love.graphics.getWidth() / 2 - (40 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (40 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (25 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (45 * playerCamera.globalScale) then
                if title.mainColor[3] == 1 then
                    title.button.normal.menu.button1 = title.button.normal.animations.activeBlue
                else
                    title.button.normal.menu.button1 = title.button.normal.animations.activeGreen
                end
            else
                title.button.normal.menu.button1 = title.button.normal.animations.normal
            end
        end
    end
end
function love.mousepressed(x, y, button, istouch)
    if title.mikert.showed == false then
        title.mikert.showed = true
    else
        if title.state == 0 then
            if title.logo.y >= 90 then
                if button == 1 and x > love.graphics.getWidth() / 2 - (100 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 - (72 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (50 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (88 * playerCamera.globalScale) then
                    title.state = 1
                    file.show()
                    title.rezet()
                    title.icons.start.image = title.icons.start.inactive
                    title.text.name = "Ruined"
                    title.text.chapter = "Chapter 1"
                    title.mainColor = {0, 1, 1}
                    title.background.current = title.background.blue
                end
                if button == 1 and x > love.graphics.getWidth() / 2 - (12.5 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (12.5 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (50 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (88 * playerCamera.globalScale) then
                    print("chapter 2 is not unlocked, finish chapter 1 to play chapter 2.")
                    title.state = 2
                    file.show()
                    title.rezet()
                    title.icons.past.image = title.icons.past.inactive
                    title.text.name = "The days of John's"
                    title.text.chapter = "Chapter 2"
                    title.mainColor = {0, 1, 0}
                    title.background.current = title.background.green
                end
                if x > love.graphics.getWidth() / 2 + (71 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (96 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (50 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (88 * playerCamera.globalScale) then
                    print("chapter 3 is not unlocked, finish chapter 2 to play chapter 3.")
                    title.state = 3
                    file.show()
                    title.rezet()
                    title.icons.final.image = title.icons.final.inactive
                    title.text.name = "Returned"
                    title.text.chapter = "Chapter 3"
                    title.mainColor = {0, 1, 1}
                    title.background.current = title.background.blue
                end
            else
                title.logo.anim = title.logo.animations.region2
                title.logo.y = 90
            end
        elseif title.state >= 1 and title.state <= 3 then
            if button == 1 and x > love.graphics.getWidth() / 2 + (108 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (128 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (70 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (90 * playerCamera.globalScale) then
                if title.delete.mode == false then
                    title.delete.mode = true
                    if title.state == 1 then
                        title.delete.anim = title.delete.animations.hoverPlay
                    else
                        title.delete.anim = title.delete.animations.hoverPlayG
                    end
                else
                    title.delete.mode = false
                    title.delete.anim = title.delete.animations.hoverDelete
                end
                title.rezet()
            end
            if button == 1 and x > love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 - (108 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (70 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (90 * playerCamera.globalScale) then
                -- settings
                title.settings.anim = title.settings.animations.normal
                title.state = 4
                settings.load()
            end
            if button == 1 and x > love.graphics.getWidth() / 2 - (40 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (40 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (70 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (90 * playerCamera.globalScale) then
                title.state = 0
            end
            if button == 1 and x > love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 - (48 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (43 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (63 * playerCamera.globalScale) then
                if title.delete.mode == true then
                    love.filesystem.remove("savegame1.json")
                    love.filesystem.remove("previewcard1.json")
                    file.show()
                    title.rezet()
                else
                    file.filenumber = 1
                    game.state = 0
                    data = file.load()
                    worldManagement.teleport("start")
                    game.freeze = false
                    title.state = 5
                    gui.esc = false
                    data = file.save()
                    player.noMove = false
                end
                title.button.normal.menu.button1 = title.button.normal.animations.normal
                title.button.red.menu.button2 = title.button.red.animations.normal
            end
            if button == 1 and x > love.graphics.getWidth() / 2 - (40 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (40 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (43 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (63 * playerCamera.globalScale) then
                if title.delete.mode == true then
                    love.filesystem.remove("savegame2.json")
                    love.filesystem.remove("previewcard2.json")
                    file.show()
                    title.rezet()
                else
                    file.filenumber = 2
                    game.state = 0
                    data = file.load()
                    worldManagement.teleport("start")
                    game.freeze = false
                    title.state = 5
                    gui.esc = false
                    data = file.save()
                    player.noMove = false
                end
                title.button.normal.menu.button2 = title.button.normal.animations.normal
                title.button.red.menu.button3 = title.button.red.animations.normal
            end
            if button == 1 and x > love.graphics.getWidth() / 2 + (48 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (128 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (43 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (63 * playerCamera.globalScale) then
                if title.delete.mode == true then
                    love.filesystem.remove("savegame3.json")
                    love.filesystem.remove("previewcard3.json")
                    file.show()
                    title.rezet()
                else
                    file.filenumber = 3
                    game.state = 0
                    data = file.load()
                    worldManagement.teleport("start")
                    game.freeze = false
                    title.state = 5
                    gui.esc = false
                    data = file.save()
                    player.noMove = false
                end
                title.button.normal.menu.button3 = title.button.normal.animations.normal
                title.button.red.menu.button4 = title.button.red.animations.normal
            end
        elseif title.state == 4 then
            if button == 1 and x > love.graphics.getWidth() / 2 - (40 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (40 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (70 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (90 * playerCamera.globalScale) then
                if title.texture == false then
                    if gui.esc == true then
                        title.state = 5
                    else
                        love.window.setTitle("Ruined | Title Screen")
                        if title.mainColor[3] == 0 then
                            title.state = 2
                        else
                            title.state = 1
                            --fix there will be the finaly (3)
                        end
                    end
                else
                    title.texture = false
                end
            end
            if title.texture == false then
                if settings.settings == "game" then
                    if button == 1 and x > love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 - (48 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 - (55 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 - (35 * playerCamera.globalScale) then
                        button:update(x, y)
                        if savedSettings.devmode == false then
                            savedSettings.devmode = true
                            print("Console is active")
                            if title.mainColor[3] == 1 then
                                title.button.normal.menu.button2 = title.button.normal.animations.activeBlue
                            else
                                title.button.normal.menu.button2 = title.button.normal.animations.activeGreen
                            end
                        else
                            savedSettings.devmode = false
                            print("Console is deactivated --restart game to take effect")
                            title.button.red.menu.button2 = title.button.red.animations.active
                        end
                        file.savedSettings.save()
                    end
                    if button == 1 and x > love.graphics.getWidth() / 2 + (48 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (128 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 - (55 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 - (35 * playerCamera.globalScale) then
                        if title.texture == false then
                            title.texture = true
                        else
                            title.texture = false
                        end
                    end
                elseif settings.settings == "video" then
                    -- video settings
                elseif settings.settings == "controls" then
                    -- controls settings
                end
            end
        elseif title.state == 5 then
            if gui.esc == true then
                if button == 1 and x > love.graphics.getWidth() / 2 - (40 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (40 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 - (25 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 - (5 * playerCamera.globalScale) then
                    gui.esc = false
                    love.window.setTitle("Ruined | Title Screen")
                    keys.esc = false
                    game.freeze = false
                    --data = file.save()
                    title.rezet()
                    enemymanager:load()
                    game.state = 1
                    if title.mainColor[3] == 0 then
                        title.state = 2
                    else
                        title.state = 1
                        --fix there will be the finaly (3)
                    end
                end
                if button == 1 and x > love.graphics.getWidth() / 2 - (40 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (40 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 - (0 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (20 * playerCamera.globalScale) then
                    title.state = 4
                end
                if button == 1 and x > love.graphics.getWidth() / 2 - (40 * playerCamera.globalScale) and x < love.graphics.getWidth() / 2 + (40 * playerCamera.globalScale) and y > love.graphics.getHeight() / 2 + (25 * playerCamera.globalScale) and y < love.graphics.getHeight() / 2 + (45 * playerCamera.globalScale) then
                    gui.esc = false
                    game.freeze = false
                    keys.esc = false
                    player.noMove = false
                end
            end
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