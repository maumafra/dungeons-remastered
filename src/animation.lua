local AnimationHandler = {}

local function pickCharacterSpriteSheet(charAnimation, targetAnimation)
    local spriteSheet = {}
    if targetAnimation == ANIMATION_ACTION.IDLE then
        spriteSheet = charAnimation.idle
    elseif targetAnimation == ANIMATION_ACTION.DOWN then
        spriteSheet = charAnimation.down
    elseif targetAnimation == ANIMATION_ACTION.UP then
        spriteSheet = charAnimation.up
    elseif targetAnimation == ANIMATION_ACTION.LEFT then
        spriteSheet = charAnimation.left
    elseif targetAnimation == ANIMATION_ACTION.RIGHT then
        spriteSheet = charAnimation.right
    elseif targetAnimation == ANIMATION_ACTION.ATTACK_UP then
        spriteSheet = charAnimation.attack.up
    elseif targetAnimation == ANIMATION_ACTION.ATTACK_DOWN then
        spriteSheet = charAnimation.attack.down
    elseif targetAnimation == ANIMATION_ACTION.ATTACK_LEFT then
        spriteSheet = charAnimation.attack.left
    elseif targetAnimation == ANIMATION_ACTION.ATTACK_RIGHT then
        spriteSheet = charAnimation.attack.right
    end
    return spriteSheet
end

local function pickInterval(charAnimation, targetAnimation)
    local interval = 0.5
    if targetAnimation == ANIMATION_ACTION.IDLE then
        interval = charAnimation.idleInterval
    elseif targetAnimation > ANIMATION_ACTION.ATTACK then
        interval = charAnimation.attackInterval
    else
        interval = charAnimation.moveInterval
    end
    return interval
end

local function startAnimation(charSprite, charAnimation, targetAnimation, spriteSheet)
    charAnimation.timer = 0
    charAnimation.curr.index = 1
    charAnimation.curr.action = targetAnimation
    charSprite.texture = spriteSheet[1]
end

local function continueAnimation(charSprite, charAnimation, dt, spriteSheet, interval)
    -- Increase animation timer
    charAnimation.timer = charAnimation.timer + dt

    -- Checks if the timer already passed the interval
    if charAnimation.timer >= interval then
        local count = TableLength(spriteSheet)

        -- Checks if this is the last part of an attack animation
        if (charAnimation.curr.action > ANIMATION_ACTION.ATTACK and charAnimation.curr.index == count) then
            -- If so, we just set it free and return
            charAnimation.curr.action = ANIMATION_ACTION.FREE
            return true
        end

        -- Reset the timer for the next iteration
        charAnimation.timer = 0
        -- Get the next sprite Index
        charAnimation.curr.index = (charAnimation.curr.index + 1)%(count + 1)

        -- If the index is 0, we set it to 1 (LUA starts with index 1)
        if charAnimation.curr.index == 0 then
            charAnimation.curr.index = 1
        end
    end
    -- Set the character's sprite
    charSprite.texture = spriteSheet[charAnimation.curr.index]
    return false
end

function AnimationHandler:handleCharacterAnimation(entity, dt, targetAnimation)
    local charAnimation, charSprite = nebula.ecs.getComponent(entity, Animation, Sprite)

    -- If the curr animation is attack, we simply continue it
    if charAnimation.curr.action >= ANIMATION_ACTION.ATTACK then
        local spriteSheet = pickCharacterSpriteSheet(charAnimation, charAnimation.curr.action)
        local interval = pickInterval(charAnimation, charAnimation.curr.action)
        return continueAnimation(charSprite, charAnimation, dt, spriteSheet, interval)
    end

    local spriteSheet = pickCharacterSpriteSheet(charAnimation, targetAnimation)
    local interval = pickInterval(charAnimation, targetAnimation)

    -- If the target animation is not the current, we start it
    if charAnimation.curr.action ~= targetAnimation then
        startAnimation(charSprite, charAnimation, targetAnimation, spriteSheet)
        return false
    else
        return continueAnimation(charSprite, charAnimation, dt, spriteSheet, interval)
    end
end

return AnimationHandler