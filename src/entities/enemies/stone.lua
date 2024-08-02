local worldManagement = require("src/gameplay/worldmanager")
local particle = require("src/gameplay/particle")
local stone = {
    animation = {
        summon = {
            path = {1, 2, 3, 4, 5, 6, 7, 8}
        },
        walk = {
            body = {},
            eyes = {},
            path = {1}
        }
    }
}
for i = 1, 8 do
    table.insert(stone.animation.summon, love.graphics.newImage("assets/textures/entities/enemies/stone/summon/" .. i .. ".png"))
end
for i = 1, 1 do
    table.insert(stone.animation.walk.body, love.graphics.newImage("assets/textures/entities/enemies/stone/walk/body/" .. i .. ".png"))
    table.insert(stone.animation.walk.eyes, love.graphics.newImage("assets/textures/entities/enemies/stone/walk/eyes/" .. i .. ".png"))
end
stone.__index = stone


-- self functions
function stone.new(x, y, calorLVL)
    local instance = setmetatable({}, stone)
    instance.animation = {
        state = "summon",
        current = 1,
        timer = 1,
        speed = 8,
    }
    instance.x = x
    instance.y = y
    instance.width = stone.animation.walk.body[1]:getWidth()
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
        particle.center.x = self.x + self.width / 2
        particle.center.y = self.y + self.height / 2
        world:remove(self)
        table.remove(enemymanager.activeEnemies, i)
        particle.system:emit(100)
    end
end
        
        
function stone:walk(playerX, playerY, dt)
    if self.animation.state == "walk" then
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
    else
        self.x, self.y = world:move(self, self.x, self.y)
        self.collider = {
            x = self.x - 0.5,
            y = self.y - 0.5,
            width = self.width + 1,
            height = self.height + 1
        }
    end
end

--

function stone:update(dt)
    self:walk(player.x, player.y - 6, dt)
    self.animation.timer = self.animation.timer - (dt * self.animation.speed)
    if self.animation.timer <= 0 then
        self.animation.current = self.animation.current + 1
        if self.animation.current > #stone.animation[self.animation.state].path then
            self.animation.current = 1
            if self.animation.state == "summon" then
                self.animation.state = "walk"
            end
        end
        self.animation.timer = 1
    end
end

function stone:draw()
    if self.animation.state == "walk" then
        love.graphics.draw(stone.animation[self.animation.state].body[self.animation.current], self.x, self.y - self.offsetY)
        love.graphics.setColor(self.eyeColor)
        if self.isLeft == false then
            love.graphics.draw(stone.animation[self.animation.state].eyes[self.animation.current], self.x, self.y - self.offsetY)
        else
            love.graphics.draw(stone.animation[self.animation.state].eyes[self.animation.current], self.x + self.width , self.y - self.offsetY, nil, -1, 1)
        end
    else
        if self.isLeft == false then
            love.graphics.draw(stone.animation[self.animation.state][self.animation.current], self.x, self.y - self.offsetY)
        else
            love.graphics.draw(stone.animation[self.animation.state][self.animation.current], self.x + self.width , self.y - self.offsetY, nil, -1, 1)
        end
    end
    if keys.tab == true then
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("line", self.collider.x, self.collider.y, self.collider.width, self.collider.height)
    end
    love.graphics.setColor(1, 1, 1)
end

return stone