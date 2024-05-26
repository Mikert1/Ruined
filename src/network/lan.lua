local lan = {}
local json = require("src/library/json")
local socket = require("socket")

local hostPort = 54321
socket = require "socket" .udp()
socket:setsockname("0.0.0.0", hostPort)
socket:setoption("broadcast", true)
function lan.connect()
    if game.lanEnabled == true then

    else
        local msg, ip, port = socket:receivefrom()
        if msg then
            print("Received: " .. msg .. " from " .. ip .. ":" .. port)
            socket:setpeername(ip, port)
            game.lanEnabled = true
            message = "connect"
            socket:send(message)
            socket:settimeout(0)
        end
    end
end

function lan.host()
    message = "host"
    socket:sendto(message, "255.255.255.255", hostPort)
    while true do
        local msg, ip, port = socket:receivefrom()
        if msg == "connect" then
            print("Received: " .. msg .. " from " .. ip .. ":" .. port)
            socket:setpeername(ip, port)
            game.lanEnabled = true
            socket:settimeout(0)
            break
        end
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

function lan.draw()
    if game.lanEnabled == true then
        love.graphics.print("LAN Enabled", 10, 10)
    end
end

return lan