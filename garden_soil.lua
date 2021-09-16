local S = composting.translator

local time_divider = composting.settings.soil_time_divider;

composting.watering_cans = {}

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
end

local garden_soil_tiles = {"composting_garden_soil.png"};
local garden_soil_wet_tiles = {"composting_garden_soil_wet.png"};
if minetest.get_modpath("farming") then
  garden_soil_tiles = {"composting_garden_soil.png^farming_soil.png", "composting_garden_soil.png"};
  garden_soil_tiles = {"composting_garden_soil_wet.png^farming_soil_wet.png", "composting_garden_soil.png^farming_soil_wet_side.png"};
end
if minetest.get_modpath("hades_farming") then
  garden_soil_tiles = {"composting_garden_soil.png^hades_farming_soil.png", "composting_garden_soil.png"};
  garden_soil_tiles = {"composting_garden_soil_wet.png^hades_farming_soil_wet.png", "composting_garden_soil.png^hades_farming_soil_wet_side.png"};
end

-- garden soil
local function effect_of_flora(pos)
  local pos = vector.add(pos, vector.new(0,1,0));
  local node = minetest.get_node(pos);
  local flora = minetest.get_item_group(node.name, "flora");
  if (flora>0) then
    return 2;
  else
    return 1;
  end
end

local short_desc = S("Garden Soil");
local desc = short_desc;
local tt_help = S("Punch me with water bucket/wateringcan to make me wet.");
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
    tiles = {"composting_garden_soil.png"},
    -- soil have to be 2, because farming code detect wet soil via soil value
    groups = {crumbly = 3, soil = 2, grassland = 1},
    drop = "default:dirt",
    sounds = node_sounds,
    on_construct = function(pos)
      local node = minetest.get_node(pos);
      node.param1 = 255;
      minetest.swap_node(pos, node);
      local timer = minetest.get_node_timer(pos);
      timer:start((3422/time_divider)/effect_of_flora(pos));
    end,
    on_timer = function(pos, elapsed)
      local node = minetest.get_node(pos);  
      if (node.param1>0) then
        node.param1 = node.param1-1;
        if minetest.find_node_near(pos, 3, {"group:water"}) then
          node.name = "composting:garden_soil_wet";
        end
        minetest.swap_node(pos, node);
        local timer = minetest.get_node_timer(pos);
        timer:start((3422/time_divider)/effect_of_flora(pos));
        return true;
      else
        minetest.set_node(pos, {name="farming:soil"});
      end
      return false;
    end,
    on_punch = function(pos, node, puncher)
      if puncher then
        local item = puncher:get_wielded_item();
        local watering_can = composting.watering_cans[item:get_name()];
        if watering_can then
          node.name = "composting:garden_soil_wet"
          node.param2 = 4;
          minetest.swap_node(pos, node);
          puncher:set_wielded_item(watering_can(puncher, item));
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
    tiles = {"composting_garden_soil_wet.png"},
    groups = {crumbly = 3, soil = 5, grassland = 1, wet = 1, not_in_creative_inventory = 1},
    drop = "default:dirt",
    sounds = node_sounds,
    on_construct = function(pos)
      local node = minetest.get_node(pos);
      node.param1 = 255;
      node.param2 = 4;
      minetest.swap_node(pos, node);
      local timer = minetest.get_node_timer(pos);
      timer:start((1711/time_divider)/effect_of_flora(pos));
    end,
    on_timer = function(pos, elapsed)
      local node = minetest.get_node(pos);  
      if (node.param1>0) then
        local timer_const = 3422;
        node.param1 = node.param1-1;
        if minetest.find_node_near(pos, 3, {"group:water"}) then
          node.param2 = 4;
        end
        if (node.param2>0) then
          node.param2 = node.param2-1;
        else
          if not minetest.find_node_near(pos, 3, {"ignore"}) then
            node.name = "composting:garden_soil";
            timer_const = 1711;
          end
        end
        minetest.swap_node(pos, node);
        local timer = minetest.get_node_timer(pos);
        timer:start((timer_const/time_divider)/effect_of_flora(pos));
        return true;
      elseif (node.param2>0) then
        minetest.set_node(pos, {name="farming:soil_wet"});
      else
        minetest.set_node(pos, {name="farming:soil"});
      end
      return false;
    end,
    on_punch = function(pos, node, puncher)
      if puncher then
        local item = puncher:get_wielded_item();
        local watering_can = composting.watering_cans[item:get_name()];
        if watering_can then
          node.param2 = node.param2+4;
          if (node.param2>5) then
            node.param2 = 5;
          end
          minetest.swap_node(pos, node);
          puncher:set_wielded_item(watering_can(puncher, item));
        end
      end
    end,
  })

