local gui = {}
local title
local settings
local weapon
local button = require("src/gui/button")

function gui.load()
    title = require("src/gui/title")
    settings = require("src/gui/settings")
    weapon = require("src/gameplay/weapons")
    local anim8 = require("src/library/animations")
    gui.welcome = {}
    gui.welcome.timer = 0
    gui.welcome.image = love.graphics.newImage("assets/textures/gui/gameplay/welcome.png")
    gui.welcome.grid = anim8.newGrid( 75, 20, gui.welcome.image:getWidth(), gui.welcome.image:getHeight() )
    gui.welcome.animations = {}
    gui.welcome.animations.region1 = anim8.newAnimation( gui.welcome.grid('1-10', 1), 0.3 )

    gui.healthbar = {}
    gui.healthbar.image = {}
    gui.healthbar.animation = {
        current = 0
    }
    for i = 0, 8 do
        gui.healthbar.image[i] = love.graphics.newImage("assets/textures/gui/gameplay/healthBar/" .. i ..".png")
    end

    gui.focusbar = {}
    gui.focusbar.sprite = love.graphics.newImage("assets/textures/gui/gameplay/specialbar.png")
    gui.focusbar.grid = anim8.newGrid( 78, 14, gui.focusbar.sprite:getWidth(), gui.focusbar.sprite:getHeight())
    gui.focusbar.animations = {}
    gui.focusbar.animations.normal = anim8.newAnimation(gui.focusbar.grid('1-9', 1), 1)
    gui.focusbar.animations.bow = anim8.newAnimation(gui.focusbar.grid('1-9', 3), 1)
    gui.focusbar.anim = gui.focusbar.animations.normal
    gui.focusbar.active = false
    gui.focusbar.bowActive = false
    gui.focusbar.lightActive = false
    gui.focusReady = false
    gui.focusTime = 0
    gui.gameover = love.graphics.newImage("assets/textures/gui/gameplay/gameover.png")

    gui.hide = {}
    gui.hide.sword = {}
    gui.hide.sword.y = -20
    gui.hide.health = {}
    gui.hide.health.y = -20

    gui.text = {}
    gui.text.back = "Title screen"
    gui.text.settings = "Settings"
    gui.text.resume = "Resume"

    gui.map = false
    gui.mapImage = love.graphics.newImage("assets/textures/world/minimap/map.png")
    gui.mapImageBackground = love.graphics.newImage("assets/textures/world/minimap/background.png")
    gui.mapPoint = {}
    gui.mapPoint.x = player.x / 100
    gui.mapPoint.y = player.y / 100
    gui.mapWorld = {
        x = 0,
        y = 0
    }
end

function gui.update(dt)
    if gui.welcome.timer > 0 then
        gui.welcome.timer = gui.welcome.timer - dt
        gui.welcome.animations.region1:update(dt)
    end
    if weapon.equipment == 1 then
        gui.focusbar.anim = gui.focusbar.animations.normal
        if gui.focusTime == 8 then
            gui.focusbar.anim:gotoFrame(1)
        elseif gui.focusTime >= 7 then
            gui.focusbar.anim:gotoFrame(2)
        elseif gui.focusTime >= 6 then
            gui.focusbar.anim:gotoFrame(3)
        elseif gui.focusTime >= 5 then
            gui.focusbar.anim:gotoFrame(4)
        elseif gui.focusTime >= 4 then
            gui.focusbar.anim:gotoFrame(5)
        elseif gui.focusTime >= 3 then
            gui.focusbar.anim:gotoFrame(6)
        elseif gui.focusTime >= 2 then
            gui.focusbar.anim:gotoFrame(7)
        elseif gui.focusTime >= 1 then
            gui.focusbar.anim:gotoFrame(8)
        elseif gui.focusTime >= 0 then
            gui.focusbar.anim:gotoFrame(9)
            player.focus = false
        end
    elseif weapon.equipment == 2 then
        gui.focusbar.anim = gui.focusbar.animations.bow
        if weapon.bow.arrow.count == 8 then
            gui.focusbar.anim:gotoFrame(1)
        elseif weapon.bow.arrow.count >= 7 then
            gui.focusbar.anim:gotoFrame(2)
        elseif weapon.bow.arrow.count >= 6 then
            gui.focusbar.anim:gotoFrame(3)
        elseif weapon.bow.arrow.count >= 5 then
            gui.focusbar.anim:gotoFrame(4)
        elseif weapon.bow.arrow.count >= 4 then
            gui.focusbar.anim:gotoFrame(5)
        elseif weapon.bow.arrow.count >= 3 then
            gui.focusbar.anim:gotoFrame(6)
        elseif weapon.bow.arrow.count >= 2 then
            gui.focusbar.anim:gotoFrame(7)
        elseif weapon.bow.arrow.count >= 1 then
            gui.focusbar.anim:gotoFrame(8)
        elseif weapon.bow.arrow.count == 0 then
            gui.focusbar.anim:gotoFrame(9)
        end
    end
    if not gui.healthbar then
        gui.healthbar = {}
    end
    if not player.hearts then
        gui.healthbar.hearts = 7
    end
    if player.hearts >= 9 then
        player.hearts = 8
    end
    gui.healthbar.animation.current = player.hearts
    if gui.focus == false then
        gui.healthbar.anim = gui.healthbar.animations.normal
        player.sheet = player.spriteSheet
    end
end

function gui.hider(dt)
    if gui.hide.sword.y >= -20  then
        gui.hide.sword.y = gui.hide.sword.y - (dt * 100)
    end
    if gui.hide.health.y >= -20 then
        gui.hide.health.y = gui.hide.health.y - (dt * 100)
    end
end
function gui.shower(dt)
    if gui.hide.sword.y < 0 then
        if player.item.sword == true then
            gui.hide.sword.y = gui.hide.sword.y + (dt * 100)
        end
    else
        gui.hide.sword.y = 0
    end
    if gui.hide.health.y < 0 then
        gui.hide.health.y = gui.hide.health.y + (dt * 100)
    else
        gui.hide.health.y = 0
    end
end

function gui:draw()
    if player.isDead == true then
        love.graphics.draw(gui.gameover, love.graphics.getWidth() / 2 - (46 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (40 * playerCamera.globalScale), nil, playerCamera.globalScale)
        love.graphics.print("Press enter (return) to load last save.", love.graphics.getWidth() / 2 - (46 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (30 * playerCamera.globalScale), nil, playerCamera.globalScale / 2.5)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(gui.healthbar.image[gui.healthbar.animation.current], 0, love.graphics.getHeight() - (16.5 * playerCamera.globalScale) - gui.hide.health.y * playerCamera.globalScale, nil, playerCamera.globalScale * 1.2)
    gui.focusbar.anim:draw(gui.focusbar.sprite, love.graphics.getWidth() - (93.5 * playerCamera.globalScale), love.graphics.getHeight() - (16.5 * playerCamera.globalScale) - gui.hide.sword.y * playerCamera.globalScale, nil, playerCamera.globalScale * 1.2)
    -- if gui.welcome.timer > 0 then
    --     gui.welcome.animations.region1:draw(gui.welcome.image, love.graphics.getWidth() / 2 - (75 / 2 * playerCamera.globalScale), love.graphics.getHeight() / 4 - (20 / 2 * playerCamera.globalScale), nil, playerCamera.globalScale)
    -- end
    if gui.map == true then
        if player.isMoving == false then
            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        end
        if player.isMoving == true then
            love.graphics.setColor(1, 1, 1, 0.5)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.draw(gui.mapImageBackground, love.graphics.getWidth() / 2 - (gui.mapImageBackground:getWidth() / 2 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (gui.mapImageBackground:getHeight() / 2 * playerCamera.globalScale), nil, playerCamera.globalScale)
        love.graphics.draw(gui.mapImage, love.graphics.getWidth() / 2 - (gui.mapImage:getWidth() / 2 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (gui.mapImage:getHeight() / 2 * playerCamera.globalScale), nil, playerCamera.globalScale)
        love.graphics.setColor(0, 1, 1)
        love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - (1 / 2 * playerCamera.globalScale) + (player.x / 16 * playerCamera.globalScale) + (gui.mapWorld.x * playerCamera.globalScale) - (gui.mapImage:getWidth() / 2 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (1 / 2 * playerCamera.globalScale) + (player.y / 16 * playerCamera.globalScale) + (gui.mapWorld.y * playerCamera.globalScale) - (gui.mapImage:getHeight() / 2 * playerCamera.globalScale), 5, 5, playerCamera.globalScale)
    end
    love.graphics.setColor(1, 1, 1)
end
return gui