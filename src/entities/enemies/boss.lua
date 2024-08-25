local worldManagement = require("src/gameplay/worldmanager")
local boss = {image = love.graphics.newImage("assets/textures/entities/enemies/boss.png")}
boss.__index = boss
local stone = require("src/entities/enemies/stone") -- for the summon function

-- self functions

function boss.new(x, y, calorLVL)
    calorLVL = calorLVL or 1
    local instance = setmetatable({}, boss)
    instance.x = x
    instance.y = y
    instance.width = boss.image:getWidth()
    instance.height = 3
    instance.offsetY = boss.image:getHeight() - instance.height
    world:add(instance, instance.x, instance.y, instance.width, instance.height)
    if calorLVL == 1 then
        instance.health = 20
        instance.speed = 30
        instance.eyeColor = {1, 1, 0}
    elseif calorLVL == 2 then
        instance.health = 30
        instance.speed = 40
        instance.eyeColor = {1, 0.5, 0}
    elseif calorLVL == 3 then
        instance.health = 50
        instance.speed = 50
        instance.eyeColor = {1, 0, 0}
    end
    instance.isLeft = false
    instance.stepTimer = 5
    instance.collider = {
        x = instance.x - 0.5,
        y = instance.y - 0.5,
        width = instance.width + 1,
        height = instance.height + 1
    }
    instance.knockback = {
        x = 0,
        y = 0,
        force = 100
    }
    instance.arrowInvincible = false
    instance.attackTimer = 0
    instance.distanceFromPlayer = 200
    
    return instance
end

function boss:death()
    world:remove(self)
    for i, enemy in ipairs(enemymanager.activeEnemies) do
        if enemy == self then
            table.remove(enemymanager.activeEnemies, i)
            break
        end
    end
end

function boss:takeDamage(damage, i)
    self.health = self.health - damage
    if self.health <= 0 then
        self:death()
    end
end

function boss:summon()
    for i = 1, 5 do
        range = 50
        random = math.random() * 2
        local x = math.random(self.x + (self.width / 2) - range, self.x + (self.width / 2) + range)
        local y = math.random(self.y - range, self.y + range)
        stone.delaySummon(x, y, 2, random)
    end
end

function boss:attack(dt)
    if self.attackTimer <= 0 then
        self.attackTimer = 10
        if self.distanceFromPlayer <= 220 then
            self:summon()
        end
    end
    self.attackTimer = self.attackTimer - dt
end

function boss:walk(playerX, playerY, dt)
    local dx = (playerX + 6) - (self.x + self.width / 2)
    local dy = (playerY + self.offsetY) - self.y
    self.distanceFromPlayer = math.sqrt(dx * dx + dy * dy)

    if self.distanceFromPlayer <= 200 then
        if dx < 0 then
            self.isLeft = true
        else
            self.isLeft = false
        end
        local dirX = dx / self.distanceFromPlayer
        local dirY = dy / self.distanceFromPlayer
        if self.distanceFromPlayer > 81 then
            self.x, self.y = world:move(self, self.x + dirX * self.speed * dt, self.y + dirY * self.speed * dt)  
        elseif self.distanceFromPlayer < 79 then
            self.x, self.y = world:move(self, self.x - dirX * self.speed * dt, self.y - dirY * self.speed * dt)
        else
            self.x, self.y = world:move(self, self.x, self.y)
        end
    else
        if self.stepTimer <= 5 then
            self.x, self.y = world:move(self, self.x + (dt * self.speed / 2), self.y)
            self.isLeft = false
        elseif self.stepTimer <= 10 then
            self.x, self.y = world:move(self, self.x - (dt * self.speed / 2), self.y)
            self.isLeft = true
        else
            self.stepTimer = 0
        end
        self.stepTimer = self.stepTimer + dt
        
    end
    self.collider = {
        x = self.x - 0.5,
        y = self.y - 0.5,
        width = self.width + 1,
        height = self.height + 1
    }

end

function boss:update(dt)
    self:walk(player.x, player.y - 6, dt)
    self:attack(dt)
end

function boss:draw()
    if self.isLeft == false then
        love.graphics.draw(self.image, self.x, self.y - self.offsetY)
    else
        love.graphics.draw(self.image, self.x + self.width , self.y - self.offsetY, nil, -1, 1)
    end
    if keys.tab == true then
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("line", self.collider.x, self.collider.y, self.collider.width, self.collider.height)
        love.graphics.setColor(1, 1, 1)
    end
end

return boss