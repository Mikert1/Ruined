local objectsManager = {}
objectsManager.objects = {}
local objectsManager = {}
objectsManager.objects = {}

function loadObjectsForWorld(world)
    objectsManager.objects = {}
    if world == "Snow" then
        objectsManager.objects.tent = {
            type = "static",
            world = "Snow",
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
            world = "Mountains",
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
end

for k, v in pairs(objectsManager.objects) do
    if v.type == "animation" then
        for i = 1, v.animation.count do
            v.image[i] = love.graphics.newImage("assets/textures/world/structures/" .. k .. "/a" .. i .. ".png")
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
        end
    end
end

return objectsManager