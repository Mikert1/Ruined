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

function love.gamepadpressed(joystick, _button)

end

function love.gamepadreleased(joystick, _button)
    game.controlType = 1
    if _button == "y" then
        if weapon.equipment == 1 then
            weapon.equipment = 2
        else
            weapon.equipment = 1
            weapon.bow.hold = false
            weapon.bow.holdCounter = 0
        end
    elseif _button == "x" then

        if gui.focusReady and not player.focus then
            controller.vibrationL = 0.2
            controller.vibrationR = 1
            player.focusAnim = true
        end
    elseif _button == "a" then
        story.skiped = false
    elseif _button == "start" then
        -- Pause menu
        if not player.isDead and title.state == 5 then
            game.esc = not game.esc
            player.noMove = game.esc
            game.freeze = game.esc
            button.loadAll()
            if game.esc then
                gui.map = false
                player.walkingOnGrass:stop()
            end
        end
    elseif _button == "back" then
        game.controlType = 1
        if game.state == 0 then
            if not player.isDead and title.state == 5 then
                -- Toggle map display
                gui.map = not gui.map
            end
        elseif game.state == 1 then
            -- quick load savefile 1
            if not title.mikert.showed then
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
end

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

    controller.joysticks = love.joystick.getJoysticks()[1]
    if controller.joysticks and controller.joysticks:isConnected() then
        if not player.isDead then
            if controller.joysticks:getGamepadAxis("triggerright") > 0.5 then
                if controller.buttonReleace.triggerL == true then
                    controller.buttonReleace.triggerL = false
                    game.controlType = 1
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
        end
        local lx = controller.joysticks:getGamepadAxis("leftx")
        local ly = controller.joysticks:getGamepadAxis("lefty")
        local rx = controller.joysticks:getGamepadAxis("rightx")
        local ry = controller.joysticks:getGamepadAxis("righty")
        if lx > 0.1 or lx < -0.1
        or ly > 0.1 or ly < -0.1
        or rx > 0.1 or rx < -0.1
        or ry > 0.1 or ry < -0.1 then
            game.controlType = 1
        end
    end
end

return controller