
if minetest.get_modpath("default") then
  minetest.register_craft({
    type = "shapeless",
    output = "default:dirt",
    recipe = {
      "default:dry_dirt",
      "composting:compost_clod",
    }
  })  
end

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

local metal_ingot = "default:steel_ingot"
local motor = "basic_materials:motor"
local transformer = "basec_materials:copper_wire"

if minetest.get_modpath("technic") then
  metal_ingot = "technic:carbon_steel_ingot"
  transformer = "technic:lv_transformer"
end
if minetest.get_modpath("hades_core") then
  metal_ingot = "hades_core:steel_ingot"
end
if minetest.get_modpath("hades_technic") then
  metal_ingot = "hades_technic:carbon_steel_ingot"
  transformer = "hades_technic:lv_transformer"
end

minetest.register_craft({
	output = "composting:electric_composter",
	recipe = {
		{metal_ingot, motor, metal_ingot},
		{metal_ingot, transformer, metal_ingot},
		{metal_ingot, metal_ingot, metal_ingot}
	}
})

