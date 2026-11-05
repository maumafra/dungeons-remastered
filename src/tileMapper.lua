local TileMapper = {}

local tileSize = 0
local tileXCount = 0
local tileYCount = 0
local spawnX = 0
local spawnY = 12 -- 600 (wind:getWidth()) - 576 (all tiles on Y) = 24 -> 24/2 -> 12

local torchTimer = 0

-- all tiles are 16x16, scailing (x3) it goes to 48x48

function TileMapper:createCollisionLightningTile(entity, texture, offsetY, offsetX, normal)
    nebula.ecs.addComponent(
        entity,
        Position({x = spawnX, y = spawnY}),
        Sprite({texture = texture, normal = normal}),
        Scale({x = SPRITE_SCALE, y = SPRITE_SCALE}),
        CollisionBox({width = texture:getWidth(), height = texture:getHeight(), y = offsetY, x = offsetX}),
        --Light({x = 24, y = 24, radius = 350, intensity = 1.5}),
        Color({r = 1, g = 1, b = 1, a = 1}),
        TileFlag()
    )

    -- TODO: right now we dont support color usage, so changing a color of an entity
    -- also changes the color from the texture. so, we will create an entity for the light alone
    local light = nebula.ecs.spawn()
    nebula.ecs.addComponent(
        light,
        Position({x = spawnX, y = spawnY}),
        -- radius and intensity are updated
        Light({x = 24, y = 24, radius = 250, intensity = 1, height = 10}),
        Color({r = 1, g = 0.4, b = 0.4, a = 1}),
        TileFlag()
    )

    --print("spawnX: "..spawnX, tileSize)
    spawnX = spawnX + (tileSize * SPRITE_SCALE)
end

function TileMapper:createCollisionTile(entity, texture, offsetY, offsetX, normal)
    if normal then
        nebula.ecs.addComponent(
            entity,
            Position({x = spawnX, y = spawnY}),
            Sprite({texture = texture, normal = normal}),
            Scale({x = SPRITE_SCALE, y = SPRITE_SCALE}),
            CollisionBox({width = texture:getWidth(), height = texture:getHeight(), y = offsetY, x = offsetX}),
            TileFlag()
        )
    else
        nebula.ecs.addComponent(
            entity,
            Position({x = spawnX, y = spawnY}),
            Sprite({texture = texture}),
            Scale({x = SPRITE_SCALE, y = SPRITE_SCALE}),
            CollisionBox({width = texture:getWidth(), height = texture:getHeight(), y = offsetY, x = offsetX}),
            TileFlag()
        )
    end
    --print("spawnX: "..spawnX, tileSize)
    spawnX = spawnX + (tileSize * SPRITE_SCALE)
end

function TileMapper:createTile(entity, texture, normalTexture)
    if normalTexture then
        nebula.ecs.addComponent(
            entity,
            Position({x = spawnX, y = spawnY}),
            Sprite({texture = texture, normal = normalTexture}),
            Scale({x = SPRITE_SCALE, y = SPRITE_SCALE}),
            --Color({r = 1.0, g = 1.0, b = 1.0, a = 1.0}),
            TileFlag()
        )
    else
        nebula.ecs.addComponent(
            entity,
            Position({x = spawnX, y = spawnY}),
            Sprite({texture = texture}),
            Scale({x = SPRITE_SCALE, y = SPRITE_SCALE}),
            --Color({r = 1.0, g = 1.0, b = 1.0, a = 1.0}),
            TileFlag()
        )
    end

    spawnX = spawnX + (tileSize * SPRITE_SCALE)
end

function TileMapper:getMapBounds()
    local tileSizeScaled = tileSize * SPRITE_SCALE
    return (tileXCount * tileSizeScaled), (tileYCount * tileSizeScaled)
end

function TileMapper:row()
    spawnX = 0
    spawnY = spawnY + (tileSize * SPRITE_SCALE)
end

function TileMapper:readMap()
    local mapPath = "resources/map/map.txt"
    --local testPath = "resources/map/testMap.txt"

    local f = io.open(mapPath, "rb")
    if not f then
        print("CANNOT READ MAP")
        return {}
    end
    f:close()
    local lines = {}
    for line in io.lines(mapPath) do
        lines[#lines+1] = line
    end
    return lines
end

function TileMapper:loadMap()
    local mainMap = TileMapper:readMap()

    local texBrickPurple = nebula.graphics.newTexture("resources/tiles/BrickPurple.png")
    local texBrickPurpleN = nebula.graphics.newTexture("resources/tiles/BrickPurpleNormal.png")

    local texBrickPurpleBorder = nebula.graphics.newTexture("resources/tiles/BrickPurpleBorder.png")
    local texBrickPurpleBorderLB = nebula.graphics.newTexture("resources/tiles/BrickPurpleBorderLB.png")
    local texBrickPurpleBorderRB = nebula.graphics.newTexture("resources/tiles/BrickPurpleBorderRB.png")
    local texBrickPurpleBorderRT = nebula.graphics.newTexture("resources/tiles/BrickPurpleBorderRT.png")
    local texBrickPurpleBottom = nebula.graphics.newTexture("resources/tiles/BrickPurpleBottom.png")
    local texBrickPurpleLeft = nebula.graphics.newTexture("resources/tiles/BrickPurpleLeft.png")
    local texBrickPurpleRight = nebula.graphics.newTexture("resources/tiles/BrickPurpleRight.png")
    local texCage = nebula.graphics.newTexture("resources/tiles/Cage.png")
    local texCageDown = nebula.graphics.newTexture("resources/tiles/CageDown.png")
    local texCageLeft = nebula.graphics.newTexture("resources/tiles/CageLeft.png")
    local texDirt = nebula.graphics.newTexture("resources/tiles/Dirt.png")
    local texDirtPurple = nebula.graphics.newTexture("resources/tiles/DirtPurple.png")
    local texDirtPurpleGrass = nebula.graphics.newTexture("resources/tiles/DirtPurpleGrass.png")
    local texDirtPurpleGrassBlood = nebula.graphics.newTexture("resources/tiles/DirtPurpleGrassBlood.png")
    local texDirtPurpleRock = nebula.graphics.newTexture("resources/tiles/DirtPurpleRock.png")
    local texDirtPurpleRockBlood = nebula.graphics.newTexture("resources/tiles/DirtPurpleRockBlood.png")
    local texTorch = nebula.graphics.newTexture("resources/tiles/Torch.png")
    local texTorchNormal = nebula.graphics.newTexture("resources/tiles/TorchNormal.png")
    local texTorchDown = nebula.graphics.newTexture("resources/tiles/TorchDown.png")

    tileSize = texDirt:getWidth()

    local updateTileXCount = true

    for k, values in pairs(mainMap) do
        local offsetY = -10
        if k > 1 then
            offsetY = 0
        end

        tileYCount = tileYCount + 1

        for c in values:gmatch("%w+") do
            local entity = nebula.ecs.spawn()

            if updateTileXCount then
                tileXCount = tileXCount + 1
            end

            if c == '0' then
                TileMapper:createCollisionTile(entity, texBrickPurple, offsetY, 0, texBrickPurpleN)
            elseif c == '1' then
                TileMapper:createTile(entity, texDirt)
            elseif c == '2' then
                TileMapper:createTile(entity, texDirtPurple)
            elseif c == '3' then
                TileMapper:createCollisionLightningTile(entity, texTorch, offsetY, 0, texTorchNormal)
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
            elseif c == '16' then
                TileMapper:createCollisionLightningTile(entity, texTorchDown, offsetY)
            elseif c == '17' then
                TileMapper:createCollisionTile(entity, texCageDown, offsetY)
            elseif c == '18' then
                TileMapper:createCollisionTile(entity, texCageLeft, offsetY, -4)
            end
        end

        updateTileXCount = false

        TileMapper:row()
    end
end

function TileMapper:update(dt)
    torchTimer = torchTimer + dt;

    if torchTimer < 0.1 then
        return
    end

    for _, ent in pairs(nebula.ecs.getEntitiesWith(TileFlag, Light)) do
        local eLight = nebula.ecs.getComponent(ent, Light)
        local rn = math.random()

        --eLight.intensity = 1.5 - (rn/2)
        eLight.radius = 250 - (rn * 35)
    end

    torchTimer = 0
end

function TileMapper:draw()
    for _, ent in pairs(nebula.ecs.getEntitiesWith(TileFlag)) do
        nebula.graphics.draw(ent)
    end
end

return TileMapper