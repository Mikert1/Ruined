local LOADTIMER = os.clock()
print("Starting to load")
require("src/system/error")
love.graphics.setDefaultFilter("nearest", "nearest")
local fontScale = 16
_G.font = love.graphics.newFont("assets/textures/fonts/berylium bd.otf", fontScale, "mono", 2, 1)
love.graphics.setFont(font)
require("src/controls/mouse")
_G.game = require("src/system/game")
_G.player = require("src/entities/player")
_G.playerCamera = require("src/gameplay/camera")
_G.controls = require("src/controls/controls")
_G.keys = require("src/controls/keyboard")
_G.controller = require("src/controls/controller")
_G.enemymanager = require("src/entities/enemies/enemymanager")
local bump = require 'src/library/bump'
local weapon = require("src/gameplay/weapons")
local currentWorld = require("src/gameplay/worldmanager")
local worldManagement = require("src/gameplay/worldmanager")
local file = require("src/system/data")
local preview = require("src/system/data")
local debug = require("src/system/debug")
local title = require("src/gui/title")
local gui = require("src/gui/gui")
local time = require("src/system/timer")
local shader = require("src/system/shaders")
local story = require("src/gameplay/story")
local scene = require("src/gameplay/cutscene")
local stone = require("src/entities/enemies/stone")
local button = require("src/gui/button")
local settings = require("src/gui/settings")
_G.server = require("src/network/server")
print("Done loading in " .. os.clock() - LOADTIMER .. " seconds")

story.loadAssets()
worldManagement.loadAssets()
player.loadAssets()

file.settings.loadTexturePack()
_G.savedSettings = file.settings.load()

worldManagement.load()
player.load()
gui.load()
title.load()
controls.load()
enemymanager:load()
button.load()

function love.load()
    story.load()
end

function love.update(dt)
    controller.update(dt)
    file.update(dt)
    if game.state == 0 then
        gui.update(dt)
        if game.freeze == false then
            player.update(dt)
            player.movement(dt)
        end
        playerCamera.follow(dt)
        if game.freeze == false then
            player.focusUpdate(dt)
            worldManagement.update(dt)
            time.update(dt)
            weapon.sword.update(dt)
            weapon.bow.update(dt)
            enemymanager:update(dt)
            gui.shower(dt)
        end
    elseif game.state == 1 then
        title.update(dt)
        playerCamera.follow(dt)
    elseif game.state >= 2 and game.state < 3 then
        gui.hider(dt)
        playerCamera.follow(dt)
        if game.state == 2.3 or game.state == 2.4 or game.state == 2.6 then
            scene.camera.update(dt)
        end
        if game.state == 2.1 or game.state == 2.5 or game.state == 2.6 then
            story.slowShow(dt)
        end
    end
    button:UpdateAll(dt)
end

function love.draw()
    love.graphics.setFont(font)
    love.graphics.setShader()
    if player.focus == true then 
        love.graphics.setShader(shader.focus)
    end
    playerCamera.cam:attach()
        worldManagement:draw()
        debug.world:draw()
        story.npc:draw()
        weapon.draw()
        enemymanager:draw()
        -- Player
        player:draw()
        --
        worldManagement:draw2dLayer()
        enemymanager:draw2L()
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
end