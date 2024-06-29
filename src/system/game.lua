local game = {}
game.version = "1.6"
game.name = "Ruined"
game.beta = "Early Developer Bèta"
game.buildName = "(DEV Build)"
game.chapter = 1
game.state = 1
-- 0 = main gameplay
-- 1 = title screen
-- 2 = cutscene,s and npc talks
-- 2.1 = talking
-- 2.2 = player walking show
-- 2.3 = camera movement
-- 2.4 = show and camera
-- 2.5 = show and talk
-- 2.6 = talk and camera
game.lanEnabled = false
game.esc = false
game.controlType = 0
-- 0 = keyboard and mouse
-- 1 = controller
-- 2 = touchpad or phone
game.freeze = true

game.cursor = {
    x = 0,
    y = 0,
    -- sprite = love.graphics.newImage("assets/textures/gui/cursor.png")
}

function game.update(dt)
    game.cursor.x, game.cursor.y = love.mouse.getPosition()
end

function game.draw()
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.circle("fill", game.cursor.x - 4, game.cursor.y - 4, 8, 8)
    love.graphics.setColor(1, 1, 1)
end

return game