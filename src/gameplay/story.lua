local file
local worldManagement
local story = {}
story.npc = {}
story.npcs = {
    john = {
        image = love.graphics.newImage("assets/textures/npc/johnNpcWounded.png"),
        collider = {
            x = 170,
            y = 332,
            width = 16,
            height = 16,
            world = "Snow"
        },
        color = {0, 0.8, 0},
        nextDialogue = {
            name = 1,
            type = "chat",
            marked = "important"
        }
    },
    gambler = {
        x = 115,
        y = 128,
        image = love.graphics.newImage("assets/textures/npc/gambler.png"),
        collider = {
            x = 170,
            y = 332,
            width = 28,
            height = 24,
            world = "Mountains"
        },
        nextDialogue = {
            value = 1,
            type = "chat",
            marked = "question"
        }
    }
}
story.npc.who = "john"
story.npc.whoID = "john"
story.npc.foto = {}
story.npc.foto.john_normal = love.graphics.newImage("assets/textures/npc/john.png")
story.npc.foto.john_wounded = love.graphics.newImage("assets/textures/npc/johnWounded.png")
story.npc.foto.john = story.npc.foto.john_normal

story.npc.interaction = false
story.npc.interactionAvalible = false
story.npc.interactionHold = 0

story.dialogue = {}
story.dialogue.image = love.graphics.newImage("assets/textures/gui/dialogue/dialogue.png")
story.dialogue.skipImage = love.graphics.newImage("assets/textures/gui/dialogue/skip.png")
story.dialogue.doneImage = love.graphics.newImage("assets/textures/gui/dialogue/done.png")
story.dialogue.storyAvalible = {
    important = love.graphics.newImage("assets/textures/gui/dialogue/important.png"),
    question = love.graphics.newImage("assets/textures/gui/dialogue/question.png"),
    game = love.graphics.newImage("assets/textures/gui/dialogue/game.png"),
}
story.dialogue.storyAvalibleShadow = love.graphics.newImage("assets/textures/gui/dialogue/interactshadow.png")
story.dialogue.position = 0
story.dialogue.john1 = {
    "Hello traveler, my name is John.",
    "I got attacked. For now I can no \nlonger fight. I need your help.",
    "Take my sword and defeat the\nenemies in the mountains. \nAnd bring me the Cryonium. I \nwill reward you with my sword.",
    "I will teach you how to use\nCryonium. and show you \nhow it can help you on your \njourney.",
    "Good luck traveler. I will wait\nfor you here.",
}
story.dialogue.john2 = {
    "Hey traveler, You got the\nCryonium?",
    "Thanks for your help. i need \nthis for later on. you can keep\nmy sword. It's yours now.",
    "Wanna try out the real power of\nCryonium?",
    "Oke get your sword and Press Q",
}
story.id = "john1"
story.currentStory = story.dialogue[story.id][1]
story.arrayLength = #story.dialogue[story.id]
story.dialogue.length = string.len(story.currentStory)

story.data = {}
story.data.current = 1
story.data.storyTold = {}
story.data.storyTold.john1 = false
story.data.storyTold.john2 = false
story.dialogue.text = string.sub(story.currentStory, 0, story.dialogue.position)
story.dialogue.active = false
story.lasttext = false
story.skiped = false

function story.loadAssets()
    file = require("src/system/data")
    worldManagement = require("src/gameplay/worldmanager")
end

function story.load()
    story.data.current = 1
    story.currentStory = story.dialogue[story.id][story.data.current]
    story.arrayLength = #story.dialogue[story.id]
    story.dialogue.length = string.len(story.currentStory)
end

function story.slowShow(dt)
    if not(string.sub(story.currentStory, story.dialogue.position, story.dialogue.position) == ("." or "," or "!" or "?" or " ")) then
        story.dialogue.position = story.dialogue.position + (dt * 30)
    else
        story.dialogue.position = story.dialogue.position + (dt * 2)
    end
    story.dialogue.text = string.sub(story.currentStory, 0, story.dialogue.position)
    story.dialogue.length = string.len(story.currentStory)
end

function story.dialogue.update()
    if story.arrayLength < story.data.current then
        -- this is the end of the story
        story.npc.interaction = false
        player.item.sword = true
        story.lasttext = false
        game.state = 0
        story.load()
        worldManagement.saved = false
        game.freeze = false
        return
    end
    if story.arrayLength == story.data.current then
        story.lasttext = true
    end
    story.currentStory = story.dialogue[story.id][story.data.current]
    story.dialogue.text = string.sub(story.currentStory, 0, story.dialogue.position)
end

function story.npc:draw()
    for name, npc in pairs(story.npcs) do
        if npc.collider.world == worldManagement.thisWorld then
            if npc.collider.y < player.y then
                love.graphics.draw(player.shadow, npc.collider.x + 2, npc.collider.y - 2)
                love.graphics.draw(npc.image, npc.collider.x, npc.collider.y - npc.image:getHeight())
            end
        end
    end
end

function story.dialogue:draw()
    if story.npc.interaction == true then
        love.graphics.setColor(story.npcs[story.npc.whoID].color or {0, 1, 1})
        love.graphics.draw(story.dialogue.image, love.graphics.getWidth() / 2 - (109 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (13 * playerCamera.globalScale), nil, playerCamera.globalScale)
        if story.dialogue.length < story.dialogue.position then
            if story.lasttext == false then
                love.graphics.draw(story.dialogue.skipImage, love.graphics.getWidth() / 2 + (90 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (-80 * playerCamera.globalScale), nil, playerCamera.globalScale)
            else
                love.graphics.draw(story.dialogue.doneImage, love.graphics.getWidth() / 2 + (90 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (-80 * playerCamera.globalScale), nil, playerCamera.globalScale)
            end
        end
        love.graphics.setColor(1,1,1)
        love.graphics.draw(story.npc.foto.john, love.graphics.getWidth() / 2 - (100 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (30 * playerCamera.globalScale), nil, playerCamera.globalScale)
        love.graphics.print(story.dialogue.text, love.graphics.getWidth() / 2 - (30 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (28 * playerCamera.globalScale), nil, playerCamera.globalScale/1.5)
        love.graphics.print(story.npc.who, love.graphics.getWidth() / 2 - (95 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (14 * playerCamera.globalScale), nil, playerCamera.globalScale/1.5)
    end
end
function story.npc:draw2L()
    for name, npc in pairs(story.npcs) do
        if npc.collider.world == worldManagement.thisWorld then
            if npc.collider.y >= player.y then
                love.graphics.draw(player.shadow, npc.collider.x + 2, npc.collider.y - 2)
                love.graphics.draw(npc.image, npc.collider.x, npc.collider.y - npc.image:getHeight())
            end
        end
        if story.npc.interactionAvalible then
            if npc.collider.world == worldManagement.thisWorld then
                if npc.collider.y < player.y then
                    local sprite = story.dialogue.storyAvalible[npc.nextDialogue.marked]
                    local x = npc.collider.x - sprite:getWidth() / 2 + npc.collider.width / 2
                    local y = npc.collider.y - npc.image:getHeight() - 1
                    local storyWidth = sprite:getWidth()
                    local storyHeight = sprite:getHeight()
                    local interactionHeight = (-story.npc.interactionHold * 4) * storyHeight
    
                    love.graphics.stencil(function()
                        love.graphics.rectangle("fill", x, y, storyWidth, interactionHeight)
                    end, "replace", 1)
    
                    love.graphics.draw(story.dialogue.storyAvalibleShadow, x, y - storyHeight)
                    love.graphics.setColor(0.3, 0.3, 0.3)
                    love.graphics.draw(sprite, x, y - storyHeight)
                    love.graphics.setStencilTest("greater", 0)
                    love.graphics.setColor(npc.color or {0, 1, 1})
                    love.graphics.draw(sprite, x, y - storyHeight)
                    love.graphics.setStencilTest()
                end
            end
            love.graphics.setColor(1, 1, 1)
        end
    end
end
return story