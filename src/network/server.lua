-- require the socket library
local socket = require("socket")

-- create a UDP socket
local udp = socket.udp()

-- set local IP address and port
local localIP = "127.0.0.1" -- het lokale IP-adres van de speler
local localPort = 12345 -- het lokale poortnummer van de speler

-- bind the socket to the local address and port
udp:setsockname(localIP, localPort)

-- set the IP address and port of the other player
local otherPlayerIP = "192.168.1.100" -- het IP-adres van de andere speler
local otherPlayerPort = 54321 -- het poortnummer van de andere speler

-- Definieer de server module
local server = {}

-- function to send data to the other player
function server.sendData(data)
    udp:sendto(data, otherPlayerIP, otherPlayerPort)
end

-- function to receive data from the other player
function server.receiveData()
    udp:settimeout(0) -- Stel de timeout in op 0 om niet-blokkerend te zijn
    local data, msg = udp:receivefrom()
    if data then
        print("Received data from other player: " .. data)
    elseif msg ~= "timeout" then
        print("Error receiving data: " .. msg)
    else
        print("No data received")
    end
end

return server