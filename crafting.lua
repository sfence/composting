
local dirt = "default:dirt";
if minetest.get_modpath("hades_core") then
  dirt = "hades_core:dirt";
end

minetest.register_craft({
	output = "composting:garden_soil",
	recipe = {
		{"composting:compost_clod", dirt, "composting:compost_clod"},
	}
})

local wood = "group:wood";

minetest.register_craft({
	output = "composting:composter",
	recipe = {
		{wood, "", wood},
		{wood, "", wood},
		{wood, "", wood}
	}
})

