local enemymanager = {}
local stone = require("src/entities/enemies/stone")
local boss = require("src/entities/enemies/boss")
local worldManagement = require("src/gameplay/worldmanager")
enemymanager.enemyGotHit = 0

function enemymanager:load()
    if self.activeEnemies then
        for _, entity in ipairs(self.activeEnemies) do
            world:remove(entity)
        end
    end
    self.activeEnemies = {}
end

function enemymanager:update(dt)
    for _, entity in ipairs(self.activeEnemies) do
        entity:update(dt)
        entity:walk(player.x, player.y - 6, dt)
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