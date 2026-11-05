-- this file is for testing only

local Sandbox = {}

local e = 0

function Sandbox:setup()
    -- LIGHT ON MOUSE
    --e = nebula.ecs.spawn()
    --nebula.ecs.addComponent(
    --    e,
    --    Position({x = 10, y = 10}),
    --    --Quad({width = 300, height = 300}),
    --    Color({}),
    --    Light({x = -75, y = -75, radius = 150, intensity = 1.0})
    --)
end

function Sandbox:update(dt)
    -- LIGHT ON MOUSE
    --eePos = nebula.ecs.getComponent(e, Position)
    --eePos.x = nebula.mouse.getX()
    --eePos.y = nebula.mouse.getY()
end

function Sandbox:draw()
    -- LIGHT ON MOUSE
    --nebula.graphics.draw(e)
end

return Sandbox