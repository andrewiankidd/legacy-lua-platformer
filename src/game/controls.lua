local Projectile = require("love2d4me").projectile

local BULLET_SPEED = 450
local BULLET_LIFETIME = 1.5
local BULLET_RADIUS = 4
local SHOOT_COOLDOWN = 0.25
local shoot_timer = 0

function othercontrols(dt)
    shoot_timer = shoot_timer - (dt or 0.016)
    if Input.held("shoot") and shoot_timer <= 0 then
        local dx = playerfacing == "right" and BULLET_SPEED or -BULLET_SPEED
        Projectile.spawn({
            x = protagX + playersize / 2,
            y = protagY,
            dx = dx, dy = 0,
            radius = BULLET_RADIUS,
            lifetime = BULLET_LIFETIME,
        })
        shoot_timer = SHOOT_COOLDOWN
    end
end
