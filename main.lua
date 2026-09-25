SPRITE_SCALE = 3
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

TileMapper = require("src.tileMapper")
GameManager = require("src.gameManager")
Menu = require("src.menu")
Game = require("src.game")
Ui = require("src.ui")

function nebula.setup()
    nebula.window.setTitle("Dungeons Remastered")
    nebula.window.setIcon("resources/icon/sacrificeMark.png")

    nebula.graphics.setDefaultFilter("nearest")

    GameFont120 = nebula.graphics.newFont("resources/font/x12y16pxMaruMonica.ttf", 120)
    GameFont50 = nebula.graphics.newFont("resources/font/x12y16pxMaruMonica.ttf", 50)
    GameFont20 = nebula.graphics.newFont("resources/font/x12y16pxMaruMonica.ttf", 20)

    Position = nebula.ecs.component("Position")
    CollisionBox = nebula.ecs.component("CollisionBox")
    Sprite = nebula.ecs.component("Sprite")
    Text = nebula.ecs.component("Text")
    Color = nebula.ecs.component("Color")
    Scale = nebula.ecs.component("Scale")
    Rotation = nebula.ecs.component("Rotation")

    -- custom components
    Animation = nebula.ecs.component(
        "Animation",
        {
            timer = 0,
            curr = {action = 0, index = 1},
            idle = {},
            up = {},
            down = {},
            right = {},
            left = {},
            attack = {}
        }
    )
    Speed = nebula.ecs.component("Speed", {x = 0, y = 0})
    TileFlag = nebula.ecs.component("Tile", {})
    MenuFlag = nebula.ecs.component("Menu", {})

    GameManager:setup()
    TileMapper:loadMap()
    Menu:setup()
    Game:setup()
    Ui:setup()
end

function nebula.update(dt)
    Ui:update()
    local state = GameManager:getState()
    if state == GAME_STATE.RUNNING then
        Game:update(dt)
    elseif state == GAME_STATE.MENU then
        Menu:update()
    end
end

function nebula.draw()
    local scene = GameManager:getScene()
    if scene == GAME_SCENE.GAME then
        TileMapper:draw()
        Game:draw()
    elseif scene == GAME_SCENE.MENU then
        Menu:draw()
    elseif scene == GAME_SCENE.ACHIEVEMENTS then
        
    elseif scene == GAME_SCENE.SETTINGS then

    end
    Ui:draw()
end