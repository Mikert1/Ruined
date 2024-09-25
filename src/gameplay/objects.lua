local objectsManager = {}
objectsManager.objects = {}

local worldManagement = require("src/gameplay/worldmanager")
local file = require("src/system/data")

function loadObjectsForWorld(world)
    objectsManager.objects = {}
    if world == "Snow" then
        objectsManager.objects.tent = {
            type = "static",
            x = 167,
            y = 286,
            width = 46,
            height = 61,
            image = love.graphics.newImage("assets/textures/world/structures/tent/a.png"),
            imageBackground = love.graphics.newImage("assets/textures/world/structures/tent/b.png")
        }
    elseif world == "Mountains" then
        objectsManager.objects.cryonium = {
            type = "animation",
            x = 30,
            y = 100,
            width = 15,
            height = 20,
            image = {},
            animation = {
                frame = 1,
                timer = 0,
                count = 2,
                order = {
                    {
                        frameNumber = 1,
                        timeOnFrame = 0.2
                    },
                    {
                        frameNumber = 2,
                        timeOnFrame = 0.3
                    },
                    {
                        frameNumber = 1,
                        timeOnFrame = 0.1
                    },
                    {
                        frameNumber = 2,
                        timeOnFrame = 0.4
                    },
                    {
                        frameNumber = 1,
                        timeOnFrame = 0.1
                    },
                    {
                        frameNumber = 2,
                        timeOnFrame = 0.7
                    },
                    {
                        frameNumber = 1,
                        timeOnFrame = 0.1
                    },
                    {
                        frameNumber = 2,
                        timeOnFrame = 0.2
                    }
                }
            }
        }
    end
    local saveX, saveY = 0, 0
    for _, layer in ipairs(_G.currentWorld.layers) do
        if layer.name == "wall" then
            correctLayer = layer
            break
        end
    end
    if correctLayer then
        for _, object in ipairs(correctLayer.objects) do
            if object.name == "save" then
                saveX = object.x
                saveY = object.y
                break
            end
        end
    else
        saveX = 0
        saveY = 0
        print("[Warn  ] saveStone not found")
    end
    objectsManager.objects.savestone = {
        type = "interactive",
        subType = "walk",
        name = "save",
        radius = 35,
        x = saveX,
        y = saveY,
        width = 31,
        height = 32,
        active = false,
        activeImage = love.graphics.newImage("assets/textures/world/structures/savestone/active.png"),
        inactiveImage = love.graphics.newImage("assets/textures/world/structures/savestone/inactive.png"),
        ellipseCut = 1.2,
        timer = 0
    }
    for k, v in pairs(objectsManager.objects) do
        if v.type == "animation" then
            for i = 1, v.animation.count do
                v.image[i] = love.graphics.newImage("assets/textures/world/structures/" .. k .. "/a" .. i .. ".png")
            end
        end
    end
end

function objectsManager.update(dt)
    for k, v in pairs(objectsManager.objects) do
        if v.type == "animation" then
            v.animation.timer = v.animation.timer + dt
            if v.animation.timer > v.animation.order[v.animation.frame].timeOnFrame then
                v.animation.timer = 0
                v.animation.frame = v.animation.frame + 1
                if v.animation.frame > #v.animation.order then
                    v.animation.frame = 1
                end
            end
            elseif v.type == "interactive" then
            if v.subType == "walk" then
                if objectsManager.checkCollision(player, v) then
                    v.active = true
                    if worldManagement.saved == false then
                        worldManagement.saved = true
                        data = file.save()
                    end
                else
                    worldManagement.saved = false
                end
            end
        end
    end
end

function objectsManager.checkCollision(rect, ellipse)    
    local rectCenterX = rect.x + rect.width / 2
    local rectCenterY = rect.y + rect.height / 2

    local ellipseDistanceX = math.abs(ellipse.x - rectCenterX)
    local ellipseDistanceY = math.abs(ellipse.y - rectCenterY)

    if ellipseDistanceX <= (rect.width / 2 + ellipse.radius) and
        ellipseDistanceY <= (rect.height / 2 + ellipse.radius / ellipse.ellipseCut) then
        if ellipseDistanceX <= (rect.width / 2) or
            ellipseDistanceY <= (rect.height / 2) then
            return true
        end

        local cornerDistanceSquared = (ellipseDistanceX - rect.width / 2)^2 +
                                      (ellipseDistanceY - rect.height / 2)^2

        if cornerDistanceSquared <= (ellipse.radius^2) then
            return true
        end
    end
    return nil
end

function objectsManager.subDraw(drawLayer)
    for k, v in pairs(objectsManager.objects) do
        local objectY = v.y + v.height / 2
        if v.type == "interactive" and v.name == "save" then
            local ellipseCenterX = (v.x + v.width / 2) - v.radius / 2
            local ellipseCenterY = objectY
            if drawLayer == 1 and objectY < player.y then
            love.graphics.setColor(0, 1, 1, 0 + (v.timer / 2))
            love.graphics.ellipse("line", ellipseCenterX, ellipseCenterY + (v.timer * 10), v.radius, v.radius / v.ellipseCut)
            love.graphics.setColor(0, 1, 1, 0.5)
            love.graphics.ellipse("line", ellipseCenterX, ellipseCenterY, v.radius, v.radius / v.ellipseCut)
            elseif drawLayer == 2 and objectY >= player.y then
            love.graphics.setColor(0, 1, 1, 0 + (v.timer / 2))
            love.graphics.ellipse("line", ellipseCenterX, ellipseCenterY + (v.timer * 10), v.radius, v.radius / v.ellipseCut)
            love.graphics.setColor(0, 1, 1, 0.5)
            love.graphics.ellipse("line", ellipseCenterX, ellipseCenterY, v.radius, v.radius / v.ellipseCut)
            end
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end

function objectsManager.draw(drawLayer)
    objectsManager.subDraw(drawLayer)
    for k, v in pairs(objectsManager.objects) do
        local objectY = v.y + v.height / 2
        if v.type == "static" then
            if drawLayer == 1 then
                love.graphics.draw(v.imageBackground, v.x, v.y, 0, 1, 1, v.width / 2, v.height / 2)
            end
            if drawLayer == 1 and objectY < player.y then
                love.graphics.draw(v.image, v.x, v.y, 0, 1, 1, v.width / 2, v.height / 2)
            elseif drawLayer == 2 and objectY >= player.y then
                love.graphics.draw(v.image, v.x, v.y, 0, 1, 1, v.width / 2, v.height / 2)
            end
        elseif v.type == "animation" then
            if drawLayer == 1 and objectY < player.y then
                love.graphics.draw(v.image[v.animation.order[v.animation.frame].frameNumber], v.x, v.y, 0, 1, 1, v.width / 2, v.height / 2)
            elseif drawLayer == 2 and objectY >= player.y then
                love.graphics.draw(v.image[v.animation.order[v.animation.frame].frameNumber], v.x, v.y, 0, 1, 1, v.width / 2, v.height / 2)
            end
        elseif v.type == "interactive" then
            if drawLayer == 1 and objectY < player.y then
                if v.active then
                    love.graphics.draw(v.activeImage, v.x, v.y, 0, 1, 1, v.width / 2, v.height / 2)
                else
                    love.graphics.draw(v.inactiveImage, v.x, v.y, 0, 1, 1, v.width / 2, v.height / 2)
                end
            elseif drawLayer == 2 and objectY >= player.y then
                if v.active then
                    love.graphics.draw(v.activeImage, v.x, v.y, 0, 1, 1, v.width / 2, v.height / 2)
                else
                    love.graphics.draw(v.inactiveImage, v.x, v.y, 0, 1, 1, v.width / 2, v.height / 2)
                end
            end
        end
    end
end

return objectsManager