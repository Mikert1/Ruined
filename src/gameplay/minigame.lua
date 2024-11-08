local minigame = {}
minigame.active = false
minigame.playingCards = {
    deck = {
        {
            name = "Ace of Cryonium",
            type = "Cryonium",
            value = "a"
        },
        {
            name = "Two of Cryonium",
            type = "Cryonium",
            value = 2
        },
        {
            name = "Three of Cryonium",
            type = "Cryonium",
            value = 3
        },
        {
            name = "Four of Cryonium",
            type = "Cryonium",
            value = 4
        },
        {
            name = "Five of Cryonium",
            type = "Cryonium",
            value = 5
        },
        {
            name = "Six of Cryonium",
            type = "Cryonium",
            value = 6
        },
        {
            name = "Seven of Cryonium",
            type = "Cryonium",
            value = 7
        },
        {
            name = "Eight of Cryonium",
            type = "Cryonium",
            value = 8
        },
        {
            name = "Nine of Cryonium",
            type = "Cryonium",
            value = 9
        },
        {
            name = "Ten of Cryonium",
            type = "Cryonium",
            value = 10
        },
        {
            name = "Jack of Cryonium",
            type = "Cryonium",
            value = "j"
        },
        {
            name = "Queen of Cryonium",
            type = "Cryonium",
            value = "q"
        },
        {
            name = "King of Cryonium",
            type = "Cryonium",
            value = "k"
        }
    }
}

for i, card in ipairs(minigame.playingCards.deck) do
    card.sprite = love.graphics.newImage("assets/textures/gui/minigame/cards/" .. card.type .. "/" .. card.value .. ".png")
end

function minigame.update(dt)
    if minigame.active then
        
    end
end

return minigame