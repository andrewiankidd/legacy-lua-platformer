--	DO NOT EDIT -- DO NOT EDIT -- DO NOT EDIT -- DO NOT EDIT -- DO NOT EDIT -- DO NOT EDIT -- DO NOT EDIT                                                                   
 --	 ____           _____ _____ _____   ______ _    _ _   _  _____ _______ _____ ____  _   _  _____ 
 --	|  _ \   /\    / ____|_   _/ ____| |  ____| |  | | \ | |/ ____|__   __|_   _/ __ \| \ | |/ ____|
 --	| |_) | /  \  | (___   | || |      | |__  | |  | |  \| | |       | |    | || |  | |  \| | (___  
 --	|  _ < / /\ \  \___ \  | || |      |  __| | |  | | . ` | |       | |    | || |  | | . ` |\___ \ 
 --	| |_) / ____ \ ____) |_| || |____  | |    | |__| | |\  | |____   | |   _| || |__| | |\  |____) |
 --	|____/_/    \_\_____/|_____\_____| |_|     \____/|_| \_|\_____|  |_|  |_____\____/|_| \_|_____/ 
                                                                                                 
--	DO NOT EDIT -- DO NOT EDIT -- DO NOT EDIT -- DO NOT EDIT -- DO NOT EDIT -- DO NOT EDIT -- DO NOT EDIT                                                                   

function math.round(dir, num)
	if dir=="up" then
    return math.floor(num+0.5)
	elseif dir=="down" then
    return math.floor(num+0.0)
	else
	return 0
	end
end
function implode(d,p)
  local newstr
  newstr = ""
  if(#p == 1) then
    return p[1]
  end
  for ii = 1, (#p-1) do
    newstr = newstr .. p[ii] .. d
  end
  newstr = newstr .. p[#p]
  return newstr
end
function stringsplit(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end