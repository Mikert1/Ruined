local enemymanager = {}
local stone = require("source/enemies/stone")
local boss = require("source/enemies/boss")
local worldManagement = require("source/worlds")
enemymanager.enemyGotHit = 0

function enemymanager:load()
    if self.activeStones then
        for i, entity in ipairs(self.activeStones) do
            world:remove(entity)
        end
    end
    self.activeStones = {}
end

function enemymanager:update(dt)
    for _, entity in ipairs(self.activeStones) do
        entity:update(dt)
        entity:followPlayer(player.x, player.y - 6, dt)
    end
    for i, entity in ipairs(self.activeStones) do
        if entity.health <= 0 then
            world:remove(entity)
            table.remove(self.activeStones, i)
        end
    end
end

function enemymanager:draw()
    table.sort(self.activeStones, function(a, b)
        return a.y < b.y
    end)
    for _, entity in ipairs(self.activeStones) do
        entity:draw()
    end
end

return enemymanager