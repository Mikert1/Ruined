local gui = {}
local title
local settings
local weapon
function gui.load()
    title = require("source/screens/title")
    settings = require("source/screens/settings")
    weapon = require("source/weapons")
    local anim8 = require("assets/library/animations")
    gui.pressE = love.graphics.newImage("assets/textures/npc/pressE.png")
    gui.welcome = {}
    gui.welcome.timer = 0
    gui.welcome.image = love.graphics.newImage("assets/textures/gui/welcome.png")
    gui.welcome.grid = anim8.newGrid( 75, 20, gui.welcome.image:getWidth(), gui.welcome.image:getHeight() )
    gui.welcome.animations = {}
    gui.welcome.animations.region1 = anim8.newAnimation( gui.welcome.grid('1-10', 1), 0.3 )

    gui.healthbar = {}
    gui.healthbar.sprite = love.graphics.newImage("assets/textures/gui/healthbarplayer.png")
    gui.healthbar.grid = anim8.newGrid( 78, 14, gui.healthbar.sprite:getWidth(), gui.healthbar.sprite:getHeight() )
    gui.healthbar.animations = {}
    gui.healthbar.animations.normal = anim8.newAnimation(gui.healthbar.grid('1-9', 1), 0.3)
    gui.healthbar.animations.focus = anim8.newAnimation(gui.healthbar.grid('1-9', 3), 0.3)
    gui.healthbar.anim = gui.healthbar.animations.normal

    gui.focusbar = {}
    gui.focusbar.sprite = love.graphics.newImage("assets/textures/gui/specialbar.png")
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
    gui.gameover = love.graphics.newImage("assets/textures/gui/gameover.png")

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
    gui.mapImage = love.graphics.newImage("assets/textures/world/map.png")
    gui.mapImageBackground = love.graphics.newImage("assets/textures/world/mapBackground.png")
    gui.mapPoint = {}
    -- gui.mapPoint.image = love.graphics.newImage("assets/textures/world/mapPoint.png")
    gui.mapPoint.x = player.x / 100
    gui.mapPoint.y = player.y / 100
    gui.mapWorld = {
        x = 0,
        y = 0
    }
end

function gui.update(dt)
    if not love.window.hasFocus() then
        keys.esc = true
        game.esc = true
        player.noMove = true
        game.freeze = true
    end
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
    if player.hearts >= 8 then
        gui.healthbar.anim:gotoFrame(9)
    elseif player.hearts >= 7 and player.hearts < 8 then
        gui.healthbar.anim:gotoFrame(8)
    elseif player.hearts >= 6 and player.hearts < 7 then
        gui.healthbar.anim:gotoFrame(7)
    elseif player.hearts >= 5 and player.hearts < 6 then
        gui.healthbar.anim:gotoFrame(6)
    elseif player.hearts >= 4 and player.hearts < 5 then
        gui.healthbar.anim:gotoFrame(5)
    elseif player.hearts >= 3 and player.hearts < 4 then
        gui.healthbar.anim:gotoFrame(4)
    elseif player.hearts >= 2 and player.hearts < 3 then
        gui.healthbar.anim:gotoFrame(3)
    elseif player.hearts >= 1 and player.hearts < 2 then
        gui.healthbar.anim:gotoFrame(2)
    elseif player.hearts >= 0 and player.hearts < 1 then
        gui.healthbar.anim:gotoFrame(1)
    end
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
    if game.esc == true and title.state == 5 then
        title.button.normal.menu.button1:draw(title.button.normal.image, love.graphics.getWidth() / 2 - (40 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (25 * playerCamera.globalScale), nil, playerCamera.globalScale)
        title.button.normal.menu.button2:draw(title.button.normal.image, love.graphics.getWidth() / 2 - (40 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (0 * playerCamera.globalScale), nil, playerCamera.globalScale)
        title.button.red.menu.button1:draw(title.button.red.image, love.graphics.getWidth() / 2 - (40 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (25 * playerCamera.globalScale), nil, playerCamera.globalScale)
        if not(title.button.red.menu.button1 == title.button.red.animations.normal) then
            love.graphics.setColor(1, 0, 0)
        else
            love.graphics.setColor(0.15, 0.15, 0.15)
        end
        love.graphics.print(gui.text.back, love.graphics.getWidth() / 2 - (font:getWidth(gui.text.back) / 2 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (26 * playerCamera.globalScale), nil, playerCamera.globalScale)
        if not(title.button.normal.menu.button2 == title.button.normal.animations.normal) then
            love.graphics.setColor(title.mainColor)
        else
            love.graphics.setColor(0.15, 0.15, 0.15)
        end
        love.graphics.print(gui.text.settings, love.graphics.getWidth() / 2 - (font:getWidth(gui.text.settings) / 2 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (1 * playerCamera.globalScale), nil, playerCamera.globalScale)
        if not(title.button.normal.menu.button1 == title.button.normal.animations.normal) then
            love.graphics.setColor(title.mainColor)
        else
            love.graphics.setColor(0.15, 0.15, 0.15)
        end
        love.graphics.print(gui.text.resume, love.graphics.getWidth() / 2 - (font:getWidth(gui.text.resume) / 2 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (24 * playerCamera.globalScale), nil, playerCamera.globalScale)
    end
    love.graphics.setColor(1, 1, 1)
    gui.healthbar.anim:draw(gui.healthbar.sprite, 0, love.graphics.getHeight() - (16.5 * playerCamera.globalScale) - gui.hide.health.y * playerCamera.globalScale, nil, playerCamera.globalScale * 1.2)
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