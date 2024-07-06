local particle = {
    image = love.graphics.newImage("assets/textures/world/particle.png"),
    system = nil,
    center = {x = 0, y = 0}
}

function particle.load()
    particle.system = love.graphics.newParticleSystem(particle.image, 1000)
    particle.system:setParticleLifetime(0.5, 1.5) -- Particles live between 0.5 and 1.5 seconds
    particle.system:setSizeVariation(1) -- Particles can be different sizes
    particle.system:setLinearAcceleration(-50, -50, 50, 50) -- Particles can move in any direction with varying speeds
    particle.system:setColors(139, 69, 19, 255, 139, 69, 19, 0) -- Brown color fading to transparent
end

particle.load()

function particle.update(dt)
    particle.system:update(dt)
end

function particle.draw()
    love.graphics.draw(particle.system, particle.center.x, particle.center.y)
end

return particle