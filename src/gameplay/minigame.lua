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
    local availableCards = {}

    for _, cards in pairs(minigame.playingCards.deck) do
        for cardKey, card in pairs(cards) do
            table.insert(availableCards, card)
        end
    end

    if #availableCards == 0 then

        return nil
    end

    local card = availableCards[math.random(#availableCards)]
    return card
end
function minigame.update(dt)
    if minigame.active then
        
    end
end

function minigame.draw()
    if minigame.active then
        for i, card in ipairs(minigame.hand.player) do
            love.graphics.draw(card.sprite, love.graphics.getWidth() / 2 - (18 * playerCamera.globalScale) + (i - 2) * (18 * playerCamera.globalScale), love.graphics.getHeight() - (56 * playerCamera.globalScale), 0, playerCamera.globalScale, playerCamera.globalScale)
        end
    end
end

return minigame