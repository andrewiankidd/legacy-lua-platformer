--  __  __  ______      ________ __  __ ______ _   _ _______       _____          __  __ ______ _____            
-- |  \/  |/ __ \ \    / /  ____|  \/  |  ____| \ | |__   __|__   / ____|   /\   |  \/  |  ____|  __ \     /\    
-- | \  / | |  | \ \  / /| |__  | \  / | |__  |  \| |  | | ( _ ) | |       /  \  | \  / | |__  | |__) |   /  \   
-- | |\/| | |  | |\ \/ / |  __| | |\/| |  __| | . ` |  | | / _ \/\ |      / /\ \ | |\/| |  __| |  _  /   / /\ \  
-- | |  | | |__| | \  /  | |____| |  | | |____| |\  |  | || (_>  < |____ / ____ \| |  | | |____| | \ \  / ____ \ 
-- |_|  |_|\____/   \/   |______|_|  |_|______|_| \_|  |_| \___/\/\_____/_/    \_\_|  |_|______|_|  \_\/_/    \_\
------------------------------------------------------------------------------------------------------------------
defaultmovespeed=5
movespeed=defaultmovespeed
playercell = {x=0,y=0,c=0}
dbg2=""
cameraoffsetx=0
cameraoffsety=0
protagX=0
protagY=0
calcx=0
calcy=0
cellsize=45
camthreshold=50
playersize=cellsize
jumpheight=0
playerfacing="right"
nojump=false
--NOTHING BELOW THIS LINE NEEDS EDITED--NOTHING BELOW THIS LINE NEEDS EDITED--NOTHING BELOW THIS LINE NEEDS EDITED

function okaytomove(dir)

	--WORK OUT POTENTIAL POSITION X Y, CALCULATE CELL
	if dir =="up" then 
		nc=getcell(calcx,(calcy-(movespeed))) --leftside
		nc2=getcell(calcx+(playersize-1),(calcy-(movespeed))) --rightside
	elseif
	dir =="down" then 
		nc=getcell(calcx,calcy+playersize-1+(movespeed))
		nc2=getcell(calcx+(playersize-1),calcy+(playersize-1)+(movespeed))
	elseif
	dir =="left" then
		nc=getcell(calcx-(movespeed) ,calcy)
		nc2=getcell(calcx-(movespeed) ,calcy+(playersize-1))
	elseif
	dir =="right" then
		nc=getcell((calcx+(playersize-1))+(movespeed),calcy)
		nc2=getcell((calcx+(playersize-1))+(movespeed),calcy+(playersize-1))
	end
	--EMD OF CELL CALC
	hookhop=false
	
	--CHECK THE POTENTIAL CELL AGAINST MAP DATA
	if nc.c >=1 and nc.x >=0 and nc.y >=0 and nc.x+1 <= mapwidth and nc.y <= mapheight then --mapboundaries
		ccell = getcell(calcx ,calcy-playersize)
		dbg2="current cell" ..  mapperms[ccell.c] .. " nc.x " .. nc.x .. "   nx.y " .. nc.y .. "   nc.c " .. nc.c  .. "  " .. "\n nc.c " .. nc.c .. "  nc2.c " .. nc2.c .. " mapperms[nc.c] " .. mapperms[nc.c] .. "  mapperms[nc2.c] " ..  mapperms[nc2.c]
		if mapperms[nc.c] == 0 and mapperms[nc2.c]==0 then --if 0 then free to move
			if mapperms[ccell.c] == '5' then
				return false
			else
				return true
			end
		elseif mapperms[nc.c] == 1 and mapperms[nc2.c]== 1 then --if 1 then no move
			return false
		elseif mapperms[nc.c] == 5 and mapperms[nc2.c]==5 then
			hookhop=true
			return false
		elseif mapperms[nc.c] == 5 or mapperms[nc2.c]==5 then
			hookhop=true
			return falsed
		elseif mapperms[nc.c] == 3 and mapperms[nc2.c]==3 then
			dead=true
			return true
		end
	end
end
function getcell(theX, theY)
	local cell={
		x = math.round("down",theX / cellsize), 
		y = math.round("down",theY / cellsize) ,
		c = 0
	}
	cell.c = (cell.y * (mapwidth) +cell.x)+1
	return cell;
end

function moveplayer(dir)
	if dir=="up" then	
		protagY=protagY-defaultmovespeed
		jumpheight=jumpheight+defaultmovespeed
		if protagY < 150 then
			cameraoffsety=cameraoffsety +defaultmovespeed
		end
	elseif dir=="down" then
		protagY=protagY+movespeed
		if protagY > (gh/2) and (mapheight*cellsize)+cameraoffsety > gh then --themapheight doesnt line up with the bottom of the window
			cameraoffsety=cameraoffsety -defaultmovespeed
		end
	elseif dir=="hookhop" then
		protagY=protagY-(defaultmovespeed)
		jumpheight=jumpheight+(defaultmovespeed)
		if protagY < 150 then
			cameraoffsety=cameraoffsety +(defaultmovespeed)
		end
	end
	
	if dir=="left" then
		if protagX < (gw/2) and cameraoffsetx*1 < 0 then   
			cameraoffsetx=cameraoffsetx+movespeed
		else
			protagX=protagX-movespeed
		end
	elseif dir=="right" then
		if protagX > (gw/2)+camthreshold and cameraoffsetx*-1 < (mapwidth*cellsize)-gw then
			cameraoffsetx=cameraoffsetx-movespeed
		else
			protagX=protagX+movespeed
		end
	end
end

function movementcontrols()
	calcx=protagX-cameraoffsetx 
	calcy=protagY-cameraoffsety
	playercell = getcell(calcx,calcy)
	
	if jumpheight>cellsize*2 then
		nojump=true
	elseif jumpheight==0 then
		if okaytomove("down") then
			moveplayer("down")
		end
	end

		
	if love.keyboard.isDown(" ") and nojump==false then
		if okaytomove("up") then
			if hookhop==true then
				moveplayer("hookhop")
			else
				moveplayer("up")
			end
		end
	elseif jumpheight > 0 then
		if okaytomove("down") then
			moveplayer("down")
		else 
			nojump=false
			jumpheight=0
		end
	end
	
	if love.keyboard.isDown("a") then
		playerfacing="left"
		if okaytomove(playerfacing) then
			moveplayer(playerfacing)
		end
	elseif love.keyboard.isDown("s") then

		--crouch
	elseif love.keyboard.isDown("d") then
		playerfacing="right"
		if okaytomove(playerfacing) then
			moveplayer(playerfacing)
		end
	end	
	
	if love.keyboard.isDown("lshift") then
		movespeed=defaultmovespeed*2
	else
		movespeed=defaultmovespeed
	end
	
	calcx=protagX-cameraoffsetx 
	calcy=protagY-cameraoffsety
end