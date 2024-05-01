local story = require("src/story/story")
local scene = {}
scene.camera = {}
scene.x = 0
scene.y = 0

function scene.welcome()
    scene.x = 300
    scene.y = 0
    scene.stopPositive = true
end

function scene.camera.update(dt)
    scene.x = scene.x - (dt * 30)
    if scene.stopPositive == true then
        if scene.x <= 0 and scene.y <= 0 then
            game.state = 0
            scene.x, scene.y = 0, 0
        end
    else
        if scene.x >= 0 and scene.y >= 0 then
            game.state = 0
            scene.x, scene.y = 0, 0
        end
    end
end

return scene