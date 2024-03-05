showchatscreen=false
chattingwith = "null"
npcchatpicture = null
npcscript = "null"
chatoverlay = love.graphics.newImage("assets/images/chatoverlay.png")
npcchatindex = 1
function chat(name)
	chattingwith = name
	npcchatpicture = love.graphics.newImage("npcs/" .. name .. "/picture.png")
	love.filesystem.load("npcs/" ..name.. "/script.lua")()
	love.filesystem.load("objectives/" ..objectiveid.. ".lua")()

	--check objectives table, if any has "talkto" then check the name, and tick it off if it matches
	checkobjectivestring = stringsplit(objectivetype,":")
	if  checkobjectivestring[1] == "talkto" then
		if  checkobjectivestring[2] == name then
			objectivecompleted()
		end
	end
	showchatscreen=true
end