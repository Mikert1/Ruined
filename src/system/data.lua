local story = require("src/gameplay/story")
local json = require("src/library/json")
local time = require("src/system/timer")
local scene = require("src/gameplay/cutscene")
local worldManagement = require("src/gameplay/worldmanager")
local file = {}
local data = {}
local preview = {}
_G.savedSettings = {}
savedSettings.devmode = false
savedSettings.console = false
savedSettings.screenShake = true
savedSettings.masterVolume = 100
savedSettings.window = 0
savedSettings.windowIndex = 1
savedSettings.resolution = 0
savedSettings.gameSpeed = 1
file.filenumber = 0
preview.file1 = {}
preview.file2 = {}
preview.file3 = {}
file.status = "Nil"
file.message = 3
file.settings = {}

function file.save()
    file.message = 0
    file.status = "Saving..."
    data.x = player.x
    data.y = player.y
    data.isUp = player.isUp
    data.isLeft = player.isLeft
    data.world = worldManagement.thisWorld
    data.hearts = player.health

    data.item = {}
    data.item.sword = player.item.sword

    data.seconds = time.seconds
    data.minutes = time.minutes
    data.hours = time.hours

    if file.filenumber == 1 then
        preview.file1.world = worldManagement.thisWorld
        preview.file1.seconds = time.seconds
        preview.file1.minutes = time.minutes
        preview.file1.hours = time.hours
        preview.file1.item = {}
        preview.file1.item.sword = player.item.sword
        preview.file1.created = true
        preview.file1.storyProgress = 0 -- does nothing yet
        local jsonString = json.encode(data)
        local jsonString2 = json.encode(preview.file1)
        love.filesystem.write("savegame1.json", jsonString)
        love.filesystem.write("previewcard1.json", jsonString2)
        print("[Info  ] Savegame 1 Saved!")
        file.status = "Progress Saved!"
    elseif file.filenumber == 2 then
        preview.file2.world = worldManagement.thisWorld
        preview.file2.seconds = time.seconds
        preview.file2.minutes = time.minutes
        preview.file2.hours = time.hours
        preview.file2.item = {}
        preview.file2.item.sword = player.item.sword
        preview.file2.created = true
        preview.file1.storyProgress = 0 -- does nothing yet
        local jsonString = json.encode(data)
        local jsonString2 = json.encode(preview.file2)
        love.filesystem.write("savegame2.json", jsonString)
        love.filesystem.write("previewcard2.json", jsonString2)
        print("[Info  ] Savegame 2 Saved!")
        file.status = "Progress Saved!"
    elseif file.filenumber == 3 then
        preview.file3.world = worldManagement.thisWorld
        preview.file3.seconds = time.seconds
        preview.file3.minutes = time.minutes
        preview.file3.hours = time.hours
        preview.file3.item = {}
        preview.file3.item.sword = player.item.sword
        preview.file3.created = true
        preview.file1.storyProgress = 0 -- does nothing yet
        local jsonString = json.encode(data)
        local jsonString2 = json.encode(preview.file3)
        love.filesystem.write("savegame3.json", jsonString)
        love.filesystem.write("previewcard3.json", jsonString2)
        print("[Info  ] Savegame 3 Saved!")
        file.status = "Progress Saved!"
    else
        file.status = "Saving Error"
        print("[Warn  ] Savegame error (filenumer cant be 0)")
    end
    file.message = 0
    return data
end

function file.load()
    if file.filenumber == 1 then
        local jsonString = love.filesystem.read("savegame1.json")
        if jsonString then
            local success, decodedData = pcall(json.decode, jsonString)
            if success then
                data = decodedData
            else
                love.filesystem.remove("savegame1.json")
                error("Oops! The save file (savegame1.json) failed to decode, this means the file was (probably) corrupted.")
            end
        else
            data = {
                x = 233,
                y = 157,
                seconds = 0,
                minutes = 0,
                hours = 0,
                days = 0,
                item = {
                    sword = false
                },
                isUp = false,
                isLeft = true,
                world = "Village",
                hearts = 8,
                storyTold = {
                    john1 = false
                },
                storyProgress = {
                    john = 0,
                    gambler = 0
                }
            }
            game.state = 2.3
            scene.welcome()
        end
    elseif file.filenumber == 2 then
        local jsonString = love.filesystem.read("savegame2.json")
        if jsonString then
            local success, decodedData = pcall(json.decode, jsonString)
            if success then
                data = decodedData
            else
                love.filesystem.remove("savegame2.json")
                error("Oops! The save file (savegame2.json) failed to decode, this means the file was (probably) corrupted.")
            end
        else
            data = {
                x = 233,
                y = 157,
                seconds = 0,
                minutes = 0,
                hours = 0,
                days = 0,
                item = {
                    sword = false
                },
                isUp = false,
                isLeft = true,
                world = "Village",
                hearts = 8,
                storyTold = {
                    john1 = false
                },
                storyProgress = {
                    john = 0,
                    gambler = 0
                }
            }
            game.state = 2.3
            scene.welcome()
        end
    elseif file.filenumber == 3 then
        local jsonString = love.filesystem.read("savegame3.json")
        if jsonString then
            local success, decodedData = pcall(json.decode, jsonString)
            if success then
                data = decodedData
            else
                love.filesystem.remove("savegame3.json")
                error("Oops! The save file (savegame3.json) failed to decode, this means the file was (probably) corrupted.")
            end
        else
            data = {
                x = 233,
                y = 157,
                seconds = 0,
                minutes = 0,
                hours = 0,
                days = 0,
                item = {
                    sword = false
                },
                isUp = false,
                isLeft = true,
                world = "Village",
                hearts = 8,
                storyTold = {
                    john1 = false
                },
                storyProgress = {
                    john = 0,
                    gambler = 0
                }
            }
            if game.chapter == 2 then
                data.world = "naamloos"
            end
            game.state = 2.3
            scene.welcome()
        end
    end
    -- rezet some values
    player.item = {}
    -- set the values
    if data.isUp == true then
        if data.isLeft == true then
            player.anim = player.animations.upLeft
        else
            player.anim = player.animations.upRight
        end
    else
        if data.isLeft == true then
            player.anim = player.animations.downLeft
        else
            player.anim = player.animations.downRight
        end
    end
    player.isUp = data.isUp
    player.isLeft = data.isLeft
    time.seconds = data.seconds
    time.minutes = data.minutes
    time.hours = data.hours
    player.health = data.hearts
    if data.item.sword == true then
        player.item.sword = true
    end
    love.load()
    return data
end

function file.show()
    local prevjsonString = love.filesystem.read("previewcard1.json")
    if prevjsonString then
        local success, decodedData = pcall(json.decode, prevjsonString)
        if success then
            preview.file1 = decodedData
            preview.file1.created = true
        else
            love.filesystem.remove("previewcard1.json")
            error("Oops! The save file (previewcard1.json) failed to decode, this means the file was (probably) corrupted.")
        end
    else
        preview.file1 = {}
        preview.file1.world = "--"
        preview.file1.seconds = 0
        preview.file1.minutes = 0
        preview.file1.hours = 0
        preview.file1.days = 0
        preview.file1.created = false
        preview.file1.item = {}
        preview.file1.item.sword = false
    end
    local prevjsonString = love.filesystem.read("previewcard2.json")
    if prevjsonString then
        local success, decodedData = pcall(json.decode, prevjsonString)
        if success then
            preview.file2 = decodedData
            preview.file2.created = true
        else
            love.filesystem.remove("previewcard2.json")
            error("Oops! The save file (previewcard2.json) failed to decode, this means the file was (probably) corrupted.")
        end
    else
        preview.file2 = {}
        preview.file2.world = "--"
        preview.file2.seconds = 0
        preview.file2.minutes = 0
        preview.file2.hours = 0
        preview.file2.days = 0
        preview.file2.created = false
        preview.file2.item = {}
        preview.file2.item.sword = false
    end
    local prevjsonString = love.filesystem.read("previewcard3.json")
    if prevjsonString then
        local success, decodedData = pcall(json.decode, prevjsonString)
        if success then
            preview.file3 = decodedData
            preview.file3.created = true
        else
            love.filesystem.remove("previewcard3.json")
            error("Oops! The save file (previewcard3.json) failed to decode, this means the file was (probably) corrupted.")
        end
    else
        preview.file3 = {}
        preview.file3.world = "--"
        preview.file3.seconds = 0
        preview.file3.minutes = 0
        preview.file3.hours = 0
        preview.file3.days = 0
        preview.file3.created = false
        preview.file3.item = {}
        preview.file3.item.sword = false
    end
    return preview
end

function file.settings.save()
    file.message = 0
    local jsonString = json.encode(savedSettings)
    love.filesystem.write("settings" .. game.version .. ".json", jsonString)
    file.status = "Settings saved"
end

function file.settings.load()
    local jsonString = love.filesystem.read("settings" .. game.version .. ".json")
    if jsonString then
        local success, decodedData = pcall(json.decode, jsonString)
        if success then
            savedSettings = decodedData
        else
            love.filesystem.remove("settings" .. game.version .. ".json")
            error("Oops! The save file (settings.json) failed to decode, this means the file was (probably) corrupted.")
        end
    end

    --checks if the old settings are loaded -- temporary
    if not savedSettings.devmode then
        savedSettings.devmode = false
    end
    if not savedSettings.console then
        savedSettings.console = false
    end
    if not savedSettings.screenShake then
        savedSettings.screenShake = true
    end
    if not savedSettings.masterVolume then
        savedSettings.masterVolume = 100
    end
    if not savedSettings.window then
        savedSettings.window = 0
    end
    if not savedSettings.windowIndex then
        savedSettings.windowIndex = 1
    end
    if not savedSettings.resolution then
        savedSettings.resolution = 0
    end
    if not savedSettings.gameSpeed then
        savedSettings.gameSpeed = 1
    end

    local x, y, _ = love.window.getPosition()
    local f = {borderless = false, resizable = true, display = savedSettings.windowIndex}
    love.window.setPosition(x, y, savedSettings.windowIndex)
    w, h = love.window.getDesktopDimensions(savedSettings.windowIndex)
    if savedSettings.window == 1 then
        love.window.setMode(w, h, f)
    else
        print(savedSettings.resolution)
        if savedSettings.resolution == 1 then
            if (w > 800) and (h > 600) then
                love.window.setMode(800, 600, f)
            else
                love.window.setMode(w, h, f)
            end
        elseif savedSettings.resolution == 2 then
            if (w > 1024) and (h > 768) then
                love.window.setMode(1024, 768, f)
            else
                love.window.setMode(w, h, f)
            end
        elseif savedSettings.resolution == 3 then
            if (w > 1280) and (h > 720) then
                love.window.setMode(1280, 720, f)
            else
                love.window.setMode(w, h, f)
            end
        elseif savedSettings.resolution == 0 then
            love.window.setMode(w, h, f)
        end
    end

    if savedSettings.devmode == true and savedSettings.console == true then
        if love.system.getOS() == "Windows" then love._openConsole() end
    end
    
    if savedSettings.masterVolume then
        love.audio.setVolume(savedSettings.masterVolume / 100)
    else
        savedSettings.masterVolume = 100
    end
    if not savedSettings.gameSpeed then
        savedSettings.gameSpeed = 1
    end
    local settings = require("src/gui/settings")
    settings.slider.value = savedSettings.gameSpeed
    return savedSettings
end

function file.settings.saveTexturePack(imageData)
    local encodedData = imageData:encode("png")
    love.filesystem.write("player.png", encodedData)
end

function file.settings.loadTexturePack()
    if love.filesystem.getInfo("player.png") then
        local imageData = love.filesystem.newFileData("player.png")
        local image = love.graphics.newImage(imageData)
        player.spriteSheet = image
    end
end

function file.settings.removeTexturePack()
    love.filesystem.remove("player.png")
    player.spriteSheet = love.graphics.newImage("assets/textures/entities/player/entities/player.png")
end

function file.update(dt)
    if file.message < 3 then
        file.message = file.message + dt
    end
end

function file:draw()
    if file.message < 3 and (game.state == 1 or game.state == 0) then
        love.graphics.print(file.status, love.graphics.getWidth() / 2 - (font:getWidth(file.status) * (playerCamera.globalScale / 2)) / 2, 0, nil, (playerCamera.globalScale / 2))
    end
end

return file