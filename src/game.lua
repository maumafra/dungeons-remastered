local Game = {}

SWORD_TEST = 0

CHARACTER_ENT = 0
DEFAULT_SPEED = 250.0
DIAGONAL_SPEED = 177.0
CHARACTER_MOVE_ANIMATION_INTERVAL = 0.2
CHARACTER_IDLE_ANIMATION_INTERVAL = 0.6

ANIMATION_ACTION = {
    UP = 0,
    DOWN = 1,
    RIGHT = 2,
    LEFT = 3,
    ATTACK = 4,
    IDLE = 5
}

function TableLength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function Game:setup()
    Game:loadCharacter()
end

function Game:update(dt)
    Game:updateCharacter(dt)

    local testRotation, testPosition, testSprite = nebula.ecs.getComponent(SWORD_TEST, Rotation, Position, Sprite)
    local dx = nebula.mouse.getX() - (testPosition.x + testSprite.texture.width * 2)
    local dy = nebula.mouse.getY() - (testPosition.y + testSprite.texture.height * 2)
    --print(math.atan(dy, dx))

    if dy < 0 then dy = - dy end

    local v = ((math.atan(dy, dx) * (180 / 3.14159)))
    if v < 0 then v = -v end
    testRotation.value = v

    for _, e in pairs(nebula.ecs.getEntitiesWith(Position, Speed)) do
        local eSpeed, ePos = nebula.ecs.getComponent(e, Speed, Position)
        ePos.x = ePos.x + (eSpeed.x * dt)
        ePos.y = ePos.y + (eSpeed.y * dt)
        if (e == CHARACTER_ENT) then
            local collides = false

            for _, ce in pairs(nebula.ecs.getEntitiesWith(CollisionBox)) do
                if ce ~= CHARACTER_ENT then
                    collides = collides or nebula.physics.checkCollision(CHARACTER_ENT, ce)
                end
            end

            if collides then
                ePos.x = ePos.x - (eSpeed.x * dt)
                ePos.y = ePos.y - (eSpeed.y * dt)
            else
                nebula.graphics.moveCamera(eSpeed.x * dt, 0)
                local fpsPos = nebula.ecs.getComponent(FPS_ENT, Position)
                fpsPos.x = fpsPos.x + eSpeed.x * dt
            end
        end
    end
end

function Game:draw()
    nebula.graphics.draw(CHARACTER_ENT)
    nebula.graphics.draw(SWORD_TEST)
end

function Game:loadCharacter()
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

    CHARACTER_ENT = nebula.ecs.spawn()
    nebula.ecs.addComponent(
        CHARACTER_ENT,
        Position({x = 336, y = 50}),
        Speed({x = 0, y = 0}),
        Animation({
            curr = {action = ANIMATION_ACTION.IDLE, index = 1},
            idle = {texCIdle01, texCIdle02},
            down = {texCDown01, texCDown02},
            up = {texCUp01, texCUp02},
            right = {texCRight01, texCRight02},
            left = {texCLeft01, texCLeft02}
        }),
        Sprite({texture = texCIdle01}),
        CollisionBox({width = texCIdle01.width, height = texCIdle01.height}),
        Scale({x = SPRITE_SCALE, y = SPRITE_SCALE})
    )

    local a = nebula.graphics.newTexture("resources/character/testSword.png")

    SWORD_TEST = nebula.ecs.spawn()
    nebula.ecs.addComponent(
        SWORD_TEST,
        Position({x = 336 - 96, y = 50 + 30}),
        Rotation({value = 0}),
        Sprite({texture = a}),
        Scale({x = SPRITE_SCALE, y = SPRITE_SCALE})
    )
end

function Game:updateCharacter(dt)
    local charSpeed, charAnimation, charSprite = nebula.ecs.getComponent(CHARACTER_ENT, Speed, Animation, Sprite)
    charSpeed.x = 0
    charSpeed.y = 0
    if nebula.keyboard.isKeyPressed('w') then
        if nebula.keyboard.isKeyPressed("s") then
            charSpeed.y = 0
            Game:handleCharacterAnimation(
                charSprite,
                charAnimation,
                dt,
                ANIMATION_ACTION.IDLE
            )
        else
            charSpeed.y = - DIAGONAL_SPEED
            if not (nebula.keyboard.isKeyPressed("a") or nebula.keyboard.isKeyPressed("d")) then
                charSpeed.y = - DEFAULT_SPEED
                Game:handleCharacterAnimation(
                    charSprite,
                    charAnimation,
                    dt,
                    ANIMATION_ACTION.UP
                )
            end
        end
    end
    if nebula.keyboard.isKeyPressed("s") then
        if nebula.keyboard.isKeyPressed("w") then
            charSpeed.y = 0
            Game:handleCharacterAnimation(
                charSprite,
                charAnimation,
                dt,
                ANIMATION_ACTION.IDLE
            )
        else
            charSpeed.y = DIAGONAL_SPEED
            if not (nebula.keyboard.isKeyPressed("a") or nebula.keyboard.isKeyPressed("d")) then
                charSpeed.y = DEFAULT_SPEED
                Game:handleCharacterAnimation(
                    charSprite,
                    charAnimation,
                    dt,
                    ANIMATION_ACTION.DOWN
                )
            end
        end
    end
    if nebula.keyboard.isKeyPressed("a") then
        if nebula.keyboard.isKeyPressed("d") then
            charSpeed.x = 0
            Game:handleCharacterAnimation(
                charSprite,
                charAnimation,
                dt,
                ANIMATION_ACTION.IDLE
            )
        else
            charSpeed.x = - DIAGONAL_SPEED
            if not (nebula.keyboard.isKeyPressed("w") or nebula.keyboard.isKeyPressed("s")) then
                charSpeed.x = - DEFAULT_SPEED
            end
            Game:handleCharacterAnimation(
                charSprite,
                charAnimation,
                dt,
                ANIMATION_ACTION.LEFT
            )
        end
    end
    if nebula.keyboard.isKeyPressed("d") then
        if nebula.keyboard.isKeyPressed("a") then
            charSpeed.x = 0
            Game:handleCharacterAnimation(
                charSprite,
                charAnimation,
                dt,
                ANIMATION_ACTION.IDLE
            )
        else
            charSpeed.x = DIAGONAL_SPEED
            if not (nebula.keyboard.isKeyPressed("w") or nebula.keyboard.isKeyPressed("s")) then
                charSpeed.x = DEFAULT_SPEED
            end
            Game:handleCharacterAnimation(
                charSprite,
                charAnimation,
                dt,
                ANIMATION_ACTION.RIGHT
            )
        end
    end
    if not (nebula.keyboard.isKeyPressed("d") or nebula.keyboard.isKeyPressed("a") or nebula.keyboard.isKeyPressed("w") or nebula.keyboard.isKeyPressed("s")) then
        Game:handleCharacterAnimation(
            charSprite,
            charAnimation,
            dt,
            ANIMATION_ACTION.IDLE
        )
    end
end

function Game:handleCharacterAnimation(charSprite, charAnimation, dt, targetAnimation)
    local interval = CHARACTER_MOVE_ANIMATION_INTERVAL
    local spriteSheet = {}
    if targetAnimation == ANIMATION_ACTION.IDLE then
        spriteSheet = charAnimation.idle
        interval = CHARACTER_IDLE_ANIMATION_INTERVAL
    elseif targetAnimation == ANIMATION_ACTION.DOWN then
        spriteSheet = charAnimation.down
    elseif targetAnimation == ANIMATION_ACTION.UP then
        spriteSheet = charAnimation.up
    elseif targetAnimation == ANIMATION_ACTION.LEFT then
        spriteSheet = charAnimation.left
    elseif targetAnimation == ANIMATION_ACTION.RIGHT then
        spriteSheet = charAnimation.right
    end

    if charAnimation.curr.action ~= targetAnimation then
        charAnimation.timer = 0
        charAnimation.curr.index = 1
        charAnimation.curr.action = targetAnimation
        charSprite.texture = spriteSheet[1]
    else
        charAnimation.timer = charAnimation.timer + dt

        if charAnimation.timer >= interval then
            charAnimation.timer = 0
            local count = TableLength(spriteSheet)
            charAnimation.curr.index = (charAnimation.curr.index + 1)%(count + 1)

            if charAnimation.curr.index == 0 then
                charAnimation.curr.index = 1
            end
        end

        charSprite.texture = spriteSheet[charAnimation.curr.index]
    end
end

return Game