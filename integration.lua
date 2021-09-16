

function composting.add_composting_data(item_name, compost_data)
  if minetest.registered_items[item_name] then
    minetest.override_item(item_name, {
        _compost = compost_data
      })
  else
    minetest.log("error", "Adding composting data to item "..item_name.." failed. Item doesn't exist.");
  end
end

local leaves = {};
local needles = {};
local stems = {};
local grass_1 = {};
local grass_3 = {};
local grass_5 = {};
local dry_grass_5 = {};

if minetest.get_modpath("default") then
  -- leaves
  table.insert(leaves, "default:bush_leaves");
  table.insert(leaves, "default:acacia_bush_leaves");
  table.insert(leaves, "default:blueberry_bush_leaves");
  table.insert(leaves, "default:acacia_bush_leaves");
  table.insert(leaves, "default:leaves");
  table.insert(leaves, "default:jungleleaves");
  table.insert(leaves, "default:acacia_leaves");
  table.insert(leaves, "default:aspen_leaves");
  -- needles
  table.insert(needles, "default:pine_bush_needles");
  table.insert(needles, "default:pine_needles");
  -- stems
  table.insert(stems, "default:dry_shrub");
  table.insert(stems, "default:bush_stem");
  table.insert(stems, "default:acacia_bush_stem");
  table.insert(stems, "default:pine_bush_stem");
  -- grass 1
  table.insert(grass_1, "default:junglegrass");
  -- grass 3
  table.insert(grass_3, "default:fern_");
  table.insert(grass_3, "default:marram_grass_");
  -- grass 5
  table.insert(grass_5, "default:grass_");
  table.insert(dry_grass_5, "default:dry_grass_");
end
if minetest.get_modpath("hades_core") then
  -- leaves
  table.insert(leaves, "hades_trees:banana_leaves");
  table.insert(leaves, "hades_trees:birch_leaves");
  table.insert(leaves, "hades_trees:canvas_leaves");
  table.insert(leaves, "hades_trees:cultivated_jungle_leaves");
  table.insert(leaves, "hades_trees:jungle_leaves");
  table.insert(leaves, "hades_trees:leaves");
  table.insert(leaves, "hades_trees:olive_leaves");
  table.insert(leaves, "hades_trees:orange_leaves");
  table.insert(leaves, "hades_trees:pale_leaves");
  -- grass 1
  table.insert(grass_1, "hades_grass:junglegrass");
  -- grass 3
  -- grass 5
  table.insert(grass_5, "hades_grass:grass_");
  table.insert(dry_grass_5, "hades_grass:dead_grass_");
end

-- leaves
for _,item_name in pairs(leaves) do
  composting.add_composting_data(item_name, {
      amount = 15,
      C = 14921, -- 190:1 branches with leaves
      N = 79,
    })
end
-- needles
for _,item_name in pairs(needles) do
  composting.add_composting_data(item_name, {
      amount = 15,
      C = 14925, -- 200:1 branches with needles
      N = 75,
    })
end
-- stems
for _,item_name in pairs(stems) do
  composting.add_composting_data(item_name, {
      amount = 7,
      C = 6969, -- 226:1 wood mass
      N = 31,
    })
end
-- grass 1
for _,item_name in pairs(stems) do
  composting.add_composting_data("default:junglegrass", {
      amount = 3,
      C = math.floor(2833), -- 17:1 
      N = math.floor(167),
    })
end
-- grass 3
for i=1,3 do
  local part = i/3;
  for _,item_name in pairs(grass_3) do
    composting.add_composting_data(item_name..i, {
        amount = 1+math.floor(2*part),
        C = math.floor(2833*part), -- 17:1 
        N = math.floor(167*part),
      })
  end
end
-- grass 5
for i=1,5 do
  local part = i/5;
  for _,item_name in pairs(grass_5) do
    composting.add_composting_data(item_name..i, {
        amount = 1+math.floor(2*part),
        C = math.floor(2833*part), -- 17:1 
        N = math.floor(167*part),
      })
  end
  for _,item_name in pairs(dry_grass_5) do
    composting.add_composting_data(item_name..i, {
        amount = 1+math.floor(2*part),
        C = math.floor(2885*part), -- 25:1 
        N = math.floor(115*part),
      })
  end
end

