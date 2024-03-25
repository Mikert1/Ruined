local anim8 = require'assets/library/animations'
local story = {}
story.npc = {}
story.npc.john = {}
story.npc.john.x = 115
story.npc.john.y = 128
story.npc.john.image = love.graphics.newImage("assets/textures/npc/johnNpc.png")
-- story.npc.john.grid = anim8.newGrid( 10, 17, story.npc.john.image:getWidth(), story.npc.john.image:getHeight() )
-- story.npc.john.animations = {}
-- story.npc.john.animations.stand = anim8.newAnimation( story.npc.john.grid('1-1', 1), 0.05 )
-- story.npc.john.animations.walk = anim8.newAnimation( story.npc.john.grid('1-4', 1), 0.2 )
-- story.npc.john.anim = story.npc.john.animations.stand
story.npc.john.position = 1
story.npc.john.collider = {
    x = 170,
    y = 332,
    width = 16,
    height = 16,
    world = "Snow"
}
story.npc.who = "john"
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
story.dialogue.storyAvalible = love.graphics.newImage("assets/textures/gui/dialogue/interact.png")
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
        print("story told")
        story.npc.interaction = false
        player.item.sword = true
        story.lasttext = false
        game.state = 0
        story.load()
        -- data = file.load()
        -- story.data.storyTold.john1 = true
        return
    end
    if story.arrayLength == story.data.current then
        story.lasttext = true
    end
    story.currentStory = story.dialogue[story.id][story.data.current]
    story.dialogue.text = string.sub(story.currentStory, 0, story.dialogue.position)
end
function story.npc:draw()
    if story.npc.john.position == 1 then
        love.graphics.draw(player.shadow , story.npc.john.x + 2, story.npc.john.y - 2)
        love.graphics.draw(story.npc.john.image, story.npc.john.x, story.npc.john.y - story.npc.john.image:getHeight())
    end
    if story.npc.interactionAvalible == true then
        if story.data.storyTold.john1 == false then
            love.graphics.stencil(function()
                love.graphics.rectangle(
                    "fill",
                    (story.npc.john.x + 5 - story.dialogue.storyAvalible:getWidth() / 2),
                    (story.npc.john.y - 20),
                    story.dialogue.storyAvalible:getWidth(),
                    (-story.npc.interactionHold * 2) * story.dialogue.storyAvalible:getHeight())
                end, "replace", 1)
                love.graphics.draw(story.dialogue.storyAvalibleShadow, story.npc.john.x + 5 - story.dialogue.storyAvalible:getWidth() / 2, (story.npc.john.y - 20) - story.dialogue.storyAvalible:getHeight())
                love.graphics.setColor(1,1,1)
                love.graphics.draw(story.dialogue.storyAvalible, story.npc.john.x + 5 - story.dialogue.storyAvalible:getWidth() / 2, (story.npc.john.y - 20) - story.dialogue.storyAvalible:getHeight())
                love.graphics.setStencilTest("greater", 0)
                if story.npc.who == "john" then
                    love.graphics.setColor(0,0.8,0)
                else
                    love.graphics.setColor(0,1,1)
                end
            love.graphics.draw(story.dialogue.storyAvalible, story.npc.john.x + 5 - story.dialogue.storyAvalible:getWidth() / 2, (story.npc.john.y - 20) - story.dialogue.storyAvalible:getHeight())
            love.graphics.setStencilTest()
        end
        love.graphics.setColor(1,1,1)
    end
end
function story.dialogue:draw()
    if story.npc.interaction == true then
        if story.npc.who == "john" then
            love.graphics.setColor(0,0.8,0)
        else
            love.graphics.setColor(0,1,1)
        end
        love.graphics.draw(story.dialogue.image, love.graphics.getWidth() / 2 - (109 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (13 * playerCamera.globalScale), nil, playerCamera.globalScale)
        love.graphics.setColor(1,1,1)
        love.graphics.draw(story.npc.foto.john, love.graphics.getWidth() / 2 - (100 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (30 * playerCamera.globalScale), nil, playerCamera.globalScale)
        love.graphics.print(story.dialogue.text, love.graphics.getWidth() / 2 - (30 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (28 * playerCamera.globalScale), nil, playerCamera.globalScale/1.5)
        --love.graphics.print(story.dialogue.green, love.graphics.getWidth() / 2 - (30 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (28 * playerCamera.globalScale), nil, playerCamera.globalScale/1.5)
        love.graphics.print(story.npc.who, love.graphics.getWidth() / 2 - (95 * playerCamera.globalScale), love.graphics.getHeight() / 2 + (14 * playerCamera.globalScale), nil, playerCamera.globalScale/1.5)
        if story.dialogue.length < story.dialogue.position then
            love.graphics.setColor(0,0.8,0)
            if story.lasttext == false then
                love.graphics.draw(story.dialogue.skipImage, love.graphics.getWidth() / 2 + (90 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (-80 * playerCamera.globalScale), nil, playerCamera.globalScale)
            else
                love.graphics.draw(story.dialogue.doneImage, love.graphics.getWidth() / 2 + (90 * playerCamera.globalScale), love.graphics.getHeight() / 2 - (-80 * playerCamera.globalScale), nil, playerCamera.globalScale)
            end
            love.graphics.setColor(1,1,1)
        end
    end
end
return story