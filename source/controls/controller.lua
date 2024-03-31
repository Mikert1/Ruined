local controller = {}
controller.joysticks = love.joystick.getJoysticks()[1]
if controller.joysticks then
    game.controlType = 1
end
controller.buttonReleace = {}
controller.buttonReleace.triggerL = true
controller.buttonReleace.x = true
controller.buttonReleace.y = true
controller.buttonReleace.a = true
controller.buttonReleace.back = 0
controller.buttonReleace.start = true
controller.vibrationL = 0
controller.vibrationR = 0
local gui = require("source/gui")
local story = require("source/story/story")
local weapon = require("source/weapons")
local stone = require("source/enemies/stone")
local boss = require("source/enemies/boss")
local file = require("source/data")
local worldManagement = require("source/worlds")
local title = require("source/screens/title")

function controller.update(dt)
    if not (controller.vibrationL == 0) and not (controller.vibrationR == 0) then
        controller.joysticks:setVibration(controller.vibrationL, controller.vibrationR)
        controller.vibrationL = controller.vibrationL - dt / 1.3
        controller.vibrationR = controller.vibrationR - dt / 1.3
        if controller.vibrationL <= 0 and controller.vibrationR <= 0 then
            controller.vibrationL = 0
            controller.vibrationR = 0
        end
    end

    if game.controlType == 0 then
        controller.joysticks = love.joystick.getJoysticks()[1]
    else
        if controller.joysticks and controller.joysticks:isConnected() then
            if not player.isDead then
                game.controlType = 1
                if controller.joysticks:getGamepadAxis("triggerright") > 0.5 then
                    if controller.buttonReleace.triggerL == true then
                        controller.buttonReleace.triggerL = false
                        if weapon.equipment == 1 then
                            weapon.sword.use()
                        elseif weapon.equipment == 2 then
                            weapon.bow.charge()
                        end
                    end
                else
                    if weapon.equipment == 2 and weapon.bow.hold == true then
                        weapon.bow.use()
                    end
                    controller.buttonReleace.triggerL = true
                end
                if controller.joysticks:isGamepadDown("y") then
                    if controller.buttonReleace.y == true then
                        controller.buttonReleace.y = false
                        if weapon.equipment == 1 then
                            weapon.equipment = 2
                        else
                            weapon.equipment = 1
                            weapon.bow.hold = false
                            weapon.bow.holdCounter = 0
                        end
                    end
                else
                    controller.buttonReleace.y = true
                end
                if controller.joysticks:isGamepadDown("x") then
                    if controller.buttonReleace.x == true then
                        controller.buttonReleace.x = false
                        if gui.focusReady == true then
                            if player.focus == false then
                                controller.vibrationL = 0.2
                                controller.vibrationR = 1
                                player.focusAnim = true
                            end
                        end
                    end
                else
                    controller.buttonReleace.x = true
                end
                if controller.joysticks:isGamepadDown("a") then
                    if controller.buttonReleace.a == true then
                        controller.buttonReleace.a = false
                        if story.dialogue.length < story.dialogue.position then
                            story.data.current = story.data.current + 1
                            story.dialogue.position = 0
                            story.dialogue.update()
                            story.skiped = true
                        end
                    end
                else
                    controller.buttonReleace.a = true
                    story.skiped = false
                end
                print(story.skiped)
                if controller.joysticks:isGamepadDown("start") then
                    if controller.buttonReleace.start == true then
                        controller.buttonReleace.start = false
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
                else
                    controller.buttonReleace.start = true
                end
            end
            if controller.joysticks:isGamepadDown("back") then
                if title.mikert.showed == false then
                    title.mikert.showed = true
                end
                if game.state == 1 then
                    file.filenumber = 1
                    game.state = 0
                    data = file.load()
                    worldManagement.teleport("start")
                    game.freeze = false
                    title.state = 5
                    gui.esc = false
                    data = file.save()
                end
                controller.buttonReleace.back = controller.buttonReleace.back + dt
                if controller.buttonReleace.back > 1 then
                    controller.buttonReleace.back = 0
                    if keys.tab == true then
                        print("Disabled Debugg mode")
                        keys.tab = false
                    else
                        print("Enabled Debugg mode")
                        keys.tab = true
                    end
                end
            else
                controller.buttonReleace.back = 0
            end
        else
            game.controlType = 0
        end
    end
end

return controller