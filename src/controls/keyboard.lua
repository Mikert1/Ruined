local keys = {}
keys.tab = false
keys.f4 = 0
local gui = require("src/gui/gui")
local story = require("src/gameplay/story")
local title = require("src/gui/title") -- remove after easter egg remove
local settings = require("src/gui/settings")
local stone = require("src/entities/enemies/stone")
local file = require("src/system/data")
local weapon = require("src/gameplay/weapons")
local controls = require("src/controls/controls")
local button = require("src/gui/button")
local worldManagement = require("src/gameplay/worldmanager") -- if player is dead

function love.keypressed(key)
    game.controlType = 0
    if not (controls.searchForKey == nil) then
        if key == "escape" then
            controls.searchForKey = nil
            controls.save()
            button.loadAll()
            return
        end
        controls.keys[controls.searchForKey] = key
        controls.searchForKey = nil
        controls.save()
        button.loadAll()
        return
    end
    if key == "escape" then
        if title.state == 0 or love.keyboard.isDown("lshift") then
            love.event.quit()
        end
    end
    if key == controls.keys.interact and story.npc.interaction == true and not player.isDead then
        if story.dialogue.length < story.dialogue.position then
            story.data.current = story.data.current + 1
            story.dialogue.position = 0
            story.dialogue.update()
            story.skiped = true
        elseif story.skiped == false then
            story.dialogue.position = story.dialogue.length
        end
    end
    if not player.isDead and title.state == 5 and game.state == 0 then
        if key == "escape" then
            game.esc = not game.esc
            player.noMove = game.esc
            game.freeze = game.esc
            button.loadAll()
            love.mouse.setGrabbed(not game.esc)
            if game.esc then
                gui.map = false
                player.walkingOnGrass:stop()
            end
        end
        if key == controls.keys.map then
            if gui.map == true then
                gui.map = false
            else
                if game.freeze == false then
                    gui.map = true
                end
            end
        end
        if key == controls.keys.focus and gui.focusReady == true then
            if player.focus == false then
                player.focusAnim = true
            end
        end
        if key == controls.keys.switchWeapon and player.focus == false then
            if weapon.equipment == 1 then
                weapon.equipment = 2
            else
                weapon.equipment = 1
                weapon.bow.hold = false
                weapon.bow.holdCounter = 0
            end
        end
        if key == "o" then
            lan.connect()
        end
        if key == "i" then
            lan.host()
        end
        if key == "p" then
            lan.sendData("Hello, other player!")
        end
        if key == "l" then
            minigame.start()
        end
        if story.npc.interaction == true then
            if key == "right" or key == controls.keys.interact then
                if story.dialogue.length < story.dialogue.position then
                    story.data.current = story.data.current + 1
                    story.dialogue.position = 0
                    story.dialogue.update()
                end
            end
            if key == "left" then
                if story.data.current >= 2 then
                    story.data.current = story.data.current - 1
                    story.dialogue.position = 0
                    story.dialogue.update()
                end
            end
        end
    else
        if player.isDead then
            if key == "escape" then
                love.event.quit()
                return
            end
            enemymanager:load()
            data = file.load()
            worldManagement.teleport("start")
            game.freeze = false
            player.isDead = false
            gui.deadTimer = 0
        end
    end
    if savedSettings.devmode == true then
        if key == controls.keys.devMode then
            if keys.tab == true then
                print("[Info  ] Disabled Debugg mode")
                keys.tab = false
            else
                print("[Info  ] Enabled Debugg mode")
                keys.tab = true
            end
        end
    end
    if key == "f2" then
        local currentLayer = village.layers
        for _, layer in ipairs(currentLayer) do
            if layer.name == "wall" then
                currentWorld:bump_removeLayer("wall")
            end
        end
        print("[Info  ] walls removed")
    end
    if key == "f3" then
        data = file.save()
    end
    if key == "f4" then
        if keys.f4 == 3 then
            print("[Info  ] Enabled Player view")
            keys.f4 = 0
        else
            if keys.f4 == 0 then
                print("[Info  ] Enabled Player view (degrid)")
                keys.f4 = 1
            else
                if keys.f4 == 1 then
                    print("[Info  ] Enabled Map view")
                    keys.f4 = 2
                else
                    print("[Info  ] Enabled Map view (degrid)")
                    keys.f4 = 3
                end
            end
        end
    end
    if key == "f6" then
        gui.focusTime = 8
        gui.focusReady = true
    end
    if key == "f11" then
        if savedSettings.window == 0 then
            love.window.setFullscreen(true)
            savedSettings.window = 1
        elseif savedSettings.window == 1 then
            love.window.setFullscreen(false)
            savedSettings.window = 0
        end
    end
    if key == "f12" then
        error("F12 Force Error")
    end
    if key == "f8" then
        print("[Info  ] testing shake")
        playerCamera.shaker = 1
    end
    if key == "f9" then
        local newStone = stone.new(love.math.random(1, 800),love.math.random(1, 157))
        table.insert(enemymanager.activeEnemies, newStone)
    end
    if key == "f10" then
        if love.system.getOS() == "Windows" then love._openConsole() end
        print("[Info  ] Console is active\n- use Tab to show more info and show colliders")
    end
    if love.keyboard.isDown("m") and love.keyboard.isDown("r") and love.keyboard.isDown("t") then
        print("[Easter egg] Hello Mikert!")
        title.swordicon.savegame3 = title.swordicon.animations.progress4
    end
    if love.keyboard.isDown("p") and love.keyboard.isDown("r") and love.keyboard.isDown("n") and love.keyboard.isDown("d") then
        print("[Easter egg] Hello Denielo!")
        settings.tab = "eeprnd"
        button.loadAll()
    end
end
function love.keyreleased(key)
    if key == controls.keys.interact then
        story.skiped = false
    end	
end
return keys