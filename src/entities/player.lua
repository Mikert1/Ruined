local anim8
local bump
local file
local worldManagement
local weapon
local player = {}
local gui
local sword = {}

function player.loadAssets()
    anim8 = require 'src/library/animations'
    bump = require 'src/library/bump'
    
    file = require("src/system/data")
    worldManagement = require("src/gameplay/worldmanager")
    weapon = require("src/gameplay/weapons")
    gui = require("src/gui/gui")
end

function player.load()
    player.x = 71.9
    player.y = 165.5
    player.width = 12
    player.height = 2
    player.speedMultiplier = 10
    player.speed = 10 * player.speedMultiplier
    player.sideSpeed = 7.71067812 * player.speedMultiplier
    player.hearts = 8
    player.gotHit = false
    player.isDead = false
    player.invincibleTimer = 0
    world:add(player, player.x, player.y, 12, 2)
    player.spriteSheet = love.graphics.newImage("assets/textures/entities/player/player.png")
    player.spriteSheetfocus = love.graphics.newImage("assets/textures/entities/player/playerfocus.png")
    player.shadow = love.graphics.newImage("assets/textures/entities/player/shadow.png")
    player.sheet = player.spriteSheet
    player.grid = anim8.newGrid(19, 21, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    player.animations = {
        downRight = anim8.newAnimation( player.grid('1-4', 1), 0.2 ),
        downLeft  = anim8.newAnimation( player.grid('1-4', 1), 0.2 ),
        upRight   = anim8.newAnimation( player.grid('1-3', 2), 0.2 ),
        upLeft    = anim8.newAnimation( player.grid('1-3', 2), 0.2 ),
        Swimming  = anim8.newAnimation( player.grid('1-2', 5), 0.2 ),
        focus     = anim8.newAnimation( player.grid('1-5', 4), 0.3 ),
        dead      = anim8.newAnimation( player.grid('1-2', 3), 0.3 )
    }
    player.anim = player.animations.downLeft
    player.anim1 = player.animations.downLeft
    player.isUp = false
    player.isLeft = false
    player.isSwimming = false

    player.noMove = false
    player.isMoving = false
    player.acceleration = 5 * player.speedMultiplier
    player.deceleration = 5 * player.speedMultiplier
    player.maxSpeed = 2 * player.speedMultiplier
    player.maxSideSpeed = 1.54213562 * player.speedMultiplier

    player.focus = false
    player.focusAnim = false

    player.item = {}
    player.item.sword = false
    player.walkingOnGrass = love.audio.newSource("assets/audio/grass3.wav", "static")
    player.walkingOnGrass:setVolume(0.3)
    player.walkingOnGrass:setLooping(true)
    
end

local function checkCollision(rect1, rect2)
    local rect1_right = rect1.x + rect1.width
    local rect1_bottom = rect1.y + rect1.height

    local rect2_right = rect2.collider.x + rect2.collider.width
    local rect2_bottom = rect2.collider.y + rect2.collider.height

    if rect1.x < rect2_right and
        rect1_right > rect2.collider.x and
        rect1.y < rect2_bottom and
        rect1_bottom > rect2.collider.y then
        return true
    end

    return false
end

function player.update(dt)
    if player.gotHit == false then
        for _, enemy in ipairs(enemymanager.activeEnemies) do
            if checkCollision(player, enemy) then
                player.hearts = player.hearts - 1
                player.gotHit = true
                break
            end
        end
    else
        player.invincibleTimer = player.invincibleTimer + dt
        if player.invincibleTimer >= 1 then
            player.gotHit = false
            player.invincibleTimer = 0
        end
    end
    if player.hearts <= 0 then
        player.noMove = true
        player.isDead = true
        player.anim = player.animations.dead
        if love.keyboard.isDown("return") then
            enemymanager:load()
            data = file.load()
            worldManagement.teleport("start")
            player.noMove = false
            player.isDead = false
        end
    end
end

function player.movement(dt)
    player.isMoving = false
    local dx, dy = 0, 0
    if game.controlType == 0 then
        if player.noMove == false then
            if love.keyboard.isDown("right", controls.keys.right) then
                if love.keyboard.isDown(controls.keys.down, controls.keys.up,"up","down") then
                    dx = player.sideSpeed * dt
                else
                    dx = player.speed * dt
                end
                if player.isUp == false then
                    player.anim = player.animations.downRight
                else
                    player.anim = player.animations.upRight
                end
                if player.isSwimming == true then
                    player.anim = player.animations.Swimming
                end
                player.isLeft = false
                player.isMoving = true
            end
            if love.keyboard.isDown("left", controls.keys.left) then
                if love.keyboard.isDown(controls.keys.down, controls.keys.up, "down","up") then
                    dx = player.sideSpeed * -1 * dt
                else
                    dx = player.speed * -1 * dt
                end
                if player.isUp == false then
                    player.anim = player.animations.downLeft
                else
                    player.anim = player.animations.upLeft
                end
                if player.isSwimming == true then
                    player.anim = player.animations.Swimming
                end
                player.isLeft = true
                player.isMoving = true
            end
            if love.keyboard.isDown("up",controls.keys.up) then
                if love.keyboard.isDown(controls.keys.left,controls.keys.right,"left","right") then
                    dy = player.sideSpeed * -1 * dt
                else
                    dy = player.speed * -1 * dt
                end
                if player.isLeft == false then
                    player.anim = player.animations.upRight
                else
                    player.anim = player.animations.upLeft
                end
                if player.isSwimming == true then
                    player.anim = player.animations.Swimming
                end
                player.isUp = true
                player.isMoving = true
            end
            if love.keyboard.isDown("down", controls.keys.down) then
                if love.keyboard.isDown(controls.keys.left, controls.keys.right, "left", "right") then
                    dy = player.sideSpeed * dt
                else
                    dy = player.speed * dt
                end
                if player.isLeft == true then
                    player.anim = player.animations.downRight
                else
                    player.anim = player.animations.downLeft
                end
                if player.isSwimming == true then
                    player.anim = player.animations.Swimming
                end
                player.isUp = false
                player.isMoving = true
            end
            if player.isSwimming == true then
                --player.focus = false
                -- only hot water dammage
            end
            player.x, player.y = world:move(player, player.x + dx, player.y + dy)
        end
    else
        if player.noMove == false then
            if controller.joysticks:getGamepadAxis("leftx") > 0.1 then
                dx = player.speed * dt * controller.joysticks:getGamepadAxis("leftx")
                if player.isUp == false then
                    player.anim = player.animations.downRight
                else
                    player.anim = player.animations.upRight
                end
                if player.isSwimming == true then
                    player.anim = player.animations.Swimming
                end
                player.isLeft = false
                player.isMoving = true
            elseif controller.joysticks:getGamepadAxis("leftx") < -0.1 then
                dx = player.speed * dt * controller.joysticks:getGamepadAxis("leftx")
                if player.isUp == false then
                    player.anim = player.animations.downLeft
                else
                    player.anim = player.animations.upLeft
                end
                if player.isSwimming == true then
                    player.anim = player.animations.Swimming
                end
                player.isLeft = true
                player.isMoving = true
            end
            if controller.joysticks:getGamepadAxis("lefty") > 0.1 then
                dy = player.speed * dt * controller.joysticks:getGamepadAxis("lefty")
                if player.isLeft == true then
                    player.anim = player.animations.downRight
                else
                    player.anim = player.animations.downLeft
                end
                if player.isSwimming == true then
                    player.anim = player.animations.Swimming
                end
                player.isUp = false
                player.isMoving = true
            elseif controller.joysticks:getGamepadAxis("lefty") < -0.1 then
                dy = player.speed * dt * controller.joysticks:getGamepadAxis("lefty")
                if player.isLeft == false then
                    player.anim = player.animations.upRight
                else
                    player.anim = player.animations.upLeft
                end
                if player.isSwimming == true then
                    player.anim = player.animations.Swimming
                end
                player.isUp = true
                player.isMoving = true
            end
            player.x, player.y = world:move(player, player.x + dx, player.y + dy)
        end
    end
    if (player.focusAnim == true or player.isMoving) == true and player.isDead == false then
        player.walkingOnGrass:play()
        player.anim:update(dt)
    else
        player.walkingOnGrass:stop()
        player.anim:gotoFrame(1)
    end
end

function player.focusUpdate(dt)
    if player.focusAnim == true then
        player.noMove = true
        player.anim = player.animations.focus
        if player.anim.position == 5 then
            player.focusAnim = false
            player.noMove = false
            player.focus = true
            --gui.healthbar.anim = gui.healthbar.animations.focus
            player.sheet = player.spriteSheetfocus
            player.anim:gotoFrame(1)
            player.anim = player.animations.downLeft
            weapon.equipment = 1
        end
    end
    if player.focus == false then
        --healthbar.anim = healthbar.animations.normal
        player.sheet = player.spriteSheet
    end
end

function player:draw()
    love.graphics.draw(player.shadow, player.x, player.y)
    if player.isLeft == false then
        player.anim:draw(player.sheet, player.x + 6, player.y - 6, nil, 1, 1, 9.5, 10.5)
    else
        player.anim:draw(player.sheet, player.x + 6, player.y - 6, nil, -1, 1, 9.5, 10.5)
    end
end

return player