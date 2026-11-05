local Enemy = {}

MAX_ENEMIES = 40

-- entities that are not in game or have been killed
FREE_ENTITIES = {}

REMOVE_LATER = 0

function Enemy:loadEnemies()
    local slime1 = nebula.graphics.newTexture("resources/enemies/slime/slimeEye1.png")
    local slime2 = nebula.graphics.newTexture("resources/enemies/slime/slimeEye2.png")

    REMOVE_LATER = nebula.ecs.spawn()

    nebula.ecs.addComponent(
        REMOVE_LATER,
        Position({x = 336, y = 300}),
        Speed({x = 0, y = 0, value = 0.0, diagonal = 0.0}),
        Animation({
            curr = {action = ANIMATION_ACTION.IDLE, index = 1},
            idle = {slime1, slime2},
            idleInterval = 0.4
        }),
        Sprite({texture = slime1}),
        HitPoints({hpMax = 20, hp = 20}),
        CollisionBox({width = CHARACTER_SIZE, height = CHARACTER_SIZE, x = 0, y = 0}),
        Scale({x = SPRITE_SCALE, y = SPRITE_SCALE})
    )
end

function Enemy:update(dt)
    AnimationHandler:handleCharacterAnimation(REMOVE_LATER, dt, ANIMATION_ACTION.IDLE)
end

function Enemy:draw()
    nebula.graphics.draw(REMOVE_LATER)
end

return Enemy