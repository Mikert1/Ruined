local enemymanager = {}
enemymanager.enemyTypes = {
    stone = require("src/entities/enemies/stone"),
    boss = require("src/entities/enemies/boss")
}
enemymanager.enemyGotHit = 0
enemymanager.activeEnemies = {}
enemymanager.delayEnemies = {}

local worldManagement = require("src/gameplay/worldmanager")
-- glabal functions

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
    end
    if #self.delayEnemies > 0 then
        for i = #self.delayEnemies, 1, -1 do
            local instance = self.delayEnemies[i]
            instance.delay = instance.delay - dt
            if instance.delay <= 0 then
                table.insert(self.activeEnemies, self.enemyTypes[instance.name].new(instance.x, instance.y, instance.lvl))
                table.remove(self.delayEnemies, i)
            end
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