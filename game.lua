local game = {}
game.version = "1.5"
game.name = "Ruined"
game.beta = "Early Developer Bèta"
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
game.controlType = 0
-- 0 = keyboard and mouse
-- 1 = controller
game.fps = {}
game.fps.set = 1 -- no fps set
-- 0 = no fps set (maximum)
-- 1 = 
game.freeze = true
-- function game.update(dt)
--     if game.fps.set == 1 then
--         game.fps.count = 60 -- remove after setting
--         game.fps.update(dt)
--     end
-- end

-- function game.fps.update(dt)
--     if dt < 1/game.fps.count then
--         love.timer.sleep(1/game.fps.count - dt)
--     end
-- end
return game