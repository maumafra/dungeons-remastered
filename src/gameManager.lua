local GameManager = {}

GAME_STATE = {
    MENU = 0,
    PAUSE = 1,
    RUNNING = 2,
}

GAME_SCENE = {
    MENU = 0,
    GAME = 1,
    ACHIEVEMENTS = 2,
    SETTINGS = 3,
    GAME_OVER = 4
}

local currState = GAME_STATE.MENU
local currScene = GAME_SCENE.MENU
local prevState = GAME_STATE.MENU
local prevScene = GAME_SCENE.MENU

function GameManager:setup()
    currState = GAME_STATE.MENU
    currScene = GAME_SCENE.MENU
    prevState = GAME_STATE.MENU
    prevScene = GAME_SCENE.MENU
end

function GameManager:changeState(newState)
    prevState = currState
    currState = newState
end

function GameManager:changeScene(newScene)
    prevScene = currScene
    currScene = newScene
end

function GameManager:getState()
    return currState
end

function GameManager:getScene()
    return currScene
end

function GameManager:getPrevState()
    return prevState
end

function GameManager:getPrevScene()
    return prevScene
end

return GameManager