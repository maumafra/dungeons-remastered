SPRITE_SCALE = 3
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

TileMapper = require("src.tileMapper")
GameManager = require("src.gameManager")
AnimationHandler = require("src.animation")
Menu = require("src.menu")
Game = require("src.game")
Ui = require("src.ui")


Sandbox = require("src.sandbox")

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
    Quad = nebula.ecs.component("Quad")
    Light = nebula.ecs.component("Light")

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
            attack = {},
            idleInterval = 0.0,
            moveInterval = 0.0,
            attackInterval = 0.0,
        }
    )
    Map = nebula.ecs.component(
        "Map",
        {
            path = "",
            bounds = {x = 0, y = 0},
            spawnPoint = {x = 0, y = 0},
            textureAtlas = {}
        }
    )
    HitBox = nebula.ecs.component(
        "HitBox",
        {
            timer = 0,
            currState = 0,
            active = false,
            --profiles
        }
    )
    Camera = nebula.ecs.component("Camera", {maxOffset = 0, mapOffset = 0})
    HitPoints = nebula.ecs.component("HP", {hpMax = 0, hp = 0})
    Speed = nebula.ecs.component("Speed", {x = 0, y = 0, value = 0.0, diagonal = 0.0})
    TileFlag = nebula.ecs.component("Tile", {})
    MenuFlag = nebula.ecs.component("Menu", {})

    GameManager:setup()
    TileMapper:loadMap()
    Menu:setup()
    Game:setup(TileMapper:getMapBounds())
    Ui:setup()


    Sandbox:setup()
end

function nebula.update(dt)
    local state = GameManager:getState()
    if state == GAME_STATE.RUNNING then
        Game:update(dt)
        Ui:update(dt)
        TileMapper:update(dt)
    elseif state == GAME_STATE.MENU then
        Menu:update()
    end

    Sandbox:update(dt)
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
    Sandbox:draw()
end