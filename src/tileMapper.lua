local TileMapper = {}

local tileSize = 0
local spawnX = 0
local spawnY = 12 -- 600 (wind.width) - 576 (all tiles on Y) = 24 -> 24/2 -> 12

-- all tiles are 16x16, scailing (x3) it goes to 48x48

function TileMapper:createCollisionTile(entity, texture, offsetY, offsetX)
    nebula.ecs.addComponent(
        entity,
        Position({x = spawnX, y = spawnY}),
        Sprite({texture = texture}),
        Scale({x = SPRITE_SCALE, y = SPRITE_SCALE}),
        CollisionBox({width = texture.width, height = texture.height, y = offsetY, x = offsetX}),
        TileFlag()
    )

    spawnX = spawnX + (tileSize * SPRITE_SCALE)
end

function TileMapper:createTile(entity, texture)
    nebula.ecs.addComponent(
        entity,
        Position({x = spawnX, y = spawnY}),
        Sprite({texture = texture}),
        Scale({x = SPRITE_SCALE, y = SPRITE_SCALE}),
        TileFlag()
    )

    spawnX = spawnX + (tileSize * SPRITE_SCALE)
end

function TileMapper:row()
    spawnX = 0
    spawnY = spawnY + (tileSize * SPRITE_SCALE)
end

function TileMapper:readMap()
    local f = io.open("resources/map/map.txt", "rb")
    if not f then
        print("CANNOT READ MAP")
        return {}
    end
    f:close()
    local lines = {}
    for line in io.lines("resources/map/map.txt") do
        lines[#lines+1] = line
    end
    return lines
end

function TileMapper:loadMap()
    local mainMap = TileMapper:readMap()

    local texBrickPurple = nebula.graphics.newTexture("resources/tiles/BrickPurple.png")
    local texBrickPurpleBorder = nebula.graphics.newTexture("resources/tiles/BrickPurpleBorder.png")
    local texBrickPurpleBorderLB = nebula.graphics.newTexture("resources/tiles/BrickPurpleBorderLB.png")
    local texBrickPurpleBorderRB = nebula.graphics.newTexture("resources/tiles/BrickPurpleBorderRB.png")
    local texBrickPurpleBorderRT = nebula.graphics.newTexture("resources/tiles/BrickPurpleBorderRT.png")
    local texBrickPurpleBottom = nebula.graphics.newTexture("resources/tiles/BrickPurpleBottom.png")
    local texBrickPurpleLeft = nebula.graphics.newTexture("resources/tiles/BrickPurpleLeft.png")
    local texBrickPurpleRight = nebula.graphics.newTexture("resources/tiles/BrickPurpleRight.png")
    local texCage = nebula.graphics.newTexture("resources/tiles/Cage.png")
    local texDirt = nebula.graphics.newTexture("resources/tiles/Dirt.png")
    local texDirtPurple = nebula.graphics.newTexture("resources/tiles/DirtPurple.png")
    local texDirtPurpleGrass = nebula.graphics.newTexture("resources/tiles/DirtPurpleGrass.png")
    local texDirtPurpleGrassBlood = nebula.graphics.newTexture("resources/tiles/DirtPurpleGrassBlood.png")
    local texDirtPurpleRock = nebula.graphics.newTexture("resources/tiles/DirtPurpleRock.png")
    local texDirtPurpleRockBlood = nebula.graphics.newTexture("resources/tiles/DirtPurpleRockBlood.png")
    local texTorch = nebula.graphics.newTexture("resources/tiles/Torch.png")

    tileSize = texDirt.width

    for k, values in pairs(mainMap) do
        local offsetY = -10
        if k > 1 then
            offsetY = 0
        end

        for c in values:gmatch("%w+") do
            local entity = nebula.ecs.spawn()
            if c == '0' then
                TileMapper:createCollisionTile(entity, texBrickPurple, offsetY)
            elseif c == '1' then
                TileMapper:createTile(entity, texDirt)
            elseif c == '2' then
                TileMapper:createTile(entity, texDirtPurple)
            elseif c == '3' then
                TileMapper:createCollisionTile(entity, texTorch, offsetY)
            elseif c == '4' then
                TileMapper:createCollisionTile(entity, texCage, offsetY)
            elseif c == '5' then
                TileMapper:createCollisionTile(entity, texBrickPurpleBorder, offsetY)
            elseif c == '6' then
                TileMapper:createTile(entity, texBrickPurpleBorderLB)
            elseif c == '7' then
                TileMapper:createTile(entity, texBrickPurpleBorderRB)
            elseif c == '8' then
                TileMapper:createTile(entity, texBrickPurpleBorderRT)
            elseif c == '9' then
                TileMapper:createTile(entity, texDirtPurpleGrass)
            elseif c == '10' then
                TileMapper:createTile(entity, texDirtPurpleGrassBlood)
            elseif c == '11' then
                TileMapper:createTile(entity, texDirtPurpleRock)
            elseif c == '12' then
                TileMapper:createTile(entity, texDirtPurpleRockBlood)
            elseif c == '13' then
                TileMapper:createCollisionTile(entity, texBrickPurpleRight, offsetY, 4)
            elseif c == '14' then
                TileMapper:createCollisionTile(entity, texBrickPurpleLeft, offsetY, -4)
            elseif c == '15' then
                TileMapper:createCollisionTile(entity, texBrickPurpleBottom, offsetY)
            end
        end
        TileMapper:row()
    end
end

function TileMapper:draw()
    for _, ent in pairs(nebula.ecs.getEntitiesWith(TileFlag)) do
        nebula.graphics.draw(ent)
    end
end

return TileMapper