local title = {}
local worldManagement
local gui
local file = require("src/system/data")
local preview = file.show()
local settings
local shake
local button
require("src/system/data")
function title.load()
    button = require("src/gui/button")
    settings = require("src/gui/settings")
    local anim8 = require("src/library/animations")
    worldManagement = require("src/gameplay/worldmanager")
    gui = require("src/gui/gui")
    title.state = 0
    -- 0 = main title screen
    -- 1 = save game menu | main story
    -- 2 = save game menu | johns past
    -- 3 = save game menu | finaly
    -- 4 = settings
    -- 5 = back to gameplay
    title.background = {}
    title.background.blue = love.graphics.newImage("assets/textures/gui/title/backgroundBlue.png")
    title.background.green = love.graphics.newImage("assets/textures/gui/title/backgroundGreen.png")
    title.background.storm = love.graphics.newImage("assets/textures/gui/title/storm.png")
    title.background.current = title.background.blue
    title.logo = {}
    title.logo.y = 27
    title.logo.image = love.graphics.newImage("assets/textures/gui/title/mikert.png")
    title.logo.grid = anim8.newGrid( 200, 53, title.logo.image:getWidth(), title.logo.image:getHeight() )
    title.logo.animations = {}
    title.logo.animations.region1 = anim8.newAnimation( title.logo.grid('1-62', 1), 0.013 )
    title.logo.animations.region2 = anim8.newAnimation( title.logo.grid('1-8', 2), 0.1 )
    title.logo.animations.region3 = anim8.newAnimation( title.logo.grid('1-8', 3), 0.1 )
    title.logo.animations.region4 = anim8.newAnimation( title.logo.grid('1-32', 4), 0.1 )
    title.logo.anim = title.logo.animations.region1
    title.mainColor = {0, 1, 1}
    title.icons = {}
    title.icons.start = love.graphics.newImage("assets/textures/gui/title/buttons/start.png")
    title.icons.past = love.graphics.newImage("assets/textures/gui/title/buttons/past.png")
    title.icons.final = love.graphics.newImage("assets/textures/gui/title/buttons/final.png")
    title.icons.settings1 = love.graphics.newImage("assets/textures/gui/title/buttons/settings1.png")
    title.icons.settings2 = love.graphics.newImage("assets/textures/gui/title/buttons/settings2.png")
    title.icons.currentSettings = title.icons.settings1
    title.icons.delete1 = love.graphics.newImage("assets/textures/gui/title/buttons/delete1.png")
    title.icons.delete2 = love.graphics.newImage("assets/textures/gui/title/buttons/delete2.png")
    title.icons.currentDelete = title.icons.delete1
    title.rune = {}
    title.rune.image1 = love.graphics.newImage("assets/textures/gui/title/rune1.png")
    title.rune.image2 = love.graphics.newImage("assets/textures/gui/title/rune2.png")
    title.rune.image3 = love.graphics.newImage("assets/textures/gui/title/rune3.png")

    title.delete = {}
    title.delete.mode = false
    title.preview = {}
    title.preview.locationGray = love.graphics.newImage("assets/textures/gui/title/locatie.png")
    title.preview.locationBlue = love.graphics.newImage("assets/textures/gui/title/locatie2.png")
    title.preview.location1 = title.preview.locationGray
    title.preview.location2 = title.preview.locationGray
    title.preview.location3 = title.preview.locationGray
    title.preview.timeGray = love.graphics.newImage("assets/textures/gui/title/time.png")
    title.preview.timeBlue = love.graphics.newImage("assets/textures/gui/title/time2.png")
    title.preview.time1 = title.preview.timeGray
    title.preview.time2 = title.preview.timeGray
    title.preview.time3 = title.preview.timeGray
    title.savetile = {}
    title.savetile.image = love.graphics.newImage("assets/textures/gui/title/displaysave.png")
    title.swordicon = {}
    title.swordicon.image = love.graphics.newImage("assets/textures/gui/title/cryonium_sword.png")
    title.swordicon.grid = anim8.newGrid( 32, 32, title.swordicon.image:getWidth(), title.swordicon.image:getHeight() )
    title.swordicon.animations = {}
    title.swordicon.animations.progress1 = anim8.newAnimation( title.swordicon.grid('1-1', 1), 0.3 )
    title.swordicon.animations.progress2 = anim8.newAnimation( title.swordicon.grid('1-1', 2), 0.3 )
    title.swordicon.animations.progress3 = anim8.newAnimation( title.swordicon.grid('1-1', 3), 0.3 )
    title.swordicon.animations.progress4 = anim8.newAnimation( title.swordicon.grid('1-4', 4), 0.3 )
    title.swordicon.savegame1 = title.swordicon.animations.progress1
    title.swordicon.savegame2 = title.swordicon.animations.progress1
    title.swordicon.savegame3 = title.swordicon.animations.progress1
    title.setting = false
    title.text = {}
    title.text.name = "Main story"
    title.text.chapter = "Chapter 1"
    title.text.button1 = "Play"
    title.text.button2 = "Play"
    title.text.button3 = "Play"
    title.mikert = {}
    title.mikert.timer = -1
    title.mikert.showed = false
    title.mikert.order = {
        1, 2, 3, 5, 6,
        7, 8, 9, 10, 11,
        13, 14, 14, 14, 15,
        16, 16, 16, 17, 16,
        16, 16, 17, 14, 14,
        14, 14, 14, 14, 14,
        14, 14, 14, 14, 14,
        14, 14, 14, 14, 14,
        14, 14, 14, 14, 14,
        14, 14, 14, 14, 14
    }
    title.mikert.image = {}
    for i = 1, 17 do
        title.mikert.image[i] = love.graphics.newImage("assets/textures/gui/title/mikert/" .. i .. ".png")
    end

    title.settingBackground = love.graphics.newImage("assets/textures/gui/title/background.png")

    shake = {
        {
            isActive = true,
            targetPosition = 0,
            currentPosition = 0,
            targetPositive = true,
        },
        {
            isActive = true,
            targetPosition = 0,
            currentPosition = 0,
            targetPositive = true,
        },
        {
            isActive = true,
            targetPosition = 0,
            currentPosition = 0,
            targetPositive = true,
        }
    }
end

function title.rezet()
    local time = require("src/system/timer")
    time.seconds = 0
    time.minutes = 0
    time.hours = 0
    gui.focusTime = 0
    if preview.file1.created == true then
        title.preview.location1 = title.preview.locationBlue
        title.preview.time1 = title.preview.timeBlue
        if title.delete.mode == false then
            title.text.button1 = "Play"
        else
            title.text.button1 = "Delete"
        end
    else
        title.preview.location1 = title.preview.locationGray
        title.preview.time1 = title.preview.timeGray
        if title.delete.mode == false then
            title.text.button1 = "Create"
        else
            title.text.button1 = "Not Created"
        end
    end
    if preview.file2.created == true then
        title.preview.location2 = title.preview.locationBlue
        title.preview.time2 = title.preview.timeBlue
        if title.delete.mode == false then
            title.text.button2 = "Play"
        else
            title.text.button2 = "Delete"
        end
    else
        title.preview.location2 = title.preview.locationGray
        title.preview.time2 = title.preview.timeGray
        if title.delete.mode == false then
            title.text.button2 = "Create"
        else
            title.text.button2 = "Not Created"
        end
    end
    if preview.file3.created == true then
        title.preview.location3 = title.preview.locationBlue
        title.preview.time3 = title.preview.timeBlue
        if title.delete.mode == false then
            title.text.button3 = "Play"
        else
            title.text.button3 = "Delete"
        end
    else
        title.preview.location3 = title.preview.locationGray
        title.preview.time3 = title.preview.timeGray
        if title.delete.mode == false then
            title.text.button3 = "Create"
        else
            title.text.button3 = "Not Created"
        end
    end
end

function title.update(dt)
    if title.mikert.showed == false then
        title.mikert.timer = title.mikert.timer + dt
        if title.mikert.timer > 5 then
            title.mikert.showed = true
            button.loadAll()
        end
    else
        if title.state == 0 then
            if title.logo.y <= 89 then
                title.logo.y = title.logo.y + (dt * 80)
            else
                title.logo.y = 90
            end
            if title.logo.anim.position == 62 and title.logo.anim == title.logo.animations.region1  then
                title.logo.anim:gotoFrame(1)
                title.logo.anim = title.logo.animations.region2
            end
            title.logo.anim:update(dt)
            if love.keyboard.isDown("f5") then -- DEZE WEGHALEN NA BETA
                file.filenumber = 1
                game.state = 0
                data = file.load()
                worldManagement.teleport("start")
                game.freeze = false
                title.state = 5
                game.esc = false
                data = file.save()
            end
        end
        if title.state >= 1 and title.state <= 3 then
            title.swordicon.savegame1:update(dt)
            title.swordicon.savegame2:update(dt)
            title.swordicon.savegame3:update(dt)
        end
        if title.delete.mode == true then
            for i, v in ipairs(shake) do
                if shake[i].isActive then
                    shake[i].targetPosition = love.math.random(-5, 5)
                    shake[i].isActive = false
                else
                    local speed = 40
                    shake[i].currentPosition = shake[i].currentPosition + (shake[i].targetPosition - shake[i].currentPosition) * speed * dt
                    
                    if math.abs(shake[i].currentPosition - shake[i].targetPosition) < 0.1 then
                        shake[i].currentPosition = shake[i].targetPosition
                        shake[i].isActive = true
                    end
                end
            end
        end
    end
end

function love.filedropped(droppedFile)
    if settings.tab == "skin" then
        local filename = droppedFile:getFilename()
        local ext = filename:match("%.%w+$")

        if ext == ".png" then
            print("[Info  ] file is png")
            droppedFile:open("r")
            fileData = droppedFile:read("data")
            local img = love.image.newImageData(fileData)
            file.settings.saveTexturePack(img)
            img = love.graphics.newImage(img)
            if img:getWidth() == 95 and img:getHeight() == 105 then
                print("[Info  ] dimentions are oke.")
                player.spriteSheet = img
                print("[Info  ] Succesfully changed your skin")
            else
                print("[Warn  ] your file is" .. img:getWidth() .. "x" .. img:getHeight())
                print("try a image whith the dimentions 95x105")
            end
        else
            print("[Warn  ] try a png file")
        end
    else
        print("[Warn  ] not in texture mode (go to settings > general > skin - beta)")
    end
end

function title:draw()
    if title.mikert.showed == false then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        if title.mikert.timer > 0 and title.mikert.timer < 5 then
            love.graphics.setColor(1, 1, 1, 1 -( title.mikert.timer -3) / 2)
            love.graphics.draw(title.mikert.image[title.mikert.order[math.floor(title.mikert.timer * 10) + 1]], (love.graphics.getWidth() / 2) - (884 / 2 * (playerCamera.globalScale / 5)), (love.graphics.getHeight() / 2) - (188 / 2 * (playerCamera.globalScale / 5)), nil, playerCamera.globalScale / 5)
        end
    else
        love.graphics.setColor(1, 1, 1)
        if title.state == 0 or  title.state == 1 or title.state == 2 or title.state == 3 or (title.state == 4 and game.esc == false) then
            love.graphics.draw(title.background.current, 0, 0, nil, love.graphics.getWidth() / title.background.current:getWidth(), love.graphics.getHeight() / title.background.current:getHeight())
            love.graphics.setColor(0, 0, 0, 1 - (title.logo.y - 27) / 63)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            love.graphics.setColor(1, 1, 1, 1)
        end
        if title.state == 0 then
            love.graphics.print("".. game.beta .. " " .. game.name .. " " .. game.buildName .. ", Version " .. game.version, 5, 5, nil, playerCamera.globalScale / 3)
            title.logo.anim:draw(title.logo.image, love.graphics.getWidth() / 2 - (100 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (title.logo.y * playerCamera.globalScale), nil, playerCamera.globalScale)
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(title.rune.image1, love.graphics.getWidth() / 2 - (112 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (40 * playerCamera.globalScale) , nil, playerCamera.globalScale)
            love.graphics.draw(title.rune.image2, love.graphics.getWidth() / 2 - (28.5 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (36 * playerCamera.globalScale) , nil, playerCamera.globalScale)
            love.graphics.draw(title.rune.image3, love.graphics.getWidth() / 2 + (60 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (40 * playerCamera.globalScale) , nil, playerCamera.globalScale)
        elseif title.state >= 1 and title.state <= 3 then
            -- show title
            love.graphics.setColor(title.mainColor)
            love.graphics.print(title.text.name, love.graphics.getWidth() / 2 - (font:getWidth(title.text.name) * playerCamera.globalScale), love.graphics.getHeight() / 2 - (title.logo.y * playerCamera.globalScale), nil, playerCamera.globalScale * 2)
            love.graphics.setColor(0.3, 0.3, 0.3)
            love.graphics.print(title.text.chapter, love.graphics.getWidth() / 2 - (font:getWidth(title.text.chapter) / 2 * playerCamera.globalScale), love.graphics.getHeight() / 2 - ((title.logo.y - (font:getHeight() * 2) + 2) * playerCamera.globalScale), nil, playerCamera.globalScale)
            love.graphics.setColor(1, 1, 1)
            -- draw buttons and savegame tiles
            if title.delete.mode == false then
                love.graphics.draw(title.savetile.image, love.graphics.getWidth() / 2 - (130 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (34 * playerCamera.globalScale) , nil, playerCamera.globalScale)
                love.graphics.draw(title.savetile.image, love.graphics.getWidth() / 2 - (42 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (34 * playerCamera.globalScale) , nil, playerCamera.globalScale)
                love.graphics.draw(title.savetile.image, love.graphics.getWidth() / 2 + (46 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (34 * playerCamera.globalScale) , nil, playerCamera.globalScale)
            else
                love.graphics.draw(title.savetile.image, love.graphics.getWidth() / 2 - (130 * playerCamera.globalScale) + title.savetile.image:getWidth() / 2 * playerCamera.globalScale, love.graphics.getHeight() / 2 - (34 * playerCamera.globalScale) + title.savetile.image:getHeight() / 2 * playerCamera.globalScale, shake[1].currentPosition / 100, playerCamera.globalScale, nil, title.savetile.image:getWidth() / 2, title.savetile.image:getHeight() / 2)
                love.graphics.draw(title.savetile.image, love.graphics.getWidth() / 2 - (42 * playerCamera.globalScale) + title.savetile.image:getWidth() / 2 * playerCamera.globalScale, love.graphics.getHeight() / 2 - (34 * playerCamera.globalScale) + title.savetile.image:getHeight() / 2 * playerCamera.globalScale, shake[2].currentPosition / 100, playerCamera.globalScale, nil, title.savetile.image:getWidth() / 2, title.savetile.image:getHeight() / 2)
                love.graphics.draw(title.savetile.image, love.graphics.getWidth() / 2 + (46 * playerCamera.globalScale) + title.savetile.image:getWidth() / 2 * playerCamera.globalScale, love.graphics.getHeight() / 2 - (34 * playerCamera.globalScale) + title.savetile.image:getHeight() / 2 * playerCamera.globalScale, shake[3].currentPosition / 100, playerCamera.globalScale, nil, title.savetile.image:getWidth() / 2, title.savetile.image:getHeight() / 2)
            end
            --show location
            if preview.file1.created == true then
                love.graphics.setColor(title.mainColor[1] * button.fader, title.mainColor[2] * button.fader, title.mainColor[3] * button.fader)
            end
            love.graphics.draw(title.preview.location1, love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (14 * playerCamera.globalScale) , nil, playerCamera.globalScale / 2)
            love.graphics.draw(title.preview.time1, love.graphics.getWidth() / 2 - (128 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (34 * playerCamera.globalScale) , nil, playerCamera.globalScale / 2)
            love.graphics.setColor(1, 1, 1)
            if preview.file2.created == true then
                love.graphics.setColor(title.mainColor[1] * button.fader, title.mainColor[2] * button.fader, title.mainColor[3]* button.fader)
            end
            love.graphics.draw(title.preview.location2, love.graphics.getWidth() / 2 - (40 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (14 * playerCamera.globalScale) , nil, playerCamera.globalScale / 2)
            love.graphics.draw(title.preview.time2, love.graphics.getWidth() / 2 - (40 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (34 * playerCamera.globalScale) , nil, playerCamera.globalScale / 2)
            love.graphics.setColor(1, 1, 1)
            if preview.file3.created == true then
                love.graphics.setColor(title.mainColor[1] * button.fader, title.mainColor[2] * button.fader, title.mainColor[3] * button.fader)
            end
            love.graphics.draw(title.preview.location3, love.graphics.getWidth() / 2 + (48 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (14 * playerCamera.globalScale) , nil, playerCamera.globalScale / 2)
            love.graphics.draw(title.preview.time3, love.graphics.getWidth() / 2 + (48 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (34 * playerCamera.globalScale) , nil, playerCamera.globalScale / 2)
            love.graphics.setColor(1, 1, 1)
            -- show sword (indecates how far the palyer is in the game)
            if preview.file1.item.sword == true then
                title.swordicon.savegame1:draw(title.swordicon.image, love.graphics.getWidth() / 2 - (68 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (14 * playerCamera.globalScale) , 2.35, playerCamera.globalScale * 0.9)
            end
            if preview.file2.item.sword == true then
                title.swordicon.savegame2:draw(title.swordicon.image, love.graphics.getWidth() / 2 + (20 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (14 * playerCamera.globalScale) , 2.35, playerCamera.globalScale * 0.9)
            end
            if preview.file3.item.sword == true then
                title.swordicon.savegame3:draw(title.swordicon.image, love.graphics.getWidth() / 2 + (108 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (14 * playerCamera.globalScale) , 2.35, playerCamera.globalScale * 0.9)
            end
            -- Time preview
            
            love.graphics.setColor(0.15, 0.15, 0.15)
            love.graphics.print(preview.file1.world, love.graphics.getWidth() / 2 - (118 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (14 * playerCamera.globalScale) , nil, playerCamera.globalScale / 2)
            love.graphics.print(preview.file2.world, love.graphics.getWidth() / 2 - (30 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (14 * playerCamera.globalScale) , nil, playerCamera.globalScale / 2)
            love.graphics.print(preview.file3.world, love.graphics.getWidth() / 2 + (58 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (14 * playerCamera.globalScale) , nil, playerCamera.globalScale / 2)
            love.graphics.print("h" .. preview.file1.hours .. ", m" .. preview.file1.minutes .. ", s" .. string.sub(preview.file1.seconds, 0, 2) , love.graphics.getWidth() / 2 - (118 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (34 * playerCamera.globalScale) , nil, playerCamera.globalScale / 2)
            love.graphics.print("h" .. preview.file2.hours .. ", m" .. preview.file2.minutes .. ", s" .. string.sub(preview.file2.seconds, 0, 2) , love.graphics.getWidth() / 2 - (30 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (34 * playerCamera.globalScale) , nil, playerCamera.globalScale / 2)
            love.graphics.print("h" .. preview.file3.hours .. ", m" .. preview.file3.minutes .. ", s" .. string.sub(preview.file3.seconds, 0, 2) , love.graphics.getWidth() / 2 + (58 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (34 * playerCamera.globalScale) , nil, playerCamera.globalScale / 2)
            -- show savegame name
            if preview.file1.created == true then
                love.graphics.setColor(title.mainColor[1] * button.fader, title.mainColor[2] * button.fader, title.mainColor[3] * button.fader)
            else
                love.graphics.setColor(0.15, 0.15, 0.15)
            end
            love.graphics.print("Save 1", love.graphics.getWidth() / 2 - (109 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (30 * playerCamera.globalScale), nil, playerCamera.globalScale)
            if preview.file2.created == true then
                love.graphics.setColor(title.mainColor[1] * button.fader, title.mainColor[2] * button.fader, title.mainColor[3] * button.fader)
            else
                love.graphics.setColor(0.15, 0.15, 0.15)
            end
            love.graphics.print("Save 2", love.graphics.getWidth() / 2 - (21 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (30 * playerCamera.globalScale), nil, playerCamera.globalScale)
            if preview.file3.created == true then
                love.graphics.setColor(title.mainColor[1] * button.fader, title.mainColor[2] * button.fader, title.mainColor[3] * button.fader)
            else
                love.graphics.setColor(0.15, 0.15, 0.15)
            end
            love.graphics.print("Save 3", love.graphics.getWidth() / 2 + (67 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (30 * playerCamera.globalScale), nil, playerCamera.globalScale)
            -- play, create ect. text,s and back text
            love.graphics.setColor(1, 1, 1)
        end
    end
end
return title