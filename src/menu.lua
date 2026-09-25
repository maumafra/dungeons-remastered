local Menu = {}

local posY = 16
local currFont = GameFont120

local selectonEnt = 0
local currSelection = 0
local MenuSelecion = {
    START = 0,
    ACHIEVEMENTS = 1,
    QUIT = 2
}
local SelectionPos = {
    START = {x = WINDOW_WIDTH/2 - 80, y = 312},
    ACHIEVEMENTS = {x = WINDOW_WIDTH/2 - 150, y = 402},
    QUIT = {x = WINDOW_WIDTH/2 - 60, y = 492}
}

local menuOptionsCount = 3
local MenuText = {
    TITLE = "DUNGEONS",
    START = "START",
    ACHIEVEMENTS = "ACHIEVEMENTS",
    QUIT = "QUIT",
    SELECTION = ">"
}

local shadowText = {}

local MenuColors = {
    YELLOW = {r = 1.0, g = 0.78, b = 0.0, a = 1.0},
    RED = {r = 1.0, g = 0.0, b = 0.0, a = 1.0}
}

function Menu:createText(text, posX, color)
    local ent = nebula.ecs.spawn()
    nebula.ecs.addComponent(
        ent,
        Position({x = posX, y = posY}),
        Color(color),
        Text({font = currFont, value = text}),
        MenuFlag({})
    )
    return ent
end

function Menu:createShadowText(text, posX, color)
    local ent = nebula.ecs.spawn()
    nebula.ecs.addComponent(
        ent,
        Position({x = posX, y = posY + 4}),
        Color(color),
        Text({font = currFont, value = text})
    )
    return ent
end

function Menu:row(value)
    posY = posY + value
end

function Menu:switchFont(font)
    currFont = font
end

function Menu:setup()
    Menu:switchFont(GameFont120)
    -- Creating multiple texts to create a "BOLD" effect, as we dont support it
    -- right now on nebula engine
    shadowText[1] = Menu:createShadowText(MenuText.TITLE, WINDOW_WIDTH/4 - 20 + 3, MenuColors.RED)
    shadowText[2] = Menu:createShadowText(MenuText.TITLE, WINDOW_WIDTH/4 - 20 + 4, MenuColors.RED)
    shadowText[3] = Menu:createShadowText(MenuText.TITLE, WINDOW_WIDTH/4 - 20 + 5, MenuColors.RED)

    Menu:createText(MenuText.TITLE, WINDOW_WIDTH/4 - 20, MenuColors.YELLOW)
    Menu:createText(MenuText.TITLE, WINDOW_WIDTH/4 - 20 + 1, MenuColors.YELLOW)
    Menu:createText(MenuText.TITLE, WINDOW_WIDTH/4 - 20 + 2, MenuColors.YELLOW)

    Menu:row(120)

    local texSacrificeMark = nebula.graphics.newTexture("resources/icon/sacrificeMark.png")
    local sacrificeMark = nebula.ecs.spawn()
    nebula.ecs.addComponent(
        sacrificeMark,
        Position({x = WINDOW_WIDTH/2 - (texSacrificeMark.width/2 * SPRITE_SCALE), y = posY}),
        Sprite({texture = texSacrificeMark}),
        Scale({x = SPRITE_SCALE, y = SPRITE_SCALE}),
        MenuFlag({})
    )

    Menu:row(176) -- 96 (sprite size) + 80
    Menu:switchFont(GameFont50)

    selectonEnt = Menu:createText(MenuText.SELECTION, SelectionPos.START.x, MenuColors.YELLOW)
    Menu:createText(MenuText.START, WINDOW_WIDTH/2 - 50, MenuColors.YELLOW)
    Menu:row(90)
    Menu:createText(MenuText.ACHIEVEMENTS, WINDOW_WIDTH/2 - 120, MenuColors.YELLOW)
    Menu:row(90)
    Menu:createText(MenuText.QUIT, WINDOW_WIDTH/2 - 30, MenuColors.YELLOW)
end

function Menu:update()
    local hasMoved = false
    if nebula.keyboard.isKeyReleased("w") then
        if currSelection == MenuSelecion.START then
            currSelection = MenuSelecion.QUIT
        else
            currSelection = currSelection - 1
        end

        hasMoved = true
    end
    if nebula.keyboard.isKeyReleased("s") then
        currSelection = (currSelection + 1)%menuOptionsCount

        hasMoved = true
    end

    if nebula.keyboard.isKeyPressed("enter") then
        if currSelection == MenuSelecion.START then
            GameManager:changeState(GAME_STATE.RUNNING)
            GameManager:changeScene(GAME_SCENE.GAME)
        elseif currSelection == MenuSelecion.ACHIEVEMENTS then
            GameManager:changeScene(GAME_SCENE.ACHIEVEMENTS)
        elseif currSelection == MenuSelecion.QUIT then
            nebula.event.quit()
        end
    end

    if not hasMoved then
        return
    end

    local posComponent = nebula.ecs.getComponent(selectonEnt, Position)
    if currSelection == MenuSelecion.START then
        posComponent.x = SelectionPos.START.x
        posComponent.y = SelectionPos.START.y
    elseif currSelection == MenuSelecion.ACHIEVEMENTS then
        posComponent.x = SelectionPos.ACHIEVEMENTS.x
        posComponent.y = SelectionPos.ACHIEVEMENTS.y
    elseif currSelection == MenuSelecion.QUIT then
        posComponent.x = SelectionPos.QUIT.x
        posComponent.y = SelectionPos.QUIT.y
    end
end

function Menu:draw()
    nebula.graphics.draw(shadowText[1])
    nebula.graphics.draw(shadowText[2])
    nebula.graphics.draw(shadowText[3])
    for _, ent in pairs(nebula.ecs.getEntitiesWith(MenuFlag)) do
        nebula.graphics.draw(ent)
    end
end

return Menu