bulletsx={}
bulletsy={}
bulletsfacing={}
i=1


function othercontrols()
	if love.keyboard.isDown("return") then
		table.insert(bulletsx, i, protagX)
		table.insert(bulletsy, i, protagY)
		table.insert(bulletsfacing, i, playerfacing)
		i=i+1
	end

end

function dobullets()
	n=table.maxn(bulletsx)
	i=1
	while i < n+1 do
		if bulletsx[i] ~=nil then
			if bulletsfacing[i]=="right" then
				bulletsx[i]=bulletsx[i]+defaultmovespeed*3
			elseif bulletsfacing[i]=="left" then
				bulletsx[i]=bulletsx[i]-defaultmovespeed*3
			end
			love.graphics.circle( "fill", bulletsx[i], bulletsy[i], 8, 8 )
			if bulletsx[i]>(gw-100) or bulletsx[i]<(100) then
				table.remove(bulletsx, i)
				table.remove(bulletsy, i)
			end
		end
		i=i+1
	end
end