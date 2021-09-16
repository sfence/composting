
composting = {
  translator = minetest.get_translator("composting"),
  
}

local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/settings.lua")

dofile(modpath.."/composter.lua")
--dofile(modpath.."/electric_composter.lua")

dofile(modpath.."/integration.lua")

dofile(modpath.."/garden_soil.lua")

dofile(modpath.."/craftitems.lua")
dofile(modpath.."/crafting.lua")
