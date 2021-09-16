
minetest.register_craft({
	output = "composting:garden_soil",
	recipe = {
		{"composting:compost_clod", "default:dirt", "composting:compost_clod"},
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

