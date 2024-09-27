local worldManagement = {}

-- load assets
local sti, bump
local camera, story, shader, gui, stone, boss, file, objectsManager

function worldManagement.loadAssets()
    bump = require 'src/library/bump'
    sti = require 'src/library/sti'
    camera = require 'src/library/cam'
    shader = require("src/system/shaders")
    gui = require("src/gui/gui")
    stone = require("src/entities/enemies/stone")
    boss = require("src/entities/enemies/boss")
    file = require("src/system/data")
    story = require("src/gameplay/story")
    objectsManager = require("src/gameplay/objects")
end

-- load variables
local playerCircleRadius
local lightPositions
local lightRadii
function worldManagement.load()
    worldManagement.thisWorld = "Title"
    worldManagement.saved = false
    _G.world = bump.newWorld(16)
    _G.village = sti("assets/maps/village.lua", { "bump" })
    _G.mountains = sti("assets/maps/mountains.lua", { "bump" })
    _G.forrest = sti("assets/maps/forrest.lua", { "bump" })
    _G.snow = sti("assets/maps/snow.lua", { "bump" })
    _G.naamloos = sti("assets/maps/naamloos.lua", { "bump" })
    _G.currentWorld = village
    currentWorld:bump_init(world)

    playerCircleRadius = 10
    lightPositions = {{0, 0}, {0, 0}}
    lightRadii = {0, 0}
    ellipseXScale = 1.0
    ellipseYScale = 0.8
    local MAX_LIGHTS = 3
    shader.light:send("ellipseXScale", ellipseXScale)
    shader.light:send("ellipseYScale", ellipseYScale)
    shader.light:send("numLights", #lightPositions)
    shader.light:send("lightPositions", unpack(lightPositions))
    shader.light:send("lightRadii", unpack(lightRadii))
end

-- load non-worldManagement functions
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

local function findLayer(name)
    for _, layer in ipairs(_G.currentWorld.layers) do
        if layer.name == name then
            return layer
        end
    end
end

function drawLayer(name)
    local layer = findLayer(name)
    if layer then
        for _, object in pairs(layer.objects) do
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("line", object.x, object.y, object.width, object.height)
            love.graphics.setColor(1, 1, 1)
        end
    end
end

local function playerWalkingOn()
    local layers = {
        "water",
        "stairs"
    }
    for _, layerName in ipairs(layers) do
        local correctLayer = findLayer(layerName)
        if correctLayer then
            for _, object in pairs(correctLayer.objects) do
                if checkCollision(player, object) then
                    return layerName
                end
            end
        end
    end
end

local function checkPortals()
    local correctLayer = findLayer("portals")

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
    story.skiped = true
end

-- load worldManagement functions
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
        elseif data.world == "naamloos" then
            currentWorld = naamloos
            love.window.setTitle("Ruined | Overworld - TEST")
            gui.mapWorld = {
                x = 100,
                y = 50
            }
        else
            print("[Warn  ] world not found. spawning player in The Village")
            currentWorld = village
            gui.mapWorld = {
                x = 0,
                y = 0
            }
        end
        player.x, player.y = world:move(player, data.x, data.y)
        worldManagement.thisWorld = data.world
    end
    if loc == "mountains" then
        currentWorld = mountains
        player.x, player.y = world:move(player, player.x, 795)
        worldManagement.thisWorld = "Mountains"
        love.window.setTitle("Ruined | Overworld - Mountains")
        gui.mapWorld = {
            x = 100,
            y = 0
        }
    elseif loc == "mountainsWest" then
        currentWorld = mountains
        player.x, player.y = world:move(player, 2, player.y)
        worldManagement.thisWorld = "Mountains"
        love.window.setTitle("Ruined | Overworld - Mountains")
        gui.mapWorld = {
            x = 100,
            y = 0
        }
    elseif loc == "mountainsEast" then
        currentWorld = mountains
        player.x, player.y = world:move(player, currentWorld.width * currentWorld.tilewidth - 14, player.y)
        worldManagement.thisWorld = "Mountains"
        love.window.setTitle("Ruined | Overworld - Mountains")
        gui.mapWorld = {
            x = 100,
            y = 0
        }
    elseif loc == "village" then
        currentWorld = village
        player.x, player.y = world:move(player, player.x, 3)
        worldManagement.thisWorld = "Village"
        love.window.setTitle("Ruined | Overworld - The Village")
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
        gui.mapWorld = {
            x = 150,
            y = 0
        }
    end
    currentWorld:bump_init(world)
    loadObjectsForWorld(worldManagement.thisWorld)
    worldManagement.spawn()
    if (story.data.storyTold.john1 == false or story.data.storyTold.john2 == true) and worldManagement.thisWorld == story.npc.john.collider.world then
        story.npc.john.position = 1
        story.npc.john.x = 170
        story.npc.john.y = 332
        story.npc.john.image = love.graphics.newImage("assets/textures/npc/johnNpcWounded.png")
    else
        story.npc.john.position = 0
    end
    playerCamera.cam:lookAt(player.x - 6, player.y - 8)
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
                local newStone = stone.new(object.x, object.y, object.properties.calorLVL)
                table.insert(enemymanager.activeEnemies, newStone)
            end
            if object.name == "boss" then
                local newBoss = boss.new(object.x, object.y, object.properties.calorLVL)
                table.insert(enemymanager.activeEnemies, newBoss)
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

local function checkNpc(dt)
    local correctLayer = nil
    if story.npc.john.collider.world == worldManagement.thisWorld then
        correctLayer = story.npc.john.collider
    end
    if correctLayer then
        if checkCollision(player, story.npc.john.collider) then
            if story.npc.interaction == false then
                story.npc.who = "john"
                story.npc.interactionAvalible = true
                if love.keyboard.isDown(controls.keys.interact) or (controller.joysticks and controller.joysticks:isGamepadDown("a")) then
                    if story.npc.interactionHold >= 0.25 then
                        if story.data.storyTold.john1 == false then
                            talk("john1")
                        elseif story.data.storyTold.john2 == false then
                            talk("john2")
                        end
                        game.freeze = true
                        story.npc.interactionHold = 0
                    else
                        if story.skiped == false then
                            story.npc.interactionHold = story.npc.interactionHold + dt
                        end
                    end
                else
                    if story.npc.interactionHold > 0 then
                        story.npc.interactionHold = story.npc.interactionHold - dt / 4
                    else
                        story.npc.interactionHold = 0
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
    -- if saveStone.active == true then
    --     lightPositions[2] = {playerCamera.cam:cameraCoords(saveStone.x + 13.5, saveStone.y + 31)}
    --     lightRadii[2] = saveStone.radius * playerCamera.globalScale
    -- else
    --     lightPositions[2] = {0, 0}
    --     lightRadii[2] = 0
    -- end


    shader.light:send("numLights", #lightPositions)
    shader.light:send("lightPositions", unpack(lightPositions))
    shader.light:send("lightRadii", unpack(lightRadii))
end

function worldManagement.update(dt)
    currentWorld:update(dt)
    if worldManagement.thisWorld == "Forrest" then
        inDarkness(dt)
    end
    local ground = playerWalkingOn()
    player.isSwimming = false
    if ground == "stairs" then
        player.speedMultiplier = 5
    elseif ground == "water" then
        if worldManagement.thisWorld == "Snow" then
            player.isSwimming = false
        else
            player.isSwimming = true
        end
        player.speedMultiplier = 6,666666666666667
    end
    checkPortals()
    checkNpc(dt)
end


function worldManagement:draw()
    if currentWorld.layers["ground"] then
        currentWorld:drawLayer(currentWorld.layers["ground"])
    end
    if currentWorld.layers["walls"] then
        currentWorld:drawLayer(currentWorld.layers["walls"])
    end
    if currentWorld.layers["groundL2"] then
        currentWorld:drawLayer(currentWorld.layers["groundL2"])
    end
    if currentWorld.layers["objective1"] then
        currentWorld:drawLayer(currentWorld.layers["objective1"])
    end
    love.graphics.setColor(1, 1, 1)
    objectsManager.draw(1)
end

function worldManagement:draw2dLayer()
    objectsManager.draw(2)
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