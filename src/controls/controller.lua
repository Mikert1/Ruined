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
controller.buttonReleace.back = true
controller.buttonReleace.backCount = 0
controller.buttonReleace.start = true
controller.vibrationL = 0
controller.vibrationR = 0
local gui = require("src/gui/gui")
local story = require("src/gameplay/story")
local weapon = require("src/gameplay/weapons")
local stone = require("src/entities/enemies/stone")
local boss = require("src/entities/enemies/boss")
local file = require("src/system/data")
local worldManagement = require("src/gameplay/worldmanager")
local title = require("src/gui/title")
local button = require("src/gui/button")

function controller.update(dt)
    if not (controller.vibrationL == 0) and not (controller.vibrationR == 0) then
        controller.vibrationL = controller.vibrationL - dt / 1.3
        controller.vibrationR = controller.vibrationR - dt / 1.3
        if controller.vibrationL <= 0 and controller.vibrationR <= 0 then
            controller.vibrationL = 0
            controller.vibrationR = 0
        end
        controller.joysticks:setVibration(controller.vibrationL, controller.vibrationR)
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
                        elseif story.skiped == false then
                            story.dialogue.position = story.dialogue.length
                        end
                    end
                else
                    controller.buttonReleace.a = true
                    story.skiped = false
                end
                if controller.joysticks:isGamepadDown("start") then
                    if controller.buttonReleace.start == true then
                        controller.buttonReleace.start = false
                        if not player.isDead and title.state == 5 then
                            if game.esc == true then
                                game.esc = false
                                player.noMove = false
                                game.freeze = false
                                button.loadAll()
                            else
                                game.esc = true
                                player.noMove = true
                                game.freeze = true
                                button.loadAll()
                                gui.map = false
                                player.walkingOnGrass:stop()
                            end
                        end
                    end
                else
                    controller.buttonReleace.start = true
                end
            end
            if controller.joysticks:isGamepadDown("back") then
                if controller.buttonReleace.back == true then
                    controller.buttonReleace.back = false
                    if game.state == 0 then
                        if not player.isDead and title.state == 5 then
                            if gui.map == true then
                                gui.map = false
                            else
                                gui.map = true
                            end
                        end
                    elseif game.state == 1 then
                        if title.mikert.showed == false then
                            title.mikert.showed = true
                            button.loadAll()
                        end
                        file.filenumber = 1
                        game.state = 0
                        data = file.load()
                        worldManagement.teleport("start")
                        game.freeze = false
                        title.state = 5
                        game.esc = false
                        data = file.save()
                        button.loadAll()
                    end
                end
                controller.buttonReleace.backCount = controller.buttonReleace.backCount + dt
                if controller.buttonReleace.backCount > 1 then
                    controller.buttonReleace.backCount = 0
                    if keys.tab == true then
                        print("[Info  ] Disabled Debugg mode")
                        keys.tab = false
                    else
                        print("[Info  ] Enabled Debugg mode")
                        keys.tab = true
                    end
                end
            else
                controller.buttonReleace.backCountCount = 0
                controller.buttonReleace.back = true
            end
        else
            game.controlType = 0
        end
    end
end

return controller