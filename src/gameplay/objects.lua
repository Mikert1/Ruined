local objectsManager = {}

objectsManager.objects = {
    tent = {
        type = "static",
        world = "Snow",
        x = 167,
        y = 286,
        width = 46,
        height = 61,
        image = love.graphics.newImage("assets/textures/world/structures/tent.png"),
        imageBackground = love.graphics.newImage("assets/textures/world/structures/tentBackground.png")
    },
    cryonium = {
        type = "animation",
        world = "Snow",
        x = 0,
        y = 0,
        width = 13,
        height = 18,
        image = {},
        animation = {
            frame = 1,
            timer = 0,
            order = {1, 2}
        }
    }
}

for i = 1, 2 do
    objectsManager.objects.cryonium.image[i] = love.graphics.newImage("assets/textures/world/cryonium/a" .. i .. ".png")
end

function objectsManager.update(dt)
    for k, v in pairs(objectsManager.objects) do
        if v.type == "animation" then
            v.animation.timer = v.animation.timer + dt
            if v.animation.timer > 0.5 then
                v.animation.timer = 0
                v.animation.frame = v.animation.frame + 1
                if v.animation.frame > #v.animation.order then
                    v.animation.frame = 1
                end
            end
        end
    end
end

function objectsManager.draw(drawLayer, world)
    print("Drawing objects")
    print(objectsManager.objects)
    for k, v in pairs(objectsManager.objects) do
        if v.world == world then
            if v.type == "static" then
                if drawLayer == 1 then
                    love.graphics.draw(v.imageBackground, v.x, v.y, 0, 1, 1, v.width / 2, v.height / 2)
                elseif drawLayer == 2 then
                    love.graphics.draw(v.image, v.x, v.y, 0, 1, 1, v.width / 2, v.height / 2)
                end
            elseif v.type == "animation" then
                if drawLayer == 1 then
                    love.graphics.draw(v.image[v.animation.order[v.animation.frame]], v.x, v.y, 0, 1, 1, v.width / 2, v.height / 2)
                elseif drawLayer == 2 then
                    love.graphics.draw(v.image[v.animation.order[v.animation.frame]], v.x, v.y, 0, 1, 1, v.width / 2, v.height / 2)
                end
            end
        end
    end
end

return objectsManager