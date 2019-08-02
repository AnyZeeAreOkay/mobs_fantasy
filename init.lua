
local path = minetest.get_modpath("mobs_fantasy")

-- Intllib
local S
if minetest.global_exists("intllib") then
	if intllib.make_gettext_pair then
		-- New method using gettext.
		S = intllib.make_gettext_pair()
	else
		-- Old method using text files.
		S = intllib.Getter()
	end
else
	S = function(s) return s end
end
mobs.intllib = S

-- Monsters
dofile(path .. "/imp.lua")

dofile(path .. "/fire_elemental.lua")
