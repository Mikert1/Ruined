local controller = {}
controller.joysticks = love.joystick.getJoysticks()[1]
if controller.joysticks and controller.joysticks:isConnected() then
    game.controlType = 1
end
controller.buttonReleace = {}
controller.buttonReleace.triggerL = true
controller.vibrationL = 0
controller.vibrationR = 0
local gui = require("src/gui/gui")
local story = require("src/gameplay/story")
local weapon = require("src/gameplay/weapons")
local stone = require("src/entities/enemies/stone")
local title = require("src/gui/title")
local button = require("src/gui/button")
local settings = require("src/gui/settings")

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
        if title.mikert.showed == false then
            title.mikert.showed = true
            button.loadAll()
        else
            for _, button in ipairs(button.activeButtons) do
                if button.hover then
                    button:action(button.id)
                end
            end
            story.skiped = false
        end
    elseif _button == "b" then
        if not (button.warning.id == 0) then
            button.warning.id = 0
            button.warning.text = ""
            button.loadAll()
            return
        end
        if title.state == 5 then
            game.esc = false
            player.noMove = false
            game.freeze = false
            button.loadAll()
        end
        if title.state == 4 then
            if game.esc == true then
                title.state = 5
            else
                love.window.setTitle("Ruined | Title Screen")
                if title.mainColor[3] == 0 then
                    title.state = 2
                else
                    title.state = 1
                    --fix there will be the finaly (3)
                end
                title.delete.mode = false
            end
            button.loadAll()
        elseif title.state == 1 or title.state == 2 or title.state == 3 then
            title.state = 0
            title.delete.mode = false
            controls.searchForKey = nil
            button.loadAll()
        end
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
            if not player.isDead and title.state == 5 and not game.esc then
                -- Toggle map display
                gui.map = not gui.map
            end
        end
    elseif _button == "rightshoulder" then
        if title.state == 4 then
            if settings.tab == "game" then
                settings.tab = "video"
            elseif settings.tab == "video" then
                settings.tab = "controls"
            elseif settings.tab == "controls" then
                settings.tab = "skin"
            elseif settings.tab == "skin" then
                settings.tab = "audio"
            elseif settings.tab == "audio" then
                settings.tab = "stats"
            elseif settings.tab == "stats" then
                settings.tab = "game"
            end
            settings.scroll = 0
            button.loadAll()
        end
    elseif _button == "leftshoulder" then
        if title.state == 4 then
            if settings.tab == "game" then
                settings.tab = "stats"
            elseif settings.tab == "video" then
                settings.tab = "game"
            elseif settings.tab == "controls" then
                settings.tab = "video"
            elseif settings.tab == "skin" then
                settings.tab = "controls"
            elseif settings.tab == "audio" then
                settings.tab = "skin"
            elseif settings.tab == "stats" then
                settings.tab = "audio"
            end
            settings.scroll = 0
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
        if title.state == 4 then
            if ry > 0.1 or ry < -0.1 then
                settings.scroll = settings.scroll - (ry * 3)
                if settings.scroll > 0 then
                    settings.scroll = 0
                end
            end
        end
    end
end

return controller