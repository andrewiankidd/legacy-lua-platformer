local Collision = require("love2d4me").collision

-- Movement constants
local MOVE_SPEED = 5
local SPRINT_MULTIPLIER = 2
local CAMERA_THRESHOLD = 50
local PLAYER_SIZE = 45
local MAX_JUMP_HEIGHT = PLAYER_SIZE * 2

-- Collision color map (red channel â†’ permission)
local COLOR_MAP = {
    [0]   = "solid",
    [255] = "walk",
    [128] = "hazard",
    [64]  = "grapple",
    [200] = "trigger",
    [201] = "trigger",
    [202] = "trigger",
    [203] = "trigger",
    [204] = "trigger",
}

local TRIGGER_BASE_COLOR = 200

-- Globals (read by enemies.lua, controls.lua, main.lua)
defaultmovespeed = MOVE_SPEED
playersize = PLAYER_SIZE
playerfacing = "right"
collision = nil

-- File-local state
local movespeed = MOVE_SPEED
local jumpheight = 0
local nojump = false

function load_collision(collision_data)
    collision = Collision.new(collision_data, COLOR_MAP)
end

function get_trigger_index()
    if not collision then return nil end
    local color = collision:color_at(calcx + PLAYER_SIZE / 2, calcy)
    if color >= TRIGGER_BASE_COLOR and color < TRIGGER_BASE_COLOR + 10 then
        return color - TRIGGER_BASE_COLOR
    end
    return nil
end

local function check_move(dir)
    if not collision then return true end

    local nx, ny = calcx, calcy
    if dir == "up" then ny = calcy - movespeed
    elseif dir == "down" then ny = calcy + PLAYER_SIZE + movespeed
    elseif dir == "left" then nx = calcx - movespeed
    elseif dir == "right" then nx = calcx + PLAYER_SIZE + movespeed
    end

    if dir == "up" or dir == "down" then
        local left = collision:check(calcx, ny)
        local right = collision:check(calcx + PLAYER_SIZE - 1, ny)
        if left == "solid" or right == "solid" then return false, "solid" end
        if left == "hazard" or right == "hazard" then return true, "hazard" end
        if left == "grapple" and right == "grapple" then return false, "grapple" end
        if left == "grapple" or right == "grapple" then return false, "grapple" end
        return true, "walk"
    else
        local top = collision:check(nx, calcy)
        local bottom = collision:check(nx, calcy + PLAYER_SIZE - 1)
        if top == "solid" or bottom == "solid" then return false, "solid" end
        if top == "hazard" or bottom == "hazard" then return true, "hazard" end
        if top == "grapple" and bottom == "grapple" then return false, "grapple" end
        if top == "grapple" or bottom == "grapple" then return false, "grapple" end
        return true, "walk"
    end
end

local function move_player(dir)
    if dir == "up" or dir == "hookhop" then
        protagY = protagY - MOVE_SPEED
        jumpheight = jumpheight + MOVE_SPEED
        if protagY < 150 then
            cameraoffsety = cameraoffsety + MOVE_SPEED
        end
    elseif dir == "down" then
        protagY = protagY + movespeed
        if protagY > (gh / 2) and collision and (collision.h + cameraoffsety) > gh then
            cameraoffsety = cameraoffsety - MOVE_SPEED
        end
    end

    if dir == "left" then
        if protagX < (gw / 2) and cameraoffsetx < 0 then
            cameraoffsetx = cameraoffsetx + movespeed
        else
            protagX = protagX - movespeed
        end
    elseif dir == "right" then
        if protagX > (gw / 2) + CAMERA_THRESHOLD and collision and cameraoffsetx * -1 < collision.w - gw then
            cameraoffsetx = cameraoffsetx - movespeed
        else
            protagX = protagX + movespeed
        end
    end
end

function movementcontrols()
    calcx = protagX - cameraoffsetx
    calcy = protagY - cameraoffsety

    -- Gravity
    if jumpheight > MAX_JUMP_HEIGHT then
        nojump = true
    elseif jumpheight == 0 then
        local can, _ = check_move("down")
        if can then move_player("down") end
    end

    -- Jump
    if Input.held("confirm") and not nojump then
        local can, perm = check_move("up")
        if can then
            move_player("up")
        elseif perm == "grapple" then
            move_player("hookhop")
        end
    elseif jumpheight > 0 then
        local can, _ = check_move("down")
        if can then
            move_player("down")
        else
            nojump = false
            jumpheight = 0
        end
    end

    -- Horizontal
    if Input.held("move_left") then
        playerfacing = "left"
        local can, perm = check_move("left")
        if can then move_player("left") end
        if perm == "hazard" then require("love2d4me").gamestate.die() end
    elseif Input.held("move_right") then
        playerfacing = "right"
        local can, perm = check_move("right")
        if can then move_player("right") end
        if perm == "hazard" then require("love2d4me").gamestate.die() end
    end

    -- Sprint
    if Input.held("sprint") then
        movespeed = MOVE_SPEED * SPRINT_MULTIPLIER
    else
        movespeed = MOVE_SPEED
    end

    calcx = protagX - cameraoffsetx
    calcy = protagY - cameraoffsety
end
