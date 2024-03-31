local enemymanager = {}
local stone = require("source/enemies/stone")
local boss = require("source/enemies/boss")
local worldManagement = require("source/worlds")
enemymanager.enemyGotHit = 0

function enemymanager:load()
    if self.activeEnemies then
        for i, entity in ipairs(self.activeEnemies) do
            world:remove(entity)
        end
    end
    self.activeEnemies = {}
end

function enemymanager:update(dt)
    for _, entity in ipairs(self.activeEnemies) do
        entity:update(dt)
        entity:followPlayer(player.x, player.y - 6, dt)
    end
    for i, entity in ipairs(self.activeEnemies) do
        if entity.health <= 0 then
            world:remove(entity)
            table.remove(self.activeEnemies, i)
        end
    end
end

function enemymanager:draw()
    table.sort(self.activeEnemies, function(a, b)
        return a.y < b.y
    end)
    for _, entity in ipairs(self.activeEnemies) do
        if entity.y <= player.y then
            entity:draw()
        end
    end
end

function enemymanager:draw2L()
    for _, entity in ipairs(self.activeEnemies) do
        if entity.y > player.y then
            entity:draw()
        end
    end
end

return enemymanager