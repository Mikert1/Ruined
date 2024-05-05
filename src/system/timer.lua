local gui = require("src/gui/gui")
local time = {}
time.seconds = 0
time.minutes = 0
time.hours = 0
local timer = time.seconds

function time.update(dt)
    time.seconds = time.seconds + dt
    if timer + 1 <= time.seconds then
        time.everySecond()
    end
end

function time.everySecond()
    if time.seconds >= 59 then
        time.seconds = 0
        time.minutes = time.minutes + 1
    end
    if time.minutes >= 60 then
        time.minutes = 0
        time.hours = time.hours + 1
    end
    if player.item.sword == true then
        if player.focus == true then
            gui.focusTime = gui.focusTime - 1
            if gui.focusTime == 0 then
                player.focus = false
            end
        end
        if gui.focusTime >= 8 then
            gui.focusTime = 8
            gui.focusReady = true
        else
            gui.focusTime = gui.focusTime + 0.25
            if gui.focusTime >= 8 then
                gui.focusTime = 8
                gui.focusReady = true
            end
        end
    end
    timer = time.seconds
end
return time