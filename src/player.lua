local Player = {}

CHARACTER_ENT = 0
FAIRY_ENT = 0

-- character sprite
CHARACTER_SIZE = 16
CHARACTER_OFFSET = 32

-- character animation
CHARACTER_MOVE_ATTACK_INTERVAL = 0.1
CHARACTER_MOVE_ANIMATION_INTERVAL = 0.2
CHARACTER_IDLE_ANIMATION_INTERVAL = 0.6
ATTACKING = false

-- hitbox
HITBOX_ENTITY = 0
HITBOX_PROFILES = {
    HITBOX_INACTIVE = {
        width = 0,
        height = 0
    },
    ATTACK_DOWN = {
        offSetX = 1 * SPRITE_SCALE,
        offsetY = 38 * SPRITE_SCALE,
        width = 78 * SPRITE_SCALE,
        height = 34 * SPRITE_SCALE
    }
}

function Player:loadCharacter()
    local texCUp01 = nebula.graphics.newTexture("resources/character/charUp01.png")
    local texCUp02 = nebula.graphics.newTexture("resources/character/charUp02.png")
    local texCIdle01 = nebula.graphics.newTexture("resources/character/charIdle01.png")
    local texCIdle02 = nebula.graphics.newTexture("resources/character/charIdle02.png")
    local texCDown01 = nebula.graphics.newTexture("resources/character/charDown01.png")
    local texCDown02 = nebula.graphics.newTexture("resources/character/charDown02.png")
    local texCLeft01 = nebula.graphics.newTexture("resources/character/charLeft01.png")
    local texCLeft02 = nebula.graphics.newTexture("resources/character/charLeft02.png")
    local texCRight01 = nebula.graphics.newTexture("resources/character/charRight01.png")
    local texCRight02 = nebula.graphics.newTexture("resources/character/charRight02.png")
    local texAUp01 = nebula.graphics.newTexture("resources/character/attackUp01.png")
    local texAUp02 = nebula.graphics.newTexture("resources/character/attackUp02.png")
    local texAUp03 = nebula.graphics.newTexture("resources/character/attackUp03.png")
    local texADown01 = nebula.graphics.newTexture("resources/character/attackDown01.png")
    local texADown02 = nebula.graphics.newTexture("resources/character/attackDown02.png")
    local texADown03 = nebula.graphics.newTexture("resources/character/attackDown03.png")
    local texALeft01 = nebula.graphics.newTexture("resources/character/attackLeft01.png")
    local texALeft02 = nebula.graphics.newTexture("resources/character/attackLeft02.png")
    local texALeft03 = nebula.graphics.newTexture("resources/character/attackLeft03.png")
    local texARight01 = nebula.graphics.newTexture("resources/character/attackRight01.png")
    local texARight02 = nebula.graphics.newTexture("resources/character/attackRight02.png")
    local texARight03 = nebula.graphics.newTexture("resources/character/attackRight03.png")

    CHARACTER_ENT = nebula.ecs.spawn()
    nebula.ecs.addComponent(
        CHARACTER_ENT,
        Position({x = 336, y = 50}),
        Speed({x = 0, y = 0, value = 250.0, diagonal = 177.0}),
        Animation({
            curr = {action = ANIMATION_ACTION.IDLE, index = 1},
            idle = {texCIdle01, texCIdle02},
            down = {texCDown01, texCDown02},
            up = {texCUp01, texCUp02},
            right = {texCRight01, texCRight02},
            left = {texCLeft01, texCLeft02},
            attack = {
                up = {texAUp01, texAUp02, texAUp03},
                down = {texADown01, texADown02, texADown03},
                left = {texALeft01, texALeft02, texALeft03},
                right = {texARight01, texARight02, texARight03},
            },
            idleInterval = 0.6,
            moveInterval = 0.2,
            attackInterval = 0.1,
        }),
        Sprite({texture = texCIdle01}),
        CollisionBox({width = CHARACTER_SIZE, height = CHARACTER_SIZE, x = CHARACTER_OFFSET, y = CHARACTER_OFFSET}),
        Scale({x = SPRITE_SCALE, y = SPRITE_SCALE})
    )

    FAIRY_ENT = nebula.ecs.spawn()
    nebula.ecs.addComponent(
        FAIRY_ENT,
        Position({x = 326, y = 50}),
        Light({radius = 300, intensity = 0.75, height = 1.5}),
        Color({r = 0.3, b = 0.8}),
        Speed({x = 0, y = 0}),
        Quad({width = 10, height = 10})
    )

    HITBOX_ENTITY = nebula.ecs.spawn()
    nebula.ecs.addComponent(
        HITBOX_ENTITY,
        Quad({}),
        Position({}),
        --HitBox({}),
        CollisionBox({}),
        Color({r = 1, g = 0, b = 0, a = 0})
    )
end

function Player:updateCharacter(dt)
    local charSpeed = nebula.ecs.getComponent(CHARACTER_ENT, Speed)
    charSpeed.x = 0
    charSpeed.y = 0

    -- SPEED
    if nebula.keyboard.isKeyPressed('w') then
        charSpeed.y = charSpeed.y - charSpeed.value
    end

    if nebula.keyboard.isKeyPressed('s') then
        charSpeed.y = charSpeed.y + charSpeed.value
    end

    if nebula.keyboard.isKeyPressed('a') then
        charSpeed.x = charSpeed.x - charSpeed.value
    end

    if nebula.keyboard.isKeyPressed('d') then
        charSpeed.x = charSpeed.x + charSpeed.value
    end

    if charSpeed.x ~= 0 and charSpeed.y ~= 0 then
        charSpeed.x = charSpeed.diagonal * (charSpeed.x/charSpeed.value)
        charSpeed.y = charSpeed.diagonal * (charSpeed.y/charSpeed.value)
    end

    -- FAIRY
    local fairySpeed = nebula.ecs.getComponent(FAIRY_ENT, Speed)
    fairySpeed.x = charSpeed.x
    fairySpeed.y = charSpeed.y

    -- ANIMATION
    if ATTACKING then
        ATTACKING = not AnimationHandler:handleCharacterAnimation(CHARACTER_ENT, dt, ANIMATION_ACTION.ATTACK)
    end

    -- If we are still attacking, there is no need to invoke other animations
    if ATTACKING then return end

    local lmbPressed = nebula.mouse.isClicked("lmb")

    if charSpeed.x > 0 then
        if lmbPressed then
            AnimationHandler:handleCharacterAnimation(CHARACTER_ENT, dt, ANIMATION_ACTION.ATTACK_RIGHT)
            ATTACKING = true
        else
            AnimationHandler:handleCharacterAnimation(CHARACTER_ENT, dt, ANIMATION_ACTION.RIGHT)
        end
        return
    end

    if charSpeed.x < 0 then
        if lmbPressed then
            AnimationHandler:handleCharacterAnimation(CHARACTER_ENT, dt, ANIMATION_ACTION.ATTACK_LEFT)
            ATTACKING = true
        else
            AnimationHandler:handleCharacterAnimation(CHARACTER_ENT, dt, ANIMATION_ACTION.LEFT)
        end
        return
    end

    if charSpeed.y > 0 then
        if lmbPressed then
            AnimationHandler:handleCharacterAnimation(CHARACTER_ENT, dt, ANIMATION_ACTION.ATTACK_DOWN)
            Player:handleAttackHitBox(HITBOX_PROFILES.ATTACK_DOWN)
            ATTACKING = true
        else
            AnimationHandler:handleCharacterAnimation(CHARACTER_ENT, dt, ANIMATION_ACTION.DOWN)
        end
        return
    end

    if charSpeed.y < 0 then
        if lmbPressed then
            AnimationHandler:handleCharacterAnimation(CHARACTER_ENT, dt, ANIMATION_ACTION.ATTACK_UP)
            ATTACKING = true
        else
            AnimationHandler:handleCharacterAnimation(CHARACTER_ENT, dt, ANIMATION_ACTION.UP)
        end
        return
    end

    if lmbPressed then
            AnimationHandler:handleCharacterAnimation(CHARACTER_ENT, dt, ANIMATION_ACTION.ATTACK_DOWN)
            Player:handleAttackHitBox(HITBOX_PROFILES.ATTACK_DOWN)
            ATTACKING = true
    else
        AnimationHandler:handleCharacterAnimation(CHARACTER_ENT, dt, ANIMATION_ACTION.IDLE)
    end
end

function Player:handleAttackHitBox(hitBoxProfile)
    local charPos = nebula.ecs.getComponent(CHARACTER_ENT, Position)
    local hbPos, hbColor, hbQuad, hbCB = nebula.ecs.getComponent(HITBOX_ENTITY, Position, Color, Quad, CollisionBox)

    if hitBoxProfile == HITBOX_PROFILES.ATTACK_DOWN then
        hbPos.x = charPos.x + HITBOX_PROFILES.ATTACK_DOWN.offSetX
        hbPos.y = charPos.y + HITBOX_PROFILES.ATTACK_DOWN.offsetY

        hbQuad.width = HITBOX_PROFILES.ATTACK_DOWN.width
        hbQuad.height = HITBOX_PROFILES.ATTACK_DOWN.height

        hbQuad.width = HITBOX_PROFILES.ATTACK_DOWN.width
        hbQuad.height = HITBOX_PROFILES.ATTACK_DOWN.height

        hbCB.width = HITBOX_PROFILES.ATTACK_DOWN.width
        hbCB.height = HITBOX_PROFILES.ATTACK_DOWN.height

        hbColor.a = 0.5
    end
end

function Player:checkCharacterColision(ePos, eSpeed, dt)
    local collides = false

    for _, ce in pairs(nebula.ecs.getEntitiesWith(CollisionBox)) do
        if ce ~= CHARACTER_ENT and ce~=HITBOX_ENTITY then
            collides = collides or nebula.physics.checkCollision(CHARACTER_ENT, ce)
        end
    end

    if collides then
        ePos.x = ePos.x - (eSpeed.x * dt)
        ePos.y = ePos.y - (eSpeed.y * dt)
    end
end

function Player:draw()
    nebula.graphics.draw(CHARACTER_ENT)
    nebula.graphics.draw(FAIRY_ENT)
    nebula.graphics.draw(HITBOX_ENTITY)
end

return Player