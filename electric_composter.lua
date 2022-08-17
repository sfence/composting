------------------------
-- Electric Composter --
------------------------
------- Ver 1.0 --------
-----------------------
-- Initial Functions --
-----------------------
local S = composting.translator;

composting.electric_composter = appliances.appliance:new(
    {
      node_name_inactive = "composting:electric_composter",
      node_name_active = "composting:electric_composter_active",
      
      node_description = S("Electric Composter"),
    	node_help = S("Accelerate composting process of biomaterial."),
      
      usage_stack = 0,
      have_usage = false,
      
      sounds = {
        running = {
          sound = "composting_electric_composter_running",
          sound_param = {max_hear_distance = 16, gain = 1},
          repeat_timer = 4,
        },
      },
    })

local electric_composter = composting.electric_composter

electric_composter:item_data_register(
  {
    ["tube_item"] = {
      },
    ["techage_item"] = {
      },
    ["minecart_item"] = {
      },
  })
electric_composter:power_data_register(
  {
    ["no_power"] = {
        disable = {}
      },
    ["LV_power"] = {
        demand = 100,
        run_speed = 1,
        disable = {"no_power"}
      },
    ["power_generators_electric_power"] = {
        demand = 100,
        run_speed = 1,
        disable = {"no_power"}
      },
    ["elepower_power"] = {
        demand = 8,
        run_speed = 1,
        disable = {"no_power"}
      },
    ["techage_electric_power"] = {
        demand = 40,
        run_speed = 1,
        disable = {"no_power"}
      },
    ["factory_power"] = {
        demand = 5,
        run_speed = 1,
        disable = {"no_power"}
      },
  })

electric_composter.node_help = S("Connect to power (@1).", electric_composter:get_power_help()).."\n"..electric_composter.node_help

--------------
-- Formspec --
--------------

---------------
-- Callbacks --
---------------

local compost_per_clod = composting.settings.clod_cost
local electric_composter_time = composting.settings.electric_composter_time

local function input_on_done(self, timer_step, output)
  local compost = timer_step.meta:get_int("compost")
  compost = compost + timer_step.use_input.amount
  if compost>=compost_per_clod then
    timer_step.meta:set_int("compost", compost-compost_per_clod)
    return {"composting:compost_clod"}
  end
  timer_step.meta:set_int("compost", compost)
  return {""}
end

function electric_composter:recipe_aviable_input(inventory)
  local input_stack = inventory:get_stack(self.input_stack, 1)
  local input_def = input_stack:get_definition()
  
  if input_def._compost then
    local input = {
        inputs = 1,
        outputs = {"composting:compost_clod"},
        on_done = input_on_done,
        production_time = input_def._compost.amount*electric_composter_time,
        amount = input_def._compost.amount,
      }
    return input, nil
  end
  return nil, nil
end

function electric_composter:recipe_inventory_can_put(pos, listname, index, stack, player)
  local input_def = stack:get_definition()
  if input_def._compost then
    return stack:get_count()
  end
  return 0
end

function electric_composter:recipe_inventory_can_take(pos, listname, index, stack, player_name)
  if player_name then
    if minetest.is_protected(pos, player_name) then
      return 0
    end
  end
  local count = stack:get_count();
  local meta = minetest.get_meta(pos);
  if (listname==self.input_stack) then
    if count>0 then
      local production_time = meta:get_int("production_time")
      if (production_time>0) then
        return count-1
      end
    end
  end
  return count
end

----------
-- Node --
----------

local node_sounds = nil
if minetest.get_modpath("default") then
  node_sounds = default.node_sound_metal_defaults();
end
if minetest.get_modpath("hades_sounds") then
  node_sounds = hades_sounds.node_sound_metal_defaults();
end
if minetest.get_modpath("sounds") then
  node_sounds = sounds.node_metal();
end

-- node box {x=0, y=0, z=0}
local node_box = {
  type = "fixed",
  fixed = {
    {-0.4375,-0.375,-0.4375,0.4375,0.25,0.4375},
    {-0.4375,0.375,-0.4375,0.4375,0.5,0.4375},
    {-0.375,-0.5,-0.375,0.375,-0.375,0.375},
    {-0.375,0.25,-0.375,0.375,0.375,0.375},
    {-0.5,-0.1875,-0.1875,-0.4375,0.1875,0.1875},
    {0.4375,-0.1875,-0.1875,0.5,0.1875,0.1875},
    {-0.0625,-0.0625,0.4375,0.0625,0.0625,0.5},
  },
}

local node_def = {
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 2},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = node_sounds,
    drawtype = "mesh",
    mesh = "composting_electric_composter.obj",
    use_texture_alpha = "blend",
    collision_box = node_box,
    selection_box = node_box,
 }

local node_inactive = {
    tiles = {
        "composting_electric_composter_body.png",
        "composting_electric_composter_body2.png",
        "composting_electric_composter_power.png",
        "composting_electric_composter_tube.png",
    },
  }

local node_active = {
    tiles = {
        {
          image = "composting_electric_composter_body_active.png",
          animation = {
            type = "vertical_frames",
            aspect_w = 16,
            aspect_h = 16,
            length = 2
          }
        },
        "composting_electric_composter_body2.png",
        "composting_electric_composter_power.png",
        "composting_electric_composter_tube.png",
    },
  }

electric_composter:register_nodes(node_def, node_inactive, node_active)

-------------------------
-- Recipe Registration --
-------------------------

--[[
appliances.register_craft_type("composting_electric_composter", {
    description = S("Composting"),
    icon = "composting_composting_craft_type_icon.png",
    width = 1,
    height = 1,
  })

electric_composter:recipe_register_input(
	"",
	{
		inputs = 1,
		outputs = {"composting:compost_clod"},
		consumption_time = 76,
		consumption_step_size = 1,
	});

  electric_composter:register_recipes("composting_electric_composter", "composting_electric_composter_usage")
  )
--]]

