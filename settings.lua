
local function settings_get_int(key, default)
  local value = minetest.settings:get(key);
  if value then
    value = tonumber(value)
  else
    value = default
  end
  return value
end

local settings = {
  amount_limit = settings_get_int("composting_amount_per_composter", 200),
  clod_cost = settings_get_int("composting_clod_cost", 25),
  composting_time_divider = settings_get_int("composting_time_divider", 3600),
  soil_time_divider = settings_get_int("composting_soil_time_divider", 720),
  wet_points = settings_get_int("composting_soil_wet_points", 25),
}

composting.settings = settings;

