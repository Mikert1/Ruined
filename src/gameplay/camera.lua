local playerCamera = {}
local camera = require 'src/library/cam'
local scene = require("src/gameplay/cutscene")
playerCamera.cam = camera()
playerCamera.globalScaleFactor = 6
playerCamera.globalScale = (playerCamera.globalScaleFactor / 1200) * love.graphics.getHeight()
playerCamera.realScale = {}
playerCamera.realScale.x = (playerCamera.globalScaleFactor / 1200) * love.graphics.getWidth()
playerCamera.realScale.y = (playerCamera.globalScaleFactor / 1200) * love.graphics.getHeight()

function playerCamera.shake(intensity)
    playerCamera.cam:lookAt(player.x + 6 + love.math.random(-intensity, intensity), player.y - 8 + love.math.random(-intensity, intensity))
end


function playerCamera.follow(dt)
    if love.keyboard.isDown("f8") then
        if love.keyboard.isDown("0") then
            playerCamera.shake(10 * playerCamera.globalScale)
        elseif love.keyboard.isDown("1") then
            playerCamera.shake(5 * playerCamera.globalScale)
        else
            playerCamera.shake(1 * playerCamera.globalScale)
        end
    else
        if controller.joysticks then
            if controller.joysticks:isGamepadDown("y") then
                playerCamera.shake(1 * playerCamera.globalScale)
            end
        end
        if game.state == 0 then
            playerCamera.cam:lookAt(player.x + 6, player.y - 8)
        else
            playerCamera.cam:lookAt(player.x + scene.x + 6, player.y + scene.y - 8)
        end
    end
    if player.focus == true then
        playerCamera.globalScaleFactor = playerCamera.globalScaleFactor + 0.05
        if playerCamera.globalScaleFactor >= 8 then
            playerCamera.globalScaleFactor = 8
        end
        playerCamera.globalScale = (playerCamera.globalScaleFactor / 1200) * love.graphics.getHeight()
    else
        playerCamera.globalScaleFactor = playerCamera.globalScaleFactor + -0.05
        if playerCamera.globalScaleFactor <= 6 then
            playerCamera.globalScaleFactor = 6
        end
        playerCamera.globalScale = (playerCamera.globalScaleFactor/ 1200) * love.graphics.getHeight()
    end
    playerCamera.realScale.x = (playerCamera.globalScaleFactor / 1200) * love.graphics.getWidth()
    playerCamera.realScale.y = (playerCamera.globalScaleFactor / 1200) * love.graphics.getHeight()
    playerCamera.cam:zoomTo(playerCamera.globalScale)
    if keys.f4 == 2 or keys.f4 == 3 then -- debugg keys remove when done
        playerCamera.cam:zoomTo(1)
    end
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    
    --local w, h = love.graphics.getDimensions()
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

return playerCamera