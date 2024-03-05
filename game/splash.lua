splashsrc = love.graphics.newImage("assets/images/splash.png")
splash = newAnimation(splashsrc, 280, 280, 0.1, 0)
splash:seek(1)

function drawsplash()
	if gamemode == "splash" then
		splash:draw(gw/2-(280/2),gh/2-(280/2))
		if splash:getCurrentFrame()==80 then
			gamemode="gameplay"
		end
	end
	splash:update(0.05)
end