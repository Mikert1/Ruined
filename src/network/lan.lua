local lan = {}
local socket = require("socket")

local port = 12345

socket = require "socket" .udp()
socket:setsockname("0.0.0.0", port)
socket:setoption("broadcast", true)
-- socket:settimeout(0)
if game.lanEnabled == true then

else
    msg, ip, port = socket:receivefrom()
    print("Received: " .. msg .. " from " .. ip .. ":" .. port)
    -- testing peer later
    -- socket:setpeername(ip, port)

    -- local message = "Hello, other player!"
    -- socket:send(message)
end

function lan.sendData()
    message = "Hello, client!"
    socket:sendto(message, "255.255.255.255", port)
end

function love.draw()
    love.graphics.print("Server", 10, 10)
    love.graphics.print("IP: " .. ip, 10, 30)
    love.graphics.print("Port: " .. port, 10, 50)
    love.graphics.print("Message: " .. msg, 10, 70)
end