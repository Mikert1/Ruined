local lan = {}
local json = require("src/library/json")
local socket = require("socket")

local port = 12345

socket = require "socket" .udp()
socket:setsockname("0.0.0.0", port)
socket:setoption("broadcast", true)
socket:settimeout(1)
if game.lanEnabled == true then

else
    msg, ip, port = socket:receivefrom()
    if msg then
        print("Received: " .. msg .. " from " .. ip .. ":" .. port)
        socket:setpeername(ip, port)

        local message = "Hello, other player!"
        socket:send(message)
    end
end

function lan.sendData()
    message = {x = player.x, y = player.y}
    message = json.encode(message)
    socket:send(message)
end

return lan