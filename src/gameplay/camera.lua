local playerCamera = {}
local camera = require 'src/library/cam'
local scene = require("src/gameplay/cutscene")
playerCamera.cam = camera()
playerCamera.globalScaleFactor = 3
playerCamera.shaker = 0

local function scaleCalculation()
    local scale = {
        x = (playerCamera.globalScaleFactor / 1200) * love.graphics.getWidth(),
        y = (playerCamera.globalScaleFactor / 800) * love.graphics.getHeight()
    }
    return scale
end

playerCamera.realScale = scaleCalculation()
playerCamera.globalScale = playerCamera.realScale.y

function love.resize(w, h)
    playerCamera.realScale = scaleCalculation()
    playerCamera.globalScale = playerCamera.realScale.y
    playerCamera.cam:zoomTo(playerCamera.globalScale)
end

function playerCamera.shake(intensity)
    if savedSettings.screenShake == false then
        return
    end
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    w, h = w / playerCamera.globalScale, h / playerCamera.globalScale
    local x
    local y
    if keys.f4 == 0 or keys.f4 == 2 then -- debugg keys remove when done
        if playerCamera.cam.x < w/2 then
            x = w/2 + love.math.random(intensity, intensity + intensity)
        end
        if playerCamera.cam.y < h/2 then
            y = h/2 + love.math.random(intensity, intensity + intensity)
        end
        local mapW = currentWorld.width * currentWorld.tilewidth
        local mapH = currentWorld.height * currentWorld.tileheight
        if playerCamera.cam.x > (mapW - w/2) then
            x = (mapW - w/2) - love.math.random(intensity, intensity + intensity)
        end
        if playerCamera.cam.y > (mapH - h/2) then
            y = (mapH - h/2) - love.math.random(intensity, intensity + intensity)
        end
        if x == nil then
            x = player.x + 6 + love.math.random(-intensity, intensity)
        end
        if y == nil then
            y = player.y - 8 + love.math.random(-intensity, intensity)
        end
    else
        x = player.x + 6 + love.math.random(-intensity, intensity)
        y = player.y - 8 + love.math.random(-intensity, intensity)
    end
    playerCamera.cam:lookAt(x, y)
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

function playerCamera.follow(dt)
    local lerpFactor = 7 * dt
    local delayedCamPosition = {x = 0, y = 0}
    if game.state == 0 then
        delayedCamPosition = {x = lerp(playerCamera.cam.x ,player.x + 6, lerpFactor), y = lerp(playerCamera.cam.y, player.y - 8, lerpFactor)}
    else
        delayedCamPosition = {x = lerp(playerCamera.cam.x ,player.x + scene.x + 6, lerpFactor), y = lerp(playerCamera.cam.y, player.y + scene.y - 8, lerpFactor)}
    end
    playerCamera.cam:lookAt(delayedCamPosition.x, delayedCamPosition.y)
    if playerCamera.shaker > 0 then
        playerCamera.shaker = playerCamera.shaker - dt
        playerCamera.shake(playerCamera.shaker * playerCamera.globalScale)
    else
        playerCamera.shaker = 0
    end
    if keys.f4 == 2 or keys.f4 == 3 then -- debugg keys remove when done
        playerCamera.cam:zoomTo(1)
    end
    if playerCamera.shaker <= 0 then
        local w = love.graphics.getWidth()
        local h = love.graphics.getHeight()

        w, h = w / playerCamera.globalScale, h / playerCamera.globalScale
        if keys.f4 == 0 or keys.f4 == 2 then -- debugg keys remove when done
            if playerCamera.cam.x < w/2 then
                playerCamera.cam.x = w/2
            end
            
            if playerCamera.cam.y < h/2 then
                playerCamera.cam.y = h/2
            end
            
            local mapW = currentWorld.width * currentWorld.tilewidth
            local mapH = currentWorld.height * currentWorld.tileheight
            if playerCamera.cam.x > (mapW - w/2) then
                playerCamera.cam.x = (mapW - w/2)
            end
            
            if playerCamera.cam.y > (mapH - h/2) then
                playerCamera.cam.y = (mapH - h/2)
            end
        end
    end
end

return playerCamera