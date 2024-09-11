local LOADTIMER = os.clock()
local loadState = 1
love.window.setTitle("Ruined | Title Screen")
love.window.setIcon(love.image.newImageData("assets/textures/gui/title/logo1.png"))

-- global variables
local file, weapon, currentWorld, worldManagement, preview, debug, title, gui, time, shader, story, scene, stone, button, settings, particle, objectsManager

local function loader()
    if loadState > 1 then
        print("[Loader] Starting...")
        
        love.graphics.setDefaultFilter("nearest", "nearest")
        _G.font = love.graphics.newFont("assets/fonts/berylium bd.otf", 16, "mono", 2, 1)
        love.graphics.setFont(font)
        love.mouse.setVisible(false)
        love.mouse.setGrabbed(false)

        _G.game = require("src/system/game")
        _G.player = require("src/entities/player")
        _G.playerCamera = require("src/gameplay/camera")
        _G.controls = require("src/controls/controls")
        _G.keys = require("src/controls/keyboard")
        _G.controller = require("src/controls/controller")
        _G.enemymanager = require("src/entities/enemies/enemymanager")
        _G.lan = require("src/network/lan")

        file = require("src/system/data")
        weapon = require("src/gameplay/weapons")
        currentWorld = require("src/gameplay/worldmanager")
        worldManagement = require("src/gameplay/worldmanager")
        preview = require("src/system/data")
        debug = require("src/system/debug")
        title = require("src/gui/title")
        gui = require("src/gui/gui")
        time = require("src/system/timer")
        shader = require("src/system/shaders")
        story = require("src/gameplay/story")
        scene = require("src/gameplay/cutscene")
        stone = require("src/entities/enemies/stone")
        button = require("src/gui/button")
        settings = require("src/gui/settings")
        particle = require("src/gameplay/particle")
        objectsManager = require("src/gameplay/objects")
        
        story.loadAssets()
        worldManagement.loadAssets()
        player.loadAssets()
        
        file.settings.loadTexturePack()
        
        enemymanager:load()
        worldManagement.load()
        player.load()
        gui.load()
        title.load()
        controls.load()
        button.load()

        require("src/system/error")
        require("src/controls/mouse")

        local LOADTIMER2 = os.clock()
        print("[Loader] Done Loading files it took " .. LOADTIMER2 - LOADTIMER .. " seconds")
        print("[Loader] Done Loading game it took " .. os.clock() - LOADTIMER2 .. " seconds")
        print("[Loader] Total Time: " .. os.clock() - LOADTIMER .. " seconds")
        print("[Debug ] Console is active\n    - use Tab to show more info and show colliders")
    
        local dev -- for me to skip some things like titlescreen becouse i see it every day ;)
        if love.filesystem.getInfo("dev.lua") then
            dev = require("dev")
            if dev.skipTitlescreen == true then
                title.mikert.showed = true
                button.loadAll()
                title.state = 1
                file.show()
                title.rezet()
                title.logo.anim = title.logo.animations.region2
                title.logo.y = 90
                title.text.name = "Ruined"
                title.text.chapter = "Chapter 1"
                title.mainColor = {0, 1, 1}
                title.background.current = title.background.blue
                button.loadAll()
                file.filenumber = 1
                game.state = 0
                data = file.load()
                worldManagement.teleport("start")
                game.freeze = false
                title.state = 5
                game.esc = false
                data = file.save()
                player.noMove = false
                button.loadAll()
                love.mouse.setGrabbed(true)
            end
        end
    end
end

function loadForLast()
    savedSettings = file.settings.load()
end

function love.load()
    if loadState > 1 then
        story.load()
    end
end


function love.update(dt)
    if loadState > 1 then
        dt = dt * savedSettings.gameSpeed
        game.update(dt)
        lan.receiveData()
        lan.sendData()
        controller.update(dt)
        file.update(dt)
        if game.state == 0 then
            if game.freeze == false then
                player.update(dt)
                player.movement(dt)
            end
            playerCamera.follow(dt)
            if game.freeze == false then
                player.focusUpdate(dt)
                worldManagement.update(dt)
                time.update(dt)
                weapon.update(dt)
                enemymanager:update(dt)
                gui.barShow = true
            end
            gui.update(dt)
        elseif game.state == 1 then
            title.update(dt)
            playerCamera.follow(dt)
        elseif game.state >= 2 and game.state < 3 then
            gui.barShow = false
            playerCamera.follow(dt)
            if game.state == 2.3 or game.state == 2.4 or game.state == 2.6 then
                scene.camera.update(dt)
            end
            if game.state == 2.1 or game.state == 2.5 or game.state == 2.6 then
                story.slowShow(dt)
            end
        end
        settings.update()
        button:UpdateAll(dt)
        objectsManager.update(dt)
        particle.update(dt)
    end
    if loadState == 2 then
        loadForLast()
        loadState = 3
    end
end

function love.draw()
    if loadState > 1 then
        love.graphics.setFont(font)
        if player.focus == true then 
            love.graphics.setShader(shader.focus)
        else
            love.graphics.setShader()
        end
        playerCamera.cam:attach()
            worldManagement:draw()
            debug.world:draw()
            story.npc:draw()
            weapon.draw()

            love.graphics.setShader()
            enemymanager:draw()
            particle.draw()
            player:draw()
            lan.drawPlayer2()
            enemymanager:draw2L()
            if player.focus == true then 
                love.graphics.setShader(shader.focus)
            end

            worldManagement:draw2dLayer()
            weapon.draw2L()
            story.npc:draw2L()

            worldManagement:drawDarkness()
        playerCamera.cam:detach()
            love.graphics.setColor(1, 1, 1)
            story.dialogue:draw()
            if game.esc == true then
                love.graphics.setColor(0, 0, 0, 0.5)
                love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
                love.graphics.setColor(1, 1, 1)
            end
            gui:draw()
            title:draw()
            settings.draw()
            button:drawAll()
            debug:draw()
            file:draw()
            settings.draw2Layer()
            lan.draw()
            game.draw()
    else
        love.graphics.print("Loading...", 10, 10)
        loadState = 2
        loader()
    end
end