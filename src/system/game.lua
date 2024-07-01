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
    sprite = love.graphics.newImage("assets/textures/gui/gameplay/cursor.png"),
    color = {1, 1, 1, 0.5},
    isHovering = false
}

function game.update(dt)
    game.cursor.x, game.cursor.y = love.mouse.getPosition()
    if game.cursor.isHovering then
        game.cursor.color = {0, 1, 1, 1}
    else
        game.cursor.color = {0.3, 0.3, 0.3, 0.5}
    end
end

function game.draw()
    love.graphics.setColor(game.cursor.color)
    love.graphics.draw(game.cursor.sprite, game.cursor.x - 0.5 * playerCamera.globalScale, game.cursor.y - 0.5 * playerCamera.globalScale, 0, playerCamera.globalScale, playerCamera.globalScale, 0, 0)
    love.graphics.setColor(1, 1, 1)
end

return game