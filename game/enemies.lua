i=1
enemysize=cellsize
enemymovespeed=0.075
function enemyai()
	n=table.maxn(enemies)
	i=1
	while i < n+1 do
		if enemies[i] ~=nil then
			tmpx=((enemies[i][1]*cellsize)+cameraoffsetx)
			tmpy=((enemies[i][2]*cellsize)+cameraoffsety)
			--dbg2= "\n" .. tmpx .. "  " .. (enemies[i][1]) .. "  " .. (enemies[i][2])
			if ( tmpx< gw and tmpx > 0 )then
				if enemies[i][1]-enemymovespeed> playercell.x then
					if npcokaytomove("left",enemies[i][1],enemies[i][2]) then
						enemies[i][1]=enemies[i][1] - enemymovespeed
					end
				elseif enemies[i][1]+enemymovespeed < playercell.x then
					if npcokaytomove("right",enemies[i][1],enemies[i][2]) then
						enemies[i][1]=enemies[i][1] + enemymovespeed
					end
				end
			end
		end
		i=i+1
	end

end
function npcokaytomove(dir,thex,they)
	
	--WORK OUT POTENTIAL POSITION X Y, CALCULATE CELL
	nc = (they * (mapwidth) +thex)
	nc=math.round("up",nc)
	
	if dir=="right" then
		nc=nc+1
	else
		nc=nc-1
	end
	
	
	--EMD OF CELL CALC
	dbg2="" .. nc
	
	--CHECK THE POTENTIAL CELL AGAINST MAP DATA
		--dbg2="" .. nc.x .. "   " .. nc.y .. "   " .. nc.c  .. "  " .. "\n" .. nc.c .. "  " .. nc2.c .. " " .. mapperms[nc.c] .. "  " ..  mapperms[nc2.c]
		if mapperms[nc] == 0 then --if 0 then free to move
			dbg2=dbg2 .. " canmove"
			return true
		else
			dbg2=dbg2 .. " cant move"
			return false
		end
end
function drawenemies()

	n=table.maxn(enemies)
	i=1
	while i < n+1 do
		if enemies[i] ~=nil then
			love.graphics.rectangle( "fill", (enemies[i][1]*cellsize)+cameraoffsetx, (enemies[i][2]*cellsize), cellsize, cellsize )
		end
	i=i+1
	end

end