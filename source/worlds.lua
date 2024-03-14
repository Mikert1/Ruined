local worldManagement = {}
worldManagement.thisWorld = "Title"
local sti = require "assets/library/sti"
local bump = require 'assets/library/bump'
local camera = require 'assets/library/cam'
local story = require("source/story/story")
local shader = require("source/shaders")
local gui = require("source/gui")
local stone
local file
_G.world = bump.newWorld(16)
_G.village = sti("assets/maps/village.lua", { "bump" })
_G.mountains = sti("assets/maps/mountains.lua", { "bump" })
_G.forrest = sti("assets/maps/forrest.lua", { "bump" })
_G.snow = sti("assets/maps/snow.lua", { "bump" })
_G.currentWorld = village
currentWorld:bump_init(world)
local saveStone = {}
saveStone.x = 0
saveStone.y = 0
saveStone.width = 50
saveStone.height = 50
saveStone.radius = 35
saveStone.active = false
saveStone.healing = 0 -- timer
saveStone.timer = 0
saveStone.imageActive = love.graphics.newImage("assets/textures/world/structures/saveStone.png")
saveStone.imageInactive = love.graphics.newImage("assets/textures/world/structures/inactiveStone.png")
saveStone.image = saveStone.imageInactive

structures = {}
structures.s1 = {
    image = love.graphics.newImage("assets/textures/world/structures/tent.png"),
}
local playerCircleRadius = 10
local lightPositions = {{0, 0}, {0, 0}}
local lightRadii = {0, 0}
local MAX_LIGHTS = 3
shader.light:send("numLights", #lightPositions)
shader.light:send("lightPositions", unpack(lightPositions))
shader.light:send("lightRadii", unpack(lightRadii))

function worldManagement.load()
    stone = require("source/enemies")
    file = require("source/data")
end

local function checkCircleCollision(rect, circle)
    local rectCenterX = rect.x + rect.width / 2
    local rectCenterY = rect.y + rect.height / 2

    local circleDistanceX = math.abs(saveStone.x + 13.5 - rectCenterX)
    local circleDistanceY = math.abs(saveStone.y + 31 - rectCenterY)

    if circleDistanceX > (rect.width / 2 + circle.radius) then
        return false
    end

    if circleDistanceY > (rect.height / 2 + circle.radius) then
        return false
    end

    if circleDistanceX <= (rect.width / 2) then
        return true
    end

    if circleDistanceY <= (rect.height / 2) then
        return true
    end

    local cornerDistanceSquared = (circleDistanceX - rect.width / 2)^2 +
                                  (circleDistanceY - rect.height / 2)^2

    return cornerDistanceSquared <= (circle.radius^2)
end

local function checkCollision(rect1, rect2)
    local rect1_right = rect1.x + rect1.width
    local rect1_bottom = rect1.y + rect1.height

    local rect2_right = rect2.x + rect2.width
    local rect2_bottom = rect2.y + rect2.height

    if rect1.x < rect2_right and
        rect1_right > rect2.x and
        rect1.y < rect2_bottom and
        rect1_bottom > rect2.y then
        return true
    end

    return false
end

local function findWaterLayer()
    local correctLayer
    for _, layer in ipairs(_G.currentWorld.layers) do
        if layer.name == "water" then
            for property, value in pairs(layer.properties) do
                if property == "collidableSwim" and value == true then
                    correctLayer = layer
                    break
                end
            end
        end
    end

    return correctLayer
end

function drawWaterLayer()
    local correctLayer = findWaterLayer()
    if correctLayer then
        for _, object in pairs(correctLayer.objects) do
            love.graphics.setColor(0, 0.5, 1)
            love.graphics.rectangle("line", object.x, object.y, object.width, object.height)
            love.graphics.setColor(1, 1, 1)
        end
    end
end

local function isSwimming()
    local correctLayer = findWaterLayer()
    if correctLayer then
        for _, object in pairs(correctLayer.objects) do
            if checkCollision(player, object) then
                return true
            end
        end
    end

    return false
end

local function findPortalsLayer()
    local correctLayer

    for _, layer in ipairs(_G.currentWorld.layers) do
        if layer.name == "portals" then
            correctLayer = layer
            break
        end
    end

    return correctLayer
end

function drawPortalLayer()
    local correctLayer = findPortalsLayer()

    for _, object in pairs(correctLayer.objects) do
        love.graphics.setColor(0.5, 0, 1)
        love.graphics.rectangle("line", object.x, object.y, object.width, object.height)
        love.graphics.setColor(1, 1, 1)
    end
end

local function findStairLayer()
    local correctLayer
    for _, layer in ipairs(_G.currentWorld.layers) do
        if layer.name == "stairs" then
            for property, value in pairs(layer.properties) do
                if property == "collidableStairs" and value == true then
                    correctLayer = layer
                    break
                end
            end
        end
    end

    return correctLayer
end

function drawStairLayer()
    local correctLayer = findStairLayer()

    if correctLayer then
        for _, object in pairs(correctLayer.objects) do
            love.graphics.setColor(1, 0.8, 0)
            love.graphics.rectangle("line", object.x, object.y, object.width, object.height)
            love.graphics.setColor(1, 1, 1)
        end
    end
end

local function isStairs()
    local correctLayer = findStairLayer()
    if correctLayer then
        for _, object in pairs(correctLayer.objects) do
            if checkCollision(player, object) then
                return true
            end
        end
    end

    return false
end

local function saveStones()
    saveStone.active = false
    saveStone.image = saveStone.imageInactive
    local correctLayer
    for _, layer in ipairs(_G.currentWorld.layers) do
        if layer.name == "wall" then
            correctLayer = layer
            break
        end
    end
    if correctLayer then
        for _, object in ipairs(correctLayer.objects) do
            if object.name == "save" then
                saveStone.x = object.x
                saveStone.y = object.y
            end
        end
    end
end

local function Structures()

    if worldManagement.thisWorld == "Snow" then
        for _, layer in ipairs(_G.currentWorld.layers) do
            if layer.name == "wall" then
                correctLayer = layer
                break
            end
        end
        if correctLayer then
            for _, object in ipairs(correctLayer.objects) do
                if object.name == "structure1" then
                    love.graphics.draw(structures.s1.image, object.x, object.y)
                end
            end
        end
    end 
end

function worldManagement.teleport(loc)
    for _, layer in ipairs(_G.currentWorld.layers) do
        if layer.name == "wall" then
            currentWorld:bump_removeLayer("wall")
        end
        if layer.name == "portals" then
            currentWorld:bump_removeLayer("portals")
        end
        if layer.name == "water" then
            currentWorld:bump_removeLayer("water")
        end
        if layer.name == "npc" then
            currentWorld:bump_removeLayer("npc")
        end
        if layer.name == "stairs" then
            currentWorld:bump_removeLayer("stairs")
        end
        if layer.name == "objective1wall" then
            currentWorld:bump_removeLayer("objective1wall")
        end
        enemymanager:load()
    end
    if loc == "start" then
        if data.world == "Village" then
            currentWorld = village
            love.window.setTitle("Ruined | Overworld - The Village")
            gui.mapWorld = {
                x = 100,
                y = 50
            }
        elseif data.world == "Mountains" then
            currentWorld = mountains
            love.window.setTitle("Ruined | Overworld - Mountains")
            gui.mapWorld = {
                x = 100,
                y = 0
            }
        elseif data.world == "Forrest" then
            currentWorld = forrest
            love.window.setTitle("Ruined | Overworld - Forrest")
            gui.mapWorld = {
                x = 0,
                y = 0
            }
        elseif data.world == "Snow" then
            currentWorld = snow
            love.window.setTitle("Ruined | Overworld - Snowy Mountains")
            gui.mapWorld = {
                x = 150,
                y = 0
            }
        else
            print("world not found. spawning player in The Village")
            currentWorld = village
            gui.mapWorld = {
                x = 0,
                y = 0
            }
        end
        player.x, player.y = world:move(player, data.x, data.y)
        worldManagement.thisWorld = data.world
        gui.welcome.timer = 3
        gui.welcome.animations.region1:gotoFrame(1)
    end
    if loc == "mountains" then
        currentWorld = mountains
        player.x, player.y = world:move(player, player.x, 795)
        worldManagement.thisWorld = "Mountains"
        love.window.setTitle("Ruined | Overworld - Mountains")
        print("player is in the Mountains")
        gui.welcome.timer = 3
        gui.welcome.animations.region1:gotoFrame(1)
        gui.mapWorld = {
            x = 100,
            y = 0
        }
    elseif loc == "mountainsWest" then
        currentWorld = mountains
        player.x, player.y = world:move(player, 2, player.y)
        worldManagement.thisWorld = "Mountains"
        love.window.setTitle("Ruined | Overworld - Mountains")
        print("player is in the Mountains")
        gui.welcome.timer = 3
        gui.welcome.animations.region1:gotoFrame(1)
        gui.mapWorld = {
            x = 100,
            y = 0
        }
    elseif loc == "mountainsEast" then
        currentWorld = mountains
        player.x, player.y = world:move(player, currentWorld.width * currentWorld.tilewidth - 14, player.y)
        worldManagement.thisWorld = "Mountains"
        love.window.setTitle("Ruined | Overworld - Mountains")
        print("player is in the Mountains")
        gui.welcome.timer = 3
        gui.welcome.animations.region1:gotoFrame(1)
        gui.mapWorld = {
            x = 100,
            y = 0
        }
    elseif loc == "village" then
        currentWorld = village
        player.x, player.y = world:move(player, player.x, 3)
        worldManagement.thisWorld = "Village"
        love.window.setTitle("Ruined | Overworld - The Village")
        print("player is in the Village")
        gui.welcome.timer = 3
        gui.welcome.animations.region1:gotoFrame(1)
        gui.mapWorld = {
            x = 100,
            y = 50
        }
    elseif loc == "forrest" then
        playerCircleRadius = 10
        currentWorld = forrest
        player.x, player.y = world:move(player, currentWorld.width * currentWorld.tilewidth - 13, player.y)
        worldManagement.thisWorld = "Forrest"
        love.window.setTitle("Ruined | Overworld - Forrest")
        print("player is in the Forrest")
        gui.welcome.timer = 3
        gui.welcome.animations.region1:gotoFrame(1)
        gui.mapWorld = {
            x = 0,
            y = 0
        }
    elseif loc == "snow" then
        playerCircleRadius = 10
        currentWorld = snow
        player.x, player.y = world:move(player, 2, player.y)
        worldManagement.thisWorld = "Snow"
        love.window.setTitle("Ruined | Overworld - Snowy Mountains")
        print("player is in the Snowy Mountains")
        gui.welcome.timer = 3
        gui.welcome.animations.region1:gotoFrame(1)
        gui.mapWorld = {
            x = 150,
            y = 0
        }
    end
    if worldManagement.thisWorld == "Snow" then
        saveStone.radius = 100
    else
        saveStone.radius = 35
    end
    currentWorld:bump_init(world)
    if (story.data.storyTold.john1 == false or story.data.storyTold.john2 == true) and worldManagement.thisWorld == story.npc.john.collider.world then
        story.npc.john.position = 1
        story.npc.john.x = 170
        story.npc.john.y = 332
        story.npc.john.image = love.graphics.newImage("assets/textures/npc/johnNpcWounded.png")
    else
        story.npc.john.position = 0
    end
    saveStones()
    worldManagement.spawn()
end

local function checkPortals()
    local correctLayer = findPortalsLayer()

    if correctLayer then
        for _, object in ipairs(correctLayer.objects) do
            for property, value in pairs(object.properties) do
                if property == "portalMountains" and value == true then
                    if checkCollision(player, object) then
                        worldManagement.teleport("mountains")
                    end
                elseif property == "portalMountainsWest" and value == true then
                    if checkCollision(player, object) then
                        worldManagement.teleport("mountainsWest")
                    end
                elseif property == "portalMountainsEast" and value == true then
                    if checkCollision(player, object) then
                        worldManagement.teleport("mountainsEast")
                    end
                elseif property == "portalVillage" and value == true then
                    if checkCollision(player, object) then
                        worldManagement.teleport("village")
                    end
                elseif property == "portalForrest" and value == true then
                    if checkCollision(player, object) then
                        worldManagement.teleport("forrest")
                    end
                elseif property == "portalSnow" and value == true then
                    if checkCollision(player, object) then
                        worldManagement.teleport("snow")
                    end
                end
            end
        end
    end
end


local function talk(id)
    if id == "john1" then
        story.npc.foto.john = story.npc.foto.john_wounded
    elseif id == "john2" then

    end
    story.id = id
    story.npc.interactionAvalible = false
    story.npc.interaction = true
    story.dialogue.position = 0
    game.state = 2.1
    story.currentStory = story.dialogue[story.id][story.data.current]
    story.arrayLength = #story.dialogue[story.id]
end

function worldManagement.spawn()
    local correctLayer
    
    for _, layer in ipairs(_G.currentWorld.layers) do
        if layer.name == "enemies" then
            correctLayer = layer
        end
    end
    
    if correctLayer then
        for _, object in ipairs(correctLayer.objects) do
            if object.name == "stone" then
                local newStone = stone.new(object.x, object.y)
                table.insert(enemymanager.activeStones, newStone)
            end
        end
    end
end

function drawNpcLayer()
    local correctLayer = nil
    if story.npc.john.collider.world == worldManagement.thisWorld then
        correctLayer = story.npc.john.collider
    end

    if correctLayer then
        love.graphics.setColor(0, 0.8, 0)
        love.graphics.rectangle("line", correctLayer.x, correctLayer.y, correctLayer.width, correctLayer.height)
        love.graphics.setColor(1, 1, 1)
    end
end

local function checkNpc()
    local correctLayer = nil
    if story.npc.john.collider.world == worldManagement.thisWorld then
        correctLayer = story.npc.john.collider
    end
    if correctLayer then
        if checkCollision(player, story.npc.john.collider) then
            if story.npc.interaction == false then
                story.npc.who = "john"
                story.npc.interactionAvalible = true
                if love.keyboard.isDown("e") or (controller.joysticks and controller.joysticks:isGamepadDown("a")) then
                    if story.data.storyTold.john1 == false then
                        talk("john1")
                    elseif story.data.storyTold.john2 == false then
                        talk("john2")
                    end
                end
            end
        else
            story.npc.interactionAvalible = false
            story.npc.interaction = false
        end
    end
end

local function inDarkness(dt)
    if playerCircleRadius < 100 then
        playerCircleRadius = playerCircleRadius + dt * 50
        if playerCircleRadius > 100 then
            playerCircleRadius = 100
        end 
    end
    lightPositions[1] = {playerCamera.cam:cameraCoords(player.x + 6, player.y - 8)}
    lightRadii[1] = playerCircleRadius * playerCamera.globalScale
    if saveStone.active == true then
        lightPositions[2] = {playerCamera.cam:cameraCoords(saveStone.x + 13.5, saveStone.y + 31)}
        lightRadii[2] = saveStone.radius * playerCamera.globalScale
    else
        lightPositions[2] = {0, 0}
        lightRadii[2] = 0
    end


    shader.light:send("numLights", #lightPositions)
    shader.light:send("lightPositions", unpack(lightPositions))
    shader.light:send("lightRadii", unpack(lightRadii))
end

function worldManagement.update(dt)
    if worldManagement.thisWorld == "Forrest" then
        inDarkness(dt)
    end
    if isSwimming() then
        if worldManagement.thisWorld == "Snow" then
            player.isSwimming = false
            player.speed = 10 * player.speedMultiplier / 1.5
            player.sideSpeed = 7.71067812 * player.speedMultiplier / 1.5
        else
            player.isSwimming = true
            player.speed = 10 * player.speedMultiplier / 1.5
            player.sideSpeed = 7.71067812 * player.speedMultiplier / 1.5
        end
    else
        player.isSwimming = false
        if isStairs() then
            player.speed = 10 * player.speedMultiplier / 2
            player.sideSpeed = 7.71067812 * player.speedMultiplier / 2
        else
            -- if weapon.bow.hold then
            --     player.speed = 10 * player.speedMultiplier / 3
            --     player.sideSpeed = 7.71067812 * player.speedMultiplier / 3
            -- else
                player.speed = 10 * player.speedMultiplier
                player.sideSpeed = 7.71067812 * player.speedMultiplier
            -- end
        end
    end
    checkPortals()
    checkNpc()
    if checkCircleCollision(player, saveStone) then
        if saveStone.active == false then
            saveStone.active = true
            saveStone.image = saveStone.imageActive
            data = file.save()
        end
        if player.hearts <= 8 then
            if saveStone.healing >= 1 then
                player.hearts = player.hearts + 1
                saveStone.healing = 0
                if player.hearts == 8 then
                    saveStone.active = true
                    saveStone.image = saveStone.imageActive
                    data = file.save()
                end
            else
                saveStone.healing = saveStone.healing + dt
            end
        end
    end
    if saveStone.timer >= 1 then
        saveStone.timer = 0
    else
        saveStone.timer = saveStone.timer + (dt / 4)
    end
end


function worldManagement:draw()
    if currentWorld.layers["ground"] then
        currentWorld:drawLayer(currentWorld.layers["ground"])
    end
    if currentWorld.layers["walls"] then
        currentWorld:drawLayer(currentWorld.layers["walls"])
    end
    if currentWorld.layers["objective1"] then
        currentWorld:drawLayer(currentWorld.layers["objective1"])
    end
    if saveStone.y + 30 < player.y then
        love.graphics.draw(saveStone.image, saveStone.x, saveStone.y)
    end
    love.graphics.setColor(0, 1, 1, 0 + (saveStone.timer / 2))
    love.graphics.circle("line", saveStone.x + 13.5, saveStone.y + 21 + (saveStone.timer * 10), saveStone.radius)
    love.graphics.setColor(0, 1, 1, 0.5)
    love.graphics.circle("line", saveStone.x + 13.5, saveStone.y + 31, saveStone.radius)
    love.graphics.setColor(1, 1, 1)
    Structures()
end

function worldManagement:draw2dLayer()
    if saveStone.y + 30 > player.y then
        love.graphics.draw(saveStone.image, saveStone.x, saveStone.y)
    end
end

function worldManagement:drawDarkness()
    if worldManagement.thisWorld == "Forrest" then
        love.graphics.setShader(shader.light)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 0, 0, currentWorld.width * currentWorld.tilewidth, currentWorld.height * currentWorld.tileheight)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setShader()
    end
end


return worldManagement