print("Starting to load")
require("source/error")
love.graphics.setDefaultFilter("nearest", "nearest")
local fontScale = 16
_G.font = love.graphics.newFont("assets/textures/fonts/berylium bd.otf", fontScale, "mono", 2, 1)
love.graphics.setFont(font)
require("source/controls/mouse")
_G.game = require("game")
_G.player = require("source/player")
_G.playerCamera = require("source/camera")
_G.controls = require("source/controls/controls")
_G.keys = require("source/controls/keyboard")
_G.controller = require("source/controls/controller")
_G.enemymanager = require("source/enemies/enemymanager")
local bump = require 'assets/library/bump'
local weapon = require("source/weapons")
local currentWorld = require("source/worlds")
local worldManagement = require("source/worlds")
local file = require("source/data")
local preview = require("source/data")
local debug = require("source/debug")
local title = require("source/screens/title")
local gui = require("source/gui")
local time = require("source/timer")
local shader = require("source/shaders")
local story = require("source/story/story")
local scene = require("source/story/cutscene")
local stone = require("source/enemies/stone")
local button = require("source/screens/button")
_G.server = require("source/network/server")
print("Done loading")

player.load()
worldManagement.load()
gui.load()
title.load()
_G.savedSettings = file.savedSettings.load()
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
    button:UpdateAll()
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
        button:drawAll()
        debug:draw()
        file:draw()
end