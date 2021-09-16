local S = composting.translator;

local amount_limit = composting.settings.amount_limit;
local produced_per_clod = composting.settings.clod_cost;
local time_divider = composting.settings.composting_time_divider;

local base_production_time = ((365*24*3600)/amount_limit)/time_divider;

local function composter_update_node(pos, node)
  local meta = minetest.get_meta(pos)
  local amount = meta:get_int("amount");
  local produced = meta:get_int("produced");
  
  if (amount+produced)>0 then
    local C = meta:get_int("C") or 0;
    local N = meta:get_int("N") or 0;
    
    local line = math.floor(3.75*math.log(C/N) - 5 + 0.5);
    if (line<0) then
      line = 0;
    elseif (line>15) then
      line = 15;
    end
    local done = 0;
    if (produced>0) then
      done = math.floor(15*produced/(produced+amount)+0.5);
    end
    
    node.name = "composting:composter_filled";
    node.param2 = line*16+done;
    minetest.swap_node(pos, node);
    local timer = minetest.get_node_timer(pos);
    if not timer:is_started() then
      timer:start(base_production_time);
    end
    
    if (produced>=produced_per_clod) then
      meta:set_string("infotext", S("Compost clod."));
    elseif (amount==0) then
      meta:set_string("infotext", S("More biomase needed."));
    else
      meta:set_string("infotext", S("Composting in progress."));
    end
  else
    node.name = "composting:composter";
    minetest.set_node(pos, node);
  end
end

local function composter_on_punch(pos, node, puncher, pointed_thing)
  if puncher then
    local wield_item = puncher:get_wielded_item();
    local item_name = wield_item:get_name();
    
    local shovel = minetest.get_item_group(item_name, "shovel");
    if (shovel==0) then
      -- try to add biomase
      local item_def = wield_item:get_definition();
      if item_def and item_def._compost then
        local meta = minetest.get_meta(pos);
        local amount = meta:get_int("amount");
        local C = meta:get_int("C");
        local N = meta:get_int("N");
        amount = amount + item_def._compost.amount;
        if (amount<amount_limit) then
          C = C + item_def._compost.C;
          N = N + item_def._compost.N;
          meta:set_int("amount", amount);
          meta:set_int("C", C);
          meta:set_int("N", N);
          composter_update_node(pos, node, meta);
          wield_item:take_item();
          puncher:set_wielded_item(wield_item);
        end
      end
    else
      -- try to get compost clod
      local meta = minetest.get_meta(pos);
      local produced = meta:get_int("produced");
      
      if (produced>=produced_per_clod) then
        local amount = meta:get_int("amount");
        local C = meta:get_int("C");
        local N = meta:get_int("N");
        
        local part = produced_per_clod/(amount+produced);
          
        meta:set_int("C", math.floor(C*part+0.5));
        meta:set_int("N", math.floor(N*part+0.5));
        meta:set_int("produced", produced-produced_per_clod);
        
        local inv = puncher:get_inventory();
        local clod = ItemStack("composting:compost_clod");
        if (inv:room_for_item("main", clod)) then
          inv:add_item("main", clod);
        else
          minetest.add_item(pos, clod);
        end
      end
    end
  end
end

function composter_on_timer(pos, elapsed)
  local node = minetest.get_node(pos);
  local meta = minetest.get_meta(pos);
  local amount = meta:get_int("amount");
  local C = meta:get_int("C");
  local N = meta:get_int("N");
  local produced = meta:get_int("produced");
  
  if (amount>0) then
    amount = amount - 1;
    produced = produced + 1;
    
    meta:set_int("amount", amount);
    meta:set_int("produced", produced);
  end
  
  if C==0 then
    C = 1;
  end
  if N==0 then
    N = 1;
  end
  
  local ratio = C/N;
  local speed = 1/(((amount+produced)/amount_limit)^4);
  
  if ratio>32.5 then
    speed = speed*math.exp(ratio/500);
  else
    speed = speed*math.exp(ratio/25);
  end
  
  if (amount>0) then
    local timer = minetest.get_node_timer(pos);
    timer:set(base_production_time*speed, 0);
  end
  composter_update_node(pos, node, meta);
  
  return amount>0;
end

local short_desc = S("Composter");
local desc = short_desc;
local tt_help = S("Punch me with water bucket/wateringcan to make me more wet.");
if (minetest.get_modpath("tt")==nil) then
  desc = desc.."\n"..tt_help;
end

local node_sounds = nil
if minetest.get_modpath("default") then
  node_sounds = default.node_sound_wood_defaults();
end
if minetest.get_modpath("hades_sounds") then
  node_sounds = hades_sounds.node_sound_wood_defaults();
end
if minetest.get_modpath("sounds") then
  node_sounds = sounds.node_wood();
end

minetest.register_node("composting:composter", {
    short_description = short_desc,
    description = desc,
    _tt_help = tt_help,
    paramtype = "light",
    groups = {cracky = 2},
    is_ground_content = false,
    sounds = node_sounds,
    drawtype = "mesh",
    mesh = "composting_composter.obj",
    tiles = {
      "default_wood.png"
    },
    
    on_punch = composter_on_punch,
    on_construct = function (pos)
      local meta = minetest.get_meta(pos);
      print("on_construct: "..dump(meta:to_table()))
      meta:set_int("amount", 0)
      meta:set_int("N", 0)
      meta:set_int("C", 0)
      meta:set_int("production", 0)
    end,
  })

minetest.register_node("composting:composter_filled", {
    description = S("Filled Composter"),
    paramtype2 = "color",
    groups = {cracky = 2, not_in_creative_inventory = 1},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = node_sounds,
    drawtype = "mesh",
    mesh = "composting_composter_filled.obj",
    use_texture_alpha = "blend",
    tiles = {
        {name="default_wood.png",color="white"},
        "composting_composter_filled.png",
    },
    palette = "composting_composter_palette.png",
    
    on_punch = composter_on_punch,
    on_timer = composter_on_timer,
 })


