local keys = {}
keys.tab = false
keys.esc = false
keys.f4 = 0
local gui = require("source/gui")
local story = require("source/story/story")
local title = require("source/screens/title") -- remove after easter egg remove
local stone = require("source/enemies/stone")
local file = require("source/data")
local weapon = require("source/weapons")
local controls = require("source/controls/controls")

function love.keypressed(key)
    if not player.isDead and title.state == 5 then
        if key == "escape" then
            if keys.esc == true then
                keys.esc = false
                gui.esc = false
                player.noMove = false
                game.freeze = false
            else
                keys.esc = true
                gui.esc = true
                player.noMove = true
                game.freeze = true
            end
        end
        if key == controls.keys.interact and story.npc.interaction == true then
            if story.dialogue.length < story.dialogue.position then
                story.data.current = story.data.current + 1
                story.dialogue.position = 0
                story.dialogue.update()
                story.skiped = true
            end
        end
        if key == controls.keys.map then
            gui.map = true
        end
        if key == "q" and gui.focusReady == true then
            if player.focus == false then
                player.focusAnim = true
            end
        end
        if key == "r" and player.focus == false then
            if weapon.equipment == 1 then
                weapon.equipment = 2
            else
                weapon.equipment = 1
                weapon.bow.hold = false
                weapon.bow.holdCounter = 0
            end
        end
        if key == "c" then
            server.sendData("Hello, other player!")
            server.receiveData()
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
    end
    if savedSettings.devmode == true then
        if key == "tab" then
            if keys.tab == true then
                print("Disabled Debugg mode")
                keys.tab = false
            else
                print("Enabled Debugg mode")
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
        print("walls removed")
    end
    if key == "f3" then
        data = file.save()
    end
    if key == "f4" then
        if keys.f4 == 3 then
            print("Enabled Player view")
            keys.f4 = 0
        else
            if keys.f4 == 0 then
                print("Enabled Player view (degrid)")
                keys.f4 = 1
            else
                if keys.f4 == 1 then
                    print("Enabled Map view")
                    keys.f4 = 2
                else
                    print("Enabled Map view (degrid)")
                    keys.f4 = 3
                end
            end
        end
    end
    if key == "f12" then
        print("debugg")
        error("F12 Force Error")
    end
    if key == "f8" then
        print("testing shake -- use 1 or 0 to schale shake")
    end
    if key == "f9" then
        local newStone = stone.new(love.math.random(1, 800),love.math.random(1, 157))
        table.insert(enemymanager.activeEnemies, newStone)
    end
    if key == "f10" then
        love._openConsole()
        print("Console is active\n- use Tab to show more info and show colliders")
    end
    if love.keyboard.isDown("m") and love.keyboard.isDown("r") and love.keyboard.isDown("t") then
        print("Hello Mikert!")
        title.swordicon.savegame3 = title.swordicon.animations.progress4
    end
end
function love.keyreleased(key)
    if key == "m" then
        gui.map = false
    end
    if key == controls.keys.interact then
        story.skiped = false
    end	
end
return keys