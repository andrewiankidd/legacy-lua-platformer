local Love2D4Me = require("love2d4me")
Input = Love2D4Me.input
local GameState = Love2D4Me.gamestate
local MapLoader = Love2D4Me.maploader
local NPC = Love2D4Me.npc
local Projectile = Love2D4Me.projectile
local Fonts = Love2D4Me.fonts
local HUD = Love2D4Me.hud
require("game.movement")
require("game.controls")

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- Globals (required by movement.lua, controls.lua)
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

gw, gh = 0, 0
protagX = 0
protagY = 0
cameraoffsetx = 0
cameraoffsety = 0
calcx = 0
calcy = 0
dead = false

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- File-local state
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

local entities = {}
local mapsky = nil
local mapbg = nil
local map = nil
local mapoverlay = nil
local trigger_messages = {}
local active_message = nil

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- Map loading
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

function loadmap(mapname, spawn_override)
    local loaded = MapLoader.load(mapname)
    mapsky = loaded.sky
    mapbg = loaded.background
    map = loaded.main_layer
    mapoverlay = loaded.overlay
    entities = {}
    Projectile.clear()

    if loaded.collision then
        load_collision(loaded.collision)
    end

    local cfg = loaded.config or {}
    for i, entry in ipairs(cfg.entities or {}) do
        entities[i] = NPC.create_entity(entry)
    end

    trigger_messages = cfg.messages or {}

    local spawn = spawn_override or cfg.spawn or {}
    protagX = tonumber(spawn.x) or 0
    protagY = tonumber(spawn.y) or 0
    cameraoffsetx = tonumber(spawn.cam_x) or 0
    cameraoffsety = tonumber(spawn.cam_y) or 0
    calcx = protagX - cameraoffsetx
    calcy = protagY - cameraoffsety
end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- Gameplay
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

local function gameplay_init()
    local cfg = GameState.get_config()
    dead = false
    HUD.set_controls({
        "Arrows: Move",
        "Space: Jump",
        "Shift: Sprint",
        "X: Shoot",
    })
    loadmap(cfg.starting_map or "spawn")
end

local function gameplay_update(dt)
    if not dead then
        movementcontrols()
        othercontrols(dt)
    end
    for _, entity in ipairs(entities) do
        NPC.update_entity(entity, dt, calcx, calcy)
        if entity.alive and entity.interaction == "collision" then
            if NPC.check_collision(entity, protagX, protagY, playersize, playersize) then
                GameState.die()
            end
            if Projectile.check_hits(entity.x + cameraoffsetx, entity.y + cameraoffsety, 36, 48) then
                entity.hp = (entity.hp or 3) - 1
                entity.hit_flash = 0.15
                if entity.hp <= 0 then
                    entity.alive = false
                end
            end
        end
    end
    Projectile.update(dt)

    local trigger_idx = get_trigger_index()
    if trigger_idx and trigger_messages[trigger_idx + 1] then
        active_message = trigger_messages[trigger_idx + 1]
    else
        active_message = nil
    end
end

local function gameplay_draw()
    if mapsky then love.graphics.draw(mapsky, cameraoffsetx / 2, cameraoffsety) end
    if mapbg then love.graphics.draw(mapbg, cameraoffsetx, cameraoffsety) end
    if map then love.graphics.draw(map, cameraoffsetx, cameraoffsety) end

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", protagX, protagY - playersize, playersize, playersize * 2)
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("line", protagX, protagY, playersize, playersize)
    love.graphics.setColor(1, 1, 1, 1)

    for _, entity in ipairs(entities) do
        NPC.draw_entity(entity, cameraoffsetx, cameraoffsety)
    end

    Projectile.draw(0, 0)

    if mapoverlay then love.graphics.draw(mapoverlay, cameraoffsetx, cameraoffsety) end

    if active_message then
        local sw, sh = love.graphics.getDimensions()
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", sw * 0.1, sh * 0.05, sw * 0.8, sh * 0.12, 8, 8)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(_G["pixelfont"] or Fonts.get(nil, 18))
        love.graphics.printf(active_message, sw * 0.12, sh * 0.07, sw * 0.76, "center")
    end

    HUD.draw()
end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- Boot
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

function love.load()
    GameState.init({
        on_gameplay_init = gameplay_init,
        on_gameplay_update = gameplay_update,
        on_gameplay_draw = gameplay_draw,
        on_death = function() dead = true end,
        on_respawn = function()
            dead = false
            loadmap("spawn", { x = 90, y = 630, cam_x = 0, cam_y = 0 })
        end,
    })
    gw, gh = GameState.get_game_size()
end

function love.update(dt)
    GameState.update(dt)
end

function love.draw()
    GameState.draw()
end

function love.keypressed(key)
    GameState.keypressed(key)
end

function love.keyreleased(key)
    GameState.keyreleased(key)
end
