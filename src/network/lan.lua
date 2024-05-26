local lan = {}
local json = require("src/library/json")
local socket = require("socket")

local port = 12345
socket = require "socket" .udp()
socket:setsockname("0.0.0.0", port)
socket:setoption("broadcast", true)
function lan.connect()
    if game.lanEnabled == true then

    else
        local msg, ip, port = socket:receivefrom()
        if msg then
            print("Received: " .. msg .. " from " .. ip .. ":" .. port)
            socket:setpeername(ip, port)
            game.lanEnabled = true
        end
        socket:settimeout(0)
    end
end

function lan.host()
    if game.lanEnabled == true then
        message = "host"
        socket:sendto(message, "255.255.255.255", port)
    end
end

function lan.receiveData()
    if game.lanEnabled == true then
        local msg, error = socket:receive()
        if msg then
            print("Received: " .. msg)
        end
    end
end

function lan.sendData()
    if game.lanEnabled == true then
        message = {x = player.x, y = player.y}
        message = json.encode(message)
        socket:send(message)
    end
end

return lan