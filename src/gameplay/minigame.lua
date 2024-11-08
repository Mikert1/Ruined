local minigame = {}
minigame.active = false

math.randomseed(os.time())

function minigame.start()
    minigame.active = true
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
        cardType.ca = {
            name = "Ace of "..cardTypeName,
            value = "a"
        }
        cardType.c2 = {
            name = "Two of "..cardTypeName,
            value = 2
        }
        cardType.c3 = {
            name = "Three of "..cardTypeName,
            value = 3
        }
        cardType.c4 = {
            name = "Four of "..cardTypeName,
            value = 4
        }
        cardType.c5 = {
            name = "Five of "..cardTypeName,
            value = 5
        }
        cardType.c6 = {
            name = "Six of "..cardTypeName,
            value = 6
        }
        cardType.c7 = {
            name = "Seven of "..cardTypeName,
            value = 7
        }
        cardType.c8 = {
            name = "Eight of "..cardTypeName,
            value = 8
        }
        cardType.c9 = {
            name = "Nine of "..cardTypeName,
            value = 9
        }
        cardType.c10 = {
            name = "Ten of "..cardTypeName,
            value = 10
        }
        cardType.cj = {
            name = "Jack of "..cardTypeName,
            value = "j"
        }
        cardType.cq = {
            name = "Queen of "..cardTypeName,
            value = "q"
        }
        cardType.ck = {
            name = "King of "..cardTypeName,
            value = "k"
        }
        for cardKey, card in pairs(cardType) do
            card.sprite = love.graphics.newImage("assets/textures/gui/minigame/cards/"..cardTypeName.."/"..card.value..".png")
        end
    end
    minigame.avalibleCards = {
        cryonium = {"ca", "c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "c10", "cj", "cq", "ck"},
        calorite = {"ca", "c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "c10", "cj", "cq", "ck"},
        stone = {"ca", "c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "c10", "cj", "cq", "ck"}
        -- other = {"joker", "joker"}
    }
    minigame.random = getRandomCard()
end

function getRandomCard()
    local categories = {}
    for category in pairs(minigame.avalibleCards) do
        table.insert(categories, category)
    end

    local randomCategory = categories[math.random(#categories)]
    
    local cards = minigame.avalibleCards[randomCategory]
    local randomCard = cards[math.random(#cards)]

    return {card = randomCard, category = randomCategory}
end
function minigame.update(dt)
    if minigame.active then
        
    end
end

function minigame.draw()
    if minigame.active then
        local card = minigame.random.card
        local catecory = minigame.random.category
        love.graphics.draw(minigame.playingCards.deck[catecory][card].sprite, 0, 0, 0, playerCamera.globalScale, playerCamera.globalScale)  
    end
end 

return minigame