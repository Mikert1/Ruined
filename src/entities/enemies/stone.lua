local worldManagement = require("src/gameplay/worldmanager")
local stone = {
    image = love.graphics.newImage("assets/textures/entities/enemies/stone/body.png"),
    eyes = love.graphics.newImage("assets/textures/entities/enemies/stone/eyes.png")
}
stone.__index = stone

-- self functions

function stone.new(x, y, calorLVL)
    local instance = setmetatable({}, stone)
    instance.x = x
    instance.y = y
    instance.width = stone.image:getWidth()
    instance.offsetY = 6
    instance.height = 2
    world:add(instance, instance.x, instance.y, instance.width, instance.height)
    if calorLVL == 1 then
        instance.health = 1
        instance.speed = 30
        instance.eyeColor = {1, 1, 0}
    elseif calorLVL == 2 then
        instance.health = 2
        instance.speed = 40
        instance.eyeColor = {1, 0.5, 0}
    elseif calorLVL == 3 then
        instance.health = 4
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
        force = 150
    }
    instance.arrowInvincible = true
    return instance
end

function stone:takeDamage(damage, i)
    self.health = self.health - damage
    if self.health <= 0 then
        world:remove(self)
        table.remove(enemymanager.activeEnemies, i)
    end
end
        
        
function stone:walk(playerX, playerY, dt)
    local dx = playerX - (self.x + self.width / 2)
    local dy = (playerY + self.offsetY) - self.y
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance <= 80 then
        if dx < 0 then
            self.isLeft = true
        else
            self.isLeft = false
        end
        local dirX = dx / distance
        local dirY = dy / distance

        self.x, self.y = world:move(self, self.x + dirX * self.speed * dt, self.y + dirY * self.speed * dt)
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

--

function stone:update(dt)
    self:walk(player.x, player.y - 6, dt)
end

function stone:draw()
    if self.isLeft == false then
        love.graphics.draw(self.image, self.x, self.y - self.offsetY)
        love.graphics.setColor(self.eyeColor)
        love.graphics.draw(self.eyes, self.x, self.y - self.offsetY)
    else
        love.graphics.draw(self.image, self.x + self.width , self.y - self.offsetY, nil, -1, 1)
        love.graphics.setColor(self.eyeColor)
        love.graphics.draw(self.eyes, self.x + self.width , self.y - self.offsetY, nil, -1, 1)
    end
    if keys.tab == true then
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("line", self.collider.x, self.collider.y, self.collider.width, self.collider.height)
    end
    love.graphics.setColor(1, 1, 1)
end

return stone