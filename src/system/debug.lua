local debug = {}
debug.world = {}
local time = require("src/system/timer")
local worldManagement = require("src/gameplay/worldmanager")
local file = require("src/system/data")
local title = require("src/gui/title")
function debug.update()
    if keys.tab == true then
        debug.gameName = "" .. love.window.getTitle()
        debug.version = "Version: " .. game.beta .. " " .. game.version .. " " .. game.buildName
        debug.cpu = "Cpu: " .. love.system.getProcessorCount()
        debug.engine = "LÖVE " .. love.getVersion() .. "  " .. _VERSION
        debug.screen = "Screen: " .. love.graphics.getWidth() .. ", " .. love.graphics.getHeight()
        if game.state == 0 then
            debug.savegame = "Savegame ".. file.filenumber
            debug.savedX = "X: " .. data.x
            debug.savedY = "Y: ".. data.y
            debug.savedWorld = "World: " .. data.world
            debug.savedTime = "Time played: " .. string.sub(data.seconds, 0, 2) .. "sec ".. data.minutes .. "min " .. data.hours .. "hours"
        end
    end
end
function debug.world:draw()
    if keys.tab == true then
        if game.state == 0 then
            currentWorld:bump_draw()
            drawWaterLayer()
            drawPortalLayer()
            drawNpcLayer()
            drawStairLayer()
            --sword collider
        end
    end
end
local function getGPUUsage()
    local stats = love.graphics.getStats()
    return stats.texturememory / 1024 / 1024
end

local function getCPUUsage()
    local frameTime = love.timer.getAverageDelta()
    return frameTime * 1000
end
function debug:draw()
    if keys.tab == true then
        debug.update()
        --left
        love.graphics.print("FPS:" .. love.timer.getFPS(), 2, 2)
        love.graphics.print("GPU Usage: " .. getGPUUsage() .. " MB" .. ", CPU Usage: " .. getCPUUsage() .. " ms", 2, 17) --
        love.graphics.print("X: " .. player.x, 2, 47)
        love.graphics.print("Y: " .. player.y, 2, 62)
        love.graphics.print("World: " .. worldManagement.thisWorld, 2, 77)
        love.graphics.print("Speed: " .. player.speed .. " SideSpeed: " .. player.sideSpeed, 2, 92)
        if player.isSwimming == true then
            love.graphics.print("Player is Swimming", 2, 107) else love.graphics.print("Player is not Swimming", 2, 107)
        end
        if time.seconds < 10 then
            love.graphics.print("Time played: " .. string.sub(time.seconds, 0, 1) .. "sec ".. time.minutes .. "min " .. time.hours .. "hours", 2, 122)
        else
            love.graphics.print("Time played: " .. string.sub(time.seconds, 0, 2) .. "sec ".. time.minutes .. "min " .. time.hours .. "hours", 2, 122)
        end

        --right
        love.graphics.print(debug.gameName, love.graphics.getWidth() - font:getWidth(debug.gameName) - 2, 2)
        love.graphics.print(debug.version, love.graphics.getWidth() - font:getWidth(debug.version) - 2, 17)

        love.graphics.print(debug.engine, love.graphics.getWidth() - font:getWidth(debug.engine) - 2, 47)
        love.graphics.print(debug.screen, love.graphics.getWidth() - font:getWidth(debug.screen) - 2, 77)

        if game.state == 0 then
            love.graphics.print(debug.savegame, love.graphics.getWidth() - font:getWidth(debug.savegame) - 2, 107)
            love.graphics.print(debug.savedX, love.graphics.getWidth() - font:getWidth(debug.savedX) - 2, 127)
            love.graphics.print(debug.savedY, love.graphics.getWidth() - font:getWidth(debug.savedY) - 2, 147)
            love.graphics.print(debug.savedWorld, love.graphics.getWidth() - font:getWidth(debug.savedWorld) - 2, 167)
            love.graphics.print(debug.savedTime, love.graphics.getWidth() - font:getWidth(debug.savedTime) - 2, 187)
        end

        -- dot at 0,0
        love.graphics.rectangle("fill", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 1, 1)
        if keys.f4 == 2 or keys.f4 == 3 then
            love.graphics.rectangle("line", (love.graphics.getWidth() / 2) - love.graphics.getWidth() / 2 / playerCamera.globalScale, (love.graphics.getHeight() / 2) - love.graphics.getHeight() / 2 / playerCamera.globalScale, love.graphics.getWidth() / playerCamera.globalScale, love.graphics.getHeight() / playerCamera.globalScale)
        end

        -- left down
        love.graphics.print("- use Tab to show/hide debugg mode\n\n- use F2 to remove walls\n- use F3 to Force save\n- use F4 to swap cam point\n- use F8 for a screen shake\n- use F9 spawn stone enemy\n- use F10 to open console\n- use F11 to force start savefile 1 (also in loading phase)\n- use F12 for a Force error", 2, love.graphics.getHeight() - (font:getHeight(debug.gameName) * 10) - 2)
    end
end
return debug