local controls = {}
local json = require("assets/library/json")
controls.keys = {
    map = "m",
    focus = "q",
    interact = "e",
    switchWeapon = "r",
}

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