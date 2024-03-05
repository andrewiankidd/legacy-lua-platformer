require("AnAL")
require("movement")
require("controls")
require("toys")
require("chat")
require('enemies')
require('splash')

local lg = love.graphics
local typed = {''}
local editmode=false
local t = {}

function love.load()
--vidya settings
res   = require 'res'
gw,gh = 1280,720
sw,sh = gw,gh
resstr = gw .. "x" .. gh
mode  = 'stretch'
font  = lg.newFont(20)
res.set(mode,gw,gh,sw,sh)
lg.setFont(font)
lg.setMode(sw,sh)
lg.setDefaultImageFilter('linear','nearest')
--set fps
min_dt = 1/60
next_time = love.timer.getMicroTime()
winCreated = love.graphics.isCreated( )

--fonts
pixelfont = love.graphics.newImageFont("assets/fonts/pixelfont.png"," abcdefghijklmnopqrstuvwxyz" .."ABCDEFGHIJKLMNOPQRSTUVWXYZ0" .."123456789.,!?-+/():;%&`'*#=[]\"")
pixelfontlarge = love.graphics.newImageFont("assets/fonts/pixelfontlarge.png"," abcdefghijklmnopqrstuvwxyz" .."ABCDEFGHIJKLMNOPQRSTUVWXYZ0" .."123456789.,!?-+/():;%&`'*#=[]\"")
pixelfonthuge = love.graphics.newImageFont("assets/fonts/pixelfonthuge.png"," abcdefghijklmnopqrstuvwxyz" .."ABCDEFGHIJKLMNOPQRSTUVWXYZ0" .."123456789.,!?-+/():;%&`'*#=[]\"")
pixelfontlargew = love.graphics.newImageFont("assets/fonts/pixelfontlargew.png"," abcdefghijklmnopqrstuvwxyz" .."ABCDEFGHIJKLMNOPQRSTUVWXYZ0" .."123456789.,!?-+/():;%&`'*#=[]\"")
love.graphics.setFont(pixelfont)
music = love.audio.newSource("assets/audio/theme.ogg") -- if "static" is omitted, LÖVE will stream the file from disk, good for longer music tracks
--images
blood = love.graphics.newImage( "assets/images/blood.png" )
bloodposy = 720
--game init var
gamemode = "splash"
gamemode = "gameplay" 
music:setVolume(0.3)
--music:play()
music:setLooping( true )
--game vars
dbg=""
dead=false
playername="YOU"
loadmap("spawn","590","630","-500","0")
debugmode=true
end

function loadmap(mapname,xxx,yyy,offx,offy)
	collrect={}
	npcimg={}
	love.filesystem.load("maps/" ..mapname.. "/map.lua")()
	mapsky = love.graphics.newImage("maps/" ..mapname.. "/sky.png")
	mapbg = love.graphics.newImage("maps/" ..mapname.. "/background.png")
	map = love.graphics.newImage("maps/" ..mapname.. "/main.png")
	mapoverlay = love.graphics.newImage("maps/" ..mapname.. "/overlay.png")
	if love.filesystem.exists( "maps/" ..mapname.. "/lights.png" ) == true then
		islightmap=true
		lightmap = love.graphics.newImage("maps/" ..mapname.. "/lights.png")
	else
		islightmap=false
	end
	protagX=xxx+0
	protagY=yyy+0
	cameraoffsetx=offx
	cameraoffsety=offy
	curmap = mapname
	calcx=protagX-cameraoffsetx 
	calcy=protagY - cameraoffsety 
	--res.set(mode,gw,gh,640,360)
	--lg.setMode(640,360)
end

function love.keyreleased( key )

	if dead==true then
		if key=="return" then
			loadmap("spawn","90","630","0","0")
			dead=false
		end
	end	

end

function love.update(dt)
	--fps control
	next_time = next_time + min_dt
	

	
	if gamemode == "gameplay" then
	
		if dead==false then
			movementcontrols()
			othercontrols()
		end
		if enemies ~=nil then
			enemyai()
		end
		dobullets()
	end
	
	dbg=" OFFX: " .. cameraoffsetx .. " OFFY: " ..cameraoffsety .. " CALCX " .. calcx .. " CALCY " .. calcy.. "\n  " .. playercell.x .. "  " .. playercell.y .. "  " .. playercell.c
	
end

function draw()

	if gamemode == "splash" then
		drawsplash()
	elseif gamemode == "gameplay" then	
		--draw the actual map
		love.graphics.draw(mapsky, cameraoffsetx/2, cameraoffsety)
		love.graphics.draw(mapbg, cameraoffsetx, cameraoffsety)
		love.graphics.draw(map, cameraoffsetx, cameraoffsety)
		
		love.graphics.setFont( pixelfont )
		
		
		--draw the player
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", protagX, protagY-playersize, playersize, playersize*2 )
		love.graphics.setColor(255, 0, 0)
		love.graphics.rectangle("line", protagX, protagY, playersize, playersize )
		love.graphics.setColor(127, 127, 127)
		
		--draw dbg
		love.graphics.printf(dbg .. "\n " .. dbg2 .. "\n " .. playerfacing, 10, 10, gw, "left")
		--reset color
		love.graphics.setColor(255, 255, 255)
		--drawbullets
		n=table.maxn(bulletsx)
		i=1
		while i < n+1 do
			if bulletsx[i] ~=nil then
				love.graphics.circle( "fill", bulletsx[i], bulletsy[i], 8, 8 )
				if bulletsx[i]>(protagX+500) or bulletsx[i]<(protagX-500) then
					table.remove(bulletsx, i)
					table.remove(bulletsy, i)
				end
			end
			i=i+1
		end
		if enemies ~=nil then
			drawenemies()
		end
		love.graphics.draw(mapoverlay, (cameraoffsetx), cameraoffsety)
		
		if dead==true then
			love.graphics.draw(blood, 0,-bloodposy)
			if bloodposy >0 then
				bloodposy = bloodposy-15
			end
			love.graphics.setColor(127, 127, 127)
			love.graphics.setFont( pixelfonthuge )
			love.graphics.printf("DEAD",gw/2-50, bloodposy+50, 100,"center")
			love.graphics.setFont( pixelfontlarge )
			if bloodposy==0 then
				love.graphics.printf("Press Enter to Respawn",0, gh-(gh/2), gw,"center")
			end
		end
	end
	--FPS LOCK
	local cur_time = love.timer.getMicroTime()
	if next_time <= cur_time then
		next_time = cur_time
		return
	end
	--love.timer.sleep(next_time - cur_time)
end

function love.draw( key )
	--render to res
	res.render(draw)
end