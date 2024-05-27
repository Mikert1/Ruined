local lan = {}
local json = require("src/library/json")
local worldManagement = require("src/gameplay/worldmanager")
local socket = require("socket")
lan.player = {
    x = 0,
    y = 0
}

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
            if msg:sub(1, 1) == "{" then
                lan.player = json.decode(msg)
            end
        end
    end
end

function lan.sendData()
    if game.lanEnabled == true then
        message = {x = player.x, y = player.y, world = worldManagement.thisWorld, isLeft = player.isLeft}
        message = json.encode(message)
        socket:send(message)
        
    end
end

function lan.draw()
    if game.lanEnabled == true then
        love.graphics.print("LAN Enabled", 10, 10)
    end
end

function lan.drawPlayer2()
    if game.lanEnabled == true then
        if lan.player.world == worldManagement.thisWorld then
            love.graphics.draw(player.shadow, lan.player.x, lan.player.y)
            if lan.player.isLeft == false then
                player.anim1:draw(player.sheet, lan.player.x + 6, lan.player.y - 6, nil, 1, 1, 9.5, 10.5)
            else
                player.anim1:draw(player.sheet, lan.player.x + 6, lan.player.y - 6, nil, -1, 1, 9.5, 10.5)
            end
        end
    end
end

return lan