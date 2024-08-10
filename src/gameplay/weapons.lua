local anim8 = require("src/library/animations")
local time = require("src/system/timer")
local bump = require 'src/library/bump'
local weapon = {}

weapon.equipment = 1

weapon.sword = {}
weapon.sword.image = love.graphics.newImage("assets/textures/entities/player/cryonium_sword.png")
weapon.sword.slash = {}
weapon.sword.slash.active = false
weapon.sword.slash.direction = 0

weapon.sword.animation = {
    state = 1,
    current = 1,
    timer = 1,
    speed = 30,
    image = {}
}

for j = 1, 3 do
    weapon.sword.animation.image[j] = {}
    local row = 5
    if j == 3 then
        row = 6
    end
    for i = 1, row do
        table.insert(weapon.sword.animation.image[j], love.graphics.newImage("assets/textures/entities/player/swordSlash/" .. j .. "/" .. i .. ".png"))
    end
end
weapon.sword.prepSlash = {}
weapon.sword.prepSlash.active = false
weapon.sword.combo = {
    timer = 1,
    max = 3,
    current = 1
}
weapon.sword.cooldown = false
weapon.sword.downTimer = 0
weapon.sword.collider = {
    x = 0,
    y = 0,
    width = 30,
    height = 30
}
weapon.sword.colliderActive = false
weapon.sword.sound = love.audio.newSource("assets/audio/hit.wav", "static")

weapon.bow = {}
weapon.bow.arrow = {}
weapon.bow.arrow.image = love.graphics.newImage("assets/textures/entities/player/arrow.png")
weapon.bow.arrow.active = false
weapon.bow.arrow.count = 8
weapon.bow.arrow.speed = 250
weapon.bow.hold = false
weapon.bow.holdCounter = 0

weapon.cursor = {}
weapon.cursor.x = 0
weapon.cursor.y = 0
weapon.cursor.angle = 0
weapon.cursor.distance = 0

weapon.aim = {}
weapon.aim.radius = 0
weapon.aim.startAngle = 0
weapon.aim.endAngle = 0

weapon.dammageDisplay = {}
weapon.dammageDisplay.timer = 0
weapon.enemyGotHit = false

local projectiles = {}
local Projectile = {}

-- local functions

local function applyKnockback(target, angle)
    target.knockback.x = target.knockback.force * math.cos(angle)
    target.knockback.y = target.knockback.force * math.sin(angle)
end

local function checkCollision(rect1, rect2, offsetX, offsetY)
    offsetX = offsetX or 0
    offsetY = offsetY or 0
    local rect1_right = rect1.x + rect1.width + offsetX
    local rect1_bottom = rect1.y + rect1.height + offsetY

    local rect2_right = rect2.x + rect2.width
    local rect2_bottom = rect2.y + rect2.height

    if (rect1.x + offsetX) < rect2_right and
       rect1_right > rect2.x and
       (rect1.y + offsetY) < rect2_bottom and
       rect1_bottom > rect2.y then
        return true
    end

    return false
end

local function findWallLayer()
    local correctLayer
    for _, layer in ipairs(_G.currentWorld.layers) do
        if layer.name == "wall" then
            for property, value in pairs(layer.properties) do
                if property == "collidable" and value == true then
                    correctLayer = layer
                    break
                end
            end
        end
    end
    return correctLayer
end

local function isColliding(collider)
    local correctLayer = findWallLayer()
    if correctLayer then
        for _, object in pairs(correctLayer.objects) do
            if checkCollision(collider, object) then
                return true
            end
        end
    end
    return false
end

-- dammageDisplay functions

function weapon.dammageDisplay.draw()
    if weapon.equipment == 1 then
        love.graphics.setColor(0, 1, 1)
    elseif weapon.equipment == 2 then
        love.graphics.setColor(1, 0.5, 0)
    end
    love.graphics.print(weapon.dammage, weapon.dammageDisplay.x, weapon.dammageDisplay.y)
    love.graphics.setColor(1, 1, 1)
end

-- projectile functions

function Projectile:new(x, y, speed, angle, image, hold)
    local speedNurf
    local angleNurf
    if hold > 1 then
        hold = hold - 1
        speedNurf = 2
        angleNurf = hold * 2
    else
        speedNurf = hold * 2
        angleNurf = 0
    end

    angleNurf = math.min(math.max(angleNurf, 0), 1)

    local maxAngleRange = math.pi / 8
    local angleRange = maxAngleRange * (1 - angleNurf)

    local randomAngleOffset = (math.random() * 2 - 1) * angleRange
    local randomizedAngle = angle + randomAngleOffset

    local projectile = {
        collider = {
            x = x,
            y = y,
            width = image:getHeight(),
            height = image:getHeight()
        },
        speed = speed * speedNurf,
        angle = randomizedAngle,
        image = image,
        isActive = true
    }

    local dx = projectile.speed * math.cos(projectile.angle) * 0.02
    local dy = projectile.speed * math.sin(projectile.angle) * 0.02
    
    projectile.collider.x = projectile.collider.x + dx
    projectile.collider.y = projectile.collider.y + dy
    world:add(projectile, projectile.collider.x, projectile.collider.y, 1, 1)
    setmetatable(projectile, self)
    self.__index = self
    return projectile
end

function Projectile:update(dt, i)
    self.speed = self.speed * 0.98 * (1 - dt)
    local dx = self.speed * math.cos(self.angle) * dt
    local dy = self.speed * math.sin(self.angle) * dt
    if self.isActive then
        self.collider.x, self.collider.y = world:move(self, self.collider.x - 0.5 + dx, self.collider.y - 0.5 + dy, function(item, other)
            return "touch"
        end)
        self.collider.x = self.collider.x + 0.5
        self.collider.y = self.collider.y + 0.5
    end
    if self.speed < 5 then
        if world:hasItem(self) then
            world:remove(self)
            self.isActive = false
        end
        for _, projectile in ipairs(projectiles) do
            if checkCollision(player, self.collider, 1.5, 1.5) then
                table.remove(projectiles, i)
                weapon.bow.arrow.count = weapon.bow.arrow.count + 1
                return
            end
        end
    else
        for i, enemy in ipairs(enemymanager.activeEnemies) do
            if checkCollision(enemy, self.collider, 1.5, 1.5) then
                if enemy.arrowInvincible then
                    weapon.dammage = 0.5
                    table.remove(projectiles, i)
                    world:remove(self)
                else
                    enemymanager.enemyGotHit = 0.5
                    self.speed = 0
                    weapon.dammage = 2
                    local angle = math.atan2(enemy.y - player.y, enemy.x - player.x)
                    applyKnockback(enemy, angle)
                end
                enemy:takeDamage(weapon.dammage, i)
                weapon.enemyGotHit = true
                enemymanager.enemyGotHit = 0.5
                weapon.dammageDisplay.x = enemy.x + love.math.random(-5, 5)
                weapon.dammageDisplay.y = enemy.y + love.math.random(0, 10)
            end
        end
    end
end

function Projectile:draw()
    love.graphics.draw(self.image, self.collider.x , self.collider.y, self.angle, 1, 1, self.collider.width * 3, self.collider.height / 2)
    if keys.tab == true then
		love.graphics.setColor(1, 0, 1, 0.3)
        love.graphics.rectangle("line", self.collider.x - self.collider.width / 2, self.collider.y - self.collider.height / 2, self.collider.width, self.collider.height, 0, 0)
        love.graphics.setColor(1, 1, 1)
    end
end

-- sword functions

function weapon.sword.update(dt)
    if weapon.sword.combo.timer > 0 then
        weapon.sword.combo.timer = weapon.sword.combo.timer - dt
    else
        weapon.sword.combo.timer = 0
        weapon.sword.combo.current = 1
    end
    if enemymanager.enemyGotHit >= 0 then
        enemymanager.enemyGotHit = enemymanager.enemyGotHit - dt
    end
    if weapon.sword.slash.active and weapon.sword.animation.timer <= 0 then
        weapon.sword.animation.current = weapon.sword.animation.current + 1
        if weapon.sword.animation.current > #weapon.sword.animation.image[weapon.sword.animation.state] then
            weapon.sword.animation.current = 1
            weapon.sword.slash.active = false
            if weapon.sword.combo.current < 3 then
                weapon.sword.combo.current = weapon.sword.combo.current + 1
            else
                weapon.sword.combo.current = 1
            end
            print(weapon.sword.combo.current)
        end
        weapon.sword.animation.timer = 1
    else
        weapon.sword.animation.timer = weapon.sword.animation.timer - (dt * weapon.sword.animation.speed)
    end
    if weapon.sword.cooldown == true then
        if weapon.sword.downTimer <= 0.5 then
            weapon.sword.downTimer = weapon.sword.downTimer + dt
        else
            weapon.sword.cooldown = false
        end
    end
    if weapon.enemyGotHit == true then
        if weapon.dammageDisplay.timer >= 60 then
            weapon.dammageDisplay.timer = 0
            weapon.enemyGotHit = false
        else
            weapon.dammageDisplay.timer = weapon.dammageDisplay.timer + dt
        end
    end
    for _, enemy in ipairs(enemymanager.activeEnemies) do
        enemy.x = enemy.x + enemy.knockback.x * dt
        enemy.y = enemy.y + enemy.knockback.y * dt
        enemy.knockback.x = enemy.knockback.x * 0.9
        enemy.knockback.y = enemy.knockback.y * 0.9
    end
end

function weapon.sword.use()
    if weapon.sword.slash.active == false and weapon.sword.cooldown == false and player.item.sword == true then
        weapon.enemyGotHit = false
        weapon.sword.animation.current = 1
        weapon.sword.animation.timer = 1
        weapon.sword.slash.active = true
        local playerCenterX = player.x + player.width / 2
        local playerCenterY = player.y + player.height / 2
        local angle
        if controller.joysticks then
            angle = math.atan2(controller.joysticks:getGamepadAxis("righty"), controller.joysticks:getGamepadAxis("rightx"))
        else
            local mouseX, mouseY = playerCamera.cam:mousePosition()
            angle = math.atan2(mouseY - playerCenterY, mouseX - playerCenterX)
        end

        local colliderDistance = 15
        local imageDistance = 25

        weapon.sword.collider.x = playerCenterX + colliderDistance * math.cos(angle) - weapon.sword.collider.width / 2
        weapon.sword.collider.y = playerCenterY + colliderDistance * math.sin(angle) - weapon.sword.collider.height / 2
        weapon.sword.slash.x = playerCenterX + imageDistance * math.cos(angle) - weapon.sword.collider.width / 2
        weapon.sword.slash.y = playerCenterY + imageDistance * math.sin(angle) - weapon.sword.collider.height / 2
        weapon.sword.slash.direction = angle - 1.5

        if angle > 1.5 or angle < -1.5 then
            player.isLeft = true
            if angle > 0 then
                player.isUp = false
                player.anim = player.animations.downLeft
            else
                player.isUp = true
                player.anim = player.animations.upLeft
            end
        else
            player.isLeft = false
            if angle > 0 then
                player.isUp = false
                player.anim = player.animations.downRight
            else
                player.isUp = true
                player.anim = player.animations.upRight
            end
        end

        for i, enemy in ipairs(enemymanager.activeEnemies) do
            if checkCollision(weapon.sword.collider, enemy.collider) then
                weapon.sword.combo.timer = 1
                enemymanager.enemyGotHit = 0.5
                weapon.dammage = 1
                if weapon.sword.combo.current == 3 then
                    weapon.dammage = 2
                end
                if player.focus == true then
                    weapon.dammage = 2
                    if weapon.sword.combo.current == 3 then
                        weapon.dammage = 4
                    end
                end
                local angle = math.atan2(enemy.y - player.y, enemy.x - player.x)
                enemy:takeDamage(weapon.dammage, i)
                applyKnockback(enemy, angle)
                weapon.enemyGotHit = true
                weapon.dammageDisplay.x = (enemy.x + (enemy.width / 2)) + love.math.random(-5, 5)
                weapon.dammageDisplay.y = (enemy.y + (enemy.height / 2)) + love.math.random(0, 10)
            end
        end
        if weapon.enemyGotHit == false then
            weapon.sword.cooldown = true
            weapon.sword.downTimer = 0
        else
            --weapon.sword.sound:play()
        end
        player.speedMultiplier = 3
        if weapon.sword.combo.current >= 3 then
            weapon.sword.cooldown = true
            weapon.sword.downTimer = 0
            playerCamera.shaker = 0.2
        end
    end
end

-- bow functions

function weapon.bow.update(dt)
    for i, projectile in ipairs(projectiles) do
        projectile:update(dt, i)
    end
    if weapon.bow.arrow.active == true then
        weapon.bow.arrow.active = false
    end
    if weapon.bow.hold then
        if weapon.bow.holdCounter < 1.8 then
            weapon.bow.holdCounter = weapon.bow.holdCounter + dt
        else
            weapon.bow.holdCounter = 1.8
        end
        player.speedMultiplier = 3
    end
end


function weapon.bow.charge()
    if weapon.bow.arrow.count >= 1 and not weapon.bow.arrow.active then
        weapon.bow.hold = true
    end
end

function weapon.bow.use()
    weapon.bow.hold = false
    if weapon.bow.arrow.count >= 1 and not weapon.bow.arrow.active then
        weapon.bow.arrow.active = true
        
        weapon.bow.arrow.count = weapon.bow.arrow.count - 1
        local playerCenterX = player.x + player.width / 2
        local playerCenterY = player.y + player.height / 2
        
        local angle
        if controller.joysticks then
            angle = math.atan2(controller.joysticks:getGamepadAxis("righty"), controller.joysticks:getGamepadAxis("rightx"))
        else
            local mouseX, mouseY = playerCamera.cam:mousePosition()
            angle = math.atan2(mouseY - playerCenterY, mouseX - playerCenterX)
        end
        
        local arrow = Projectile:new(playerCenterX, playerCenterY, weapon.bow.arrow.speed, angle, weapon.bow.arrow.image, weapon.bow.holdCounter)
        table.insert(projectiles, arrow)
        weapon.bow.holdCounter = 0
    end
end

-- global functions

function weapon.update(dt)
    weapon.cursor.x, weapon.cursor.y = player.x + player.width / 2, player.y + player.height / 2
    local mouseX, mouseY = playerCamera.cam:mousePosition()
    weapon.cursor.angle = math.atan2(mouseY - weapon.cursor.y, mouseX - weapon.cursor.x)
    -- realy calculate the distance
    local dx = mouseX - weapon.cursor.x
    local dy = mouseY - weapon.cursor.y
    weapon.cursor.distance = math.sqrt(dx * dx + dy * dy)

    if weapon.bow.hold then
        hold = weapon.bow.holdCounter
        local speedNurf
        local angleNurf
        if hold > 1 then
            hold = hold - 1
            speedNurf = 1 * 2
            angleNurf = hold * 2
        else
            speedNurf = hold * 2
            angleNurf = 0
        end
        local dx, dy
        if controller.joysticks then
            dx = controller.joysticks:getGamepadAxis("rightx")
            dy = controller.joysticks:getGamepadAxis("righty")
        else
            local mouseX, mouseY = playerCamera.cam:mousePosition()
            dx = mouseX - weapon.cursor.x
            dy = mouseY - weapon.cursor.y
        end
        local fixedAngle = math.pi / 4 + math.atan2(dy, dx) - 0.7853981633974483
        weapon.aim.radius = (weapon.bow.arrow.speed * speedNurf) * 0.46
        local scalingFactor = 1 - angleNurf / 1.66

        weapon.aim.startAngle = fixedAngle - (math.pi / 8) * scalingFactor
        weapon.aim.endAngle = fixedAngle + (math.pi / 8) * scalingFactor
    end
    weapon.sword.update(dt)
    weapon.bow.update(dt)
end


function weapon.draw()
    if weapon.sword.slash.active == true then
        -- if the direction is negative
        if weapon.sword.slash.direction < 0 and -1 or 0 then
            local image = weapon.sword.animation.image[weapon.sword.combo.current][weapon.sword.animation.current]
            local x = weapon.sword.slash.x + 34 - image:getWidth() / 2
            local y = weapon.sword.slash.y + 6 + image:getHeight() / 2
            local direction = weapon.sword.slash.direction
            local offsetX = image:getWidth() / 2
            local offsetY = image:getHeight() / 2
            love.graphics.draw(image, x, y, direction, 1, 1, offsetX, offsetY)
            if keys.tab == true then
                love.graphics.setColor(1, 0, 1)
                love.graphics.rectangle("line", weapon.sword.collider.x, weapon.sword.collider.y, weapon.sword.collider.width, weapon.sword.collider.height)
                love.graphics.setColor(1, 1, 1)
            end
        end
    end
    if enemymanager.enemyGotHit > 0 then
        weapon.dammageDisplay.draw()
    end
    for _, projectile in ipairs(projectiles) do
        projectile:draw()
    end
    if weapon.bow.hold then    
        love.graphics.setColor(1, 1 - weapon.bow.holdCounter / 2, 0, 0.2)
        love.graphics.arc("line", weapon.cursor.x, weapon.cursor.y, weapon.aim.radius, weapon.aim.startAngle, weapon.aim.endAngle)
        love.graphics.setColor(1, 1, 1)
    end
end

function weapon.draw2L()
    if weapon.sword.slash.active == true then
        if weapon.sword.slash.direction > 0 and 1 then
            local image = weapon.sword.animation.image[weapon.sword.combo.current][weapon.sword.animation.current]
            local x = weapon.sword.slash.x + 34 - image:getWidth() / 2
            local y = weapon.sword.slash.y + 6 + image:getHeight() / 2
            local direction = weapon.sword.slash.direction
            local offsetX = image:getWidth() / 2
            local offsetY = image:getHeight() / 2
            love.graphics.draw(image, x, y, direction, 1, 1, offsetX, offsetY)
            if keys.tab == true then
                love.graphics.setColor(1,0,1)
                love.graphics.rectangle("line", weapon.sword.collider.x, weapon.sword.collider.y, weapon.sword.collider.width, weapon.sword.collider.height)
                love.graphics.setColor(1,1,1)
            end
        end
    end
end

return weapon