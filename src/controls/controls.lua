local controls = {}
local json = require("src/library/json")
controls.keys = {
    interact = "e",
    switchWeapon = "r",
    left = "a",
    up = "w",
    right = "d",
    down = "s",
    devMode = "tab",
    focus = "q",
    map = "m",
}
controls.default = {
    interact = "e",
    switchWeapon = "r",
    left = "a",
    up = "w",
    right = "d",
    down = "s",
    devMode = "tab",
    focus = "q",
    map = "m",
}
controls.searchForKey = nil

function controls.load()
    if love.filesystem.getInfo("controls.json") then
        local data = love.filesystem.read("controls.json")
        controls.keys = json.decode(data)
    end
end

function controls.save()
    love.filesystem.write("controls.json", json.encode(controls.keys))
end

return controls