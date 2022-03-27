
-- ratio -> C:N -> ratio:1
function composting.add_composting_data(item_name, amount, ratio)
  if minetest.registered_items[item_name] then
    local C = math.floor(amount*1000*ratio/(ratio+1));
    local N = amount*1000-C;
    minetest.override_item(item_name, {
        _compost = {
          amount = amount,
          C = C,
          N = N,
        }
      })
  else
    minetest.log("error", "Adding composting data to item "..item_name.." failed. Item doesn't exist.");
  end
end

local leaves = {};
local dry_leaves = {};
local needles = {};
local saplings = {};
local stems = {};
local grass_1 = {};
local grass_3 = {};
local grass_5 = {};
local dry_grass_5 = {};
local vines = {}

local compostable = {}

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
  -- saplings
  table.insert(saplings, "default:acacia_bush_sapling"); 
  table.insert(saplings, "default:acacia_sapling"); 
  table.insert(saplings, "default:aspen_sapling"); 
  table.insert(saplings, "default:blueberry_bush_sapling"); 
  table.insert(saplings, "default:bush_sapling"); 
  table.insert(saplings, "default:emergent_jungle_sapling"); 
  table.insert(saplings, "default:junglesapling"); 
  table.insert(saplings, "default:pine_bush_sapling"); 
  table.insert(saplings, "default:pine_sapling"); 
  table.insert(saplings, "default:sapling"); 
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
if minetest.get_modpath("farming") then
  compostable["farming:wheat"] = {amount=4,ratio=120}
  compostable["farming:straw"] = {amount=16,ratio=120}
end
if minetest.get_modpath("darkage") then
  compostable["darkage:straw_bale"] = {amount=64,ratio=120}
end
if minetest.get_modpath("hades_trees") then
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
  table.insert(stems, "hades_trees:burned_branches")
  table.insert(saplings, "hades_trees:banana_sapling"); 
  table.insert(saplings, "hades_trees:birch_sapling"); 
  table.insert(saplings, "hades_trees:canvas_sapling"); 
  table.insert(saplings, "hades_trees:cocoa_sapling"); 
  table.insert(saplings, "hades_trees:coconut_sapling"); 
  table.insert(saplings, "hades_trees:cultivated_jungle_sapling"); 
  table.insert(saplings, "hades_trees:jungle_sapling"); 
  table.insert(saplings, "hades_trees:olive_sapling"); 
  table.insert(saplings, "hades_trees:orange_sapling"); 
  table.insert(saplings, "hades_trees:pale_sapling"); 
  table.insert(saplings, "hades_trees:sapling"); 
end
if minetest.get_modpath("hades_grass") then
  -- grass 1
  table.insert(grass_1, "hades_grass:junglegrass");
  -- grass 3
  -- grass 5
  table.insert(grass_5, "hades_grass:grass_");
  table.insert(dry_grass_5, "hades_grass:dead_grass_");
end
if minetest.get_modpath("hades_vines") then
  -- vines
  table.insert(vines, "hades_vines:cave")
  table.insert(vines, "hades_vines:cave_rotten")
  table.insert(vines, "hades_vines:jungle")
  table.insert(vines, "hades_vines:jungle_rotten")
  table.insert(vines, "hades_vines:willow")
  table.insert(vines, "hades_vines:willow_rotten")
  table.insert(vines, "hades_vines:root")
end
if minetest.get_modpath("baldcypress") or minetest.get_modpath("hades_baldcypress") then
  table.insert(leaves, "baldcypress:leaves");
  table.insert(vines, "baldcypress:liana")
  table.insert(stems, "baldcypress:dry_branches")
  table.insert(saplings, "baldcypress:sapling"); 
end
if minetest.get_modpath("bamboo") or minetest.get_modpath("hades_bamboo") then
  table.insert(leaves, "bamboo:leaves");
  compostable["bamboo:sprout"] = {amount=5,ratio=75}
end
if minetest.get_modpath("birch") or minetest.get_modpath("hades_birch") then
  table.insert(leaves, "birch:leaves");
  table.insert(saplings, "birch:sapling"); 
end
if minetest.get_modpath("cherrytree") or minetest.get_modpath("hades_cherrytree") then
  table.insert(leaves, "cherrytree:leaves");
  compostable["cherrytree:blossom_leaves"] = {amount=15,ratio=170}
  table.insert(saplings, "cherrytree:sapling"); 
end
if minetest.get_modpath("chesnuttree") or minetest.get_modpath("hades_chesnuttree") then
  table.insert(leaves, "chesnuttree:leaves");
  table.insert(saplings, "chesnuttree:sapling"); 
end
if minetest.get_modpath("clementinetree") or minetest.get_modpath("hades_clementinetree") then
  table.insert(leaves, "clementinetree:leaves");
  table.insert(saplings, "clementinetree:sapling"); 
end
if minetest.get_modpath("ebony") or minetest.get_modpath("hades_ebony") then
  table.insert(leaves, "ebony:leaves");
  table.insert(vines, "ebony:liana")
  compostable["ebony:creeper"] = {amount=5,ratio=70}
  compostable["ebony:creeper_leaves"] = {amount=6,ratio=50}
  table.insert(saplings, "ebony:sapling"); 
end
if minetest.get_modpath("cacaotree") or minetest.get_modpath("hades_cacaotree") then
  table.insert(leaves, "cacaotree:leaves");
  table.insert(vines, "cacaotree:liana")
  table.insert(saplings, "cacaotree:sapling"); 
end
if minetest.get_modpath("chestnuttree") or minetest.get_modpath("hades_chestnuttree") then
  table.insert(leaves, "chestnuttree:leaves");
  table.insert(saplings, "chestnuttree:sapling"); 
end
if minetest.get_modpath("hollytree") or minetest.get_modpath("hades_hollytree") then
  table.insert(leaves, "hollytree:leaves");
  table.insert(saplings, "hollytree:sapling"); 
end
if minetest.get_modpath("jacaranda") or minetest.get_modpath("hades_jacaranda") then
  compostable["jacaranda:blossom_leaves"] = {amount=15,ratio=170}
  table.insert(saplings, "jacaranda:sapling"); 
end
if minetest.get_modpath("larch") or minetest.get_modpath("hades_larch") then
  table.insert(leaves, "larch:leaves");
  table.insert(saplings, "larch:sapling"); 
  compostable["larch:moss"] = {amount=1,ratio=30}
end
if minetest.get_modpath("lemontree") or minetest.get_modpath("hades_lemontree") then
  table.insert(leaves, "lemontree:leaves");
  table.insert(saplings, "lemontree:sapling"); 
end
if minetest.get_modpath("mahogany") or minetest.get_modpath("hades_mahogany") then
  table.insert(leaves, "mahogany:leaves");
  table.insert(saplings, "mahogany:sapling"); 
end
if minetest.get_modpath("maple") or minetest.get_modpath("hades_maple") then
  table.insert(leaves, "maple:leaves");
  table.insert(saplings, "maple:sapling"); 
end
if minetest.get_modpath("oak") or minetest.get_modpath("hades_oak") then
  table.insert(leaves, "oak:leaves");
  table.insert(saplings, "oak:sapling"); 
end
if minetest.get_modpath("palm") or minetest.get_modpath("hades_palm") then
  compostable["palm:leaves"] = {amount=8,ratio=150}
  table.insert(saplings, "palm:sapling"); 
end
if minetest.get_modpath("plumtree") or minetest.get_modpath("hades_plumtree") then
  table.insert(leaves, "plumtree:leaves");
  table.insert(saplings, "plumtree:sapling"); 
end
if minetest.get_modpath("pomegranate") or minetest.get_modpath("hades_pomegranate") then
  table.insert(leaves, "pomegranate:leaves");
  table.insert(saplings, "pomegranate:sapling"); 
end
if minetest.get_modpath("sequoia") or minetest.get_modpath("hades_sequoia") then
  table.insert(leaves, "sequoia:leaves");
  table.insert(saplings, "sequoia:sapling"); 
end
if minetest.get_modpath("willow") or minetest.get_modpath("hades_willow") then
  table.insert(leaves, "willow:leaves");
  table.insert(saplings, "willow:sapling"); 
end
if minetest.get_modpath("technic") then
  compostable["technic:common_tree_grindings"] = {amount=64,ratio=500}
  compostable["technic:sawdust"] = {amount=64,ratio=500}
end
if minetest.get_modpath("paleotest") then
  table.insert(leaves, "paleotest:metasequoia_leaves");
  table.insert(saplings, "paleotest:metasequoia_sapling"); 
end
if minetest.get_modpath("technic") or minetest.get_modpath("hades_technic") or minetest.get_modpath("moretrees")  then
  table.insert(leaves, "moretrees:rubber_tree_leaves");
  table.insert(saplings, "moretrees:rubber_tree_sapling"); 
end
if minetest.get_modpath("hades_farming") then
  compostable["hades_farming:wheat"] = {amount=4,ratio=120}
  compostable["hades_farming:straw"] = {amount=16,ratio=120}
end
if minetest.get_modpath("hades_darkage") then
  compostable["hades_darkage:straw_bale"] = {amount=64,ratio=120}
end
if minetest.get_modpath("hades_technic") then
  compostable["hades_technic:common_tree_grindings"] = {amount=64,ratio=500}
  compostable["hades_technic:sawdust"] = {amount=64,ratio=500}
end

-- leaves
for _,item_name in pairs(leaves) do
  -- 190:1 branches with leaves
  composting.add_composting_data(item_name, 15, 190);
end
for _,item_name in pairs(dry_leaves) do
  -- 195:1 branches with dry leaves
  composting.add_composting_data(item_name, 15, 195);
end
-- needles
for _,item_name in pairs(needles) do
  -- 200:1 branches with needles
  composting.add_composting_data(item_name, 15, 200);
end
-- saplings
for _,item_name in pairs(saplings) do
  -- 125:1 saplings
  composting.add_composting_data(item_name, 5, 125);
end
-- stems
for _,item_name in pairs(stems) do
  -- 226:1 wood mass
  composting.add_composting_data(item_name, 7, 226);
end
-- grass 1
for _,item_name in pairs(grass_1) do
  composting.add_composting_data(item_name, 3, 17);
end
-- grass 3
for i=1,3 do
  local part = i/3;
  for _,item_name in pairs(grass_3) do
    composting.add_composting_data(item_name..i, 1+math.floor(2*part), 17);
  end
end
-- grass 5
for i=1,5 do
  local part = i/5;
  for _,item_name in pairs(grass_5) do
    composting.add_composting_data(item_name..i, 1+math.floor(2*part), 17);
  end
  for _,item_name in pairs(dry_grass_5) do
    composting.add_composting_data(item_name..i, 1+math.floor(2*part), 25);
  end
end
-- vines
for _,item_name in pairs(vines) do
  composting.add_composting_data(item_name, 6, 60);
end
-- compostable
for item_name,item_data in pairs(compostable) do
  composting.add_composting_data(item_name, item_data.amount, item_data.ratio);
end
