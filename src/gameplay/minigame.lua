local minigame = {}
minigame.active = false

math.randomseed(os.time())

function minigame.start()
    minigame.active = true
    game.freeze = true
    minigame.playingCards = {
        deck = {
            cryonium = {},
            calorite = {},
            stone = {},
            name = {}
        },
        other = {
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
    minigame.playingCards.deck.joker = {}
    joker = minigame.playingCards.deck.joker
    joker.j1 = {
        name = "Joker",
        value = "j",
        sprite = love.graphics.newImage("assets/textures/gui/minigame/cards/other/joker.png")
    }
    joker.j2 = {
        name = "Joker",
        value = "j",
        sprite = love.graphics.newImage("assets/textures/gui/minigame/cards/other/joker.png")
    }

    minigame.avalibleCards = {
        cryonium = {"ca", "c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "c10", "cj", "cq", "ck"},
        calorite = {"ca", "c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "c10", "cj", "cq", "ck"},
        stone = {"ca", "c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "c10", "cj", "cq", "ck"},
        name = {"ca", "c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "c10", "cj", "cq", "ck"},
        joker = {"j1", "j2"}
    }
    minigame.hand = {
        player = {
            getRandomCard(),
            getRandomCard(),
            getRandomCard()
        },
        enemy = {}
    }
end

function getRandomCard()
    local categories = {}
    local categoryWeights = {}

    for category, cards in pairs(minigame.avalibleCards) do
        local weight = #cards
        for i = 1, weight do
            table.insert(categories, category)
        end
        categoryWeights[category] = weight
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
        for i, card in ipairs(minigame.hand.player) do
            love.graphics.draw(minigame.playingCards.deck[card.category][card.card].sprite, love.graphics.getWidth() / 2 - (18 * playerCamera.globalScale) + (i - 2) * (18 * playerCamera.globalScale), love.graphics.getHeight() - (56 * playerCamera.globalScale), 0, playerCamera.globalScale, playerCamera.globalScale)
        end
    end
end 

return minigame