local socket = require("socket")
local ip = "192.168.0.100"  -- IP-adres van de host
local port = 12345  -- Kies een poortnummer

local udp = socket.udp()
udp:settimeout(0)
udp:setpeername(ip, port)

local server = {}

-- function to send data to the other player
function server.sendData(data)
    print("[Server] Sending data to other player: " .. data)
    udp:send("Hello from Game 1!")
end

-- function to receive data from the other player
function server.receiveData()
    local data, msg = udp:receive()
    if data then
        print("Received: " .. data)
    elseif msg ~= 'timeout' then
        error("Network error: " .. tostring(msg))
    end
end

return server