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

function minigame.stop()
    minigame.active = false
    game.freeze = false
end

function minigame.addCardToHand(hand)
    table.insert(hand, getRandomCard())
end

function getRandomCard()
    local availableCards = {}
    for category, cards in pairs(minigame.playingCards.deck) do
        for cardKey, card in pairs(cards) do
            table.insert(availableCards, card)
        end
    end

    if #availableCards == 0 then

        return nil
    end

    local card = availableCards[math.random(#availableCards)]

    for cardTypeName, cardType in pairs(minigame.playingCards.deck) do
        for cardKey, cardInDeck in pairs(cardType) do
            if cardInDeck.name == card.name then
                minigame.playingCards.deck[cardTypeName][cardKey] = nil
                return card
            end
        end
    end
end
function minigame.update(dt)
    if minigame.active then
        
    end
end

function minigame.hover(x, y)
    if minigame.active then
        local count = #minigame.hand.player
        for i, card in ipairs(minigame.hand.player) do
            card.hover = false
        end
        for i = count, 1, -1 do
            local card = minigame.hand.player[i]
            local cardX = love.graphics.getWidth() / 2 - 
            (count * 36 * playerCamera.globalScale - (count - 1) * 18 * playerCamera.globalScale) / 2 + 
            (i - 1) * (36 * playerCamera.globalScale - 18 * playerCamera.globalScale)
            local cardY = love.graphics.getHeight() - (56 * playerCamera.globalScale)

            if x > cardX and x < cardX + 36 * playerCamera.globalScale and y > cardY and y < cardY + 56 * playerCamera.globalScale then
                card.hover = true
                break
            end
        end
    end
end

function minigame.draw()
    if minigame.active then
        local count = #minigame.hand.player
        for i, card in ipairs(minigame.hand.player) do
            local x = love.graphics.getWidth() / 2 -
            (count * 36 * playerCamera.globalScale - (count - 1) * 18 * playerCamera.globalScale) / 2 +
            (i - 1) * (36 * playerCamera.globalScale - 18 * playerCamera.globalScale)
            local y
            if card.hover then
                y = love.graphics.getHeight() - (56 * playerCamera.globalScale) - 10 * playerCamera.globalScale
            else
                y = love.graphics.getHeight() - (56 * playerCamera.globalScale)
            end
            love.graphics.draw(card.sprite, x, y, 0, playerCamera.globalScale, playerCamera.globalScale)
        end
    end
end

return minigame