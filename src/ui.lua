local Ui = {}

FPS_ENT = 0
FPS_SHOW = false

function Ui:setup()
    FPS_ENT = nebula.ecs.spawn()
    nebula.ecs.addComponent(
        FPS_ENT,
        Position({x = 20, y = 20}),
        Text({font = GameFont20, value = "0"})
    )
end

function Ui:update()
    local textComponent = nebula.ecs.getComponent(FPS_ENT, Text)
    textComponent.value = tostring(nebula.time.getFPS())

    if nebula.keyboard.isKeyReleased('tab') then
        FPS_SHOW = not FPS_SHOW
    end
end

function Ui:draw()
    if FPS_SHOW then
       nebula.graphics.draw(FPS_ENT)
    end
end

return Ui