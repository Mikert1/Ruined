local button = {}
button.__index = button
local buttonImage = love.graphics.newImage("assets/textures/gui/title/buttons/button.png")
local buttonImageOutline = love.graphics.newImage("assets/textures/gui/title/buttons/buttonOutline.png")
local miniButtonImage = love.graphics.newImage("assets/textures/gui/title/buttons/miniButton.png")
local miniButtonImageOutline = love.graphics.newImage("assets/textures/gui/title/buttons/miniButtonOutline.png")

local file
local settings
local title
local gui
local controller
local selectedGrid = {row = 1, column = 1}
local moving = false
local preview
local worldManagement

function button.load()
    file = require("src/system/data")
    preview = file.show()
    settings = require("src/gui/settings")
    title = require("src/gui/title")
    gui = require("src/gui/gui")
    controller = require("src/controls/controller")
    worldManagement = require("src/gameplay/worldmanager")
end

button.activeButtons = {}
button.fader = 0

function button.loadAll()
    button.activeButtons = {}
    button.fader = 0.26
    selectedGrid = {row = 1, column = 1}
    if not (button.warning.id == 0) then
        if button.warning.icon == button.icons.danger then
            button.new(-96, 30, "Go Back", {0, 1, 1}, 199, 1, 1) -- Cancel the action
            button.new(16, 30, "Continue", {1, 0, 0}, 200, 2, 1) -- Continue with the action
        else
            button.new(-40, 30, "Oke", {0, 1, 1}, 199, 2, 1) -- Accepting that there is no action to be done
        end
        return
    end
    if title.state == 0 then
        button.specialNew(-100, 50, title.icons.start, {0, 1, 1}, 61, 1, 1)
        button.specialNew(-12.5, 50, title.icons.past, {0, 0.8, 0}, 62, 2, 1)
        button.specialNew(71, 50, title.icons.final, {0, 1, 1}, 63, 3, 1)
    elseif title.state == 5 then
        if game.esc == true then
            button.new(-40, -25, "Resume", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 7, 1, 1) -- back from skin to settings
            button.new(-40, 0, "Settings", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 6, 1, 2) -- back from skin to settings
            button.new(-40, 25, "Title screen", {1, 0, 0}, 5, 1, 3) -- back from skin to settings
            button.first()
        end
    elseif title.state == 4 then
        selectedGrid.column = 2
        button.specialNew(-127, -88, settings.mainButtons.game, {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 101, 1, 1, settings.button, settings.buttonOutline)
        button.specialNew(-84, -88, settings.mainButtons.video, {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 102, 2, 1, settings.button, settings.buttonOutline)
        button.specialNew(-41, -88, settings.mainButtons.controls, {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 103, 3, 1, settings.button, settings.buttonOutline)
        button.specialNew(2, -88, settings.mainButtons.customize, {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 104, 4, 1, settings.button, settings.buttonOutline)
        button.specialNew(45, -88, settings.mainButtons.audio, {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 105, 5, 1, settings.button, settings.buttonOutline)
        button.specialNew(88, -88, settings.mainButtons.a, {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 106, 6, 1, settings.button, settings.buttonOutline)
        if settings.tab == "game" then
            if savedSettings.devmode == true then
                if savedSettings.console == true then
                    button.new(-40, -53, "Enabled", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 16, 2, 2, "Auto Open Console") -- Console
                else
                    button.new(-40, -53, "Disabled", {1, 0.5, 0}, 16, 2, 2, "Auto Open Console") -- Console
                end
                button.new(-127, -53, "Enabled", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 1, 1, 2, "Developer Mode") -- devmode
            else
                button.new(-127, -53, "Disabled", {1, 0.5, 0}, 1, 1, 2, "Developer Mode") -- devmode
            end
        elseif settings.tab == "video" then
            if savedSettings.window == 0 then
                button.new(-127, -53, "Windowed", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 20, 1, 2, "Window Type:") -- Windowed
            elseif savedSettings.window == 1 then
                button.new(-127, -53, "Fullscreen", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 20, 1, 2, "Window Type:") -- Fullscreen
            end
            button.new(-40, -53, savedSettings.windowIndex, {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 21, 2, 2, "Window Index:") -- resolution
            if not (savedSettings.window == 1) then
                button.new(47, -53, love.graphics.getWidth() .. "x" .. love.graphics.getHeight(), {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 22, 2, 3, "Window Resolution:") -- resolution
            end
            if savedSettings.screenShake == true then
                button.new(-127, -18, "Enabled", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 23, 1, 3, "Screen shake") -- screen shake
            else
                button.new(-127, -18, "Disabled", {1, 0.5, 0}, 23, 1, 3, "Screen shake") -- screen shake
            end
        elseif settings.tab == "controls" then
            if controls.searchForKey == "interact" then
                button.new(-127, -53, "Press key", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 25, 1, 2, "Interact", true) -- 
            else
                button.new(-127, -53, "Key: " .. string.upper(controls.keys.interact) .. " ", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 25, 1, 2, "Interact", true) --
            end
            if controls.searchForKey == "map" then
                button.new(-127, -18, "Press key", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 26, 1, 3, "Map", true) -- 
            else
                button.new(-127, -18, "Key: " .. string.upper(controls.keys.map) .. " ", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 26, 1, 3, "Map", true) -- 
            end
            if controls.searchForKey == "focus" then
                button.new(-127, 17, "Press key", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 27, 1, 4, "Focus", true) -- 
            else
                button.new(-127, 17, "Key: " .. string.upper(controls.keys.focus) .. " ", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 27, 1, 4, "Focus", true) -- 
            end
            if controls.searchForKey == "switchWeapon" then
                button.new(-127, 52, "Press key", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 28, 1, 5, "Switch Weapon", true) -- 
            else
                button.new(-127, 52, "Key: " .. string.upper(controls.keys.switchWeapon) .. " ", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 28, 1, 5, "Switch Weapon", true) -- 
            end 
            -- keybind wasd keys
            if controls.searchForKey == "up" then
                button.new(-127, 87, "Press key", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 29, 1, 6, "Move Up", true) -- 
            else
                button.new(-127, 87, "Key: " .. string.upper(controls.keys.up) .. " ", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 29, 1, 6, "Move Up", true) -- 
            end
            if controls.searchForKey == "left" then
                button.new(-127, 122, "Press key", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 30, 1, 7, "Move Left", true) -- 
            else
                button.new(-127, 122, "Key: " .. string.upper(controls.keys.left) .. " ", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 30, 1, 7, "Move Left", true) -- 
            end
            if controls.searchForKey == "down" then
                button.new(-127, 157, "Press key", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 31, 1, 8, "Move Down", true) -- 
            else
                button.new(-127, 157, "Key: " .. string.upper(controls.keys.down) .. " ", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 31, 1, 8, "Move Down", true) -- 
            end
            if controls.searchForKey == "right" then
                button.new(-127, 192, "Press key", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 32, 1, 9, "Move Right", true) -- 
            else
                button.new(-127, 192, "Key: " .. string.upper(controls.keys.right) .. " ", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 32, 1, 9, "Move Right", true) -- 
            end
            -- if savedSettings.devmode == true then
            --     if controls.searchForKey == "devMode" then
            --         button.new(-127, 227, "Press key", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 33, "Dev info", true) -- 
            --     else
            --         button.new(-127, 227, "Key: " .. string.upper(controls.keys.devMode) .. " ", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 33, "Dev info", true) -- 
            --     end
            -- end
            button.new(-124, 70, "Reset All", {1, 0, 0}, 24, 1, 20) -- remove saved skin
        elseif settings.tab == "skin" then
            button.new(-124, 70, "Reset", {1, 0, 0}, 4, 1, 20) -- remove saved skin
        elseif settings.tab == "audio" then
        elseif settings.tab == "stats" then
        elseif settings.tab == "eeprnd" then
            button.new(-124, -40, "speed: " .. savedSettings.gameSpeed, {0, 0.5, 0.5}, 81, 1, 2) -- gameSpeed setting
        end
        button.new(-40, 70, "Back", {1, 0.5, 0}, 3, 2, 20) -- back from settings to main menu or game
    elseif title.state == 1 or title.state == 2 or title.state == 3 then
        if title.delete.mode == false then
            if preview.file1.created == true then
                button.new(-128, 43, "Play", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 51, 1, 1) -- Play game button for save 1
            else
                button.new(-128, 43, "Create", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 51, 1, 1) -- Create game button for save 1
            end
            if preview.file2.created == true then
                button.new(-40, 43, "Play", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 52, 2, 1) -- Play game button for save 2
            else
                button.new(-40, 43, "Create", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 52, 2, 1) -- Create game button for save 2
            end
            if preview.file3.created == true then
                button.new(48, 43, "Play", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 53, 3, 1) -- Play game button for save 3
            else
                button.new(48, 43, "Create", {title.mainColor[1], title.mainColor[2], title.mainColor[3]}, 53, 3, 1) -- Create game button for save 3
            end
        else
            if preview.file1.created == true then
                button.new(-128, 43, "Delete", {1, 0, 0}, 51, 1, 1) -- Delete savefile button for save 1
            else
                button.new(-128, 43, "Empty", {0.15, 0.15, 0.15}, 51, 1, 1) -- Empty that indicates that there is no savefile for save 1
            end
            if preview.file2.created == true then
                button.new(-40, 43, "Delete", {1, 0, 0}, 52, 2, 1) -- Delete savefile button for save 2
            else
                button.new(-40, 43, "Empty", {0.15, 0.15, 0.15}, 52, 2, 1) -- Empty that indicates that there is no savefile for save 2
            end
            if preview.file3.created == true then
                button.new(48, 43, "Delete", {1, 0, 0}, 53, 3, 1) -- Delete savefile button for save 3
            else
                button.new(48, 43, "Empty", {0.15, 0.15, 0.15}, 53, 3, 1) -- Empty that indicates that there is no savefile for save 3
            end
        end
        button.specialNew(-128, 70, title.icons.currentSettings, {0, 1, 1}, 64, 1, 2, miniButtonImage, miniButtonImageOutline)
        if title.delete.mode == false then
            button.specialNew(108, 70, title.icons.currentDelete, {0, 1, 1}, 65, 3, 2, miniButtonImage, miniButtonImageOutline)
        else
            button.specialNew(108, 70, title.icons.currentDelete, {1, 0, 0}, 65, 3, 2, miniButtonImage, miniButtonImageOutline)
        end
        button.new(-40, 70, "Back", {1, 0.5, 0}, 50, 2, 2) -- back to ruined Title screen
        button.first()
    end
end

function button.first()
    if game.controlType == 1 then
        local lowestRow = 0
        local lowestColumn = 0
        for _, btn in ipairs(button.activeButtons) do
            if btn.grid.row > lowestRow then
                lowestRow = btn.grid.row
            end
            if btn.grid.column > lowestColumn then
                lowestColumn = btn.grid.column
            end
        end
        selectedGrid = {row = lowestRow, column = lowestColumn}
    end
end

function button.new(x, y, text, color, id, row, column, info, scroll)
    local self = setmetatable({}, button)
    self.x = x
    self.y = y
    self.id = id
    self.image = buttonImage
    self.width = buttonImage:getWidth()
    self.height = buttonImage:getHeight()
    self.imageOutline = buttonImageOutline
    self.color = color
    self.currentColor = {0.26, 0.26, 0.26}
    self.text = text
    self.info = info
    self.hover = false
    self.clicked = false
    self.scroll = scroll

    self.grid = {
        row = row or 0, 
        column = column or 0
    }
    table.insert(button.activeButtons, self)
end

function button.specialNew(x, y, imageOnButton, color, id, row, column, image, outline)
    local self = setmetatable({}, button)
    self.x = x
    self.y = y
    self.id = id
    self.image = image
    if image then
        self.width = image:getWidth()
        self.height = image:getHeight()
    else
        self.width = imageOnButton:getWidth()
        self.height = imageOnButton:getHeight()
    end
    self.imageOutline = outline
    self.color = color
    self.currentColor = {0.26, 0.26, 0.26}
    self.imageOnButton = imageOnButton
    self.hover = false
    self.clicked = false
    if id == 101 and settings.tab == "game"
    or id == 102 and settings.tab == "video"
    or id == 103 and settings.tab == "controls"
    or id == 104 and settings.tab == "skin"
    or id == 105 and settings.tab == "audio"
    or id == 106 and settings.tab == "stats" then
        self.highlighted = true
    else
        self.highlighted = false
    end

    self.grid = {
        row = row or 0, 
        column = column or 0
    }
    table.insert(button.activeButtons, self)
end

button.icons = {}
button.icons.danger = love.graphics.newImage("assets/textures/gui/title/buttons/danger.png")
button.icons.info = love.graphics.newImage("assets/textures/gui/title/buttons/info.png")
button.warning = {
    id = 0,
    text = "",
    icon = button.icons.danger
}
button.notification = love.graphics.newImage("assets/textures/gui/title/buttons/notification.png")

function button.actionWarning(id)
    if id == 5 then
        game.esc = false
        love.window.setTitle("Ruined | Title Screen")
        game.freeze = false
        --data = file.save()
        title.rezet()
        enemymanager:load()
        game.state = 1
        if title.mainColor[3] == 0 then
            title.state = 2
        else
            title.state = 1
            --fix there will be the finaly (3)
        end
    elseif id == 24 then
        controls.keys = controls.default
        controls.save()
    elseif id == 51 then
        love.filesystem.remove("savegame1.json")
        love.filesystem.remove("previewcard1.json")
        file.show()
        title.rezet()
    elseif id == 52 then
        love.filesystem.remove("savegame2.json")
        love.filesystem.remove("previewcard2.json")
        file.show()
        title.rezet()
    elseif id == 53 then
        love.filesystem.remove("savegame3.json")
        love.filesystem.remove("previewcard3.json")
        file.show()
        title.rezet()
    elseif id == 62 then
        print("[Warn  ] chapter 2 is not unlocked, finish chapter 1 to play chapter 2.")
        title.state = 2
        game.chapter = 2
        file.show()
        title.rezet()
        title.text.name = "The days of John's"
        title.text.chapter = "Chapter 2"
        title.mainColor = {0, 0.8, 0}
        title.background.current = title.background.green
    elseif id == 63 then
        print("[Warn  ] chapter 3 is not unlocked, finish chapter 2 to play chapter 3.")
        title.state = 3
        game.chapter = 3
        file.show()
        title.rezet()
        title.text.name = "Returned"
        title.text.chapter = "Chapter 3"
        title.mainColor = {0, 1, 1}
        title.background.current = title.background.storm
    end
    button.warning.id = 0
    button.warning.text = ""
    button.loadAll()
end

function button:action()
    if self.id == 1 then -- disables or enables devmode
        if savedSettings.devmode == false then
            savedSettings.devmode = true
        else
            savedSettings.devmode = false
        end
        file.settings.save()
    elseif self.id == 16 then -- auto open console
        if savedSettings.console == false then
            savedSettings.console = true
        else
            savedSettings.console = false
        end
        file.settings.save()
    elseif self.id == 2 then -- opens skin change setting menu
        settings.tab = "skin"
    elseif self.id == 3 then -- back button on settings screen
        if game.esc == true then
            title.state = 5
        else
            love.window.setTitle("Ruined | Title Screen")
            if title.mainColor[3] == 0 then
                title.state = 2
            else
                title.state = 1
                --fix there will be the finaly (3)
            end
            title.delete.mode = false
        end
    elseif self.id == 4 then -- removes texture pack
        file.settings.removeTexturePack()
    elseif self.id == 5 then -- back to title screen
        if worldManagement.saved == false then
            button.warning.id = self.id
            button.warning.icon = button.icons.danger
            button.warning.text = "You are not standing on a savestone. \nAll unsaved progress will be lost."
        else
            button.actionWarning(self.id)
        end
    elseif self.id == 6 then -- settings button
        title.state = 4
    elseif self.id == 7 then -- resume button
        game.esc = false
        game.freeze = false
        player.noMove = false
    elseif self.id == 101 then -- game button
        settings.tab = "game"
        controls.searchForKey = nil
        settings.scroll = 0
    elseif self.id == 102 then -- video button
        settings.tab = "video"
        controls.searchForKey = nil
        settings.scroll = 0
    elseif self.id == 103 then -- controls button
        settings.tab = "controls"
        controls.searchForKey = nil
        settings.scroll = 0
    elseif self.id == 104 then -- skin button
        settings.tab = "skin"
        settings.scroll = 0
        controls.searchForKey = nil
    elseif self.id == 105 then -- audio button
        settings.tab = "audio"
        settings.scroll = 0
        controls.searchForKey = nil
    elseif self.id == 106 then -- stats button
        settings.tab = "stats"
        settings.scroll = 0
        controls.searchForKey = nil
    elseif self.id == 20 then -- fullscreen button
        print(savedSettings.window)
        if savedSettings.window == 0 then
            love.window.setFullscreen(true)
            savedSettings.window = 1
        elseif savedSettings.window == 1 then
            love.window.setFullscreen(false)
            savedSettings.window = 0
        end
        file.settings.save()
    elseif self.id == 21 then -- window index button
        if savedSettings.windowIndex < love.window.getDisplayCount() then
            savedSettings.windowIndex = savedSettings.windowIndex + 1
            love.window.setMode(love.graphics.getWidth(), love.graphics.getHeight(), {display = savedSettings.windowIndex, resizable = true})
            self.text = savedSettings.windowIndex
        else
            savedSettings.windowIndex = 1
            love.window.setMode(love.graphics.getWidth(), love.graphics.getHeight(), {display = savedSettings.windowIndex, resizable = true})
            self.text = savedSettings.windowIndex
        end
        file.settings.save()
    elseif self.id == 22 then -- resolution button
        local x, y = love.window.getDesktopDimensions(savedSettings.windowIndex)
        local f = {borderless = false, resizable = true, display = savedSettings.windowIndex}
        if savedSettings.resolution == 0 then
            savedSettings.resolution = 1
            if (x > 800) and (y > 600) then
                love.window.setMode(800, 600, f)
            else
                love.window.setMode(x, y, f)
                savedSettings.resolution = 0
            end
        elseif savedSettings.resolution == 1 then
            savedSettings.resolution = 2
            if (x > 1024) and (y > 768) then
                love.window.setMode(1024, 768, f)
            else
                love.window.setMode(x, y, f)
                savedSettings.resolution = 0
            end
        elseif savedSettings.resolution == 2 then
            savedSettings.resolution = 3
            if (x > 1280) and (y > 720) then
                love.window.setMode(1280, 720, f)
            else
                love.window.setMode(x, y, f)
                savedSettings.resolution = 0
            end
        elseif savedSettings.resolution == 3 then
            love.window.setMode(x, y, f)
            savedSettings.resolution = 0
        end
        love.resize(w, h)
        file.settings.save()
    elseif self.id == 23 then -- screen shake button
        if savedSettings.screenShake == false then
            savedSettings.screenShake = true
        else
            savedSettings.screenShake = false
        end
        file.settings.save()

    elseif self.id == 24 then -- Rezet all Keybind button
        button.warning.id = self.id
        for key, value in pairs(controls.keys) do
            if controls.keys[key] ~= controls.default[key] then
                button.warning.text = "Are you sure you want to reset all keybinds?"
                button.warning.icon = button.icons.danger
                return
            else
                button.warning.text = "All keybinds are already set to default."
                button.warning.icon = button.icons.info
            end
        end
    elseif self.id == 25 then -- keybind button
        controls.searchForKey = "interact"
    elseif self.id == 26 then -- keybind button
        controls.searchForKey = "map"
    elseif self.id == 27 then -- keybind button
        controls.searchForKey = "focus"
    elseif self.id == 28 then -- keybind button
        controls.searchForKey = "switchWeapon"
    elseif self.id == 29 then -- keybind button
        controls.searchForKey = "up"
    elseif self.id == 30 then -- keybind button
        controls.searchForKey = "left"
    elseif self.id == 31 then -- keybind button
        controls.searchForKey = "down"
    elseif self.id == 32 then -- keybind button
        controls.searchForKey = "right"
    elseif self.id == 33 then -- keybind button
        controls.searchForKey = "devMode"
    elseif self.id == 50 then -- back to ruined
        title.state = 0
        title.delete.mode = false
        controls.searchForKey = nil
    elseif self.id == 51 then -- play button
        if title.delete.mode == true then
            button.warning.id = self.id
            button.warning.icon = button.icons.danger
            button.warning.text = "Your about to delete Savefile 1?"
        else
            file.filenumber = 1
            game.state = 0
            data = file.load()
            worldManagement.teleport("start")
            game.freeze = false
            title.state = 5
            game.esc = false
            data = file.save()
            player.noMove = false
            love.mouse.setGrabbed(true)
        end
    elseif self.id == 52 then -- play button
        if title.delete.mode == true then
            button.warning.id = self.id
            button.warning.icon = button.icons.danger
            button.warning.text = "Your about to delete Savefile 2?"
        else
            file.filenumber = 2
            game.state = 0
            data = file.load()
            worldManagement.teleport("start")
            game.freeze = false
            title.state = 5
            game.esc = false
            data = file.save()
            player.noMove = false
            love.mouse.setGrabbed(true)
        end
    elseif self.id == 53 then -- play button
        if title.delete.mode == true then
            button.warning.id = self.id
            button.warning.icon = button.icons.danger
            button.warning.text = "Your about to delete Savefile 3?"
        else
            file.filenumber = 3
            game.state = 0
            data = file.load()
            worldManagement.teleport("start")
            game.freeze = false
            title.state = 5
            game.esc = false
            data = file.save()
            player.noMove = false
            love.mouse.setGrabbed(true)
        end
    elseif self.id == 61 then -- chapter button
        title.state = 1
        game.chapter = 1
        file.show()
        title.rezet()
        title.text.name = "Ruined"
        title.text.chapter = "Chapter 1"
        title.mainColor = {0, 1, 1}
        title.background.current = title.background.blue
    elseif self.id == 62 then -- chapter button
        button.warning.id = self.id
        if savedSettings.devmode == true then
            button.warning.text = "Because of DEVMODE \nyou can play chapter 2. \nWork in progress. (not recomanded)"
            button.warning.icon = button.icons.danger
        else
            button.warning.text = "This chapter is locked for now. \nWork in progress.\nIf you want to look turn on DEVMODE."
            button.warning.icon = button.icons.info
        end
    elseif self.id == 63 then -- chapter button 
        button.warning.id = self.id
        if savedSettings.devmode == true then
            button.warning.text = "Because of DEVMODE \nyou can play chapter 3. \nWork in progress. (not recomanded)"
            button.warning.icon = button.icons.danger
        else
            button.warning.text = "This chapter is locked for now. \nWork in progress.\nIf you want to look turn on DEVMODE."
            button.warning.icon = button.icons.info
        end
    elseif self.id == 64 then -- setting button
        love.window.setTitle("Ruined | Settings")
        title.state = 4
    elseif self.id == 65 then -- delete button
        if title.delete.mode == false then
            title.delete.mode = true
            title.icons.currentDelete = title.icons.delete2
        else
            title.delete.mode = false
            title.icons.currentDelete = title.icons.delete1
        end
        title.rezet()
    elseif self.id == 81 then -- gameSpeed button
        if savedSettings.gameSpeed == 1 then
            savedSettings.gameSpeed = 0.5
        elseif savedSettings.gameSpeed == 0.5 then
            savedSettings.gameSpeed = 0.25
        elseif savedSettings.gameSpeed == 0.25 then
            savedSettings.gameSpeed = 0.1
        elseif savedSettings.gameSpeed == 0.1 then
            savedSettings.gameSpeed = 100
        elseif savedSettings.gameSpeed == 100 then
            savedSettings.gameSpeed = 10
        elseif savedSettings.gameSpeed == 10 then
            savedSettings.gameSpeed = 1
        end
    elseif self.id == 199 then -- no button
        button.warning.id = 0
        button.warning.text = ""
    elseif self.id == 200 then -- yes button
        button.actionWarning(button.warning.id)
        button.warning.id = 0
    end
    button.loadAll()
end

function button:update(dt)
    if button.fader < 1 then
        button.fader = button.fader + (dt / 3)
    else
        button.fader = 1
    end
    if game.controlType == 0 then
        local x = love.mouse.getX()
        local y = love.mouse.getY()
        local modifiedY = self.y
        if self.scroll then
            modifiedY = self.y + settings.scroll
        end
        if 
            not self.scroll or (
            x > love.graphics.getWidth() / 2 + (-127 * playerCamera.globalScale) and
            x < love.graphics.getWidth() / 2 + (127 * playerCamera.globalScale) and
            y > love.graphics.getHeight() / 2 + (-61 * playerCamera.globalScale) and
            y < love.graphics.getHeight() / 2 + (69 * playerCamera.globalScale)) 
        then
            if
                x > love.graphics.getWidth() / 2 + (self.x * playerCamera.globalScale) and
                x < love.graphics.getWidth() / 2 + ((self.x + self.width) * playerCamera.globalScale) and
                y > love.graphics.getHeight() / 2 + (modifiedY * playerCamera.globalScale) and
                y < love.graphics.getHeight() / 2 + ((modifiedY + self.height) * playerCamera.globalScale)
            then
                self.hover = true
                if love.mouse.isDown(1) then
                    self.clicked = true
                else
                    if self.clicked == true then
                        self.clicked = false
                        self:action(self.id)
                    end
                end
            else
                self.hover = false
                self.clicked = false
            end
        else
            self.hover = false
        end
    end
    if self.highlighted then
        for i = 1, 3 do
            local colorDifference = math.abs(self.currentColor[i] - self.color[i])
            local transitionSpeed = dt * 6 * colorDifference
            if self.currentColor[i] < self.color[i] then
                self.currentColor[i] = math.min(self.currentColor[i] + transitionSpeed, self.color[i])
            elseif self.currentColor[i] > self.color[i] then
                self.currentColor[i] = math.max(self.currentColor[i] - transitionSpeed, self.color[i])
            end
        end
    else
        if self.hover then
            game.cursor.color = {self.color[1] / 2, self.color[2] / 2, self.color[3] / 2, 1}
            for i = 1, 3 do
                local colorDifference = math.abs(self.currentColor[i] - self.color[i])
                local transitionSpeed = dt * 6 * colorDifference
                if self.currentColor[i] < self.color[i] then
                    self.currentColor[i] = math.min(self.currentColor[i] + transitionSpeed, self.color[i])
                elseif self.currentColor[i] > self.color[i] then
                    self.currentColor[i] = math.max(self.currentColor[i] - transitionSpeed, self.color[i])
                end
            end
        else
            for i = 1, 3 do
                local colorDifference = math.abs(self.currentColor[i] - 0.15)
                local transitionSpeed = dt * 3 * colorDifference
                if self.currentColor[i] < 0.15 then
                    self.currentColor[i] = math.min(self.currentColor[i] + transitionSpeed, 0.15)
                elseif self.currentColor[i] > 0.15 then
                    self.currentColor[i] = math.max(self.currentColor[i] - transitionSpeed, 0.15)
                end
            end
        end
    end
end

function button:handleJoystickInput()
    local joystick = controller.joysticks
    local dx = joystick:getGamepadAxis("leftx")
    local dy = joystick:getGamepadAxis("lefty")

    local firstRowFound
    local firstColumnFound
    for i, button in ipairs(button.activeButtons) do
        if dx > 0.5 then
            if button.grid.row > selectedGrid.row then
                if firstRowFound then
                    if firstRowFound > button.grid.row then
                        firstRowFound = button.grid.row
                    end
                else
                    firstRowFound = button.grid.row
                end
            end
        elseif dx < -0.5 then
            if button.grid.row < selectedGrid.row then
                if firstRowFound then
                    if firstRowFound < button.grid.row then
                        firstRowFound = button.grid.row
                    end
                else
                    firstRowFound = button.grid.row
                end
            end
        end
        if dy > 0.5 then
            if button.grid.column > selectedGrid.column then
                if firstColumnFound then
                    if firstColumnFound > button.grid.column then
                        firstColumnFound = button.grid.column
                    end
                else
                    firstColumnFound = button.grid.column
                end
            end
        elseif dy < -0.5 then
            if button.grid.column < selectedGrid.column then
                if firstColumnFound then
                    if firstColumnFound < button.grid.column then
                        firstColumnFound = button.grid.column
                    end
                else
                    firstColumnFound = button.grid.column
                end
            end
        end
    end

    if moving == false then
        if firstRowFound then
            selectedGrid.row = firstRowFound
            moving = true
        end
        if firstColumnFound then
            selectedGrid.column = firstColumnFound
            moving = true
        end
    end
    -- print(selectedGrid.row, selectedGrid.column)
    if moving == true then
        if math.abs(dx) < 0.1 and math.abs(dy) < 0.1 then
            moving = false
        end
    end
    for _, button in ipairs(button.activeButtons) do
        if button.grid.row == selectedGrid.row and button.grid.column == selectedGrid.column then
            button.hover = true
        else
            button.hover = false
        end
    end
end


function button:draw()
    love.graphics.stencil(function()
        love.graphics.rectangle(
            "fill", 
            love.graphics.getWidth() / 2 + (-127 * playerCamera.globalScale), 
            love.graphics.getHeight() / 2 + (-61 * playerCamera.globalScale), 
            254 * playerCamera.globalScale,
            130 * playerCamera.globalScale
        )
    end, "replace", 1)
    local y = self.y
    if self.scroll then
        y = self.y + settings.scroll
        love.graphics.setStencilTest("greater", 0)
    end
    if self.info then
        love.graphics.setColor(0.1, 0.1, 0.1)
        love.graphics.print(
            self.info, 
            love.graphics.getWidth() / 2 + (self.x * playerCamera.globalScale), 
            love.graphics.getHeight() / 2 + (y * playerCamera.globalScale) - (self.image:getHeight() * playerCamera.globalScale * 0.5), 
            nil, 
            playerCamera.globalScale * 0.5
        )
        love.graphics.setColor(1, 1, 1)
    end
    if self.image then
        love.graphics.draw(
            self.image, 
            love.graphics.getWidth() / 2 + (self.x * playerCamera.globalScale), 
            love.graphics.getHeight() / 2 + (y * playerCamera.globalScale), 
            nil, 
            playerCamera.globalScale
        )
    end
    love.graphics.setColor(
        self.currentColor[1], 
        self.currentColor[2], 
        self.currentColor[3]
    )
    if self.imageOutline then
        love.graphics.draw(
            self.imageOutline, 
            love.graphics.getWidth() / 2 + (self.x * playerCamera.globalScale), 
            love.graphics.getHeight() / 2 + (y * playerCamera.globalScale), 
            nil, 
            playerCamera.globalScale
        )
    end
    if self.text then
        love.graphics.print(
            self.text, 
            love.graphics.getWidth() / 2 + ((self.x + 40) * playerCamera.globalScale) - (font:getWidth(self.text) * playerCamera.globalScale) / 2, 
            love.graphics.getHeight() / 2 + ((y + 10) * playerCamera.globalScale) - (font:getHeight(self.text) * playerCamera.globalScale) / 2, 
            nil, 
            playerCamera.globalScale
        )
    elseif self.imageOnButton then
        love.graphics.draw(
            self.imageOnButton,
            love.graphics.getWidth() / 2 + (self.x * playerCamera.globalScale) + (self.width * playerCamera.globalScale) / 2 - (self.imageOnButton:getWidth() * playerCamera.globalScale) / 2, 
            love.graphics.getHeight() / 2 + (y * playerCamera.globalScale) + (self.height * playerCamera.globalScale) / 2 - (self.imageOnButton:getHeight() * playerCamera.globalScale) / 2, 
            nil, 
            playerCamera.globalScale
        )
    end
    love.graphics.setStencilTest()
    love.graphics.setColor(1, 1, 1)
end

function button:UpdateAll(dt)
    game.cursor.color = {1, 1, 1, 0.5}
    for _, button in ipairs(button.activeButtons) do
        button:update(dt)
    end
    if game.controlType == 1 and controller.joysticks and controller.joysticks:isConnected() then
        button:handleJoystickInput()
    end
end

function button:drawAll()
    if not (button.warning.id == 0) then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle(
            "fill",
            0,
            0,
            love.graphics.getWidth(),
            love.graphics.getHeight()
        )
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(
            button.notification,
            love.graphics.getWidth() / 2 - (button.notification:getWidth() * playerCamera.globalScale) / 2,
            love.graphics.getHeight() / 2 - (button.notification:getHeight() * playerCamera.globalScale) / 2,
            nil,
            playerCamera.globalScale
        )
        love.graphics.draw(
            button.warning.icon,
            love.graphics.getWidth() / 2 - (button.warning.icon:getWidth() * playerCamera.globalScale) / 2,
            love.graphics.getHeight() / 2 - (button.warning.icon:getHeight() * playerCamera.globalScale) / 2 - (button.notification:getHeight() / 2) * playerCamera.globalScale,
            nil,
            playerCamera.globalScale
        )
        love.graphics.setColor(0.15, 0.15, 0.15)
        love.graphics.print(
            button.warning.text,
            love.graphics.getWidth() / 2 - ((font:getWidth(button.warning.text) * (playerCamera.globalScale / 1.5)) / 2),
            love.graphics.getHeight() / 2 - ((font:getHeight(button.warning.text) * (playerCamera.globalScale / 1.5)) / 2 + (button.notification:getHeight() / 2 / 100 * 50) * playerCamera.globalScale),
            nil,
            playerCamera.globalScale / 1.5
        )
        love.graphics.setColor(1, 1, 1)
    end
    for _, button in ipairs(button.activeButtons) do
        button:draw()
    end
end

return button