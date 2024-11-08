local minigame = {}
minigame.active = false
minigame.playingCards = {
    deck = {
        cryonium = {},
        calorite = {},
        stone = {}
    },
    other = {
        joker = {
            name = "Joker",
            value = "joker",
            sprite = love.graphics.newImage("assets/textures/gui/minigame/cards/other/j.png")
        },
        back = {
            name = "???",
            value = "back",
            sprite = love.graphics.newImage("assets/textures/gui/minigame/cards/other/back.png")
        }
    }
}

for cardTypeName, cardType in pairs(minigame.playingCards.deck) do
    cardType = {
        ca = {
            name = "Ace",
            value = "a"
        },
        c2 = {
            name = "Two",
            value = 2
        },
        c3 = {
            name = "Three",
            value = 3
        },
        c4 = {
            name = "Four",
            value = 4
        },
        c5 = {
            name = "Five",
            value = 5
        },
        c6 = {
            name = "Six",
            value = 6
        },
        c7 = {
            name = "Seven",
            value = 7
        },
        c8 = {
            name = "Eight",
            value = 8
        },
        c9 = {
            name = "Nine",
            value = 9
        },
        c10 = {
            name = "Ten",
            value = 10
        },
        cj = {
            name = "Jack",
            value = "j"
        },
        cq = {
            name = "Queen",
            value = "q"
        },
        ck = {
            name = "King",
            value = "k"
        }
    }
    for cardKey, card in pairs(cardType) do
        card.sprite = love.graphics.newImage("assets/textures/gui/minigame/cards/"..cardTypeName.."/"..card.value..".png")
    end
end


function minigame.update(dt)
    if minigame.active then
        
    end
end

function minigame.draw()
    if minigame.active then
        love.graphics.draw(minigame.playingCards.deck.cryonium.ca.sprite, 0, 0, 0, playerCamera.globalScale, playerCamera.globalScale)  
    end
end 

return minigame