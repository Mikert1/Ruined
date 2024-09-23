local objectsManager = {}
objectsManager.objects = {}
local objectsManager = {}
objectsManager.objects = {}

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
        radius = 20,
        x = saveX,
        y = saveY,
        width = 34,
        height = 32,
        active = true,
        activeImage = love.graphics.newImage("assets/textures/world/structures/savestone/active.png"),
        inactiveImage = love.graphics.newImage("assets/textures/world/structures/savestone/inactive.png"),
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
        end
    end
end

function objectsManager.draw(drawLayer)
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