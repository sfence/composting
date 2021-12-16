
local function settings_get_number(key, default)
  local value = minetest.settings:get(key);
  if value then
    value = tonumber(value)
  else
    value = default
  end
  return value
end

local settings = {
  amount_limit = settings_get_number("composting_amount_per_composter", 200),
  clod_cost = settings_get_number("composting_clod_cost", 25),
  composting_time_divider = settings_get_number("composting_time_divider", 3600),
  electric_composter_time = settings_get_number("composting_electric_composter_time", 10),
  soil_time_divider = settings_get_number("composting_soil_time_divider", 720),
  wet_points = settings_get_number("composting_soil_wet_points", 25),
  growth_acc_effect = settings_get_number("composting_growth_acc_effect", 0.25),
}

composting.settings = settings;

