Player = require("src.player")
Enemy = require("src.enemy")

local Game = {}

-- entities
CAMERA_ENT = 0

-- map
MAP_BOUNDS = {x = 0, y = 0}

ANIMATION_ACTION = {
    FREE = -1,
    UP = 0,
    DOWN = 1,
    RIGHT = 2,
    LEFT = 3,
    IDLE = 4,
    ATTACK = 5,
    ATTACK_UP = 6,
    ATTACK_DOWN = 7,
    ATTACK_LEFT = 8,
    ATTACK_RIGHT = 9,
}

function TableLength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function Game:setup(mapBoundX, mapBoundY)
    Player:loadCharacter()
    Game:loadCamera()
    Enemy:loadEnemies()
    MAP_BOUNDS.x = mapBoundX
    MAP_BOUNDS.y = mapBoundY
end

function Game:update(dt)
    Player:updateCharacter(dt)
    Game:updateCamera()
    Enemy:update(dt)

    for _, e in pairs(nebula.ecs.getEntitiesWith(Position, Speed)) do
        local eSpeed, ePos = nebula.ecs.getComponent(e, Speed, Position)
        ePos.x = ePos.x + (eSpeed.x * dt)
        ePos.y = ePos.y + (eSpeed.y * dt)

        if (e == CHARACTER_ENT) then
            Player:checkCharacterColision(ePos, eSpeed, dt)
        end

        if (e == CAMERA_ENT) then
            nebula.graphics.pointCameraTo(ePos.x + WINDOW_WIDTH/2, ePos.y + WINDOW_HEIGHT/2)
        end
    end
end

function Game:draw()
    Enemy:draw()
    Player:draw()
end

function Game:loadCamera()
    CAMERA_ENT = nebula.ecs.spawn()
    nebula.ecs.addComponent(
        CAMERA_ENT,
        Position({x = 0, y = 0}),
        Speed({x = 0, y = 0, value = 250.0}),
        Camera({maxOffset = 75, mapOffset = 10})
    )
end

function Game:updateCamera()
    local charPos = nebula.ecs.getComponent(CHARACTER_ENT, Position)
    local camSpeed, camPos, camComp = nebula.ecs.getComponent(CAMERA_ENT, Speed, Position, Camera)
    camSpeed.x = 0

    local charCenterX = charPos.x + (40 * SPRITE_SCALE)
    local camCenterX = camPos.x + WINDOW_WIDTH/2
    --local camCenterY = camPos.y + WINDOW_HEIGHT/2

    local currOffset = charCenterX - camCenterX

    local cameraLeftBound = camPos.x
    local camertaRightBound = camPos.x + WINDOW_WIDTH

    local mapLeftBound = 0
    local mapRightBound = MAP_BOUNDS.x

    if (currOffset >= camComp.maxOffset and camertaRightBound <= mapRightBound + camComp.mapOffset) then
        camSpeed.x = camSpeed.value
    end

    if (currOffset <= - camComp.maxOffset and cameraLeftBound >= mapLeftBound - camComp.mapOffset) then
        camSpeed.x = - camSpeed.value
    end
end


return Game