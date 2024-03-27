local worldManagement = require("source/worlds")
local boss = {image = love.graphics.newImage("assets/textures/enemies/boss.png")}
boss.__index = boss

function boss.new(x,y)
    local instance = setmetatable({}, boss)
    instance.x = x
    instance.y = y
    instance.width = boss.image:getWidth()
    instance.offsetY = 6
    instance.height = 2
    world:add(instance, instance.x, instance.y, instance.width, instance.height)
    instance.health = 10
    instance.speed = 40
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
    instance.arrowInvincible = false
    
    return instance
end

function boss:update()

end

function boss:followPlayer() 

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
    print(self.health)
end

return boss