local particle = {
    image = love.graphics.newImage("assets/textures/world/particle.png"),
    system = nil,
    center = {x = 0, y = 0}
}

function particle.load()
    particle.system = love.graphics.newParticleSystem(particle.image, 1000)
    particle.system:setParticleLifetime(0.3, 0.8)
    particle.system:setSizeVariation(1)
    particle.system:setEmissionArea("uniform", 3, 3, 0, true)
    particle.system:setLinearDamping(1, 2)
    particle.system:setLinearAcceleration(-10, -10, 10, 10)
    particle.system:setColors(0.267, 0.267, 0.267, 255, 0.267, 0.267, 0.267, 0)
end

particle.load()

function particle.update(dt)
    particle.system:update(dt)
end

function particle.draw()
    love.graphics.draw(particle.system, particle.center.x, particle.center.y)
end

return particle