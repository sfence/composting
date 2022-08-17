local S = composting.translator

local time_divider = composting.settings.soil_time_divider;
local time_const_base = 365*24*3600/256;
local wet_points = composting.settings.wet_points;
local growth_acc_effect = composting.settings.growth_acc_effect;

composting.watering_cans = {}
composting.fertilize_items = {
  ["composting:compost_clod"] = 127
}

local node_soil = "farming:soil"
local node_soil_wet = "farming:soil_wet"

if minetest.get_modpath("hades_farming") then
  node_soil = "hades_farming:soil"
  node_soil_wet = "hades_farming:soil_wet"
end

if minetest.get_modpath("bucket") then
  -- bucket mod
  local function empty_bucket(puncher, itemstack)
    return ItemStack("bucket:bucket_empty");
  end
  
  composting.watering_cans["bucket:bucket_water"] = empty_bucket;
  composting.watering_cans["bucket:bucket_river_water"] = empty_bucket;
end
if minetest.get_modpath("hades_bucket") then
  local function hades_empty_bucket(puncher, itemstack)
    return ItemStack("hades_bucket:bucket_empty");
  end
  
  composting.watering_cans["hades_bucket:bucket_water"] = hades_empty_bucket;
  composting.watering_cans["hades_bucket:bucket_river_water"] = hades_empty_bucket;
end
if minetest.get_modpath("wateringcan") then
  
  local function empty_wateringcan(puncher, itemstack)
    if puncher then
      minetest.sound_play({name = "wateringcan_pour", gain = 0.25, max_hear_distance = 10}, { pos = puncher:get_pos() }, true)
    end
    itemstack:add_wear(2849); -- 24 uses
    if (itemstack:get_count()==0) then
      return ItemStack("wateringcan:wateringcan_empty");
    else
      return itemstack;
    end
  end
  
  composting.watering_cans["wateringcan:wateringcan_water"] = empty_wateringcan;
  
  if wateringcan and wateringcan.wettable_nodes then
    wateringcan.wettable_nodes["composting:garden_soil"] = function(pos)
        local node = minetest.get_node(pos);
        node.name = "composting:garden_soil_wet";
        node.param1 = wet_points;
        minetest.swap_node(pos, node);
      end
  end
end

local garden_soil_tiles = nil;
local garden_soil_wet_tiles = nil;
if minetest.get_modpath("farming") then
  garden_soil_tiles = {{name="farming_soil.png",color="white"}, ""};
  garden_soil_wet_tiles = {{name="farming_soil_wet.png",color="white"}, {name="farming_soil_wet_side.png",color="white"}};
end
if minetest.get_modpath("hades_farming") then
  garden_soil_tiles = {{name="hades_farming_soil.png",color="white"}, ""};
  garden_soil_wet_tiles = {{name="hades_farming_soil_wet.png",color="white"}, {name="hades_farming_soil_wet_side.png",color="white"}};
end

-- garden soil
local function effect_of_flora(pos, growth_accel)
  local pos = vector.add(pos, vector.new(0,1,0));
  local node = minetest.get_node(pos);
  local plant = minetest.get_item_group(node.name, "plant");
  if (plant>0) then
    if growth_accel then
      local timer = minetest.get_node_timer(pos);
      local timeout = timer:get_timeout();
      if (timeout>0) then
        local elapsed = timer:get_elapsed();
        timer:set(timeout, elapsed+timeout*growth_accel);
      end
    end
    return 2;
  else
    return 1;
  end
end

local drop_dirt = "default:dirt";
if minetest.get_modpath("hades_core") then
  drop_dirt = "hades_core:dirt"
end

local short_desc = S("Garden Soil");
local desc = short_desc;
local tt_help = S("Punch me with water bucket/wateringcan to make me wet.").."\n"..S("Punch me with compost clod under garden trowel to make me more fertile.");
if (minetest.get_modpath("tt")==nil) then
  desc = desc.."\n"..tt_help;
end

local node_sounds = nil
if minetest.get_modpath("default") then
  node_sounds = default.node_sound_dirt_defaults();
end
if minetest.get_modpath("hades_sounds") then
  node_sounds = hades_sounds.node_sound_dirt_defaults();
end
if minetest.get_modpath("sounds") then
  node_sounds = sounds.node_dirt();
end

minetest.register_node("composting:garden_soil", {
    short_description = short_desc,
    description = desc,
    _tt_help = tt_help,
    paramtype2 = "color",
    palette = "composting_garden_soil_palette.png",
    color = "#6A4B31",
    tiles = {"composting_garden_soil.png"},
    overlay_tiles = garden_soil_tiles,
    -- soil have to be 2, because farming code detect wet soil via soil value
    groups = {crumbly = 3, soil = 2, grassland = 1},
    drop = drop_dirt,
    sounds = node_sounds,
    on_construct = function(pos)
      local node = minetest.get_node(pos);
      node.param2 = 255;
      minetest.swap_node(pos, node);
      local timer = minetest.get_node_timer(pos);
      timer:start((time_const_base/time_divider)/effect_of_flora(pos));
    end,
    on_timer = function(pos, elapsed)
      local node = minetest.get_node(pos);
      if (node.param2>0) then
        node.param2 = node.param2-1;
        if minetest.find_node_near(pos, 3, {"group:water"}) then
          node.name = "composting:garden_soil_wet";
        end
        minetest.swap_node(pos, node);
        local timer = minetest.get_node_timer(pos);
        --print(dump(pos)..timer:get_timeout().." gt:"..minetest.get_gametime())
        timer:set((time_const_base/time_divider)/effect_of_flora(pos), 0);
        return false;
      else
        minetest.set_node(pos, {name=node_soil});
      end
      return false;
    end,
    on_punch = function(pos, node, puncher)
      if puncher then
        local item = puncher:get_wielded_item();
        local item_name = item:get_name();
        local watering_can = composting.watering_cans[item_name];
        if watering_can then
          node.name = "composting:garden_soil_wet"
          node.param1 = wet_points;
          minetest.swap_node(pos, node);
          puncher:set_wielded_item(watering_can(puncher, item));
          return
        end
      end
    end,
  })

local short_desc = S("Wet Garden Soil");
local desc = short_desc;
local tt_help = S("Punch me with water bucket/wateringcan to make me more wet.");
if (minetest.get_modpath("tt")==nil) then
  desc = desc.."\n"..tt_help;
end
minetest.register_node("composting:garden_soil_wet", {
    short_description = short_desc,
    description = desc,
    _tt_help = tt_help,
    paramtype2 = "color",
    palette = "composting_garden_soil_palette.png",
    color = "$6A4B31",
    tiles = {"composting_garden_soil_wet.png"},
    overlay_tiles = garden_soil_wet_tiles,
    groups = {crumbly = 3, soil = 6, grassland = 1, wet = 1, not_in_creative_inventory = 1},
    drop = drop_dirt,
    sounds = node_sounds,
    on_construct = function(pos)
      local node = minetest.get_node(pos);
      node.param2 = 255;
      node.param1 = wet_points;
      minetest.swap_node(pos, node);
      local timer = minetest.get_node_timer(pos);
      timer:start(((time_const_base/2)/time_divider)/effect_of_flora(pos));
    end,
    on_timer = function(pos, elapsed)
      local node = minetest.get_node(pos);  
      if (node.param2>0) then
        local timer_const = time_const_base/2;
        node.param2 = node.param2-1;
        if minetest.find_node_near(pos, 3, {"group:water"}) then
          node.param1 = wet_points;
        end
        if (node.param1>0) then
          node.param1 = node.param1-1;
        else
          if not minetest.find_node_near(pos, 3, {"ignore"}) then
            node.name = "composting:garden_soil";
            timer_const = time_const_base;
          end
        end
        minetest.swap_node(pos, node);
        local flora_effect = effect_of_flora(pos, growth_acc_effect*node.param2/255.0);
        local timer = minetest.get_node_timer(pos);
        --print(dump(pos)..timer:get_timeout().." gt:"..minetest.get_gametime())
        timer:start((timer_const/time_divider)/flora_effect);
        return false;
      elseif (node.param1>0) then
        minetest.set_node(pos, {name=node_soil_wet});
      else
        minetest.set_node(pos, {name=node_soil});
      end
      return false;
    end,
    on_punch = function(pos, node, puncher)
      if puncher then
        local item = puncher:get_wielded_item();
        local item_name = item:get_name();
        local watering_can = composting.watering_cans[item_name];
        if watering_can then
          node.param1 = node.param1+wet_points;
          if (node.param1>wet_points) then
            node.param1 = wet_points;
          end
          minetest.swap_node(pos, node);
          puncher:set_wielded_item(watering_can(puncher, item));
          return
        end
      end
    end,
  })

