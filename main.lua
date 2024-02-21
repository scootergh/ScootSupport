require 'map-func'
require 'camera'
require 'calc'
require 'prefs'
require 'player'
require 'physics'
require 'noise'
local utf8 = require 'utf8'

function love.load(  )
    love.graphics.setBackgroundColor(104, 136, 248)

    local maps = {}
    maps[0] = loadMap('maps/chez-peter.lua')
    maps[1] = loadMap('maps/core-dump.lua')
    -- camera:newLayer(.5, function() drawMap(maps[0]) end)
    -- camera:newLayer(1, function() drawMap(maps[1], 0, 6 * 32) end)
    player:load()
    camera:newLayer(1, function()
        player:draw()
    end)

    physics:load()
    perlin:load()
    testNoise = perlin:perlin(50, 158)

    -- here's another but different test comment
    -- wow another new comment!
    thisoneisnew = 564
    heresanother = "Testing merge setup for BC"

    -- ps = love.graphics.newParticleSystem(love.graphics.newImage("gfx/icon.png"), psBufferSize)
    -- ps:setParticleLifetime(psLifetimeMin, psLifetimeMax)
    -- ps:setEmissionRate(psEmissionRate)
    -- ps:setSpread(psSpread)
    -- ps:setSpeed(psSpeed)
    -- ps:setDirection(calc:degToRad(psDirection))
    -- ps:setLinearAcceleration(psAccelerationX, psAccelerationY)
    -- ps:stop()
end

function love.update( dt )
    dtotal = dtotal + dt        -- update time passed
    physics:update(dt)
    player.moving = pressedKeys['up'] or pressedKeys['down'] or pressedKeys['right'] or pressedKeys['left']
    if player.moving then
        player.dir.x = ''
        player.dir.y = ''

        if pressedKeys['up'] then
            player.dir.y = 'up'
        elseif pressedKeys['down'] then
            player.dir.y = 'down'
        end

        if pressedKeys['right'] then
            player.dir.x = 'right'
        elseif pressedKeys['left'] then
            player.dir.x = 'left'
        end

        player:move()

        player.movTimer = player.movTimer + dt
        if player.movTimer > 0.2 then
            player.movTimer = 0
            player.iter = player.iter + 1
            if player.iter > table.getn(player.states[player.dir.x .. player.dir.y]) then
                player.iter = 1
            end
        end
    else
        player.dir.x = 'idle'
        player.dir.y = ''
        player.iter = 1
    end
end

function love.draw(  )
    love.graphics.setBackgroundColor(104, 136, 248)
    love.window.setMode(wWidth, wHeight)
    physics:draw()
    camera:draw()
    -- love.graphics.draw(ps, 100, 100)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 2, 2)
    love.graphics.print("Noise: " .. testNoise, 2, 14)
    -- love.graphics.print(text, love.window.getWidth() - 100, 2)
end

function love.keypressed( key, isrepeat )
    pressedKeys[key] = true
    if key == 'return' then
        text = text .. "\n"
    elseif key == 'backspace' then
        local byteoffset = utf8.offset(text, -1)
        if byteoffset then
            text = string.sub(text, 1, byteoffset - 1)
        end
    elseif key == 'f1' then
        -- ps:emit(5)
        ps:setDirection(calc:degToRad(90))
        ps:start()
    elseif key == 'f2' then
        ps:stop()
    elseif key == '1' then
        psEmissionRate = psEmissionRate + 5
        ps:setEmissionRate(psEmissionRate)
    elseif key == '2' then
        if psEmissionRate > 0 then
            psEmissionRate = psEmissionRate - 5
        end
        ps:setEmissionRate(psEmissionRate)
    elseif key == '3' then
        psSpeed = psSpeed + 5
        ps:setSpeed(psSpeed)
    elseif key == '4' then
        if psSpeed > 5 then
            psSpeed = psSpeed - 5
        end
        ps:setSpeed(psSpeed)
    elseif key == '5' then
        psAccelerationY = psAccelerationY - 5
        ps:setLinearAcceleration(psAccelerationX, psAccelerationY)
    elseif key == '6' then
        if psAccelerationY < -5 then
            psAccelerationY = psAccelerationY + 5
        end
        ps:setLinearAcceleration(psAccelerationX, psAccelerationY)
    elseif key == 'kp+' then
        psBufferSize = psBufferSize + 5
        ps:setBufferSize(psBufferSize)
    elseif key == 'kp-' then
        if psBufferSize > 0 then
            psBufferSize = psBufferSize - 5
        end
        ps:setBufferSize(psBufferSize)
    end
end

function love.keyreleased( key )
    pressedKeys[key] = false
end

function love.textinput( t )
    -- text = text .. t
end